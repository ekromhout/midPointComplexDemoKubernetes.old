# Overview

This is a demonstration of midPoint - Grouper integration. It is a work in progress.                                  

It is derived from [TIER Grouper composition](https://github.internet2.edu/docker/grouper/tree/master/test-compose).

In contrary to the original idea, the midPoint -> Grouper connection is realized via intermediate LDAP repository. This allows for better isolation, easier diagnostics and troubleshooting.

There are the following containers:

- `g-data`: the Grouper repository (MySQL)
- `g-ui`, `g-daemon`, `g-ws`: containers fulfilling various Grouper roles
- `mp-data`: midPoint repository (MySQL)
- `mp-server`: midPoint application (GUI, REST, tasks, etc) (in the future this might be split into containers for distinct roles)
- `i-data`: intermediate LDAP repository for communication from midPoint to Grouper
- `idp`: Shibboleth identity provider
- `s-data`: source data (LDAP & MySQL), simulating systems of record

All files needed to build and compose these containers are in `mp-gr` directory.

TODO ...

TODO: how to initialize things
