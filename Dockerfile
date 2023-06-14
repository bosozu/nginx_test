FROM ubuntu:latest
WORKDIR /tmp
RUN apt-get update \ 
    && apt-get -y install build-essential \
    && apt-get -y install libpcre3 libpcre3-dev \
    && apt-get -y libcurl4-openssl-dev\
    && apt-get -y gcc \
    && apt-get -y wget

RUN wget https://nginx.org/dowload/nginx-1.24.0.tar.gz \
    && tar -xf nginx-1.24.0.tar.gz \
    && cd /nginx \
    && ./configure \
        --prefix=/usr/local/nginx \
        --sbin-path=/usr/sbin \
        --conf-path=/etc/nginx/nginx.conf \
        --pid-path=/var/run/nginx.pid \
        --error-log-path=/var/log/nginx/error.log \
        --http-log-path=/var/log/nginx/access.log \
        --with-http_ssl_module \
    &&  make && make install

VOLUME ~/docker_learn/nginx_test/extensions

EXPOSE 3080/tcp
EXPOSE 3080/udp

