#!/bin/bash

sudo docker stop server
sudo docker rm server
sudo rm -rf admin/
sudo rm -rf docker_ssh/
sudo rm -rf server_docs/scripts/*
