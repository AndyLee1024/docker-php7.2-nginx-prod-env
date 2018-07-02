#!/bin/bash

# Lets Encrypt
if [ -z "$WEBROOT" ] || [ -z "$GIT_EMAIL" ] || [ -z "$DOMAIN" ] && [ "$DOMAIN" -ne "_"]; then
 echo "You need the \$WEBROOT, \$GIT_EMAIL , \$DOMAIN Variables and DOMAIN not equal _ ."
else
 cp /root/files/site-ssl.conf /etc/nginx/sites-enabled/site-ssl.conf 
 certbot certonly --webroot -w $WEBROOT -d $DOMAIN --email $GIT_EMAIL --agree-tos --quiet
 ln -s /etc/nginx/sites-enabled/site-ssl.conf /etc/nginx/sites-available/

 # change nginx for webroot and domain name
 sed -i -e "s/##DOMAIN##/${DOMAIN}/g" -e "s#root /var/www/html;#root ${WEBROOT};#g" /etc/nginx/sites-enabled/site-ssl.conf
 supervisorctl restart nginx
fi  