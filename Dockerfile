FROM ubuntu:latest
WORKDIR /tmp
RUN apt-get update \ 
    && apt-get -y install build-essential libpcre3 libpcre3-dev  libcurl4-openssl-dev\
    libssl-dev zlib1g zlib1g-dev gcc wget

RUN wget https://nginx.org/download/nginx-1.24.0.tar.gz \
    && tar -xf nginx-1.24.0.tar.gz \
    && cd nginx-1.24.0/ \
    && ./configure \
        --prefix=/usr/local/nginx \ 
        --sbin-path=/usr/sbin \
        --conf-path=/etc/nginx/nginx.conf \ 
        --pid-path=/var/run/nginx.pid \
        --error-log-path=/var/log/nginx/error.log \ 
        --http-log-path=/var/log/nginx/access.log\ 
	--with-http_ssl_module\
    && make && make install

COPY nginx /etc/init.d/

RUN chmod +x /etc/init.d/nginx

VOLUME ./extensions

CMD ["nginx", "-g", "daemon off;"]
