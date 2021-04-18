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

```shell
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

```shell
ldt@ldt-PC:~/apue.3e/mytest$ cat Make.defines.linux 
# Common make definitions, customized for each platform

# Definitions required in all program directories to compile and link
# C programs using gcc.

## 编译器为gcc
## 库编译目录为根目录下的lib目录
## 生成的库为放在 lib/libapue.a 

CC=gcc                
COMPILE.c=$(CC) $(CFLAGS) $(CPPFLAGS) -c
LINK.c=$(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS)
LDFLAGS=
LDDIR=-L$(ROOT)/lib    
LDLIBS=$(LDDIR) -lapue $(EXTRALIBS)
CFLAGS=-ansi -I$(ROOT)/include -Wall -DLINUX -D_GNU_SOURCE $(EXTRA)
RANLIB=echo
AR=ar
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

