#!/bin/bash

echo "👣 redis install-script start"
REDIS_HOME='/usr/local/redis'
REDIS_VERSION='redis-6.2.3'
REDIS_URL="https://download.redis.io/releases/${REDIS_VERSION}.tar.gz"
#1.判断安装目录是否存在,存在提示删除。否则结束脚本
if [ -d "$REDIS_HOME" ]; then
    read -t 60 -p "目录${REDIS_HOME}存在,是否删除? (y/n): " confirm
    echo "👣 输入内容: $confirm"
    case "$confirm" in
    y | Y)
        if rm -rf "$REDIS_HOME"; then
            echo "👣 删除$REDIS_HOME目录成功"
        fi
        ;;
    n | N)
        echo "👣 安装目录${REDIS_HOME}存在,脚本运行结束."
        exit
        ;;
    *)
        echo "👣 输入错误或60s未确认,脚本运行结束."
        exit
        ;;
    esac
fi

#2.创建安装目录,保证是最新的文件夹,无其他文件
if [ ! -d "$REDIS_HOME" ]; then
    echo "👣 安装目录${REDIS_HOME}不存在,创建${REDIS_HOME}"
    mkdir "$REDIS_HOME"
fi

#3.进入到REDIS_HOME路径下下载压缩包并解压
if cd "$REDIS_HOME"; then
    if wget "$REDIS_URL"; then
        tar -zxvf "$REDIS_VERSION".tar.gz
    else
        echo '👣 下载安装包失败,请检查网络重新执行'
        exit
    fi
fi
#4.进入解压目录进行编译
if cd "$REDIS_HOME"/"$REDIS_VERSION"; then
    if yum install gcc-c++ -y; then
        if make; then
            if make install PREFIX=/usr/local/redis; then
                cp redis.conf ../bin/redis.conf
                echo ""
                echo "==============================================================="
                echo "==============================================================="
                echo "===== Redis安装完成,启动脚本目录/usr/local/redis/bin             =="
                echo "===== 配置文件已复制到/usr/local/redis/bin目录下                  =="
                echo "===== 自行修改配置文件配置,开放对应端口                             =="
                echo "===== 启动命令: /usr/local/redis/bin/redis-server redis.conf   =="
                echo "===== 查看是否启动名称: ps -ef|grep redis                        =="
                echo "===== 默认端口6379,默认不需要密码                                 =="
                echo "===== 卸载: 停止程序,删除 $REDIS_HOME,rm -rf $REDIS_HOME         =="
                echo "==============================================================="
                echo "==============================================================="
                echo ""
            fi
        else
            echo "make命令执行异常"
            exit
        fi
    fi
else
    echo "👣 解压文件名称不是${REDIS_VERSION},修改脚本部分代码重试"
fi
echo ""
echo "👣 Redis安装完成."
echo ""

