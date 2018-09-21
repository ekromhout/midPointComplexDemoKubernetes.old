#!/bin/sh

# generic console logging pipe for anyone
mkfifo -m 666 /tmp/logpipe
cat <> /tmp/logpipe 1>&2 &

mkfifo -m 666 /tmp/loghttpd
(cat <> /tmp/loghttpd  | awk '{printf "%s\n", $0; fflush()}' 1>/tmp/logpipe) &

mkfifo -m 666 /tmp/logshib
(cat <> /tmp/logshib  | awk '{printf "%s\n", $0; fflush()}' 1>/tmp/logpipe) &

mkfifo -m 666 /tmp/logcrond
(cat <> /tmp/logcrond  | awk -v ENV="$ENV" -v USERTOKEN="$USERTOKEN" '{printf "crond;console;%s;%s;%s\n", ENV, USERTOKEN, $0; fflush()}' 1>/tmp/logpipe) &

mkfifo -m 666 /tmp/logsuperd
(cat <> /tmp/logsuperd | awk -v ENV="$ENV" -v USERTOKEN="$USERTOKEN" '{printf "supervisord;console;%s;%s;%s\n", ENV, USERTOKEN, $0; fflush()}' 1>/tmp/logpipe) &

/usr/bin/supervisord -c /etc/supervisor/supervisord.conf
