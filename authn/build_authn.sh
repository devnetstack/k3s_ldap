#!/usr/bin/env bash
wget https://dl.google.com/go/go1.14.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.14.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin

go get github.com/go-ldap/ldap
go get k8s.io/api/authentication/v1

wget https://raw.githubusercontent.com/devnetstack/authentication/master/authn.go

GOOS=linux GOARCH=amd64 go build authn.go

sudo openssl req -x509 -newkey rsa:2048 -nodes -subj "/CN=localhost" -keyout key.pem -out cert.pem
sudo touch /var/log/authn.log
sudo chmod 777 /var/log/authn.log
sudo ./authn localhost key.pem cert.pem &>/var/log/authn.log &