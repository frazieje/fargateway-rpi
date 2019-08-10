#!/bin/bash

ans=""

if [ "$1" == "-y" ]; then
    ans="y"
fi

while [ "$ans" != "y" ] && [ "$ans" != "yes" ] && [ "$ans" != "n" ] && [ "$ans" != "no" ]; do

    echo -e "Generate Certs? WARNING this will delete any existing Certs. Continue? (y/n): \c "
    read ans

    ans="$(echo -e "${ans}" | tr -d '[:space:]' | tr '[:upper:]' '[:lower:]')"

done

if [ "$ans" == "y" ] || [ "$ans" == "yes" ]; then

#devicecontrol auth
cd conf/devicecontrol

rm -rf auth/

mkdir auth
cd auth

mkdir server
cd server

openssl genrsa -out authkey.pem 2048

openssl pkcs8 -topk8 -inform PEM -outform PEM -in authkey.pem -out authkey8.pem -nocrypt

openssl req -new -key authkey.pem -out req.pem -outform PEM -subj /CN=devicecontrol/O=server/ -nodes

cd ../../../../ca/authca

openssl ca -config authopenssl.cnf -in ../../conf/devicecontrol/auth/server/req.pem -out ../../conf/devicecontrol/auth/server/authcert.pem -days 3650 -notext -batch -extensions server_ca_extensions

cp cacert.pem ../../conf/devicecontrol/auth/server/authcacert.pem

rm ../../conf/devicecontrol/auth/server/req.pem

cd ../../

#rabbitmq
cd conf/rabbitmq

rm -rf auth/

mkdir auth
cd auth

mkdir client
cd client

openssl genrsa -out authkey.pem 2048

openssl pkcs8 -topk8 -inform PEM -outform PEM -in authkey.pem -out authkey8.pem -nocrypt

openssl req -new -key authkey.pem -out req.pem -outform PEM -subj /CN=rabbitmq/O=client/ -nodes

cd ../../../../ca/authca

openssl ca -config authopenssl.cnf -in ../../conf/rabbitmq/auth/client/req.pem -out ../../conf/rabbitmq/auth/client/authcert.pem -days 3650 -notext -batch -extensions client_ca_extensions

cp cacert.pem ../../conf/rabbitmq/auth/client/authcacert.pem

rm ../../conf/rabbitmq/auth/client/req.pem

cd ../../

cd conf/rabbitmq

rm -rf client/

mkdir client
cd client

openssl genrsa -out key.pem 2048

openssl pkcs8 -topk8 -inform PEM -outform PEM -in key.pem -out key8.pem -nocrypt

openssl req -new -key key.pem -out req.pem -outform PEM -subj /CN=devicecontrol/O=client/ -nodes

cd ../../../../ca/mqca

openssl ca -config mqopenssl.cnf -in ../../conf/rabbitmq/client/req.pem -out ../../conf/rabbitmq/client/cert.pem -days 3650 -notext -batch -extensions client_ca_extensions

cp cacert.pem ../../conf/rabbitmq/client/cacert.pem

rm ../../conf/rabbitmq/client/req.pem

cd ../../

cd conf/rabbitmq

rm -rf server/

mkdir server
cd server

openssl genrsa -out key.pem 2048

openssl pkcs8 -topk8 -inform PEM -outform PEM -in key.pem -out key8.pem -nocrypt

openssl req -new -key key.pem -out req.pem -outform PEM -subj /CN=rabbitmq/O=server/ -nodes

cd ../../../../ca/mqca

openssl ca -config mqopenssl.cnf -in ../../conf/rabbitmq/server/req.pem -out ../../conf/rabbitmq/server/cert.pem -days 3650 -notext -batch -extensions server_ca_extensions

cp cacert.pem ../../conf/rabbitmq/server/cacert.pem

rm ../../conf/rabbitmq/server/req.pem

cd ../../

fi




