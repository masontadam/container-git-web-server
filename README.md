# lol

"It's not an acronym, it's a tiny text tie fighter."

## Description

This project is a dockerized environment for dynamic development. It has a git-server and simple web-server in an Ubuntu 16.04 Docker container. 

This project deploys a docker container that serves the results of scripts placed in a git repository over SSL (port 443). Currently, the web server is a Python Flask application that returns the results of Bash scripts in the web root directory. This could easily be expanded to other use cases. This simple design is merely a proof of concept. 

### Ports 

The Docker's git server is served over port 22. The Web Server is served over port 443. All web traffic is SSL using a self-signed certificate.

### Passwords 

Any passwords that a user encounters are `empiredidnothingwrong`

## Dependencies

This project is tested on Ubuntu 14.04. The only dependencies are:
- git
- docker

## Usage

1. Run `./start.sh`

	- This will build and instantiate a docker container that holds both the git and web server. 
	- The script will ask your permission to connect over ssh if you have the `StrictHostKeyChecking` flag in your ssh_config set to `ask`. Change it to `no` to fix this.

2. Then the git repository will be available over port 22 at the docker container's docker network IP address. This server interact in the way a normal git repository would:

	- The only repository intially present on the server is admin/admin (password in the description).
	- The docker container's IP address can be found with the following command:
		- `sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' server` where 'server' is merely the name of the docker container.

Below is a sample of common git commands (note the address of the git server):

```
git clone ssh://admin@172.17.0.2/admin/admin
git add .
git commit -m "test"
git push origin master
```

3. A test script is already present in the web server `scripts` directory. A user can push additional bash scripts to the admin/admin repository and their results will be served at:

	- `https://<Container IP>:443`

## Troubleshooting

If docker gives an error about volume ':' being invalid, you may need to export your SSH_AUTH_SOCK to an environment varible. Steps to complete this:
	- `eval $(ssh-agent -s| head -n 1)`
	- Run `echo $SSH_AUTH_SOCK` to ensure the environment variable is set. 

Once this is done, the docker run command will mount the volumes correctly.

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


# List of References

- `https://docs.docker.com/engine/examples/running_ssh_service/#run-a-test_sshd-container`
- `https://www.linux.com/learn/how-run-your-own-git-server`
- `https://blog.anvileight.com/posts/simple-python-http-server/`
- `https://gist.github.com/noelboss/3fe13927025b89757f8fb12e9066f2fa#file-post-receive`
- `https://stackoverflow.com/questions/18136389/using-ssh-keys-inside-docker-container`
- `http://networkstatic.net/10-examples-of-how-to-get-docker-container-ip-address/`
- `https://medium.freecodecamp.org/docker-entrypoint-cmd-dockerfile-best-practices-abc591c30e21`
- `https://www.digitalocean.com/community/tutorials/how-to-use-git-hooks-to-automate-development-and-deployment-tasks`
