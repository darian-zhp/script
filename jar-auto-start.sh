#!/usr/bin/env bash

APP_NAME="XX.jar"
APP_PATH="/data/www-data/app/"
APP_PID=0

start() {
  # 测试部署
  echo ">>> $APP_NAME 启动中...<<< "
  nohup java -Xms128m -Xmx512m -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=8018 -jar $APP_PATH$APP_NAME >/dev/null 2>&1 &
}

stop() {
  if [[ -n "${APP_PID}" ]]; then
    if ! kill -9 "$APP_PID"; then
      echo ">>> $APP_NAME PID=$APP_PID 进程无法关闭, 出现异常, 请手动关闭. <<<"
      exit 1
    fi
    echo ">>> $APP_NAME -> PID=$APP_PID, 进程已结束... <<< "
  fi
}


APP_PID=$(pgrep -f $APP_NAME)
if [[ ! "$APP_PID" ]]; then
  start
  exit
fi