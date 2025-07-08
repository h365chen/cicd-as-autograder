#!/bin/bash

COURSE_NAME=ece100

# assume you have proper `glab` auth already
glab api --silent --method DELETE /groups/$COURSE_NAME

rm -rf $COURSE_NAME

# clean up docker
container=gitlab-runner-${COURSE_NAME}
volume=gitlab-runner-config-${COURSE_NAME}

docker stop $container
docker rm $container
docker volume rm $volume
