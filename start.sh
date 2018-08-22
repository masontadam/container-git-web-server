#!/bin/bash

# Install Dependencies
sudo apt-get update && sudo apt-get install -y git && sudo apt-get install -y docker.io

# Create SSH Key
echo -e "\n" | ssh-keygen -N "" &> /dev/null
mkdir -p docker_ssh
cp ~/.ssh/id_rsa docker_ssh/id_rsa
cp ~/.ssh/id_rsa.pub docker_ssh/authorized_keys

# Spin up Git Server
sudo docker build -t dev-env3 . 
sudo docker run -dit --name=server \
	-v $(pwd)/git_docs/:/tmp/git_docs/ \
	-v $(pwd)/server_docs/:/www/web/ \
	-v $(pwd)/docker_ssh:/home/admin/.ssh \
	-v $(echo "$SSH_AUTH_SOCK"):$(echo "$SSH_AUTH_SOCK") \
	-e SSH_AUTH_SOCK=$(echo "$SSH_AUTH_SOCK") dev-env3

DOCKER_IP="$(sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' server)"

# Create local repo and push to server
mkdir admin
cd admin && git init
cd ../ && cp git_docs/test-script.sh admin 
cd admin && git add .

git commit -m "test message" -a
git remote add origin ssh://admin@"${DOCKER_IP}"/admin/admin
git push origin master
