FROM centos:centos7

LABEL author="tier-packaging@internet2.edu <tier-packaging@internet2.edu>"

COPY ./conf/mariadb.repo /etc/yum.repos.d/

RUN yum install -y epel-release \
    && yum update -y \
    && yum install -y mariadb-server mariadb \
    && yum clean all \
    && rm -rf /var/cache/yum

COPY database_password.txt /tmp/

RUN mysql_install_db \
    && chown -R mysql:mysql /var/lib/mysql/ \
    && sed -i 's/^\(bind-address\s.*\)/# \1/' /etc/my.cnf \
    && sed -i 's/^\(log_error\s.*\)/# \1/' /etc/my.cnf \
    && sed -i 's/\[mysqld\]/\[mysqld\]\ncharacter_set_server = utf8/' /etc/my.cnf \
    && sed -i 's/\[mysqld\]/\[mysqld\]\ncollation_server = utf8_bin/' /etc/my.cnf \
    && sed -i 's/\[mysqld\]/\[mysqld\]\nport = 3306/' /etc/my.cnf \
    && cat  /etc/my.cnf \
    && echo "/usr/bin/mysqld_safe &" > /tmp/config \
    && echo "mysqladmin --silent --wait=30 ping || exit 1" >> /tmp/config \
    && echo "mysql -e \"CREATE USER 'root'@'%' IDENTIFIED BY '`cat /tmp/database_password.txt`';\"" >> /tmp/config \
    && echo "echo ok0" >> /tmp/config \
    && echo "mysql -e 'GRANT ALL PRIVILEGES ON *.* TO \"root\"@\"%\" WITH GRANT OPTION;'" >> /tmp/config \
    && echo "echo ok1" >> /tmp/config \
    && echo "mysql -e 'CREATE DATABASE midpoint CHARACTER SET utf8 COLLATE utf8_bin;'" >> /tmp/config \
    && echo "echo ok2" >> /tmp/config \
    && echo "mysql -e \"SET PASSWORD FOR 'root'@'localhost' = PASSWORD('`cat /tmp/database_password.txt`');\"" >> /tmp/config \
    && echo "echo ok3" >> /tmp/config \
    && cat /tmp/config \
    && bash /tmp/config \
    && rm -f /tmp/config /tmp/database_password.txt

EXPOSE 3306

CMD mysqld_safe
