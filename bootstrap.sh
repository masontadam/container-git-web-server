#!/bin/bash

cp /tmp/git_docs/post-receive /admin/admin/hooks/

python /www/web/server.py &

/usr/sbin/sshd -D
