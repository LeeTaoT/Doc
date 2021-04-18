 ## manjaro安装教程设置教程

> 和我一起这样做，准没错

### 安装中文输入法.

```shell
#1. 切换国内镜像源
[ldt@ldt-tobefilledbyoem ~]$ sudo pacman-mirrors -i -c China -m rank ##选择科大镜像源
[ldt@ldt-tobefilledbyoem ~]$ 

#2. 配置archlinuxch源
[ldt@ldt-tobefilledbyoem ~]$ sudo vim /etc/pacman.conf
# An example of a custom package repository.  See the pacman manpage for
# tips on creating your own repositories.
[archlinuxcn]
SigLevel = Optional TrustedOnly
Server = https://mirrors.ustc.edu.cn/archlinuxcn/$arch 

#3. 更新软件源
[ldt@ldt-tobefilledbyoem ~]$ sudo pacman -Syy && sudo pacman -S archlinuxcn-keyring
:: 正在同步软件包数据库...
 core                                                                                166.4 KiB   304 KiB/s 00:01 [###################################################################] 100%
 extra                                                                              1964.7 KiB   413 KiB/s 00:05 [###################################################################] 100%
 community                                                                             6.6 MiB  1084 KiB/s 00:06 [###################################################################] 100%
 multilib                                                                            178.9 KiB  3.12 MiB/s 00:00 [###################################################################] 100%
 archlinuxcn                                                                        1617.8 KiB  1550 KiB/s 00:01 [###################################################################] 100%


#4. 安装yay AUR助手，用于在官方仓库没有软件源时，通过yay来安装
[ldt@ldt-tobefilledbyoem ~]$ sudo pacman -S yay

#5. 安装yaourt
[ldt@ldt-tobefilledbyoem ~]$ sudo pacman -S yaourt

#5.1 安装VIM
[ldt@ldt-tobefilledbyoem ~]$ sudo pacman -S vim

#5.2 安装 typora
[ldt@ldt-tobefilledbyoem ~]$ sudo yaourt typora


#6. 安装sogoupinyin输入法
[ldt@ldt-tobefilledbyoem ~]$ sudo pacman -S fcitx-im 
[ldt@ldt-tobefilledbyoem ~]$ sudo pacman -S fcitx-configtool
[ldt@ldt-tobefilledbyoem ~]$ sudo pacman -S fcitx-sogoupinyin  # 此处可能会报软件找不到
[ldt@ldt-tobefilledbyoem ~]$ sudo pacman -Sy base-devel        # 先运行base-devel,
[ldt@ldt-tobefilledbyoem ~]$ yaourt fcitx-sogoupinyin          # 再使用yaourt安装即可
# 6.1 安装完成后在工作目录下添加环境变量
[ldt@ldt-tobefilledbyoem ~]$ sudo vim ~/.xprofile  # ~代表工作目录
[ldt@ldt-tobefilledbyoem ~]$ cat .xprofile 
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS="@im=fcitx"
[ldt@ldt-tobefilledbyoem ~]$ reboot #重启


```



1.1 安装若没成功可能需要的步骤

>  1.打开 manjaro hello这个软件选择application，选中下图发光栏打上勾，选择UPDATE SYSTEM（这一步是安装配置fcitx，直接安装这个包不用手动配置.xprofile）



![img](https://img-blog.csdnimg.cn/20201218130855905.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM3Mjg0MDIw,size_16,color_FFFFFF,t_70)

> 2.  添加archlinuxcn源

```shell
[archlinuxcn]
SigLevel = Optional TrustedOnly
Server = https://mirrors.ustc.edu.cn/archlinuxcn/$arch 

```

![img](https://img-blog.csdnimg.cn/20201218131133383.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM3Mjg0MDIw,size_16,color_FFFFFF,t_70)

> 3. yay 安装搜狗拼音

```shell
[ldt@ldt-tobefilledbyoem ~]$ yay -S fcitx-sogoupinyin
```

>  4 . 重启 ，经过这一顿操作相信你一定安装好了中文输入法

```shell
[ldt@ldt-tobefilledbyoem ~]$ reboot  ## 什么? 你还没有安装好，期待你能连上网继续寻找答案吧
```

### 安装常用软件

```shell
# 安装视频播放软件
[ldt@ldt-tobefilledbyoem ~]$ sudo yaourt -S mpv

# 安装下载工具
[ldt@ldt-tobefilledbyoem ~]$ sudo yaourt -S uget 

# 安装steam, steam是自带软件，如果启动不成功，可以补一个包steam-native-runtime
[ldt@ldt-tobefilledbyoem ~]$ sudo pacman -S steam-native-runtime 

# 安装网络包,ifconfig
[ldt@ldt-tobefilledbyoem ~]$ sudo pacman -S net-tools

# 安装 vscode
[ldt@ldt-tobefilledbyoem ~]$ yay -S visual-studio-code-bin

# 安装网易云音乐
[ldt@ldt-tobefilledbyoem ~]$ yay -S netease-cloud-music

#安装百度云
[ldt@ldt-tobefilledbyoem ~]$ yay -S baidunetdisk

#安装chorme
[ldt@ldt-tobefilledbyoem ~]$ sudo pacman -S google-chrome

#安装思源字体，修改字体发虚
[ldt@ldt-tobefilledbyoem ~]$ sudo pacman -S google-chrome

# 删除单个软件包，保留其全部已经安装的依赖关系
[ldt@ldt-tobefilledbyoem ~]$ pacman -R package_name
# 删除指定软件包，及其所有没有被其他已安装软件包使用的依赖关系：
[ldt@ldt-tobefilledbyoem ~]$ pacman -Rs package_name
```

### 尝试美化教程

```shell
# 修改终端方案
[ldt@ldt-tobefilledbyoem ~]$ sudo pacman -S zsh
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
	# 终端->设置->编辑当前方案 ,将命令改为 /bin/zsh

# 安装底部dock
[ldt@ldt-tobefilledbyoem ~]$ sudo pacman -S latte-dock #安装dock栏

# 安装deepin-wine环境
[ldt@ldt-tobefilledbyoem ~]$ yay -S deepin-wine-wechat
# 切换到deepin-win环境
[ldt@ldt-tobefilledbyoem ~]$ /opt/apps/com.qq.weixin.deepin/files/run.sh -d


# 安装xdman
[ldt@ldt-tobefilledbyoem ~]$ yay -S xdman


#设置里都有
#提供一个仿mac方案
Plasma样式：MacBreeze Shadowless
颜色：氧气冷色
窗口装饰元素：McMojave-light


## 编辑面板
```



### 一些常用的管理命令

```shell
[ldt@ldt-tobefilledbyoem ~]$  sudo pacman -S archlinuxcn-keyring #-S表示安装某一软件
[ldt@ldt-tobefilledbyoem ~]$  sudo pacman -Syy # -Syy表示将本地的软件与软件仓库进行同步
[ldt@ldt-tobefilledbyoem ~]$  sudo pacman -Syyu # 更新一切软件包
[ldt@ldt-tobefilledbyoem ~]$  sudo pacman -R $(pacman -Qdtq) #删除系统中无用的包
[ldt@ldt-tobefilledbyoem ~]$  sudo pacman -Scc   #删除系统已经下载的安装包

#将主目录文件夹下中文替换成英文
#1.安装xdg-user-dirs-gtk
[ldt@ldt-tobefilledbyoem ~]$ sudo pacman -S xdg-user-dirs-gtk
#2.临时修改环境变量,更新目录
[ldt@ldt-tobefilledbyoem ~]$ export LANG=en_US.UTF-8 
[ldt@ldt-tobefilledbyoem ~]$ xdg-user-dirs-gtk-update  # 更新为英文目录,确定
[ldt@ldt-tobefilledbyoem ~]$ export LANG=zh_CN.UTF-8   # 将环境变量修改回中文
# 3.修改Dolphin文件管理器中目录的指向
右键-->编辑-->路径  #改成英文即可

```

### 安装deb包

```shell
# 1.检查有没有安装 debtap 
[ldt@ldt-tobefilledbyoem ~]$ sudo pacman -Q debtap
# 2. 安装
[ldt@ldt-tobefilledbyoem ~]$ yaourt -S debtap
# 3. 升级debtap
[ldt@ldt-tobefilledbyoem ~]$ sudo debtap -u
# 4. 使用方法
# 4.1 安装时会提示输入包名，以及license。包名随意，license就填GPL吧
# 4.2 上述操作完成后会在deb包同级目录生成×.tar.xz文件，直接用pacman安装即可
[ldt@ldt-tobefilledbyoem ~]$ sudo debtap xxxx.deb
[ldt@ldt-tobefilledbyoem ~]$ sudo pacman -U x.tar.xz 
```

