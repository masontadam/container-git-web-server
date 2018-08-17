FROM alpine:latest

MAINTAINER  Mason Adam <masontadam@gmail.com>

RUN apk add --no-cache \
  openssh \
  git && \
  RUN useradd -d /home/admin -ms /bin/bash -g root -G sudo -p empiredidnothingwrong admin
  

EXPOSE 22
