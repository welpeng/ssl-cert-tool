## 

## 依赖环境

1. 安装docker与docker-compose



## 快速入门

1. 样例的server.jks包含ca证书密钥对信息，实际使用中用户可以使用下面命令生成自签名的CA证书

   ```shell
   keytool -genkeypair -keyalg RSA -dname "OU=test,O=test,L=shenzhen,ST=guangdong,C=CN,CN=Test CA" -alias rootca -keystore server.jks -keypass 123456 -storepass123456 -validity 365
   
   ```

   

2.  构建镜像

   ```shell
   docker built -t ssl-tool:1.0.0 ./
   ```

3.  运行容器

   ```shell
   docker-compose up -d
   ```

4.  查看export目录，该目录是nginx需要的证书