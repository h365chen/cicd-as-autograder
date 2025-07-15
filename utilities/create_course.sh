#!/bin/bash

# This script will create only one assignment `a0`
# TODO: support creating multiple assignments

COURSE_NAME=ece100
HOSTNAME=git.uwaterloo.ca
API_HOST="${HOSTNAME}" # TODO non-80 port will cause problems in ci_config_path
API_PROTOCOL=https # or https
BASE_DOCKER_IMAGE=ubuntu:latest  # defines if no image is provided in CI/CD
                                 # file, which image to use
jq --version || exit 1

# home path
home_path=$(pwd)

# check the response to see if an operation succeed. If the response has
# "message" or "error", it indicates a failed operation
check_response() {
    response=$1
    echo "$response" | jq -e .message > /dev/null
    retcode=$?
    if [ $retcode -eq 0 ]; then
        echo "$response"
        exit 1
    fi
    echo "$response" | jq -e .error > /dev/null
    retcode=$?
    if [ $retcode -eq 0 ]; then
        echo "$response"
        exit 1
    fi
}

# create groups on GitLab
# such operations can be done using the REST API, too
# refer to the GitLab document for how to achieve it
gl_response=$(
    glab api --method POST /groups \
         --field path="${COURSE_NAME}" \
         --field name="${COURSE_NAME}"
           )

check_response "$gl_response"

group_id=$(
    echo "$gl_response" | jq -r .id
        )

# ===
# create course/root subgroup
gl_response=$(
    glab api --method POST /groups \
         --field path="root" \
         --field name="root" \
         --field parent_id="$group_id"
           )

root_group_id=$(
    echo "$gl_response" | jq -r .id
        )

# ===
# create course/root/a0 subgroup
glab api --silent --method POST /groups \
     --field path="a0" \
     --field name="a0" \
     --field parent_id="$root_group_id"

# ====
# create course folders and repos locally
mkdir ${COURSE_NAME}
mkdir ${COURSE_NAME}/root/
mkdir ${COURSE_NAME}/root/a0/


# ===
# create repos

mkdir ${COURSE_NAME}/root/a0/assessment
cd ${COURSE_NAME}/root/a0/assessment
git init
glab repo create --defaultBranch main --group ${COURSE_NAME}/root/a0 --readme --private
git pull origin main
cd $home_path

mkdir ${COURSE_NAME}/root/a0/starter
cd ${COURSE_NAME}/root/a0/starter
git init
glab repo create --defaultBranch main --group ${COURSE_NAME}/root/a0 --readme --private
git pull origin main
# remove default rule of the `starter` repo
glab api --silent --method DELETE /projects/:id/protected_branches/main
# set push level to Developer+Maintainer
glab api --silent --method POST /projects/:id/protected_branches \
     --field name="main" \
     --field push_access_level=30 \
     --field merge_access_level=30
cd $home_path

# ===
# setting up CI/CD

mkdir ${COURSE_NAME}/root/a0/ci
cd ${COURSE_NAME}/root/a0/ci
git init
glab repo create --defaultBranch main --group ${COURSE_NAME}/root/a0 --readme --private
git pull origin main

cp $home_path/config/sample_with_env_var.gitlab-ci.yml .gitlab-ci.yml
git add .gitlab-ci.yml
git commit -m "ci: add .gitlab-ci.yml"
git push --set-upstream origin main

cd $home_path


# ====
# Setup gitlab-runner

gl_response=$(
    glab api --method POST /user/runners \
         --field runner_type="group_type" \
         --field group_id="$group_id" \
         --field description="${COURSE_NAME}_runner" \
         --field run_untagged=true
)

check_response "$gl_response"

echo "==="
runner_token=$(echo "$gl_response" | jq -r .token)
echo "runner_token: $runner_token"
echo "==="

echo "=== Docker Message ==="

# create a gitlab-runner docker container
# TODO make sure the docker engine is running
container=gitlab-runner-${COURSE_NAME}
volume=gitlab-runner-config-${COURSE_NAME}

docker volume create $volume

# Step 1: start a gitlab-runner daemon (run in a container)
docker run -d --name $container --restart always \
       -v /var/run/docker.sock:/var/run/docker.sock \
       -v ${volume}:/etc/gitlab-runner \
       --env TZ=America/Toronto \
       gitlab/gitlab-runner:latest

# Step 2: register runner workers
# Given the executor is "docker", so the job is executed in
# `dind` (Docker-in-Docker) mode
docker run --rm -it \
       -v ${volume}:/etc/gitlab-runner \
       gitlab/gitlab-runner register \
       --non-interactive \
       --url "${API_PROTOCOL}://${API_HOST}" \
       --token "$runner_token" \
       --executor "docker" \
       --docker-image $BASE_DOCKER_IMAGE

# ===
# create course/term-00 subgroup
gl_response=$(
    glab api --method POST /groups \
         --field path="term-00" \
         --field name="term-00" \
         --field parent_id="$group_id"
           )

term_group_id=$(
    echo "$gl_response" | jq -r .id
             )

# ===
# create course/term-00/a0 subgroup
glab api --silent --method POST /groups \
     --field path="a0" \
     --field name="a0" \
     --field parent_id="$term_group_id"

mkdir ${COURSE_NAME}/term-00/
mkdir ${COURSE_NAME}/term-00/a0

# ===
# make it more secure - environment variables

echo "=== Make CI/CD more secure ==="

# create a deploy token

# :id will be properly replaced if we are inside the git repo
cd ${COURSE_NAME}/root/a0/assessment/

gl_response=$(
    glab api --method POST /projects/:id/deploy_tokens \
         --header "Content-Type:application/json" \
         --input $home_path/config/deploy_token_config.json
           )

check_response "$gl_response"

deploy_token=$(echo "$gl_response" | jq -r .token)

# make env variables visible for the entire group
glab api --silent --method POST /groups/${COURSE_NAME}/variables \
     --field key="CI_FEEDBACK_REPO_USER" \
     --field value="feedback_repo_user" \
     --field masked="true"

glab api --silent --method POST /groups/${COURSE_NAME}/variables \
     --field key="CI_FEEDBACK_REPO_TOKEN" \
     --field value="$deploy_token" \
     --field masked="true"

cd $home_path

# :id will be properly replaced if we are inside the git repo
cd ${COURSE_NAME}/root/a0/starter/

glab api --silent --method PUT /projects/:id \
     --field ci_config_path=".gitlab-ci.yml@${COURSE_NAME}/root/a0/ci"

cd $home_path

echo "=== DONE ==="
