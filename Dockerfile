FROM centos7

MAINTAINER LOUARDI Abdeltif <louardi.abdeltif@gmail.com>

# Prepare repositories
ADD etc/nginx.repo /etc/yum.repos.d/nginx.repo

RUN rpm -Uvh http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
RUN rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm

RUN yum -y clean all && yum -y update

# Install nginx, fpm and php
RUN yum -y --enablerepo=remi,remi-php56 install nginx php-fpm php-common

# Install php extensions
RUN yum -y --enablerepo=remi,remi-php56 install php-opcache php-pecl-apcu php-cli php-pear php-pdo php-mysqlnd php-pgsql php-pecl-mongo php-pecl-sqlite php-pecl-memcache php-pecl-memcached php-gd php-mbstring php-mcrypt php-xml

# Prepare BOOT
RUN chkconfig httpd off && chkconfig --add nginx && chkconfig --levels 235 nginx on && chkconfig --add php-fpm && chkconfig --levels 235 php-fpm on

# STOP httpd server and start nginx
RUN service httpd stop && service nginx start

# Start FPM
RUN service php-fpm start
