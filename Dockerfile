FROM centos:7

ENV CJOSE_URL=https://github.com/pingidentity/mod_auth_openidc/releases/download/v2.3.0/cjose-0.5.1-1.el7.centos.x86_64.rpm MOD_AUTH_OPENIDC_URL=https://github.com/pingidentity/mod_auth_openidc/releases/download/v2.3.3/mod_auth_openidc-2.3.3-1.el7.centos.x86_64.rpm

RUN set -x \
	&& yum install -y epel-release \
	&& yum update -y \
    && yum install -y httpd mod_ssl jansson jansson-devel openssl-devel hiredis \
    && rpm -i  ${CJOSE_URL} \
    && rpm -i ${MOD_AUTH_OPENIDC_URL} \
    && yum -y clean all

COPY ./proxy.conf /etc/httpd/conf.d/proxy.conf

RUN set -x \
    && ln -sf /dev/stdout /var/log/httpd/access_log \
    && ln -sf /dev/stderr /var/log/httpd/error_log \
    && ln -sf /dev/stdout /var/log/httpd/ssl_access_log \
    && find /etc/httpd/conf.d/ ! -name proxy.conf -type f | xargs rm

EXPOSE 80 443

CMD [ "/usr/sbin/httpd", "-DFOREGROUND" ]
