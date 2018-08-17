#!/bin/bash

sudo docker build -t git-server . 
sudo docker run -dit -p 2222:22 git-server
