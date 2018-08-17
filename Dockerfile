FROM ubuntu

MAINTAINER  Mason Adam <masontadam@gmail.com>

RUN apt-get update && apt-get install -y openssh-client && apt-get install -y git

RUN useradd -d /home/admin -ms /bin/bash -g root -G sudo -p empiredidnothingwrong admin
  
EXPOSE 22
