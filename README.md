# lol

"It's not an acronym, it's a tiny text tie fighter."

## Description

This is an incomplete project aimed at created a development environmet meeting the following requirements:
- Utilizes containerization or virtualization software
- contains a git server that serves over port 22 
- contains a web server that servrs over port 443
- All web traffic must be SSL using a self-signed cert
- Set any passwords to “empiredidnothingwrong”

## Dependencies

This project is tested on Ubuntu 14.04. The only dependencies are:
- git
- docker

## Usage

1. The environment is very simple to setup, though incomplete. Simple pull this repository, and run `./setup.sh`.

	- This will build and instantiate a docker container that holds both the git and web server. 

2. Then the git repository will be available over port 22 at the docker container's docker network IP address. This server interact in the way a normal git repository would:

The only repository intially present on the server is admin/admin (password in the description).

The docker container's IP address can be found with the following command:
	- `sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' server` where 'server' is merely the name of the docker container.

```
git clone ssh://admin@172.17.0.2/admin/admin
git add .
git commit -m "test"
git push origin master
```

3. A user can push testing scripts to the admin/admin repository and they will be served by the webserver at `https://localhost:443`. 

## Design

### Git Server

The git server runs on top of an sshd server. I shared the `SSH_AUTH_SOCK` environment variable in order to allow port 22 usage on the docker container, while allowing the host system to still utiliize that port otherwise. The git server itself is very simple. It merely required a `git init` and a user:password to authenticate. The use of git hooks was planned in order to dynamically update the web server on pushes to master. The git hook would then copy the files in master to the web root directory for the web server to handle. 

### Web Server

The web server was intended to be a simple flask application coded in python. The python application would simply run any scripts it viewed in its web root directory and display the results to the browser. 

## TODO 

- [ ] Functional Git Hook Script
- [ ] Copy Git Hook Script to `/admin/admin/hooks` on startup witout disrupting ssh
- [ ] Create functional flask app that displays html results of shell scripts in a directory

## References 

- `https://docs.docker.com/engine/examples/running_ssh_service/#run-a-test_sshd-container`
- `https://www.linux.com/learn/how-run-your-own-git-server`
- `https://blog.anvileight.com/posts/simple-python-http-server/`
- `https://gist.github.com/noelboss/3fe13927025b89757f8fb12e9066f2fa#file-post-receive`
- `https://stackoverflow.com/questions/18136389/using-ssh-keys-inside-docker-container`
- `http://networkstatic.net/10-examples-of-how-to-get-docker-container-ip-address/`
