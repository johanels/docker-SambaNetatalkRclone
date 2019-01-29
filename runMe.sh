#!/bin/bash

# https://github.com/odarriba/docker-timemachine

docker rm -f ultimate
docker image prune -f

docker build . -t ultimate

docker run --name ultimate -it -p 445:445 -p 548:548 -p 53682:53682 ultimate ash
