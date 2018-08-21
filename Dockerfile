FROM ubuntu:16.04

MAINTAINER Mason Adam <masontadam@gmail.com>

RUN apt-get update && apt-get install -y openssh-server \
	&& apt-get install -y git-core \
	&& apt-get install -y python3.6 \
	&& apt-get install -y python-pip \
	&&  apt-get install -y vim

#Setup SSH
RUN mkdir /var/run/sshd

RUN echo 'root:empiredidnothingwrong' | chpasswd
RUN groupadd admin
RUN useradd -d /home/admin -ms /bin/bash -g admin -G admin admin
RUN echo 'admin:empiredidnothingwrong' | chpasswd

# Authorize SSH Host
RUN mkdir -p /admin/.ssh && \
    chmod 0700 /admin/.ssh && \

# Add the keys and set permissions
COPY .ssh/id_rsa /admin/.ssh/id_rsa
COPY .ssh/id_rsa.pub /admin/.ssh/id_rsa.pub 
RUN chmod 600 /admin/.ssh/id_rsa && \
    chmod 600 /admin/.ssh/id_rsa.pub

#Setup Git Repo
RUN mkdir -p /admin/admin/
RUN cd /admin/admin && git init --bare
COPY /tmp/git-docs/post-recieve.sh /admin/admin/hooks/
RUN chown -R admin:admin /admin

# Setup Webserver
RUN mkdir -p /www/web/
RUN chown -R admin:admin /www/

RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
