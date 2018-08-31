# Overview

This is a preliminary version of midPoint dockerization for TIER environment.

There are two containers there:

- `midpoint-server`: provides the midPoint application
- `midpoint-data`: provides the default midPoint repository; note that the repository can be implemented in any other way - by another container (perhaps hosting a different database) or by providing it externally: on premises or in cloud.

# Building and starting
## Downloading midPoint

Before building, please build or download current `midpoint-3.9-SNAPSHOT-dist.tar.gz` file and put it into `midpoint-server` directory. There are the following options:
1. Build midPoint from sources as described [here](https://wiki.evolveum.com/display/midPoint/Building+MidPoint+From+Source+Code) - *but use `tmp/tier` branch instead of `master`*. It should contain a bit more stable code in comparison with the master branch.
2. Use `download-midpoint` script.
3. Download midPoint manually from [Evolveum web site](https://evolveum.com/downloads/midpoint-tier/midpoint-3.9-SNAPSHOT-dist.tar.gz).

Showing e.g. the second option:

```
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

After midPoint archive is correctly placed into `midpoint-server` directory, please execute the following commands:

```
$ docker-compose up --build
```

This will take a while. 

Finally, you will see notices like these:

```
Starting midpoint_midpoint-data_1 ... 
Starting midpoint_midpoint-data_1 ... done
Recreating midpoint_midpoint-server_1 ... 
Recreating midpoint_midpoint-server_1 ... done
Attaching to midpoint_midpoint-data_1, midpoint_midpoint-server_1
```

followed by startup messages from individual Docker containers.

## After installation

After Docker containers are up, check that you can log into midPoint at `http://localhost:8080/midpoint` using `administrator/5ecr3t`.
