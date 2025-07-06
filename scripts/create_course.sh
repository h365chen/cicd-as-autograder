#!/bin/bash
# ./create_course.sh 1> create_course.log 2>&1

COURSE_NAME=h365chen-ece150
HOSTNAME=git.uwaterloo.ca
API_HOST="${HOSTNAME}" # TODO non-80 port will cause problems in ci_config_path
API_PROTOCOL=https # or https
BASE_DOCKER_IMAGE=ubuntu:latest  # defines if no image is provided in CI/CD
                                 # file, which image to use

# TODO creating multiple assignment
# currently it only a0_* repos

source setup_glab.sh

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
# make it more secure - group token

# create a group access token and use that token instead of the personal access
# token
gl_response=$(
    glab api --method POST /groups/${COURSE_NAME}/access_tokens \
         --header "Content-Type:application/json" \
         --input config/group_access_token_config.json
)

check_response "$gl_response"

group_token=$(
    echo "$gl_response" | jq -r .token
)

# re-auth
echo "$group_token" | glab auth login --hostname ${HOSTNAME} --stdin

echo "=== Check group access token ==="
glab auth status

echo "==="
echo "group_token: $group_token"
echo "==="

# echo "Now you should only see one course group"
# glab api /groups

# ===
# create subgroups
# since it is ganruateed that the parent group is a newly created group, so we
# don't need additional checkings afterwards
glab api --silent --method POST /groups \
     --field path="assessment" \
     --field name="assessment" \
     --field parent_id="$group_id"
glab api --silent --method POST /groups \
     --field path="offerings" \
     --field name="offerings" \
     --field parent_id="$group_id"

# ====
# create course folders and repos locally
mkdir ${COURSE_NAME}
mkdir ${COURSE_NAME}/assessment
mkdir ${COURSE_NAME}/offerings

cd ${COURSE_NAME}/assessment/

mkdir a0_autofeedback
cd a0_autofeedback
git init
glab repo create --defaultBranch main --group ${COURSE_NAME}/assessment --readme --private
git pull origin main

cd .. # ${COURSE_NAME}/assessment
mkdir a0_solution
cd a0_solution
git init
glab repo create --defaultBranch main --group ${COURSE_NAME}/assessment --readme --private
git pull origin main

cd .. # ${COURSE_NAME}/assessment
mkdir a0_stu_template
cd a0_stu_template
git init
glab repo create --defaultBranch main --group ${COURSE_NAME}/assessment --readme --private
git pull origin main
# remove default rule of the stu_template repo
glab api --silent --method DELETE /projects/:id/protected_branches/main
# set push level to Developer+Maintainer
glab api --silent --method POST /projects/:id/protected_branches \
     --field name="main" \
     --field push_access_level=30 \
     --field merge_access_level=30

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

echo "======================"

# ===
# make it more secure - environment variables

# create a deploy token

# :id will be properly replaced if we are inside the git repo
cd ${COURSE_NAME}/assessment/a0_autofeedback/

gl_response=$(
    glab api --method POST /projects/:id/deploy_tokens \
        --header "Content-Type:application/json" \
        --input $home_path/config/deploy_token_config.json
)

check_response "$gl_response"

deploy_token=$(echo "$gl_response" | jq -r .token)

# make env variables visible for the entire group
glab api --silent --method POST /groups/${COURSE_NAME}/variables \
     --field key="GITLAB_HOST" \
     --field value="${HOSTNAME}" \
     --field masked="false"

glab api --silent --method POST /groups/${COURSE_NAME}/variables \
     --field key="COURSE_NAME" \
     --field value="${COURSE_NAME}" \
     --field masked="false"

glab api --silent --method POST /groups/${COURSE_NAME}/variables \
     --field key="CI_FEEDBACK_REPO_USER" \
     --field value="feedback_repo_user" \
     --field masked="true"

glab api --silent --method POST /groups/${COURSE_NAME}/variables \
     --field key="CI_FEEDBACK_REPO_TOKEN" \
     --field value="$deploy_token" \
     --field masked="true"

cd $home_path

# ===
# make it more secure
# prevent students from changing the `.gitlab-ci.yml` file

echo "=== setting up CI config path ==="
# :id will be properly replaced if we are inside the git repo
cd ${COURSE_NAME}/assessment/a0_stu_template
glab api --silent --method PUT /projects/:id \
     --field ci_config_path=".gitlab-ci.yml@${COURSE_NAME}/assessment/a0_solution"

cd $home_path

echo "=== make demo commits ==="
cp config/sample_with_env_var.gitlab-ci.yml ${COURSE_NAME}/assessment/a0_solution/.gitlab-ci.yml
cd ${COURSE_NAME}/assessment/a0_solution/
git add .gitlab-ci.yml
git commit -m 'add .gitlab-ci.yml'
git push --set-upstream origin main

cd $home_path

cp config/malicious.gitlab-ci.yml ${COURSE_NAME}/assessment/a0_stu_template/.gitlab-ci.yml
cd ${COURSE_NAME}/assessment/a0_stu_template/
git add .gitlab-ci.yml
git commit -m 'add malicious .gitlab-ci.yml which will never run'
git push --set-upstream origin main

cd $home_path

# ===
# create a dummy stu for testing

echo "we need the personal token to create it"
source setup_glab.sh

cd ${COURSE_NAME}/assessment/a0_stu_template

gl_response=$(
    glab api --method POST /projects/:id/access_tokens \
         --header "Content-Type:application/json" \
         --input ${home_path}/config/template_repo_access_token_config.json
)

echo "==="
dummy_stu_token=$(echo "$gl_response" | jq -r .token)
echo "dummy_stu_token: $dummy_stu_token"
echo "==="
echo "You need to use"
echo "git clone https://oauth2:${dummy_stu_token}@git.uwaterloo.ca/${COURSE_NAME}/assessment/a0_stu_template"
echo "to test it, since glab auth does not clone repo with the right token"

cd $home_path

# === Finish

echo "reset token to personal token"
source setup_glab.sh

echo "" # newline
echo "Congrats! You've created a new course ${COURSE_NAME}"
