#! /bin/bash
ARM_WORK_DIR=/root/usb/riscv64;

if [ $# -lt 1 ]; then
    echo "Usage : $0 [-d dst] src1 src2 ...  ";
    exit 1;
fi

# 通过getopts 处理参数，并将-d 表示dst赋值给DST_DIR变量
while getopts :d: opt
do 
    case "$opt" in
    d)  
        DST_DIR=$OPTARG;
    ;;
    *) echo "Unknown option: $opt";;
    esac
done

# 将前面处理的-d 参数右移，处理src1, src2, ...参数
# OPTIND表示已经处理的参数所在的位置，右移参数
shift $[ $OPTIND - 1 ];

count=1;
for param in "$@"
do 
    echo "adb push $param $ARM_WORK_DIR/$DST_DIR";
    adb push $param $ARM_WORK_DIR/$DST_DIR;
    count=$[ $count + 1 ]
done
