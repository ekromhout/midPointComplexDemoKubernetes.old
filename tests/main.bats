#!/usr/bin/env bats

load ../common

@test "010 Image is present" {
    docker image inspect tier/midpoint:latest
}

@test "020 Check basic components" {
    docker run -i $maintainer/$imagename \
	find \
		/usr/local/bin/startup.sh \
		/opt/midpoint/var/ \
		/etc/shibboleth/ \
		/etc/httpd/
}

# not much more to check here, as we cannot start midpoint container without having a repository
# so continuing with tests in demo/plain directory
