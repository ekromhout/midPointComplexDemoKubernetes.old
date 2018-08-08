#
#  Just a demonstration of how to use TIER logging feature of midPoint.
#  It requires v3.9devel-262-g2778b2c or later.
#
#  This is derived from Evolveum's dockerization; this will be changed.
#
#  Building:      (assumes midpoint-3.9-SNAPSHOT-dist.tar.gz is present in the current directory)
#
#    docker build -t mp-h2 .
#
#  Running:
#
#    docker run -e ENV=testing -e USERTOKEN=3.9 mp-h2
#

FROM openjdk:8-jdk-alpine

MAINTAINER info@evolveum.com

ARG MP_VERSION=3.9-SNAPSHOT
ARG MP_DIST_FILE=midpoint-${MP_VERSION}-dist.tar.gz

ENV MP_DIR /opt/midpoint

RUN mkdir -p ${MP_DIR}/var

COPY ${MP_DIST_FILE} ${MP_DIR}

RUN echo 'Extracting midPoint archive...' \
 && tar xzf ${MP_DIR}/midpoint-${MP_VERSION}-dist.tar.gz -C ${MP_DIR} --strip-components=1

CMD java -Xmx2048M -Xms2048M -Dfile.encoding=UTF8 -Dmidpoint.home=$MP_DIR/var -Dmidpoint.logging.console.enabled=true -Dmidpoint.logging.console.prefix="midpoint;midpoint.log;$ENV;$USERTOKEN;" -Dmidpoint.logging.console.timezone=UTC -jar $MP_DIR/lib/midpoint.war
