#!/bin/bash

echo "redis install-script start=======$0=================="
#redis安装目录，bin目录也会在这个下面
redis_home='/usr/local/redis'
#redis版本，需要安装其他版本可以修改这个，去官网参考
redis_version='redis-6.2.3'
redis_url="https://download.redis.io/releases/$redis_version.tar.gz"
#1.判断安装目录是否存在，存在提示删除。否则结束脚本
if [ -d "$redis_home" ]
then
	read -t 60 -p "目录$redis_home存在，是否删除? (y/n)："  confirm
	echo "输入内容：$confirm"
	case $confirm in
	y | Y)
		if  rm -rf "$redis_home"
		then
			echo "删除$redis_home目录成功"
		fi;;
	n | N)
		echo "安装目录$redis_home存在，脚本运行结束====================end"
		exit;;
	*)
		echo "输入错误或60s未确认，脚本运行结束====================end"
                exit;;
	esac
fi
#2.创建安装目录，保证是最新的文件夹，无其他文件
if [ ! -d $redis_home ]
then
        echo "安装目录$redis_home不存在，创建$redis_home======================="
        mkdir $redis_home
fi

#3.进入到redis_home路径下下载压缩包并解压
if cd $redis_home
then
	if wget $redis_url
	then
		tar -zxvf  "$redis_version.tar.gz" >> tar.log
	else
		echo '下载安装包失败，请检查网络重新执行======================'
		exit
	fi
fi
#4.进入解压目录进行编译
if cd "$redis_home/$redis_version"
then
	if yum install gcc-c++ -y
	then
		if make
		then
			if make install PREFIX=/usr/local/redis
			then
				cp redis.conf ../bin/redis.conf
				echo ""
				echo ""
				echo ""
				echo "========================================================================="
				echo "========================================================================="
				echo "=============Redis安装完成，启动脚本目录/usr/local/redis/bin============="
				echo "=============配置文件已复制到/usr/local/redis/bin目录下=================="
				echo "=============自行修改配置文件配置，开放对应端口=========================="
				echo "=============启动命令：/usr/local/redis/bin/redis-server redis.conf======"
				echo "=============查看是否启动名称：ps -ef|grep redis========================="
				echo "=============默认端口6379，默认不需要密码================================"
				echo "=============卸载：停止程序，删除$redis_home，rm -rf $redis_home========="
				echo "========================================================================="
				echo "========================================================================="
				echo ""
				echo ""
				echo ""
			fi  >> /usr/local/redis/install.log
		else
			echo "make命令执行异常===================="
			exit
		fi
	fi
else
	echo "解压文件名称不是$redis_version=======，修改脚本部分代码重试========="
fi
echo ""
echo ""
echo "===========Redis安装完成，安装日志查看/usr/local/redis/install.log=========="
echo ""
echo ""

