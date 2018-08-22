FROM ubuntu:16.04

MAINTAINER Mason Adam <masontadam@gmail.com>

RUN apt-get update && apt-get install -y openssh-server \
	&& apt-get install -y git-core \
	&& apt-get install -y python \
	&& apt-get install -y python-pip

RUN python -m pip install --upgrade pip && pip install Flask

#Setup SSH
RUN mkdir /var/run/sshd

# Setup User Accounts
RUN echo 'root:empiredidnothingwrong' | chpasswd
RUN groupadd admin
RUN useradd -d /home/admin -ms /bin/bash -g admin -G admin admin
RUN echo 'admin:empiredidnothingwrong' | chpasswd

# Setup Git Repository & Permissions
RUN mkdir -p /admin/admin/
RUN cd /admin/admin && git init --bare
RUN chown -R admin:admin /admin

# Setup Web server & Permissions
RUN mkdir -p /www/web/
RUN chown -R admin:admin /www/

# Configure sshd_config
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

# Expose Appropriate Ports
EXPOSE 22
EXPOSE 443

COPY ./bootstrap.sh /
ENTRYPOINT ["/bootstrap.sh"]
CMD ["/usr/sbin/sshd", "-D"]
