FROM ubuntu:14.04
MAINTAINER kazu69

ENV PHP_VERSION 5.6.26

# change login shell from dash to bash
RUN rm /bin/sh && ln -s /bin/bash /bin/sh
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

RUN mkdir -p /usr/local/bin && \
      curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
      curl -sSL https://github.com/phpbrew/phpbrew/raw/master/phpbrew -o /usr/local/bin/phpbrew && chmod +x /usr/local/bin/phpbrew

RUN phpbrew init
RUN echo "" >> ~/.bashrc
RUN echo "# Source PHPbrew" >> ~/.bashrc
RUN echo "export PHPBREW_SET_PROMPT=1" >> ~/.bashrc
RUN echo "export PHPBREW_BIN=~/.phpbrew/bin" >> ~/.bashrc
RUN echo "export PHPBREW_HOME=~/.phpbrew" >> ~/.bashrc
RUN echo "export PHPBREW_ROOT=~/.phpbrew" >> ~/.bashrc
RUN echo "[[ -e ~/.phpbrew/bashrc ]] && source ~/.phpbrew/bashrc" >> ~/.bashrc

RUN phpbrew init && phpbrew update --old
RUN phpbrew install ${PHP_VERSION} \
            +default +mysql +mb +bz2 +cli +fileinfo +json \
            +mbregex +mbstring +mhash +pcntl +pcre +pdo +phar +posix +readline +sockets \
            +tokenizer +xml +curl +zip +openssl=yes +icu +opcache +fpm
RUN source $HOME/.phpbrew/bashrc && \
    phpbrew switch "php-${PHP_VERSION}" && \
    phpbrew ext install xdebug
