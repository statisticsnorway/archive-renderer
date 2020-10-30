FROM openresty/openresty:alpine-fat

ENV PATH="/usr/local/openresty/luajit/bin:${PATH}"

RUN luarocks install gumbo
RUN luarocks install lua-resty-http
RUN luarocks install luasocket
RUN luarocks install luasec OPENSSL_DIR=/usr/local/openresty/openssl

COPY ./openresty/nginx.conf /usr/local/openresty/nginx/conf/nginx.conf
COPY ./openresty/handler.lua /usr/local/openresty/nginx/handler.lua

COPY ./lua-modules/ /usr/local/openresty/lualib
