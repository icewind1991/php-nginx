FROM php:7-fpm
MAINTAINER  Robin Appelman <robin@icewind.nl>

RUN DEBIAN_FRONTEND=noninteractive ;\
	apt-get update && \
	apt-get install --assume-yes \
		bzip2 \
		nginx \
		libaio-dev \
		wget \
		unzip \
		nano

# Oracle instantclient
ADD instantclient-basic-linux.x64-12.1.0.2.0.zip /tmp/
ADD instantclient-sdk-linux.x64-12.1.0.2.0.zip /tmp/
ADD instantclient-sqlplus-linux.x64-12.1.0.2.0.zip /tmp/

RUN unzip /tmp/instantclient-basic-linux.x64-12.1.0.2.0.zip -d /usr/local/
RUN unzip /tmp/instantclient-sdk-linux.x64-12.1.0.2.0.zip -d /usr/local/
RUN unzip /tmp/instantclient-sqlplus-linux.x64-12.1.0.2.0.zip -d /usr/local/
RUN ln -s /usr/local/instantclient_12_1 /usr/local/instantclient
RUN ln -s /usr/local/instantclient/libclntsh.so.12.1 /usr/local/instantclient/libclntsh.so
RUN ln -s /usr/local/instantclient/sqlplus /usr/bin/sqlplus
RUN echo 'instantclient,/usr/local/instantclient' | pecl install oci8
RUN echo "extension=oci8.so" > $PHP_INI_DIR/conf.d/30-oci8.ini
RUN rm /tmp/instantclient-*.zip

# php exceptions
RUN apt-get update && apt-get install -y \
		libfreetype6-dev \
		libjpeg62-turbo-dev \
		libmcrypt-dev \
		libpng12-dev \
		libpq5 \
		libpq-dev \
		libsqlite3-dev \
		libcurl4-openssl-dev \
		libicu-dev \
	&& docker-php-ext-install iconv mcrypt zip pdo pdo_pgsql pdo_sqlite pgsql pdo_mysql intl curl mbstring \
	&& docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
	&& docker-php-ext-install gd
RUN apt-get remove -y \
		libfreetype6-dev \
		libjpeg62-turbo-dev \
		libmcrypt-dev \
		libpng12-dev \
		libpq-dev \
		libsqlite3-dev \
		libcurl4-openssl-dev \
		libicu-dev
RUN pecl install apcu
ADD apcu.ini opcache.ini $PHP_INI_DIR/conf.d/

ADD nginx.conf nginx-app.conf /etc/nginx/

ADD php-fpm.conf /usr/local/etc/
ADD index.php /var/www/html/

ADD bootstrap-nginx.sh /usr/local/bin/

EXPOSE 80

ENTRYPOINT  ["bootstrap-nginx.sh"]
