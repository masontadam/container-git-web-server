#!/bin/bash

cp /tmp/git_docs/post-receive /admin/admin/hooks/

echo "test" > /home/admin/test.txt

python /www/web/server.py &

/usr/sbin/sshd -D
