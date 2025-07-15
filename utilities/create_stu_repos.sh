#!/bin/bash

COURSE_NAME=ece100
TERM=term-00
ASSIGNMENT=a0
HOSTNAME=git.uwaterloo.ca

# home path
home_path=$(pwd)

set -x

# ====
# ensure assignment folder exist
[ ! -d "${COURSE_NAME}/${TERM}/${ASSIGNMENT}" ] && echo "Please create the necessary folder first" && exit 1


# ===
# create repos

glab repo clone ${COURSE_NAME}/root/a0/starter ${COURSE_NAME}/${TERM}/${ASSIGNMENT}/stu-00
cd ${COURSE_NAME}/${TERM}/${ASSIGNMENT}/stu-00
git remote remove origin
git reset $(git commit-tree HEAD^{tree} -m "Initial commit")
glab repo create --defaultBranch main --group ${COURSE_NAME}/${TERM}/${ASSIGNMENT} --name stu-00 --private
git push --set-upstream origin main

glab api --silent --method PUT /projects/:id \
     --field ci_config_path=".gitlab-ci.yml@${COURSE_NAME}/root/${ASSIGNMENT}/ci"

cd $home_path
