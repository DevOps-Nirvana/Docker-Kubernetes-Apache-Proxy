# Our runner, standard apache
FROM httpd:2.4

# For debugging/farley install joe
RUN apt-get update \
    && apt-get install -y joe \
    && rm -rf /var/lib/apt/lists/* \
# configure apache to enable mod rewrite and proxy and ssl proxying
    && sed -i 's/#LoadModule rewrite_module modules\/mod_rewrite.so/LoadModule rewrite_module modules\/mod_rewrite.so/' /usr/local/apache2/conf/httpd.conf \
    && sed -i 's/#LoadModule proxy_module modules\/mod_proxy.so/LoadModule proxy_module modules\/mod_proxy.so/' /usr/local/apache2/conf/httpd.conf \
    && sed -i 's/#LoadModule ssl_module modules\/mod_ssl.so/LoadModule ssl_module modules\/mod_ssl.so/' /usr/local/apache2/conf/httpd.conf \
    && sed -i 's/#LoadModule proxy_http_module modules\/mod_proxy_http.so/LoadModule proxy_http_module modules\/mod_proxy_http.so/' /usr/local/apache2/conf/httpd.conf \
# configure apache to include * configuration files in the kubernetes folder
    && echo "Include conf/kubernetes/*.conf" >> /usr/local/apache2/conf/httpd.conf \
    && mkdir /usr/local/apache2/conf/kubernetes \
    && touch /usr/local/apache2/conf/kubernetes/empty.conf
# allow included/mounted codebases to override options by default, easier to tweak/configure dynamically, although this is not preferred over apache config
    && sed -i 's/AllowOverride none/AllowOverride all/gI' /usr/local/apache2/conf/httpd.conf
