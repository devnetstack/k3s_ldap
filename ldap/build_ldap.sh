#!/usr/bin/env bash
sudo su -

cat <<EOF | debconf-set-selections
slapd slapd/password1 password adminpassword
slapd slapd/password2 password adminpassword
slapd slapd/domain string devnetstack.com
slapd shared/organization string devnetstack.com
EOF

apt update
apt install -y slapd
apt install -y ldap-utils

echo "dn: cn=mrdev,dc=devnetstack,dc=com
objectClass: top
objectClass: inetOrgPerson
gn: mr
sn: dev
cn: mrdev
userPassword: mrdevpassword
ou: dev" > mrdev.ldif

echo "dn: cn=mrprod,dc=devnetstack,dc=com
objectClass: top
objectClass: inetOrgPerson
gn: mr
sn: prod
cn: mrprod
userPassword: mrprodpassword
ou: prod" > mrprod.ldif

ldapadd -H ldap://192.168.0.254 \
  -x -D cn=admin,dc=devnetstack,dc=com -w adminpassword -f mrdev.ldif

ldapadd -H ldap://192.168.0.254 \
  -x -D cn=admin,dc=devnetstack,dc=com -w adminpassword -f mrprod.ldif
  