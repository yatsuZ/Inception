#!/bin/sh

docker rm $(docker ps -aq) 
docker rmi $(docker images -q) 
