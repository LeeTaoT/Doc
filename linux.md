

## 命令使用

### 进程与文件使用命令

```shell

# 查看文件被那些进程调用使用
ldt@ldt-PC:~$ fuser -v /mnt/sdc1
                     用户     进程号 权限   命令
/mnt/sdc1:           root     kernel mount /mnt/sdc1
                     ldt       15347 ..c.. bash
ldt@ldt-PC:~$ ps -ef | grep 15347
ldt      15347  5410  0 18:13 pts/1    00:00:00 /bin/bash
ldt      15450  5418  0 18:15 pts/0    00:00:00 grep 15347


# 查看进程打开了那些文件
ldt@ldt-PC:~$ lsof /home/ldt/firefox/firefox-bin
COMMAND    PID USER  FD   TYPE DEVICE SIZE/OFF     NODE NAME
firefox-b 5789  ldt txt    REG    8,7   507472 10751436 /home/ldt/firefox/firefox-bin
Web\x20Co 5843  ldt txt    REG    8,7   507472 10751436 /home/ldt/firefox/firefox-bin
Web\x20Co 5882  ldt txt    REG    8,7   507472 10751436 /home/ldt/firefox/firefox-bin
Web\x20Co 5887  ldt txt    REG    8,7   507472 10751436 /home/ldt/firefox/firefox-bin
Web\x20Co 5898  ldt txt    REG    8,7   507472 10751436 /home/ldt/firefox/firefox-bin
Web\x20Co 5912  ldt txt    REG    8,7   507472 10751436 /home/ldt/firefox/firefox-bin
Web\x20Co 5934  ldt txt    REG    8,7   507472 10751436 /home/ldt/firefox/firefox-bin
Web\x20Co 5942  ldt txt    REG    8,7   507472 10751436 /home/ldt/firefox/firefox-bin
Web\x20Co 5974  ldt txt    REG    8,7   507472 10751436 /home/ldt/firefox/firefox-bin
WebExtens 6046  ldt txt    REG    8,7   507472 10751436 /home/ldt/firefox/firefox-bin
RDD\x20Pr 6117  ldt txt    REG    8,7   507472 10751436 /home/ldt/firefox/firefox-bin

#列出所有网络连接
ldt@ldt-PC:~$ lsof -i [tcp]
COMMAND    PID USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
firefox-b 5789  ldt   52u  IPv4 140955      0t0  TCP ldt-PC:52718->ec2-54-213-36-182.us-west-2.compute.amazonaws.com:https (ESTABLISHED)
#列出某个进程号
ldt@ldt-PC:~$ lsof -p 1
COMMAND PID USER   FD      TYPE DEVICE SIZE/OFF NODE NAME
systemd   1 root  cwd   unknown                      /proc/1/cwd (readlink: Permission denied)
systemd   1 root  rtd   unknown                      /proc/1/root (readlink: Permission denied)
systemd   1 root  txt   unknown                      /proc/1/exe (readlink: Permission denied)
systemd   1 root NOFD                                /proc/1/fd (opendir: Permission denied)


```

###  挂载相关命令

```shell
#查看挂载点

ldt@ldt-PC:~$ df -h
文件系统        容量  已用  可用 已用% 挂载点
udev            3.9G  4.0K  3.9G    1% /dev
tmpfs           792M  3.0M  789M    1% /run
/dev/sda5        15G  7.3G  6.8G   52% /
tmpfs           3.9G   47M  3.9G    2% /dev/shm
tmpfs           5.0M  4.0K  5.0M    1% /run/lock
tmpfs           3.9G     0  3.9G    0% /sys/fs/cgroup
/dev/sda1       1.5G  198M  1.2G   15% /boot
/dev/sda7       164G   14G  142G    9% /data
/dev/sda3        14G  6.4G  6.7G   49% /recovery
tmpfs           792M   56K  792M    1% /run/user/1000
/dev/sdc1       466G  112M  466G    1% /mnt/sdc1
/dev/sdb1       117G   61M  111G    1% /media/ldt/6795aa81-b72b-444e-b14d-00b26cee1625



# 自动挂载写/etc/fstab
# 1. 先确定硬盘的UUID 查看by-uuid 文件，或 使用dumpe2fs命令
# 2. 打开/etc/fstable文件，写入挂载命令
# 3. mount -a 重新挂载
# 4. 查看是否挂载成功
ldt@ldt-PC:~$ sudo ls -l /dev/disk/by-uuid/
lrwxrwxrwx 1 root root 10 4月  11 17:32 0fb7486a-58c6-4105-8269-f67409027fde -> ../../sda3
lrwxrwxrwx 1 root root 10 4月  11 17:32 6182e24d-1360-4782-89e8-0d471d0fe62d -> ../../sda4
lrwxrwxrwx 1 root root 10 4月  11 17:32 6795aa81-b72b-444e-b14d-00b26cee1625 -> ../../sdb1
lrwxrwxrwx 1 root root 10 4月  11 17:32 6db6f121-63ea-4a16-9b9d-4d5b011fe304 -> ../../sda6
lrwxrwxrwx 1 root root 10 4月  11 17:32 6ea758f4-3fd0-4d8d-8700-e114deddca54 -> ../../sda5
lrwxrwxrwx 1 root root 10 4月  11 17:32 b94a6331-5efe-4f37-87e5-d915012774bf -> ../../sda1
lrwxrwxrwx 1 root root 10 4月  11 17:48 BA8E778F8E7742C5 -> ../../sdc1
lrwxrwxrwx 1 root root 10 4月  11 17:32 fcc5e4ca-dde2-440b-9627-65f268eab010 -> ../../sda7
ldt@ldt-PC:~$ sudo vim /etc/fstab 

ldt@ldt-PC:~$ sudo dumpe2fs /dev/sdb1 | grep UUID
dumpe2fs 1.44.5 (15-Dec-2018)
Filesystem UUID:          6795aa81-b72b-444e-b14d-00b26cee1625


ldt@ldt-PC:~$  sudo vim /etc/fstab 
# 添加挂载/dev/sdb1
UUID=6795aa81-b72b-444e-b14d-00b26cee1625      /mnt/sdb1        ext4            rw,relatime     0 2

# 第四个字段是挂载参数，这个参数和 mount 命令的挂载参数一致。
# 第五个字段表示“指定分区是否被 dump 备份”，0 代表不备份，1 代表备份，2 代表不定期备份。
# 第六个字段表示“指定分区是否被 fsck 检测”，0 代表不检测，其他数字代表检测的优先级，1 的优先级比 2 高。所以先检测 1 的分区，再检测 2 的分区。一般分区的优先级是 1，其他分区的优先级是 2。

ldt@ldt-PC:~$ sudo mount -a
ldt@ldt-PC:~$ df -h
文件系统        容量  已用  可用 已用% 挂载点
udev            3.9G  4.0K  3.9G    1% /dev
tmpfs           792M  3.0M  789M    1% /run
/dev/sda5        15G  7.3G  6.8G   52% /
tmpfs           3.9G   44M  3.9G    2% /dev/shm
tmpfs           5.0M  4.0K  5.0M    1% /run/lock
tmpfs           3.9G     0  3.9G    0% /sys/fs/cgroup
/dev/sda1       1.5G  198M  1.2G   15% /boot
/dev/sda7       164G   14G  142G    9% /data
/dev/sda3        14G  6.4G  6.7G   49% /recovery
tmpfs           792M   56K  792M    1% /run/user/1000
/dev/sdc1       466G  112M  466G    1% /mnt/sdc1
/dev/sdb1       117G   61M  111G    1% /mnt/sdb1



```

### 同步相关命令

```shell
#增量同步命令rsync
#将C++目录同步到sdc1/work下, C++/ 代表同步该目录下的所有内容, C++代表一同将本目录也同步
ldt@ldt-PC:~$ rsync -avz C++ /mnt/sdc1/work/

```

### 创建链接

```shell
# ln -s 代表创建软连接，相当于一个快捷方式,不加-s 参数创建一个硬连接
# 注意：路径不同使用绝对路径
ldt@ldt-PC:~$ ln -s /home/ldt/Documents/linux.md Desktop/
ldt@ldt-PC:~$ ls -l Desktop/
总用量 4
lrwxrwxrwx 1 ldt ldt  28 4月  11 18:56 linux.md -> /home/ldt/Documents/linux.md
-rw-r--r-- 1 ldt ldt 148 4月  10 18:02 tmp.txt

```

### 解压											

```shell
##解压到.tar.gz 到当前home目录
ldt@ldt-PC:~/C++/mytest$ tar zxvf ~/Downloads/src.3e.tar.gz -C  ~

```





## VIM使用

> 关于VIM的一些常用技巧

### 与系统剪切版的交互

```shell
##1.查看vim是否支持clipboard, "-"代表不支持
   ~/Documents $ vim --version| grep clipboard                                                                             
-clipboard         +jumplist          +popupwin          +user_commands
+ex_extra          -mouse_jsbterm     -sun_workshop      -xterm_clipboard
#2.下载gvim
[ldt@ldt-tobefilledbyoem ~]$ sudo pacman -S gvim #卸载VIM选择y

[ldt@ldt-tobefilledbyoem ~]$ vim --version| grep clipboard                                                                                             ✔  10s  
+clipboard         +jumplist          +popupwin          +user_commands
+ex_extra          -mouse_jsbterm     -sun_workshop      +xterm_clipboard


#3.从剪切版copy
[ldt@ldt-tobefilledbyoem ~]$ vim test.txt  #进入vim
> normal 模式
:reg  #查看寄存器里的内容, 重点关注 "+ 与 "* 寄存器
> visiual模式
"+ p        #将 "+ 寄存器的内容p上
#4.copy 到剪切版上
> visiual模式
"+ y       #将 内容copy 到 "+ 寄存器上


# 在vim中进入visual视图后使用"Ny(N表示特定寄存器编好)，将内容复制到特定的剪切板
# "*和"+有什么差别呢？ "* 是在系统剪切板中表示选择的内容， "+ 是在系统剪切板中表示选择后Ctrl+c复制的内容


```





| 表示符号                  |                  名称                  | 作用                                                         |
| :------------------------ | :------------------------------------: | :----------------------------------------------------------- |
| `""`                      |         无名（unnamed）寄存器          | 缓存最后一次操作内容                                         |
| `"0` ～ `"9`              |         数字（numbered）寄存器         | 缓存最近操作内容，复制与删除有别，`"0`寄存器缓存最近一次复制的内容，`"1`-`"9`缓存最近9次删除内容 |
| `"-`                      |     行内删除（small delete）寄存器     | 缓存行内删除内容                                             |
| `“a` ～ `"z`或`"A` - `”Z` |          具名（named）寄存器           | 可用于主动指定                                               |
| `":`, `".`, `"%`, `"#`    |        只读（read-only）寄存器         | 分别缓存最近命令、最近插入文本、当前文件名、当前交替文件名   |
| `"=`                      |       表达式（expression）寄存器       | 用于执行表达式命令                                           |
| `"*`, `"+`, `"~`          | 选择及拖拽（selection and drop）寄存器 | 存取GUI选择文本，可用于与外部应用交互                        |
| `"_`                      |        黑洞（black hole）寄存器        | 不缓存操作内容（干净删除）                                   |
| `"/`                      |   模式寄存器（last search pattern）    | 缓存最近的搜索模式                                           |



##  VScode 设置

###  常用插件安装

+ C/C++
+ Shades of Purple       #主题
+ VIM                              # VIM插件
+ One Dark Pro            # 主题
+ vscode-icons             #图标
+ cmake                        # cmake工具
+ cmake-tool           

### 调试.json

```json
{
    //launch json
    // Use IntelliSense to learn about possible attributes.
    // Hover to view descriptions of existing attributes.
    // For more information, visit: https://go.microsoft.com/fwlink/?linkid=830387
    "version": "0.2.0",
    "configurations": [
    
        
        {
            "name": "g++ - 生成和调试活动文件",
            "type": "cppdbg",
            "request": "launch",
            "program": "${fileDirname}/build/helloworld",  //调试时调试的可执行文件路径
            "args": [],                                    //程序运行时命令行的入参
            "stopAtEntry": false,
            "cwd": "${fileDirname}",                      
            "environment": [],
            "externalConsole": false,
            "MIMode": "gdb",
            "setupCommands": [
                {
                    "description": "为 gdb 启用整齐打印",
                    "text": "-enable-pretty-printing",
                    "ignoreFailures": true
                }
            ],
            //"preLaunchTask": "C/C++: g++ 生成活动文件", 
            //调试之前需要做的任务,如下task.json标签
            "miDebuggerPath": "/usr/bin/gdb"  //使用的gdb 路径		
        }
    ]
}
```



```json

{
    //task.json
    "tasks": [
        {
            "type": "cppbuild",
            "label": "C/C++: g++ 生成活动文件", // lanch.json 调用的对象标签
            "command": "/usr/bin/g++",
            "args": [
                "-g",
                "${file}",
                "-o",
                "${fileDirname}/${fileBasenameNoExtension}" 
                //对应这条命令 g++ main.cpp ... -o helloworld 
            ],
          /* arg 参数可正常修改成命令行编译时的参数   
          "args": [
                "-g",
                "helloworld.cc",
                "swap.cc",
                "-o",
                "${fileDirname}/build/helloworld"
            ],
            */
            "options": {
                "cwd": "${fileDirname}"
            },
            "problemMatcher": [
                "$gcc"
            ],
            "group": {
                "kind": "build",
                "isDefault": true
            },
            "detail": "调试器生成的任务。"
        }
    ],
    "version": "2.0.0"
}
```

### 将cmake步骤放入task.json

```json

    "tasks": [
       {
            "type": "shell",
            "label": "cmake",      //cmake task
            "command":"cmake",     // cmake ..
            "args": [
                ".."
            ]
        },
        {

            "label": "make",       //make task
            "group": {             
                "kind": "build",
                "isDefault": true
            },
            "command": "make",       //make
            "args": [

            ]
        },
        {
            "label": "Build",  //lanuch.json调用Build任务
            "dependsOn" :[
                "cmake",       //Build依赖于cmake task 和 make task
                "make"
            ]
            
        }

    ],
    "version": "2.0.0",
    "options": {
        "cwd": "${workspaceFolder}/build"   // cd build
    },
}
```









​	

## Git 使用

```shell

## git 命令没法自动补全

# 1.下载git-completion.bash
# 2.将.bash 文件放到 ~/.git-completion.bash 中
# 3.配置~/.bashrc 配置文件，并生效
[ldt@ldt-tobefilledbyoem ~]$ git clone  https://github.com/git/git.git
[ldt@ldt-tobefilledbyoem ~]$ cp git/contrib/completion/git-completion.bash  ~/.git-completion.bash
> vim ~.bashrc
if [ -f ~/.git-completion.bash ]; then
. ~/.git-completion.bash
fi
[ldt@ldt-tobefilledbyoem ~]$ source .bashrc





```

### git 远程仓库

```shell
## 创建ssh-key 
## 并将公钥添加到仓库中，全选择默认即可
ldt@ldt-PC:~$ ssh-keygen -t rsa -C "3111824424@qq.com"
Generating public/private rsa key pair.
Enter file in which to save the key (/home/ldt/.ssh/id_rsa): 
Created directory '/home/ldt/.ssh'.
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /home/ldt/.ssh/id_rsa.
Your public key has been saved in /home/ldt/.ssh/id_rsa.pub.
The key fingerprint is:
SHA256:gjjMynY4k6b6ZmxS8s3wpcR5gh/llLtRTkmKxHptlio 3111824424@qq.com
The key's randomart image is:
+---[RSA 2048]----+
|   .             |
|    o   .        |
|   o o = .       |
| o..o.X +        |
|  =+.O.=S        |
|o.E.B *..        |
|.& X * o         |
|= X * .          |
|+*.              |
+----[SHA256]-----+
ldt@ldt-PC:~$ cat  ~/.ssh/id_rsa.pub 
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCtmHnfLV3vf+/a0euDbJbF3lwj1+E1eSOluq/qWL4gumvwi2tuoLmry0+VK+WNpXAvk1ad4ph0eEOQgEbOS+tVNCMho8mA7O8qgZoiXg26PYV5DDe67mTLlr3lp+AXDu7IQId19y/cmCWWSFCQSNHOBC1OXCs7+o1An062zEjJq2nl6OfOvku6UpZpe6HG1NpbNj5mkDn+dhldggvdmadKnOyK+3AXq8BzcUc0ueMow+B92lOCafziFhXo4OCXuEl0VeDo3GILQKi5neti4a6ppsJs0/aDzvcAWAnN7qkxftxE9tqy0+JlTjKjNamvB1z+I2NxeNy6WKGFn4j0Gz5T 3111824424@qq.com


## 创建一个本地仓库，添加readme文件
## 将本地仓库与远程仓库联系起来
## 将本地仓库的代码提交到远程仓库

ldt@ldt-PC:~$ echo "# Doc" >> README.md
ldt@ldt-PC:~$ git init
ldt@ldt-PC:~$ git add README.md
ldt@ldt-PC:~$ git commit -m "first commit"
ldt@ldt-PC:~$ git branch -M main             ## 切换到main分支
ldt@ldt-PC:~$ git remote add origin https://github.com/Title0A/Doc.git ##将本地仓库与远程仓库联系起来
ldt@ldt-PC:~$ git push -u origin main  ##提交远程仓库

## 删除远程库

## 如果添加的时候地址写错了，或者就在本地删除远程库，可以用git remote rm <name>命令。使用前，建议先用git remote -v查看远程库信息：

$ git remote -v
origin  git@github.com:michaelliao/learn-git.git (fetch)
origin  git@github.com:michaelliao/learn-git.git (push)

然后，根据名字删除，比如删除origin：

$ git remote rm origin




## 从远程仓库中拉分支
$ git clone https://github.com/Title0A/Doc.git doc                                                                                       
正克隆到 'doc'...
remote: Enumerating objects: 14, done.
remote: Counting objects: 100% (14/14), done.
remote: Compressing objects: 100% (8/8), done.
remote: Total 14 (delta 4), reused 14 (delta 4), pack-reused 0
接收对象中: 100% (14/14), 10.26 KiB | 109.00 KiB/s, 完成.
处理 delta 中: 100% (4/4), 完成.



### 首先在github创建并初始化一个仓库
### 然后本地clone 
$ git clone git@github.com:michaelliao/gitskills.git


## Git 上传一直需要输入用户名，密码问题
## 是因为git clone 时使用HTTP导致的, 切换成ssh协议即可
$ git remote -v            
origin  https://github.com/Title0A/Doc.git (fetch)
origin  https://github.com/Title0A/Doc.git (push)
$ git remote rm origin                                                                                                                     $ git remote -v                                                                                                                             $ git remote add origin git@github.com:Title0A/Doc.git                                                                                     $ git remote -v                    
origin  git@github.com:Title0A/Doc.git (fetch)
origin  git@github.com:Title0A/Doc.git (push)
$ git pull                                                                                                                                 
The authenticity of host 'github.com (192.30.255.113)' can't be established.
RSA key fingerprint is SHA256:nThbg6kXUpJWGl7E1IGOCspRomTxdCARLviKw6E5SY8.
This key is not known by any other names
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes 
Warning: Permanently added 'github.com' (RSA) to the list of known hosts.
来自 github.com:Title0A/Doc
 * [新分支]          main       -> origin/main
当前分支没有跟踪信息。
请指定您要合并哪一个分支。
详见 git-pull(1)。

    git pull <远程> <分支>

如果您想要为此分支创建跟踪信息，您可以执行：

    git branch --set-upstream-to=origin/<分支> main


$ git push origin main                                                                                                                     
Everything up-to-date
```

### git 上传图片问题 

要将图片作为资源上传至Github上，md文档在本地插入的图片只是一个本地链接

### ssh开启
```shell
# 开启ssh服务
ldt@MiWiFi-RA69-srv:~$ /etc/init.d/ssh status
# 查看ssh服务
ldt@MiWiFi-RA69-srv:~$ systemctl status ssh
● ssh.service - OpenBSD Secure Shell server
     Loaded: loaded (/lib/systemd/system/ssh.service; enabled; vendor preset: e>
     Active: active (running) since Sun 2022-01-09 21:20:04 CST; 7min ago
       Docs: man:sshd(8)
             man:sshd_config(5)
    Process: 5697 ExecStartPre=/usr/sbin/sshd -t (code=exited, status=0/SUCCESS)
   Main PID: 5698 (sshd)
      Tasks: 1 (limit: 9425)
     Memory: 1.1M
        CPU: 15ms
     CGroup: /system.slice/ssh.service
             └─5698 sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups


#添加到开机自启动
ldt@MiWiFi-RA69-srv:~$ systemctl enable ssh

```
### Debain 关闭休眠模式
```shell

#查看休眠状态
ldt@MiWiFi-RA69-srv:~$ systemctl status sleep.target
● sleep.target - Sleep
     Loaded: loaded (/lib/systemd/system/sleep.target; static)
     Active: inactive (dead)
       Docs: man:systemd.special(7)
#关闭休眠状态
ldt@MiWiFi-RA69-srv:~$ systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target 
Created symlink /etc/systemd/system/sleep.target → /dev/null.
Created symlink /etc/systemd/system/suspend.target → /dev/null.
Created symlink /etc/systemd/system/hibernate.target → /dev/null.
Created symlink /etc/systemd/system/hybrid-sleep.target → /dev/null.
#查看
ldt@MiWiFi-RA69-srv:~$ systemctl status sleep.target
● sleep.target
     Loaded: masked (Reason: Unit sleep.target is masked.)
     Active: inactive (dead)
ldt@MiWiFi-RA69-srv:~$ 

```


#### 了解一下sleep任务

+ systemd 支持四种休眠模式：
  + suspend
  休眠到内存。 操作系统停止运行， 如果主机失去电力 将会导致数据丢失， 但是休眠和唤醒速度很快。 这对应于内核的 suspend, standby, freeze 状态。
  + hibernate
  休眠到硬盘。 操作系统停止运行， 即使主机失去电力 也不会导致数据丢失， 但是休眠和唤醒速度很慢。 这对应于内核的 hibernation 状态。
  + hybrid-sleep
  混合休眠(同时休眠到内存和硬盘)。 操作系统停止运行， 如果主机一直没有失去电力， 那么休眠和唤醒速度很快。 如果主机失去电力， 那么休眠和唤醒速度很慢，但是不会导致数据丢失。 这对应于内核的 suspend-to-both 状态。
  + suspend-then-hibernate
  两阶段休眠(先休眠到内存再休眠到硬盘)。 系统首先休眠到内存，如果经过 HibernateDelaySec= 时长之后仍然没有任何操作， 那么系统将会被 RTC 警报唤醒并立即休眠到硬盘。

推荐阅读
systemd-sleep         http://www.jinbuguo.com/systemd/systemd-sleep.conf.html 


### 设置开机启动字符界面
```shell

#获取默认启动设置
ldt@MiWiFi-RA69-srv:~$ systemctl get-default 
graphical.target

#设置字符启动界面
ldt@MiWiFi-RA69-srv:~$ sudo systemctl set-default multi-user.target 
Created symlink /etc/systemd/system/default.target → /lib/systemd/system/multi-user.target.

#可能需要修改
ldt@MiWiFi-RA69-srv:~$ sudo vim etc/default/grub
#GRUB_CMDLINE_LINUX=""
GRUB_CMDLINE_LINUX="text"
ldt@MiWiFi-RA69-srv:~$ sudo update-grub

```
## clang/llvm 编译器
```shell
ldt@aml:~$ sudo apt install clang
ldt@aml:~$ sudo apt install llvm

#切换默认C++编译器
ldt@aml:~$ sudo update-alternatives --config c++
[sudo] password for ldt:
There are 2 choices for the alternative c++ (providing /usr/bin/c++).

  Selection    Path              Priority   Status
------------------------------------------------------------
* 0            /usr/bin/g++       20        auto mode
  1            /usr/bin/clang++   10        manual mode
  2            /usr/bin/g++       20        manual mode

Press <enter> to keep the current choice[*], or type selection number: 1
update-alternatives: using /usr/bin/clang++ to provide /usr/bin/c++ (c++) in manual mode
ldt@aml:~$
ldt@aml:~$

#切换默认C编译器
ldt@aml:~$ sudo update-alternatives --config cc
There are 2 choices for the alternative cc (providing /usr/bin/cc).

  Selection    Path            Priority   Status
------------------------------------------------------------
* 0            /usr/bin/gcc     20        auto mode
  1            /usr/bin/clang   10        manual mode
  2            /usr/bin/gcc     20        manual mode

Press <enter> to keep the current choice[*], or type selection number: 1
update-alternatives: using /usr/bin/clang to provide /usr/bin/cc (cc) in manual mode
```
