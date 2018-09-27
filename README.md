[![Build Status](https://jenkins.testbed.tier.internet2.edu/job/docker/job/midPoint_container/job/master/badge/icon)](https://jenkins.testbed.tier.internet2.edu/job/docker/job/midPoint_container/job/master/)

This repository contains sources for TIER-supported [midPoint](http://midpoint.evolveum.com) image.

The image contains the midPoint application along with some TIER-specific components: Apache reverse proxy with optional Shibboleth filter and TIER Beacon.

# Supported tags
- latest
- midPoint version-specific tags, e.g. 3.9, 3.9.1, 4.0, etc.

# Content
- the root directory contains build instructions for the `midpoint` image 
- `demo` directory contains a couple of demonstration scenarios:
  - `simple` to show simple composition of midPoint with the repository,
  - `shibboleth` to show integration with Shibboleth IdP,
  - `postgresql` to show how to change the repository implementation,
  - `complex` to demonstrate more complex deployment of midPoint in a sample university environment, featuring midPoint along with Grouper, LDAP directory, RabbitMQ, Shibboleth IdP, source and target systems.

# Build instructions
```
$ ./build.sh
```
You can then continue with one of demo composition, e.g. simple or complex one.

# Documentation
- For the `midpoint` image and container themselves please see [Dockerized midPoint](https://spaces.at.internet2.edu/display/MID/Dockerized+midPoint) wiki page.
- For the complex demo please see [midPoint - Grouper integration demo](https://spaces.at.internet2.edu/display/MID/midPoint+-+Grouper+integration+demo) wiki page.

This is a work in progress. For its current status please see [Status of the work](https://spaces.at.internet2.edu/display/MID/Status+of+the+work).
