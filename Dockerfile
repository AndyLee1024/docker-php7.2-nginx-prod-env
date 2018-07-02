FROM debian:stretch
LABEL maintainer="Andy Lee <andy.dev@aliyun.com>"
COPY sources.list /etc/apt/
ENV FPM_POOL_CONF \/etc\/php\/7.2\/fpm\/pool.d\/www.conf
ENV FPM_CONF \/etc\/php\/7.2\/fpm\/php-fpm.conf
ENV PHP_CONF \/etc\/php\/7.2\/fpm\/php.ini
ENV FPM_MAX_CHILDREN 100
ENV FPM_START_SERVERS 8
ENV FPM_MIN_SPARE_SERVERS 6
ENV FPM_MAX_SPARE_SERVERS 10
ENV DOMAIN _
# 网站目录
ENV SITEROOT  \/var\/www\/html
# 对外访问目录
ENV WEBROOT \/var\/www\/html\/public
# GIT账号
ENV GIT_EMAIL your@example.com
# GIT name
ENV GIT_NAME andylee
# GIT_REPO 目前仅支持http
ENV GIT_REPO github.com/z-song/laravel-admin.git
# GIT 分支
ENV GIT_BRANCH master
# GIT TOKEN
ENV GIT_TOKEN qtry_1--000-eEkeoe6
RUN apt update && apt-get install -y wget unzip curl make gcc autoconf vim apt-transport-https lsb-release ca-certificates python python-dev python-pip
RUN wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
RUN echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php.list
RUN apt update && apt install -y git php7.2-cli php7.2-fpm php7.2-phar php7.2-common php7.2-redis php7.2-bcmath php7.2-curl php7.2-gd php7.2-json php7.2-mbstring php7.2-mysql php7.2-opcache php7.2-readline php7.2-xml
RUN apt install -y nginx && pip install -i https://pypi.doubanio.com/simple -U supervisor && ulimit -n && \
pip install -i https://pypi.doubanio.com/simple -U certbot
COPY config/nginx.conf /etc/nginx/
RUN sed -i -e "s/;emergency_restart_threshold = 0/emergency_restart_threshold = 10/g" \
           -e "s/;emergency_restart_interval = 0/emergency_restart_interval = 1m/g" \
           ${FPM_CONF}
RUN sed -i -e "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" \
        -e "s/;opcache.enable=1/opcache.enable=1/g" \
        -e "s/;opcache.memory_consumption=128/opcache.memory_consumption=128/g" \
        -e "s/;opcache.interned_strings_buffer=8/opcache.interned_strings_buffer=32/g" \
        -e "s/;opcache.max_accelerated_files=10000/opcache.max_accelerated_files=10000/g" \
        -e "s/;opcache.validate_timestamps=1/opcache.validate_timestamps=0/g" \
        -e "s/;opcache.revalidate_freq=2/opcache.revalidate_freq=0/g" \
        -e "s/file_uploads = On/file_uploads = Off/g" \ 
        ${PHP_CONF}
RUN sed -i \
        -e "s/;listen.allowed_clients = 127.0.0.1/listen.allowed_clients = 127.0.0.1/g" \
        -e "s/pm.max_children = 5/pm.max_children = ${FPM_MAX_CHILDREN}/g" \
        -e "s/pm.start_servers = 2/pm.start_servers = ${FPM_START_SERVERS}/g" \
        -e "s/pm.min_spare_servers = 1/pm.min_spare_servers = ${FPM_MIN_SPARE_SERVERS}/g" \
        -e "s/pm.max_spare_servers = 3/pm.max_spare_servers = ${FPM_MAX_SPARE_SERVERS}/g" \
        -e "s/;pm.process_idle_timeout = 10s;/pm.process_idle_timeout = 7s/g" \
        -e "s/;request_slowlog_timeout = 0/request_slowlog_timeout = 5/g" \
        -e "s/;slowlog = log\/\$pool.log.slow/slowlog = \/var\/log\/\$pool.log.slow/g" \
        -e "s/;pm.max_requests = 500/pm.max_requests = 500/g" \
        -e "s/listen = \/run\/php\/php7.2-fpm.sock/listen = 127.0.0.1:9000/g" \
        -e "s/;php_admin_value[memory_limit] = 32M/php_admin_value[memory_limit] = 1024M/g" \
        ${FPM_POOL_CONF}
WORKDIR /etc/nginx/sites-enabled
RUN rm default && mkdir /root/files
COPY config/site.conf .
COPY config/site-ssl.conf /root/files
EXPOSE 80 443
COPY scripts/start.sh /
RUN chmod 755 /start.sh
COPY config/supervisord.conf /etc
COPY scripts/pull.sh /usr/local/bin/pull
COPY scripts/setssl.sh /usr/local/bin/setup-ssl
COPY scripts/renew.sh /usr/local/bin/renew-ssl
RUN chmod +x /usr/local/bin/pull && chmod +x /usr/local/bin/setup-ssl && chmod +x /usr/local/bin/renew-ssl
WORKDIR /root
CMD ["/start.sh"]