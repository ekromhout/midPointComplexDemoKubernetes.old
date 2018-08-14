# Overview

This is a demonstration of midPoint - Grouper integration. It is a work in progress.

It is derived from [TIER Grouper composition](https://github.internet2.edu/docker/grouper/tree/master/test-compose).

In contrary to the original idea, the midPoint -> Grouper connection is realized via intermediate LDAP repository. This allows for better isolation, easier diagnostics and troubleshooting.

There are the following containers:

- `s-data`: source data (LDAP & MySQL), simulating systems of record
- `m-server`: midPoint application (GUI, REST, tasks, etc); it reads from `s-data`, updates its own repository and pushes data to Grouper via `i-data`
- `m-data`: midPoint repository (MySQL)
- `i-data`: intermediate repository for communication from midPoint to Grouper (LDAP)
- `g-ui`, `g-daemon`, `g-ws`: Grouper containers
- `g-data`: the Grouper repository (MySQL)
- `idp`: Shibboleth identity provider; it uses `i-data` as the auhentication source

All files needed to build and compose these containers are in `mp-gr` directory.

TODO ...

TODO: how to initialize things
