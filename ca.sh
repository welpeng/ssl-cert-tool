#!/usr/bin/env bash
if [ -z $CN ];then
	echo "CN��������ȱʧ"
fi
if [ -z $NAME ];then
	echo "NAME��������ȱʧ"
fi

if [ -z $EXPORT ];then
	mkdir /opt/export
  EXPORT=/opt/export
else
  EXPORT=$EXPORT
fi

#������ǩ������֤��
keytool -genkeypair -keyalg RSA -dname "OU=yelink,O=yelink,L=shenzhen,ST=guangdong,C=CN,CN=$CN" -alias $NAME -keystore server.jks -keypass yelink@1234 -storepass yelink@1234

# ����֤��ǩ������CSR�ļ���
keytool -certreq -alias $NAME -keystore server.jks -file temp_$NAME.csr -storepass yelink@1234 
#ʹ��CA֤���$NAME֤��ǩ��,��������չ����SAN��SubjectAlternativeName ��
keytool -gencert -alias rootca -keystore server.jks -infile temp_$NAME.csr -outfile $NAME.crt -storepass yelink@1234  -ext SAN=dns:$CN,ip:172.16.0.3 -validity 3650
keytool -import -v -alias $NAME  -file $NAME.crt -keystore server.jks -storepass yelink@1234

#��$NAME����p12,����p12����nginx֤���ʽcrt��key
keytool -importkeystore -srckeystore server.jks -srcalias $NAME -destkeystore temp.p12 -deststoretype PKCS12 -deststorepass yelink@1234  -srcstorepass yelink@1234 
openssl pkcs12 -nocerts -nodes -in temp.p12 -out server.key  -password pass:yelink@1234
openssl pkcs12 -in temp.p12 -nokeys -clcerts -out ssl.crt -password pass:yelink@1234
openssl pkcs12 -in temp.p12 -nokeys -cacerts -out ca.crt -password pass:yelink@1234
cat ssl.crt ca.crt >server.crt

cp server.crt $EXPORT/
cp server.key $EXPORT/