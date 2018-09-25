[![Build Status](https://jenkins.testbed.tier.internet2.edu/job/docker/job/midPoint_container/job/master/badge/icon)](https://jenkins.testbed.tier.internet2.edu/job/docker/job/midPoint_container/job/master/)

This repository contains sources for TIER-supported images related to [Evolveum midPoint](http://midpoint.evolveum.com).

# Images
- `midpoint` contains the midPoint application along with some TIER-specific components: Apache reverse proxy with optional Shibboleth filter and TIER Beacon.
- `midpoint-mariadb` hosts the default MariaDB database tailored to meet midPoint needs. It can be exchanged for another repository implementation.

# Supported tags
These tags apply to both containers:
- latest
- midPoint version-specific tags, e.g. 3.9, 3.9.1, 4.0, etc.

# Content
- `midpoint` directory contains build instructions for both containers (`midpoint` and `midpoint-mariadb`),
- `demo` directory contains three demonstration scenarios:
-- `shibboleth` to show integration with Shibboleth IdP,
-- `postgresql` to show how to change the repository implementation,
-- `complex` to demonstrate more complex deployment of midPoint in a sample university environment, featuring midPoint along with Grouper, LDAP directory, RabbitMQ, Shibboleth IdP, source and target systems.

# Build instructions
Please see specific subdirectories: [midpoint](midpoint) and [demo/complex](demo/complex).

# Documentation
- For the `midpoint` and `midpoint-mariadb` containers themselves please see [Dockerized midPoint](https://spaces.at.internet2.edu/display/MID/Dockerized+midPoint) wiki page.
- For the complex demo please see [midPoint - Grouper integration demo](https://spaces.at.internet2.edu/display/MID/midPoint+-+Grouper+integration+demo) wiki page.

This is a work in progress. For its current status please see [Status of the work](https://spaces.at.internet2.edu/display/MID/Status+of+the+work).
