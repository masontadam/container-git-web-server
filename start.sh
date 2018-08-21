#!/bin/bash

# Install Dependencies
# sudo apt-get update && apt-get install -y docker.io

#Create SSH Key
echo -e "\n" | ssh-keygen -N "" &> /dev/null
cp -r ~/.ssh .

# Spin up Git Server
sudo docker build -t git-server2 . 
#sudo docker run -dit server
sudo docker run -dit --name=git-server \
	-v git-docs:/tmp/ \
	-v server-docs:/www/web \
	-v ~/.ssh:/home/admin/.ssh \
	-v $(echo "$SSH_AUTH_SOCK"):$(echo "$SSH_AUTH_SOCK") \
	-e SSH_AUTH_SOCK=$(echo "$SSH_AUTH_SOCK") git-server2

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
