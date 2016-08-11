FROM rhel7

MAINTAINER ky13 (kritchie@redhat.com)

COPY epel-release-latest-7.noarch.rpm $HOME

COPY php-mbstring-5.4.16-36.1.el7_2.1.x86_64.rpm $HOME 

COPY php-fpm-5.4.16-36.1.el7_2.1.x86_64.rpm $HOME

RUN rpm -ivh epel-release-latest-7.noarch.rpm 

RUN yum install -y wget systemd-sysv httpd mod_ssl mod_php tar git php-common php php-gd php-xml php-pear php-mysql mariadb-server mariadb && rpm -ivh php-mbstring-5.4.16-36.1.el7_2.1.x86_64.rpm && rpm -ivh php-fpm-5.4.16-36.1.el7_2.1.x86_64.rpm && yum clean all

RUN sed -i 's/Listen 80/Listen 8080/g' /etc/httpd/conf/httpd.conf
RUN sed -i 's/Listen 443/Listen 8443/g' /etc/httpd/conf.d/ssl.conf
RUN sed -i 's/Allow Override none/Allow Override all/g' /etc/httpd/conf/httpd.conf

RUN wget https://ftp.drupal.org/files/projects/drupal-8.1.7.tar.gz

RUN tar xvfz drupal-8.1.7.tar.gz -C /var/www/html/

RUN mv /var/www/html/drupal-8.1.7/ /var/www/html/drupal

RUN chown -R apache:apache /var/www/html/drupal

RUN cp -p /var/www/html/drupal/sites/default/default.settings.php /var/www/html/drupal/sites/default/settings.php

EXPOSE 8080
EXPOSE 8443

CMD mkdir /run/httpd; /usr/sbin/httpd -D FOREGROUND
