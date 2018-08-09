#
# An image that derives from shib-sp and contains a Java implementation.
#
# PRELIMINARY VERSION
#
# TODO:
# - provide TIER-approved Java here
#

FROM tier/shib-sp

ARG maintainer=tier
ARG imagename=siteadmin-sp
ARG version=1.0

MAINTAINER $maintainer
LABEL Vendor="Internet2"
LABEL ImageType="SP"
LABEL ImageName=$imagename
LABEL ImageOS=centos7
LABEL Version=$version

LABEL Build docker build --rm --tag $maintainer/$imagename .

# TODO switch to other appropriate Java implementation

RUN yum -y install java-1.8.0-openjdk
