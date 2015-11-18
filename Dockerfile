FROM debian:jessie
MAINTAINER "Youngho Byun (echoes)" <elend80@gmail.com>

ENV TERM xterm

RUN echo Asia/Seoul | tee /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata

RUN apt-get update
RUN apt-get install -y nano wget dialog net-tools curl git supervisor

# NGINX Install

RUN apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62
RUN echo "deb http://nginx.org/packages/debian/ jessie nginx" > /etc/apt/sources.list.d/nginx.list
RUN apt-get update && \
    apt-get install -y nginx && \
    rm -rf /var/lib/apt/list/* 

# HHVM Install

RUN apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0x5a16e7281be7a449
RUN echo "deb http://dl.hhvm.com/debian jessie main" > /etc/apt/sources.list.d/hhvm.list

RUN apt-get update && \
    apt-get install -y hhvm && \
    rm -rf /var/lib/apt/lists/*

ADD nginx.conf /etc/nginx/nginx.conf

ADD default.conf /etc/nginx/conf.d/default.conf

ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
RUN chown root:root /etc/supervisor/conf.d/supervisord.conf

RUN echo "<?php phpinfo(); ?>" > /usr/share/nginx/html/phpinfo.php

EXPOSE 80
EXPOSE 443

CMD ["/usr/bin/supervisord"]
