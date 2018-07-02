#!/bin/bash

sed -i -e "s#+CONF+#${FPM_POOL_CONF}#g" /etc/supervisord.conf
sed -i -e "s/##DOMAIN##/${DOMAIN}/g" -e "s#root /var/www/html;#root ${WEBROOT};#g" /etc/nginx/sites-enabled/site.conf
cd ${SITEROOT}
# GIT_COMMAND='git clone'
# GIT_COMMAND=${GIT_COMMAND}" -b ${GIT_BRANCH} http://${GIT_NAME}:${GIT_TOKEN}@${GIT_REPO}"
# Setup git variables
if [ ! -z "$GIT_EMAIL" ]; then
 git config --global user.email "$GIT_EMAIL"
fi
if [ ! -z "$GIT_NAME" ]; then
 git config --global user.name "$GIT_NAME"
 git config --global push.default simple
fi

git init && git remote add origin http://${GIT_NAME}:${GIT_TOKEN}@${GIT_REPO}
git pull origin ${GIT_BRANCH}

if ! [ -x "$(command -v composer)" ]; then
    wget -c http://dayzhub-1251179143.file.myqcloud.com/composer.phar -O /usr/local/bin/composer
    chmod +x /usr/local/bin/composer
fi
composer dump-autoload && composer config -g repo.packagist composer https://packagist.phpcomposer.com
# echo ${GIT_COMMAND}
# ${GIT_COMMAND} ${SITEROOT}
composer install -vvv && composer update -vvv
CACHE_DIR=storage
if [ -d "$CACHE_DIR" ]; then
   chmod -R 777 ${CACHE_DIR}
fi
mkdir /root/supervisor && mkdir /var/log/supervisor
exec supervisord -n -c /etc/supervisord.conf