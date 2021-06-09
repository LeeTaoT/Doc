## Makefile文件编写

### 1 目录结构

```shell
ldt@ldt-PC:~/apue.3e/mytest$ tree
.
├── bin
├── include
│   └── *.h
├── lib
│   ├── *.c
│   └── makefile         ## 各个目录下的Makefile文件
├── Make.defines.freebsd 
├── Make.defines.linux   ##不同操作系统需要定义的文件
├── Make.defines.macos
├── Make.defines.solaris
├── makefile             ## 总的makefile 文件
├── Make.libapue.inc    
├── src
│   ├── makefile         ## 各个目录下的Makefile文件
│   └── *.c
└── systype.sh           ## 生成一些关于操作系统信息的脚本

```



### 2.Makefile相关文件讲解

> 处在工作目录下的Makefile文件起着控制每个目录/模块下的Makefile的功能

```makefile
##总Makefile文件

ldt@ldt-PC:~/apue.3e/mytest$ cat makefile 
DIRS := lib src   ## 定义需要处理的目录

# 整个Make的流程是，进入目录,循环处理每个DIRS下的Makefile文件
# 当所有目录下的Makefile处理完后，退出编译
all :
        for i in $(DIRS) ; do \
                (cd $$i && echo "makeing $$i" && $(MAKE) ) || exit 1 ; \
        done

clean :
        for i in $(DIRS) ; do \
                (cd $$i && echo "cleaning $$i" && $(MAKE) clean ) || exit 1 ; \
        done
```









> make.defines.* 文档起着确定不同的操作系统使用什么编译器，编译器参数是什么的作用

```makefile
ldt@ldt-PC:~/apue.3e/mytest$ cat Make.defines.linux 
# Common make definitions, customized for each platform

# Definitions required in all program directories to compile and link
# C programs using gcc.




## 生成的库为放在 lib/libapue.a 
## 编译器指定为为gcc
CC=gcc    

## COMPILE.c , LINK.c 设置make的内置规则,可以使用make -p命令来查看
COMPILE.c=$(CC) $(CFLAGS) $(CPPFLAGS) -c   
LINK.c=$(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS)


LDFLAGS=

#库目录为 $(ROOT)目录的lib目录下，-L编译可执行程序时使用
LDDIR=-L$(ROOT)/lib

#确定使用的库名称 libapue.so 或 libapue.a ， -lapue编译时使用 
LDLIBS=$(LDDIR) -lapue $(EXTRALIBS)

# 编译器编译的选项
CFLAGS=-ansi -I$(ROOT)/include -Wall -DLINUX -D_GNU_SOURCE $(EXTRA)

#输出
RANLIB=echo

# 链接器, 将.o链接成.a时使用
AR=ar

# 样式扫描和处理awk
AWK=awk


LIBAPUE=$(ROOT)/lib/libapue.a

# Common temp files to delete from each directory.
TEMPFILES=core core.* *.o temp.* *.out



```



> systype.sh 起着确定当前操作系统的类型的作用

```shell
ldt@ldt-PC:~/apue.3e/mytest$ cat systype.sh 
 # (leading space required for Xenix /bin/sh)

#
# Determine the type of *ix operating system that we're
# running on, and echo an appropriate value.
# This script is intended to be used in Makefiles.
# (This is a kludge.  Gotta be a better way.)
#

case `uname -s` in
"FreeBSD")
        PLATFORM="freebsd"
        ;;
"Linux")
        PLATFORM="linux"
        ;;
"Darwin")
        PLATFORM="macos"
        ;;
"SunOS")
        PLATFORM="solaris"
        ;;
*)
        echo "Unknown platform" >&2
        exit 1
esac
echo $PLATFORM
exit 0


```

> Make.libapue.inc  进入lib目录执行make

```makefile
$(LIBAPUE):
        (cd $(ROOT)/lib && $(MAKE))
```

> lib/Makefile 文件

```makefile
#
# Makefile for misc library.
#
ROOT=..
PLATFORM=$(shell $(ROOT)/systype.sh)
include $(ROOT)/Make.defines.$(PLATFORM)

LIBMISC	= libapue.a
OBJS   = bufargs.o cliconn.o clrfl.o \
			daemonize.o error.o errorlog.o lockreg.o locktest.o \
			openmax.o pathalloc.o popen.o prexit.o prmask.o \
			ptyfork.o ptyopen.o readn.o recvfd.o senderr.o sendfd.o \
			servaccept.o servlisten.o setfd.o setfl.o signal.o signalintr.o \
			sleepus.o spipe.o tellwait.o ttymodes.o writen.o

all:	$(LIBMISC) sleep.o

$(LIBMISC):	$(OBJS)
	$(AR) rv $(LIBMISC) $?
	$(RANLIB) $(LIBMISC)


clean:
	rm -f *.o a.out core temp.* $(LIBMISC)

include $(ROOT)/Make.libapue.inc
```

> intro/Makefile

```makefile

ROOT=..
PLATFORM=$(shell $(ROOT)/systype.sh)
include $(ROOT)/Make.defines.$(PLATFORM)

PROGS = getcputc hello ls1 mycat shell1 shell2 testerror uidgid

all:    $(PROGS)

%:      %.c $(LIBAPUE)
        $(CC) $(CFLAGS) $@.c -o $@ $(LDFLAGS) $(LDLIBS)

clean:
        rm -f $(PROGS) $(TEMPFILES) *.o

include $(ROOT)/Make.libapue.inc

```

> 执行make

```shell
ldt@ldt-PC:~/apue.3e$ make
for i in lib intro sockets advio daemons datafiles db environ fileio filedir ipc1 ipc2 proc pty relation signals standards stdio termios threadctl threads printer exercises; do \
        (cd $i && echo "making $i" && make ) || exit 1; \
done
making lib
make[1]: 进入目录“/home/ldt/apue.3e/lib”
gcc -ansi -I../include -Wall -DLINUX -D_GNU_SOURCE   -c -o bufargs.o bufargs.c
....
gcc -ansi -I../include -Wall -DLINUX -D_GNU_SOURCE   -c -o tellwait.o tellwait.c
gcc -ansi -I../include -Wall -DLINUX -D_GNU_SOURCE   -c -o ttymodes.o ttymodes.c
gcc -ansi -I../include -Wall -DLINUX -D_GNU_SOURCE   -c -o writen.o writen.c
ar rv libapue.a bufargs.o cliconn.o clrfl.o daemonize.o error.o errorlog.o lockreg.o locktest.o openmax.o pathalloc.o popen.o prexit.o prmask.o ptyfork.o ptyopen.o readn.o recvfd.o senderr.o sendfd.o servaccept.o servlisten.o setfd.o setfl.o signal.o signalintr.o sleepus.o spipe.o tellwait.o ttymodes.o writen.o
ar: 正在创建 libapue.a
a - bufargs.o
...
a - spipe.o
a - tellwait.o
a - ttymodes.o
a - writen.o
echo libapue.a
libapue.a
gcc -ansi -I../include -Wall -DLINUX -D_GNU_SOURCE   -c -o sleep.o sleep.c
make[1]: 离开目录“/home/ldt/apue.3e/lib”
making intro
make[1]: 进入目录“/home/ldt/apue.3e/intro”
gcc -ansi -I../include -Wall -DLINUX -D_GNU_SOURCE  shell1.c -o shell1  -L../lib -lapue 
gcc -ansi -I../include -Wall -DLINUX -D_GNU_SOURCE  shell2.c -o shell2  -L../lib -lapue 
gcc -ansi -I../include -Wall -DLINUX -D_GNU_SOURCE  testerror.c -o testerror  -L../lib -lapue 
gcc -ansi -I../include -Wall -DLINUX -D_GNU_SOURCE  uidgid.c -o uidgid  -L../lib -lapue 
make[1]: 离开目录“/home/ldt/apue.3e/intro”
making sockets
make[1]: 进入目录“/home/ldt/apue.3e/sockets”
...
make[1]: 离开目录“/home/ldt/apue.3e/sockets”
making advio
making daemons
making datafiles
making db
...
make[1]: 进入目录“/home/ldt/apue.3e/db”
gcc -fPIC -ansi -I../include -Wall -DLINUX -D_GNU_SOURCE  -c db.c
gcc -shared -Wl,-dylib -o libapue_db.so.1 -L../lib -lapue -lc db.o
ln -s libapue_db.so.1 libapue_db.so
gcc -ansi -I../include -Wall -DLINUX -D_GNU_SOURCE  -c -I. t4.c
gcc -Wl,-rpath=. -o t4 t4.o -L../lib -L. -lapue_db -lapue
ar rsv libapue_db.a db.o
ar: 正在创建 libapue_db.a
a - db.o
echo libapue_db.a
libapue_db.a
making environ
making fileio
...

ldt@ldt-PC:~/apue.3e$ 

```

### 3. CMake编译过程

+ 简单的CMake编写

> CMake 是通过CMakeLists.txt文档进行makefile文件编写的

在工程目录下创建 CMakeLists.txt 编写

```cmake
project(HelloWorld)   ##创建工程名
add_executable(helloworld helloworld.cc swap.cc) 
#添加可执行文件helloworld 依赖于hellowold.cc与swap.cc
```

```shell
ldt@ldt-PC:~/cmake$ mkdir build
ldt@ldt-PC:~/cmake$ cd build/     
ldt@ldt-PC:~/cmake/build$ cmake ..
-- Configuring done
-- Generating done
-- Build files have been written to: /home/ldt/cmake/build
ldt@ldt-PC:~/cmake/build$ make
Scanning dependencies of target helloworld
[ 33%] Building CXX object CMakeFiles/helloworld.dir/helloworld.cc.o
[ 66%] Linking CXX executable helloworld
[100%] Built target helloworld
ldt@ldt-PC:~/cmake/build$ 
```



