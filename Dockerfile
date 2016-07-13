FROM ubuntu:14.04
MAINTAINER kazu69 "kazu.69.web+docker@gmail.com"

ENV PHP_VERSION 5.3.29

RUN apt-get update && \
    apt-get -y install curl \
                        git \
                        php5 \
                        php5-dev \
                        php5-cli \
                        php-pear \
                        php5-curl \
                        php5-mysql \
                        libmcrypt-dev \
                        libicu-dev \
                        libxml2-dev \
                        openssl \
                        libssl-dev \
                        libcurl4-openssl-dev \
                        bzip2 \
                        libbz2-dev \
                        build-essential \
                        autoconf \
                        automake \
                        libreadline-dev \
                        libxslt1-dev \
                        bison \
                        libpcre3-dev \
                        libjpeg-dev \
                        libpng12-dev \
                        libxpm-dev \
                        libfreetype6-dev \
                        libmysqlclient-dev \
                        libgd-dev

RUN curl -sL https://github.com/phpbrew/phpbrew/raw/master/phpbrew -o /usr/local/bin/phpbrew
RUN chmod +x /usr/local/bin/phpbrew

RUN echo "source ~/.phpbrew/bashrc\nphpbrew use ${PHP_VERSION}" >> ~/.bashrc
RUN phpbrew init && phpbrew update --old && phpbrew install ${PHP_VERSION} +default +mysql +mb
