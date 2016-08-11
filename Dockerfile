FROM rhel7

MAINTAINER ky13 (kritchie@redhat.com)

COPY epel-release-latest-7.noarch.rpm $HOME 

COPY webtatic-release.rpm $HOME

RUN rpm -ivh epel-release-latest-7.noarch.rpm && rpm -ivh webtatic-release.rpm

RUN yum install -y wget httpd mod_ssl mod_rewrite mariadb tar git php55w php55w-opcache php55w-mbstring php55w-gd php55w-xml php55w-pear php55w-fpm php55w-mysql && yum clean all

RUN sed -i 's/Listen 80/Listen 8080/g' /etc/httpd/conf/httpd.conf
RUN sed -i 's/Listen 443/Listen 8443/g' /etc/httpd/conf.d/ssl.conf
RUN sed -i 's/Allowverride none/AllowOverride all/g' /etc/httpd/conf/httpd.conf

RUN wget https://ftp.drupal.org/files/projects/drupal-8.1.7.tar.gz

RUN tar xvfz drupal-8.1.7.tar.gz -C /var/www/html/

RUN mv /var/www/html/drupal-8.1.7/ /var/www/html/drupal

RUN chown -R apache:apache /var/www/html/drupal

RUN cp -p /var/www/html/drupal/sites/default/default.settings.php /var/www/html/drupal/sites/default/settings.php

EXPOSE 8080
EXPOSE 8443

CMD /usr/sbin/httpd -D FOREGROUND
