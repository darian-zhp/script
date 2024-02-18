# script

linux script library

## 注意事项

- redis 需要自己配置
    - 无密码
    - 无后台启动
    - 没有开启远程.
    - 无 redis-cli

- nginx
    - 之开启了开机启动, 其他无配置.

- openjdk8
    - 需要自行配置环境变量,将以下内容写入 `/etc/profile`, 然后刷新文件 `source /etc/profile`
  ```bash
      export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.212.b04-0.el7_6.x86_64
      export CLASSPATH=.:$JAVA_HOME/jre/lib/rt.jar:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
      export PATH=$PATH:$JAVA_HOME/bin
  ```
  