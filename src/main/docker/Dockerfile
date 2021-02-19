# JDK8-232
FROM harbor.powerdata.com.cn:30280/com.powersmart.ptyfb.3rd/tomcat:9.0.31-jdk8

MAINTAINER ptyfb <ptyfb@szboanda.net>

# 指定应用程序的根目录
ARG ENV_WEBAPP

# 复制代码到容器中
COPY ./$ENV_WEBAPP /usr/local/webapp/

ENTRYPOINT ["bash", "/usr/local/exec.sh"]