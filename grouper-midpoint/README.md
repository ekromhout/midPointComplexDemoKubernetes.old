# Overview

This is a demonstration of midPoint - Grouper integration. It is a work in progress.

It is derived from [TIER Grouper composition](https://github.internet2.edu/docker/grouper/tree/master/test-compose).

In contrary to the original idea, the midPoint -> Grouper connection is realized via intermediate LDAP repository. This allows for better isolation, easier diagnostics and troubleshooting.

There are the following containers:

- `sources`: source data (MySQL), simulating systems of record
- `midpoint-server`: midPoint application (GUI, REST, tasks, etc); it reads from `sources`, updates its own repository and `directory`
- `midpoint-data`: midPoint repository (MySQL)
- `directory`: central LDAP directory; used also by Grouper and Shibboleth IdP
- `grouper-ui`, `grouper-daemon`, `grouper-ws`, `gsh`: Grouper containers
- `grouper-data`: the Grouper repository (MySQL)
- `idp`: Shibboleth identity provider; it uses `directory` as the auhentication source
- `targets`: target(s) where identities should be provisioned (currently MySQL)

All files needed to build and compose these containers are in `mp-gr` directory.

TODO:
 - Grouper -> midPoint via MQ
 - performance of initial import from courses (500ms per user)
 - fix hardcoded password for grouper loader LDAP
