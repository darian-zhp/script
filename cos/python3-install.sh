#!/usr/bin/env bash

#
# python 3.8.12 install script
#


# 依赖
if yum install -y zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gcc make
  then
  yum install libffi-devel -y
  echo '-√- 安装依赖完成.'
fi


# package download
if wget https://www.python.org/ftp/python/3.8.12/Python-3.8.12.tgz
then
  tar -zxvf Python-3.8.12.tgz
  cd Python-3.8.12 || {
    echo '-X- 请确认解压目录是否存在!'
    exit 1
  }
  ./configure
  # build
   make&&make install || {
     echo '-X- make error.'
     exit 1
   }
    # 软连接
   which pip3
   mv /usr/bin/python /usr/bin/python.bak
   # python3
   ln -s /usr/local/bin/python3 /usr/bin/python
   python -V
   # pip3
   which pip3
   ln -s /usr/local/bin/pip3 /usr/bin/pip
   pip -V

   # 修复 yum
   sed -i "s|/usr/bin/python|/usr/bin/python2|g" /usr/libexec/urlgrabber-ext-down
   sed -i "s|/usr/bin/python|/usr/bin/python2|g" /usr/bin/yum

   echo ''
   echo '--------------------------'
   echo '-√- python3 安装结束.'
   echo '--------------------------'
   python -V
   echo '--------------------------'
   pip -V
   echo ''
fi
