#!/bin/bash
# sudo apt-get update && apt-get install -y docker.io

# Create `docker` group and add current user to group for permissions
# sudo groupadd docker
# sudo usermod -aG docker $USER

# Spin up Git Server

sudo docker build -t git-server1 . 
#sudo docker run -dit server
sudo docker run -dit --name=git-server -v ~/.ssh:/home/admin/.ssh \
	-v $(echo "$SSH_AUTH_SOCK"):$(echo "$SSH_AUTH_SOCK") \
	-e SSH_AUTH_SOCK=$(echo "$SSH_AUTH_SOCK") git-server1

DOCKER_IP="$(sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' git-server)"
echo "${DOCKER_IP}"
# Create local repo and push to server
mkdir admin
cd admin && git init
cd ../ && cp -r git_docs/. admin
cd admin && git add .
git commit -m "test message" -a
git remote add origin ssh://admin@"${DOCKER_IP}"/admin/admin
git push origin master
