#!/usr/bin/env bash
if [ -z $CN ];then
	echo "CN环境变量缺失"
fi
if [ -z $NAME ];then
	echo "NAME环境变量缺失"
fi

if [ -z $EXPORT ];then
	mkdir /opt/export
  EXPORT=/opt/export
else
  EXPORT=$EXPORT
fi

#生成自签名二级证书
keytool -genkeypair -keyalg RSA -dname "OU=yelink,O=yelink,L=shenzhen,ST=guangdong,C=CN,CN=$CN" -alias $NAME -keystore server.jks -keypass yelink@1234 -storepass yelink@1234

# 生成证书签名请求（CSR文件）
keytool -certreq -alias $NAME -keystore server.jks -file temp_$NAME.csr -storepass yelink@1234 
#使用CA证书给$NAME证书签名,并新增扩展属性SAN（SubjectAlternativeName ）
keytool -gencert -alias rootca -keystore server.jks -infile temp_$NAME.csr -outfile $NAME.crt -storepass yelink@1234  -ext SAN=dns:$CN,ip:172.16.0.3 -validity 3650
keytool -import -v -alias $NAME  -file $NAME.crt -keystore server.jks -storepass yelink@1234

#从$NAME生成p12,根据p12生成nginx证书格式crt、key
keytool -importkeystore -srckeystore server.jks -srcalias $NAME -destkeystore temp.p12 -deststoretype PKCS12 -deststorepass yelink@1234  -srcstorepass yelink@1234 
openssl pkcs12 -nocerts -nodes -in temp.p12 -out server.key  -password pass:yelink@1234
openssl pkcs12 -in temp.p12 -nokeys -clcerts -out ssl.crt -password pass:yelink@1234
openssl pkcs12 -in temp.p12 -nokeys -cacerts -out ca.crt -password pass:yelink@1234
cat ssl.crt ca.crt >server.crt

cp server.crt $EXPORT/
cp server.key $EXPORT/