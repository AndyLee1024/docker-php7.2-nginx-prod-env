#!/bin/bash

# Lets Encrypt
if [ -z "$DOMAIN" ]; then
 echo "You need to have \$DOMAIN set"
else
 if [ -f /etc/letsencrypt/live/${DOMAIN}/fullchain.pem ]; then
  certbot renew
  supervisorctl restart nginx
 else
  echo "There is no cert to renew"
 fi
fi