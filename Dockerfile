FROM ubuntu:latest as base
WORKDIR /tmp
RUN apt-get update \ 
    && apt-get -y install build-essential libpcre3 libpcre3-dev  libcurl4-openssl-dev\
    libssl-dev zlib1g zlib1g-dev gcc wget curl make perl

RUN wget https://nginx.org/download/nginx-1.24.0.tar.gz && tar -xf nginx-1.24.0.tar.gz\ 
    && wget https://github.com/openresty/luajit2/archive/refs/tags/v2.1-20230410.tar.gz && tar -xzvf v2.1-20230410.tar.gz\
    && wget https://github.com/vision5/ngx_devel_kit/archive/refs/tags/v0.3.2.tar.gz && tar -xzvf v0.3.2.tar.gz\ 
    && wget https://github.com/openresty/lua-nginx-module/archive/refs/tags/v0.10.24.tar.gz && tar -xzvf v0.10.24.tar.gz \ 
    && wget https://github.com/openresty/lua-resty-core/archive/refs/tags/v0.1.26.tar.gz && tar -xzvf v0.1.26.tar.gz\ 
    && wget https://github.com/openresty/lua-resty-lrucache/archive/refs/tags/v0.13.tar.gz && tar -xzvf v0.13.tar.gz 

RUN cd luajit2-2.1-20230410/ \
    && make && make install

ENV LUAJIT_LIB=/usr/local/lib/
ENV LUAJIT_INC=/usr/local/include/luajit-2.1/

RUN cd lua-resty-core-0.1.26 \
    && make install PREFIX=/opt/nginx
RUN cd lua-resty-lrucache-0.13 \
    && make install PREFIX=/opt/nginx

RUN cd nginx-1.24.0\
    && ./configure \
        --prefix=/usr/local/nginx \ 
        --sbin-path=/usr/sbin \
        --conf-path=/etc/nginx/nginx.conf \ 
        --pid-path=/var/run/nginx.pid \
        --error-log-path=/var/log/nginx/error.log \ 
        --http-log-path=/var/log/nginx/access.log\
        --with-ld-opt="-Wl,-rpath,$LUAJIT_LIB" \
	--add-module=/tmp/lua-nginx-module-0.10.24/ \
	--add-module=/tmp/ngx_devel_kit-0.3.2/ \
	--with-http_ssl_module\
    && make && make install


RUN wget https://openresty.org/download/openresty-1.21.4.1.tar.gz

RUN sed -i '$i     lua_package_path "/opt/nginx/lib/lua/?.lua;;";' /etc/nginx/nginx.conf \
    && sed -i '$i     include /data/sites-enabled/*;' /etc/nginx/nginx.conf


FROM ubuntu:latest

WORKDIR /

COPY --from=base /usr/local/nginx /usr/local/nginx
COPY --from=base /usr/local/lib /usr/local/lib
COPY --from=base /usr/local/include /usr/local/include
COPY --from=base /usr/sbin/nginx /bin/sh/nginx
COPY --from=base /etc/nginx/ /etc/nginx/
COPY --from=base /var/log/nginx/ /var/log/nginx/
COPY --from=base /opt/nginx /opt/nginx/

COPY nginx /etc/init.d/

RUN chmod +x /etc/init.d/nginx

CMD ["nginx", "-g", "daemon off;"]
