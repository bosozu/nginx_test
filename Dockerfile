FROM ubuntu:latest
WORKDIR /tmp
RUN apt-get update \ 
    && apt-get -y install build-essential libpcre3 libpcre3-dev  libcurl4-openssl-dev\
    libssl-dev zlib1g zlib1g-dev gcc wget

RUN wget https://nginx.org/download/nginx-1.24.0.tar.gz && tar -xf nginx-1.24.0.tar.gz\ 
   # && wget https://github.com/openresty/luajit2/archive/refs/tags/v2.1-20230410.tar.gz && tar -xzvf v2.1-20230410.tar.gz\
    && wget https://github.com/vision5/ngx_devel_kit/archive/refs/tags/v0.3.2.tar.gz && tar -xzvf v0.3.2.tar.gz\ 
    && wget https://github.com/openresty/lua-nginx-module/archive/refs/tags/v0.10.24.tar.gz && tar -xzvf v0.10.24.tar.gz\ 
   # && wget https://github.com/openresty/lua-resty-core/archive/refs/tags/v0.1.26.tar.gz && tar -xzvf v0.1.26.tar.gz\ 
   # && wget https://github.com/openresty/lua-resty-lrucache/archive/refs/tags/v0.13.tar.gz && tar -xzvf v0.13.tar.gz\ 
    && cd nginx-1.24.0.tar.gz

RUN ./configure \
        --prefix=/usr/local/nginx \ 
        --sbin-path=/usr/sbin \
        --conf-path=/etc/nginx/nginx.conf \ 
        --pid-path=/var/run/nginx.pid \
        --error-log-path=/var/log/nginx/error.log \ 
        --http-log-path=/var/log/nginx/access.log\
	--add-module=/tmp/lua-nginx-module-0.10.24/ \
	--add-module=/tmp/ngx_devel_kit-0.3.2/ \
	--with-http_ssl_module\
    && make && make install

COPY nginx /etc/init.d/

RUN chmod +x /etc/init.d/nginx

VOLUME ./extensions

CMD ["nginx", "-g", "daemon off;"]
