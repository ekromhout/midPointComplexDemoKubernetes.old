#
#  Building assumes midpoint-3.9-SNAPSHOT-dist.tar.gz is present in the current directory.
#

FROM tier/shibboleth_sp

MAINTAINER info@evolveum.com

RUN rpm --import http://repos.azulsystems.com/RPM-GPG-KEY-azulsystems
RUN curl -o /etc/yum.repos.d/zulu.repo http://repos.azulsystems.com/rhel/zulu.repo
RUN yum -y update
RUN yum -y install zulu-8

RUN yum -y install supervisor
COPY container_files/supervisor/supervisord.conf /etc/supervisord.conf

RUN rm /etc/shibboleth/sp-key.pem /etc/shibboleth/sp-cert.pem

COPY container_files/httpd/conf/* /etc/httpd/conf.d/
COPY container_files/httpd/possible-conf/* /etc/httpd/possible-conf/
COPY container_files/shibboleth/* /etc/shibboleth/
COPY container_files/usr-local-bin/ /usr/local/bin/

RUN cp /dev/null /etc/httpd/conf.d/ssl.conf \
    && sed -i 's/LogFormat "/LogFormat "httpd;access_log;%{ENV}e;%{USERTOKEN}e;/g' /etc/httpd/conf/httpd.conf \
    && echo -e "\nErrorLogFormat \"httpd;error_log;%{ENV}e;%{USERTOKEN}e;[%{u}t] [%-m:%l] [pid %P:tid %T] %7F: %E: [client\ %a] %M% ,\ referer\ %{Referer}i\"" >> /etc/httpd/conf/httpd.conf \
    && sed -i 's/CustomLog "logs\/access_log"/CustomLog "\/tmp\/logpipe"/g' /etc/httpd/conf/httpd.conf \
    && sed -i 's/ErrorLog "logs\/error_log"/ErrorLog "\/tmp\/logpipe"/g' /etc/httpd/conf/httpd.conf \
    && echo -e "\nPassEnv ENV" >> /etc/httpd/conf/httpd.conf \
    && echo -e "\nPassEnv USERTOKEN" >> /etc/httpd/conf/httpd.conf




# TODO switch to other appropriate Java implementation



ARG MP_VERSION=3.9-SNAPSHOT
ARG MP_DIST_FILE=midpoint-${MP_VERSION}-dist.tar.gz

ENV MP_DIR /opt/midpoint

RUN mkdir -p ${MP_DIR}/var

COPY ${MP_DIST_FILE} ${MP_DIR}
COPY container_files/mp-home/ ${MP_DIR}/var/

RUN echo 'Extracting midPoint archive...' \
 && tar xzf ${MP_DIR}/midpoint-${MP_VERSION}-dist.tar.gz -C ${MP_DIR} --strip-components=1

VOLUME ${MP_DIR}/var


ENV REPO_HOST midpoint-data
ENV REPO_PORT 3306
ENV REPO_USER root
ENV REPO_DATABASE midpoint
ENV REPO_PASSWORD_FILE /run/secrets/m_database_password.txt
ENV ENV demo
ENV USERTOKEN $MP_VERSION
#ENV ACTIVE_PROFILE default,sso
ENV SSO_HEADER uid
ENV AJP_ENABLED true
ENV AJP_PORT 9090
ENV LOGOUT_URL https://localhost:4438/Shibboleth.sso/Logout

CMD ["/usr/bin/supervisord"]
