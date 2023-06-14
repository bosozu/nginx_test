FROM ubuntu:latest
WORKDIR /tmp
RUN apt-get update \ 
    && apt-get -y install build-essential \
    && apt-get -y install libpcre3\ 
    && apt-get -y install libpcre3-dev \
    && apt-get -y install libcurl4-openssl-dev\
    && apt-get -y install libssl-dev\
    && apt-get -y install zlib1g zlib1g-dev\
    && apt-get -y install gcc \
    && apt-get -y install wget

RUN wget https://nginx.org/download/nginx-1.24.0.tar.gz \
    && tar -xf nginx-1.24.0.tar.gz \
    && cd nginx-1.24.0/ \
    && echo "./configure \
        --prefix=/usr/local/nginx \ 
        --sbin-path=/usr/sbin \
        --conf-path=/etc/nginx/nginx.conf \ 
        --pid-path=/var/run/nginx.pid \
        --error-log-path=/var/log/nginx/error.log \ 
        --http-log-path=/var/log/nginx/access.log\ 
	--with-http_ssl_module\
         " > conf.sh \
    && chmod 777 conf.sh \
    && ./conf.sh \ 
    &&  make && make install

COPY nginx /etc/init.d/

RUN chmod +x /etc/init.d/nginx

VOLUME ~/docker_learn/nginx_test/extensions

EXPOSE 3080/tcp
EXPOSE 3080/udp

CMD ["/usr/sbin/update-rc.d","-f","nginx","defaults"]
