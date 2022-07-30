echo "hello , welcome in my ashrc"
MOUNT_DIR=$HOME/usb
WORK_DIR=$MOUNT_DIR/riscv64
IS_MOUNT=$(df -h | grep $MOUNT_DIR | wc -l);

MOUNT_USB()
{

	if [ ! -d $MOUNT_DIR ]; then
		mkdir $MOUNT_DIR;
	fi

	if [ -e /dev/sda1 ]; then

		# 判断是否是root用户，非root用户需要密码
		if [ $USER != root ]; then
			read -s -p "Please Enter your sudo password :" PASSWORD;
			echo "$PASSWORD" | sudo -S mount -o uid=$USER,gid=$USER /dev/sda1 $MOUNT_DIR ;
			echo ;
		else
			mount /dev/sda1 $MOUNT_DIR ; 
		fi

		# 判断上面的挂载命令是否成功
		if [ $? -eq 0 ]; then 
				echo "$USER mount success";
		else
				echo "can't mount /dev/sda1 to $MOUNT_DIR";
		fi
	else
		echo "/dev/sda1 not exist"
	fi
}  

if  [ $IS_MOUNT -eq 0 ]; then
	echo "$MOUNT_DIR not mount,try mount"
	MOUNT_USB
fi

IS_MOUNT=$(df -h | grep $MOUNT_DIR | wc -l);
if [ $IS_MOUNT -eq 1 ]; then
	if [ ! -d $WORK_DIR ]; then
		mkdir $WORK_DIR;
	fi
	echo "cd to $WORK_DIR";
	cd $WORK_DIR ;
fi 

