# php-nginx

Docker image with php using nginx and php-fpm

```
docker pull icewind1991/php-nginx
```

## Serving your code

By default nginx is configured to server code from `/var/www/html`, you can either use a docker volume to place your code there or create a new image with the added code.

## php extensions

The following php extensions are installed and enabled by default:

- iconv
- mcrypt
- zip
- pdo
- pdo_pgsql
- pdo_sqlite
- pdo_mysql
- pgsql
- intl
- curl
- mbstring
- gd
- apcu
- opache
- blackfire (only for php5)

You can add additional php extensions by using the `docker-php-ext-configure` and `docker-php-ext-install` scripts. (see also the [official docker php docs](https://hub.docker.com/_/php/))

## Customizing nginx 

You can customize the nginx config without having to overwrite the main nginx config by adding a custom `nginx-app.conf` to `/etc/nginx/`
This file will be included in the `server` block of the nginx config.