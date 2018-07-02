# docker-php7.2-nginx-prod-env
### Overview

PHP 7.2 , Nginx 1.10.3 , Optimized production environment for laravel

### Features

* PHP7.2 
* Nginx 1.10.3 with HTTP2
* Letsencrypt integration (auto set up SSL and renew)
* Optimized PHP-FPM and Nginx
* Auto deploy your laravel project

### ENV List

| ENV                   | Default Value                    | description                                                  |
| --------------------- | -------------------------------- | ------------------------------------------------------------ |
| DOMAIN                | _                                | assign a *domain* to *your* deployments                      |
| FPM_POOL_CONF         | /etc/php/7.2/fpm/pool.d/www.conf | php fpm pool config file path                                |
| FPM_CONF              | /etc/php/7.2/fpm/php-fpm.conf    | php fpm config file path                                     |
| PHP_CONF              | /etc/php/7.2/fpm/php.ini         | php config file path                                         |
| FPM_MAX_CHILDREN      | 100                              | see http://php.net/manual/en/install.fpm.configuration.php   |
| FPM_START_SERVERS     | 8                                | see http://php.net/manual/en/install.fpm.configuration.php   |
| FPM_MIN_SPARE_SERVERS | 6                                | see http://php.net/manual/en/install.fpm.configuration.php   |
| FPM_MAX_SPARE_SERVERS | 10                               | see http://php.net/manual/en/install.fpm.configuration.php   |
| SITEROOT              | /var/www/html                    | your code deploy path                                        |
| WEBROOT               | /var/www/html/public             | directory with http access                                   |
| GIT_EMAIL             |                                  | your git email account                                       |
| GIT_NAME              |                                  | your git name                                                |
| GIT_REPO              |                                  | your git repository address like  github.com/plokhotnyuk/jsoniter-scala (without any protocols) |
| GIT_BRANCH            | master                           | your git repository branch                                   |
| GIT_TOKEN             | xxxxx                            | your git access_token                                        |



### Quick Start

---

to pull image from dockerhub

```
docker pull andylee/phpenv
```

run the container 

```
docker run -d -it -p 80:80 -p 443:443 --name prod phpenv:latest
```

connect into the container

```
docker exec -it prod bash
```

pull your code

```
pull
```

set up ssl

```
setup-ssl
```

renew ssl

```
renew
```

