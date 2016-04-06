FROM ubuntu:12.04

MAINTAINER Rafael Corrêa Gomes <rafaelcg_stz@hotmail.com>

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    software-properties-common \
    python-software-properties

RUN DEBIAN_FRONTEND=noninteractive add-apt-repository ppa:ondrej/php5-oldstable

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    php5 

RUN apt-get upgrade -y

RUN apt-get install -y apache2 \
    apache2-utils \
    libapache2-mod-php5 \
    bzip2 \
    php5-cli \
    php5-curl \
    php5-gd \
    php5-mysql \
    php5-mcrypt \
    unzip \
    vim \
    mysql-client-5.5 \
    libxml2-dev \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/*

RUN usermod -u 1000 www-data    

ADD http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.bz2 /tmp/
RUN tar xvjfC /tmp/ioncube_loaders_lin_x86-64.tar.bz2 /tmp/ \
    && rm /tmp/ioncube_loaders_lin_x86-64.tar.bz2 \
    && mkdir -p /usr/local/ioncube \
    && cp /tmp/ioncube/ioncube_loader_lin_5.4.so /usr/local/ioncube \
    && rm -rf /tmp/ioncube
COPY 00-ioncube.ini /etc/php5/apache2/conf.d/00-ioncube.ini
COPY 00-ioncube.ini /etc/php5/cli/conf.d/00-ioncube.ini

RUN /etc/init.d/apache2 restart

VOLUME ["/var/www/html"]

EXPOSE 80

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]