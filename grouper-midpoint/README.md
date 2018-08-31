# Overview

This is a demonstration of midPoint - Grouper integration. It is a work in progress. It is described in more detail [here](https://spaces.at.internet2.edu/pages/viewpage.action?spaceKey=TIERENTREG&title=midPoint+-+Grouper+integration+demo).

This demonstration is derived from [TIER Grouper composition](https://github.internet2.edu/docker/grouper/tree/master/test-compose).

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

# Building and starting
## Downloading midPoint

Before building, please build or download current `midpoint-3.9-SNAPSHOT-dist.tar.gz` file and put it into `mp-gr/midpoint-server` directory. There are the following options:
1. Build midPoint from sources as described [here](https://wiki.evolveum.com/display/midPoint/Building+MidPoint+From+Source+Code) - *but use `tmp/tier` branch instead of `master`*. It should contain a bit more stable code in comparison with the master branch.
2. Use `download-midpoint` script.
3. Download midPoint manually from [Evolveum web site](https://evolveum.com/downloads/midpoint-tier/midpoint-3.9-SNAPSHOT-dist.tar.gz).

Showing e.g. the second option:

```
$ cd grouper-midpoint
$ ./download-midpoint
Downloading midPoint 3.9-SNAPSHOT
-----------------------------------------
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  157M  100  157M    0     0   867k      0  0:03:05  0:03:05 --:--:--  954k
-----------------------------------------
Checking the download...
OK
```

## Creating Docker composition

After midPoint archive is correctly placed into `mp-gr/midpoint-server` directory, please execute the following commands:

```
$ cd mp-gr
$ docker-compose up --build
```

This will take a while. You can ignore the following errors:

```
Subject API error: error with subject source id: ldap, name: EDU Ldap, problem with getSubject by id, in sources.xml: search searchSubject: , edu.internet2.middleware.subject.SourceUnavailableException: Ldap Exception: Pool is empty and object creation failed
```

They occur because the `ldap` subject source is not yet available.

Finally, you will see notices like these:

```
Creating mp-gr_directory_1     ... done
Creating mp-gr_midpoint-data_1  ... done
Creating mp-gr_mq_1             ... done
Creating mp-gr_targets_1       ... done
Creating mp-gr_sources_1       ... done
Creating mp-gr_grouper-data_1  ... done
Creating mp-gr_idp_1           ... done
Creating mp-gr_grouper-daemon_1 ... done
Creating mp-gr_grouper-ui_1      ... done
Creating mp-gr_midpoint-server_1 ... done
Attaching to mp-gr_directory_1, mp-gr_sources_1, mp-gr_targets_1, mp-gr_idp_1, mp-gr_grouper-data_1, mp-gr_mq_1, mp-gr_grouper-daemon_1, mp-gr_midpoint-data_1, mp-gr_grouper-ui_1, mp-gr_midpoint-server_1
```

followed by startup messages from individual Docker containers.

## Uploading initial objects

After Docker containers are up, check that you can log into midPoint at `http://localhost:8080/midpoint` using `administrator/5ecr3t`.
Then execute the following (in `grouper-midpoint` directory):

```
$ ./upload-objects 
Uploading midpoint-objects/objectTemplates/template-org-course.xml (objectTemplates, d35bdec6-643b-41d8-ad5d-8eeb701169d1)
Uploading midpoint-objects/objectTemplates/template-role-generic-group.xml (objectTemplates, 804f8658-0828-4dab-a2ed-f13985e4f80b)
Uploading midpoint-objects/objectTemplates/template-role-affiliation.xml (objectTemplates, d87aa04f-189c-4d6f-b6e1-216dad622142)
Uploading midpoint-objects/objectTemplates/template-org-department.xml (objectTemplates, 0caf2f69-7c72-4946-b218-d84e78b2a057)
Uploading midpoint-objects/resources/scriptedsql-sis-courses.xml (resources, 13660d60-071b-4596-9aa1-5efcd1256c04)
Uploading midpoint-objects/resources/ldap-main.xml (resources, 0a37121f-d515-4a23-9b6d-554c5ef61272)
Uploading midpoint-objects/resources/scriptedsql-sis-persons.xml (resources, 4d70a0da-02dd-41cf-b0a1-00e75d3eaa15)
Uploading midpoint-objects/resources/scriptedsql-grouper2.xml (resources, 6dcb84f5-bf82-4931-9072-fbdf87f96442)
Uploading midpoint-objects/systemConfigurations/SystemConfiguration.xml (systemConfigurations, 00000000-0000-0000-0000-000000000001)
Uploading midpoint-objects/orgs/org-departments.xml (orgs, bee44c51-2469-411d-bac7-695728e9c241)
Uploading midpoint-objects/orgs/org-courses.xml (orgs, 225e9360-0639-40ba-8a31-7f31bef067be)
Uploading midpoint-objects/roles/metarole-department.xml (roles, ffa9eaec-9539-4d15-97aa-24cd5b92ca5b)
Uploading midpoint-objects/roles/role-grouper-sysadmin.xml (roles, d48ec05b-fffd-4262-acd3-d9ff63365b62)
Uploading midpoint-objects/roles/metarole-course.xml (roles, 8aa99e7b-f7d3-4585-9800-14bab4d26a43)
Uploading midpoint-objects/roles/metarole-affiliation.xml (roles, fecae27b-d1d3-40ae-95fa-8f7e44e2ee70)
Uploading midpoint-objects/roles/role-grouper-basic.xml (roles, c89f31dd-8d4f-4e0a-82cb-58ff9d8c1b2f)
Uploading midpoint-objects/roles/metarole-generic-group.xml (roles, c691e15a-f30b-4e15-8445-532db07ceeeb)
```

After that you can log into midPoint and continue with steps described [in the After installation section](https://spaces.at.internet2.edu/display/TIERENTREG/midPoint+-+Grouper+integration+demo#midPoint-Grouperintegrationdemo-Afterinstallation) of the integration demo description.
