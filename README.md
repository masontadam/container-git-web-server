# lol

"It's not an acronym, it's a tiny text tie fighter."

## Description

This project is a dockerized environment for dynamic development. It has a git-server and simple web-server in an Ubuntu 16.04 Docker container. 

List of Requirements:
- Utilizes containerization or virtualization software
- contains a git server that serves over port 22 
- contains a web server that servrs over port 443
- All web traffic must be SSL using a self-signed cert
- Set any passwords to “empiredidnothingwrong”
- Web server serves result of scripts in the master branch of the git repository

## Dependencies

This project is tested on Ubuntu 14.04. The only dependencies are:
- git
- docker

## Usage

1. Run `./setup.sh`

	- This will build and instantiate a docker container that holds both the git and web server. 
	- The script will ask your permission to connect over ssh if you have the `StrictHostKeyChecking` flag in your ssh_config set to `ask`. Change it to `no` to fix this.

2. Then the git repository will be available over port 22 at the docker container's docker network IP address. This server interact in the way a normal git repository would:

The only repository intially present on the server is admin/admin (password in the description).

The docker container's IP address can be found with the following command:

- `sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' server` where 'server' is merely the name of the docker container.
- The git server behaves as normal over port 22. Below is a sample of common git commands (note the address of the git server):

```
git clone ssh://admin@172.17.0.2/admin/admin
git add .
git commit -m "test"
git push origin master
```

3. A user can push bash scripts to the admin/admin repository and their results will be served at:

- `https://<Container IP>:443`

## Design

### Docker Container Directory Layout

```
/admin # Git User
    /admin # Repository
        #git objects
/www
    /web
        server.py # The flask application
        /scripts
            # location of user scripts
        /templates
            index.html
        /ssl
            server.crt
            server.key
```

### Git Server

The git server runs on top of an sshd server. I shared the `SSH_AUTH_SOCK` environment variable in order to allow port 22 usage on the docker container, while allowing the host system to still utiliize that port otherwise. The start script creates an ssh key and copies it to the docker container to allow 'passwordless' authentication. When the user pushes to the remote, the server's post-receive hook auto-updates the web root directory with the new contents of the master branch. 

### Web Server

The web server can be reached at the docker container's IP over port 443, utilizing a self-signed cert by yours truly. The server is a simple flask app that runs all `.sh` scripts that the `server.py` file finds in the `scripts` directory. It then renders the `index.html` template with the script results as dynamic content.


# References

- `https://docs.docker.com/engine/examples/running_ssh_service/#run-a-test_sshd-container`
- `https://www.linux.com/learn/how-run-your-own-git-server`
- `https://blog.anvileight.com/posts/simple-python-http-server/`
- `https://gist.github.com/noelboss/3fe13927025b89757f8fb12e9066f2fa#file-post-receive`
- `https://stackoverflow.com/questions/18136389/using-ssh-keys-inside-docker-container`
- `http://networkstatic.net/10-examples-of-how-to-get-docker-container-ip-address/`
- `https://medium.freecodecamp.org/docker-entrypoint-cmd-dockerfile-best-practices-abc591c30e21`
- `https://www.digitalocean.com/community/tutorials/how-to-use-git-hooks-to-automate-development-and-deployment-tasks`
