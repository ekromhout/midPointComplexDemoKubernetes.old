#
#  Building assumes midpoint-3.9-SNAPSHOT-dist.tar.gz is present in the current directory.
#

FROM tier/shibboleth_sp

MAINTAINER info@evolveum.com

RUN yum -y install java-1.8.0-openjdk

RUN rm /etc/shibboleth/sp-key.pem /etc/shibboleth/sp-cert.pem

COPY container_files/httpd/conf/* /etc/httpd/conf.d/
COPY container_files/shibboleth/* /etc/shibboleth/
COPY container_files/usr-local-bin/* /usr/local/bin/

RUN cp /dev/null /etc/httpd/conf.d/ssl.conf \
    && sed -i 's/LogFormat "/LogFormat "httpd;access_log;%{ENV}e;%{USERTOKEN}e;/g' /etc/httpd/conf/httpd.conf \
    && echo -e "\nErrorLogFormat \"httpd;error_log;%{ENV}e;%{USERTOKEN}e;[%{u}t] [%-m:%l] [pid %P:tid %T] %7F: %E: [client\ %a] %M% ,\ referer\ %{Referer}i\"" >> /etc/httpd/conf/httpd.conf \
    && sed -i 's/CustomLog "logs\/access_log"/CustomLog "\/tmp\/logpipe"/g' /etc/httpd/conf/httpd.conf \
    && sed -i 's/ErrorLog "logs\/error_log"/ErrorLog "\/tmp\/logpipe"/g' /etc/httpd/conf/httpd.conf \
    && echo -e "\nPassEnv ENV" >> /etc/httpd/conf/httpd.conf \
    && echo -e "\nPassEnv USERTOKEN" >> /etc/httpd/conf/httpd.conf

# Build arguments

ARG MP_VERSION=3.9-SNAPSHOT
ARG MP_DIST_FILE=midpoint-${MP_VERSION}-dist.tar.gz

ENV MP_DIR /opt/midpoint

RUN mkdir -p ${MP_DIR}/var

COPY ${MP_DIST_FILE} ${MP_DIR}
COPY container_files/mp-dir/ ${MP_DIR}/

RUN echo 'Extracting midPoint archive...' \
 && tar xzf ${MP_DIR}/midpoint-${MP_VERSION}-dist.tar.gz -C ${MP_DIR} --strip-components=1

VOLUME ${MP_DIR}/var

# Repository parameters

ENV REPO_HOST midpoint-data
ENV REPO_PORT 3306
ENV REPO_USER root
ENV REPO_DATABASE midpoint
ENV REPO_JDBC_URL default
ENV REPO_PASSWORD_FILE /run/secrets/m_database_password.txt
ENV REPO_DATABASE_TYPE mariadb

# Logging parameters

ENV ENV demo
ENV USERTOKEN $MP_VERSION

# Authentication/web

ENV AUTHENTICATION internal
ENV SSO_HEADER uid
ENV AJP_ENABLED true
ENV AJP_PORT 9090
ENV LOGOUT_URL https://localhost:8443/Shibboleth.sso/Logout

# Other parameters

ENV KEYSTORE_PASSWORD_FILE /run/secrets/m_keystore_password.txt
ENV MEM 2048m

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
