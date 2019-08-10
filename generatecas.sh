#!/bin/bash

ans=""

while [ "$ans" != "y" ] && [ "$ans" != "yes" ] && [ "$ans" != "n" ] && [ "$ans" != "no" ]; do

    echo -e "Generate CAs? WARNING this will delete any existing CAs. Continue? (y/n): \c "
    read ans

    ans="$(echo -e "${ans}" | tr -d '[:space:]' | tr '[:upper:]' '[:lower:]')"

done

if [ "$ans" == "y" ] || [ "$ans" == "yes" ]; then

rm -rf ca/

mkdir ca
cd ca

mkdir mqca
cd mqca
cp ../../mqopenssl.cnf .
mkdir certs private
chmod 700 private
echo 01 > serial
touch index.txt

openssl req -x509 -config mqopenssl.cnf -newkey rsa:4096 -days 7300 -out cacert.pem -outform PEM -subj /CN=fargatewayMqCA/ -nodes

cd ..

mkdir authca
cd authca
cp ../../authopenssl.cnf .
mkdir certs private
chmod 700 private
echo 01 > serial
touch index.txt

openssl req -x509 -config authopenssl.cnf -newkey rsa:4096 -days 7300 -out cacert.pem -outform PEM -subj /CN=fargatewayAuthCA/ -nodes

fi

