#!/bin/bash

# https://geekflare.com/apache-web-server-hardening-security/
# https://geekflare.com/10-best-practices-to-secure-and-harden-your-apache-web-server/
# https://www.tecmint.com/apache-security-tips/

CONFIG_FILE="/etc/apache2/apache2.conf"
MOD_FILE="/etc/apache2/mods-available"

echo " ------------------------------- "
echo "     Apache2 Server Hardening    "
echo " ------------------------------- "

echo -e "\nPerforming These Checklist 
1. Hide Apache Version and OS Identity from Errors
2. Disable Directory Listing    	
3. Use only TLS 1.2, Disable SSLv2, SSLv3
4. Disable Null and Weak Ciphers
5. Disabling TRACE support 
6. Disable Risky Http Methods
7. Protect binary and configuration directory permission
8. System Settings Protection
9. Enable XSS Protection
10. Disable HTTP 1.0 Protocol
     "

## Hide Apache Version and OS Identity from Errors

value=$( egrep -i "ServerTokens Prod" $CONFIG_FILE )
if [[ $? -eq 1 ]]
then 
	echo ServerTokens Prod >> $CONFIG_FILE

elif [[ $( echo $value | cut -d" " -f2 ) != "prod" ]] && [[ $? -eq 1 ]]
then
	echo ServerTokens Prod >> $CONFIG_FILE
fi 

value=$( egrep -i "ServerSignature Off" $CONFIG_FILE )
if [[ $? -eq 1 ]]
then
        echo ServerSignature Off >> $CONFIG_FILE

elif [[ $( echo $value | cut -d" " -f2 ) != "Off" ]] && [[ $? -eq 1 ]]
then
        echo ServerSignature Off >> $CONFIG_FILE
fi


## Disable directory browser listing

CATCH=$( egrep -i "options.*-indexes" $CONFIG_FILE )

if [[ $? -eq 1 ]]
then
sed -i "s|^\tOptions.*Indexes.*|&\n\tOptions -Indexes|" $CONFIG_FILE
fi


## Disable SSL v2 & v3

sed -i 's/^\tSSLProtocol.*/\tSSLProtocol –ALL +TLSv1.2/' $MOD_FILE/ssl.conf 

systemctl restart apache2
