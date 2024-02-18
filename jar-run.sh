#!/usr/bin/env bash

APP_NAME="XX.jar"
APP_PATH="/data/www-data/app/"
APP_PID=0

status() {
  APP_PID=$(pgrep -f $APP_NAME)
  if [[ ! "$APP_PID" ]]; then
    echo "$APP_NAME 没有运行. "
    exit 1
  fi
  echo ">>> $APP_NAME 程序正在运行中, PID=$APP_PID <<<"
}

start() {
  # 测试部署
  echo ">>> $APP_NAME 启动中...<<< "
  nohup java -Xms128m -Xmx512m -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=8018 -jar $APP_PATH$APP_NAME >/dev/null 2>&1 &
  status
}

stop() {
  status
  if [[ -n "${APP_PID}" ]]; then
    if ! kill -9 "$APP_PID"; then
      echo ">>> $APP_NAME PID=$APP_PID 进程无法关闭, 出现异常, 请手动关闭. <<<"
      exit 1
    fi
    echo ">>> $APP_NAME -> PID=$APP_PID, 进程已结束... <<< "
  fi
}

restart() {
  stop
  start
}

usage() {
  echo "你应该输入 < 1 | 2 | 3 | 4> 其中一个码."
  exit 1
}
echo ""
echo "请选择对应的功能码"
echo "------------------------"
echo "( 1 ) : start"
echo "( 2 ) : stop"
echo "( 3 ) : restart"
echo "( 4 ) : status"
echo "------------------------"
echo -e "-> \c"
read select
echo ""
case $select in
1)
  start
  ;;
2)
  stop
  ;;
3)
  restart
  ;;
4)
  status
  ;;
*)
  usage
  ;;
esac