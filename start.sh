#!/bin/bash

# Install Dependencies
sudo apt-get update && sudo apt-get install -y git && sudo apt-get install -y docker.io

# Create SSH Key
# echo -e "\n" | ssh-keygen -N "" &> /dev/null
# cp -r ~/.ssh .

# Spin up Git Server
sudo docker build -t dev-env . 
#sudo docker run -dit server
sudo docker run -dit --name=server \
	-v $(pwd)/git_docs/:/tmp/git_docs/ \
	-v $(pwd)/server_docs/:/www/web/ \
	-v ~/.ssh:/home/admin/.ssh \
	-v $(echo "$SSH_AUTH_SOCK"):$(echo "$SSH_AUTH_SOCK") \
	-e SSH_AUTH_SOCK=$(echo "$SSH_AUTH_SOCK") dev-env


DOCKER_IP="$(sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' server)"

# For Debugging Purposes
#echo "${DOCKER_IP}"

# Create local repo and push to server
mkdir admin
cd admin && git init
cd ../ && cp git_docs/test-script.sh admin
cd admin && git add .

git commit -m "test message" -a
git remote add origin ssh://admin@"${DOCKER_IP}"/admin/admin
git push origin master
