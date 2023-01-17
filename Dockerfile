FROM openjdk:15-jdk-alpine
#ARG JAR_FILE
WORKDIR /opt/app

RUN echo -e 'https://mirrors.aliyun.com/alpine/v3.6/main/\nhttps://mirrors.aliyun.com/alpine/v3.6/community/' > /etc/apk/repositories && \
    apk update && \
    apk add openssl

COPY entrypoint.sh /opt/app/

COPY server.jks /opt/cert/
COPY ca.sh /opt/cert/

ENTRYPOINT ["sh","entrypoint.sh"]
