# Make it more secure

Now, let's consider how to make the setup more secure

### Group access token

Personal access token may be too powerful for a single course, we can create
group access tokens instead.

(I'm not sure how to pass the json payload all together with the `glab` command.
Currently, I use `group_access_token_config.json` to store it)

```shell
glab api --method POST /groups/ece100/access_tokens \
  --header "Content-Type:application/json" \
  --input group_access_token_config.json

# output
{
  "id": 12208,
  "name": "Course Bot Owner",
  "revoked": false,
  "created_at": "2023-07-22T23:59:59.000-08:00",
  "scopes": [
    "api",
    "read_api",
    "read_repository",
    "write_repository",
    "read_registry",
    "write_registry"
  ],
  "user_id": 20255,
  "last_used_at": null,
  "active": true,
  "expires_at": "2024-05-01",
  "access_level": 50,
  "token": "**************************"
}
```

Group access token is pretty much like a personal access token, but it is
restricted to manage a single group.

To revoke it, `glab api --method DELETE /groups/ece100/access_tokens/12208`

---

Put the token into `group_token.txt`

Then we can re-authenticate `glab`

```shell
glab auth login --hostname git.uwaterloo.ca --stdin < group_token.txt
```

Or you can remove the `~/.config/glab-cli/config.yml` then redo it
interactively.

---

Now you should only see groups of the course (e.g, `ece100`,
`ece100/assessment`, `ece100/offerings`). You can verify it using `glab api
/groups`.

---

### Use environment variables in gitlab-runner

If students are only allowed to interactive with their own repos, then by
default, the CI/CD job token will not grant access to the feedback repo (e.g.
`a0_autofeedback/`) as mentioned in the page [GitLab CI/CD job
token](https://docs.gitlab.com/ee/ci/jobs/ci_job_token.html).

> The token has the same permissions to access the API as the user that caused
> the job to run.

However, we can create a deploy token for the feedback repo (`a0_autofeedback`),
allowing CI job to access the feedback repo.

The deploy token is like creating a fake account which has access to the
specified repo.

---

To create a deploy token

```shell
cp deploy_token_config.json ece100/assessment/a0_autofeedback/

# :id will be properly replaced if we are inside the git repo
cd ece100/assessment/a0_autofeedback/
glab api --method POST /projects/:id/deploy_tokens \
  --header "Content-Type:application/json" \
  --input deploy_token_config.json

# output
{
  "id": 212,
  "name": "Deploy Token",
  "username": "feedback_repo_user",
  "expires_at": null,
  "scopes": ["read_repository", "read_registry"],
  "revoked": false,
  "expired": false,
  "token": "********************"
}
```

Note down the token.

---

Now, we can access the repo by

```shell
git clone https://<USERNAME>:<DEPLOY_TOKEN>@git.uwaterloo.ca/ece100/assessment/a0_autofeedback
```

However, we don't want to expose them inside the `.gitlab-ci.yml`. We can use
environment variables in this case.

```shell
glab api --method POST /groups/ece100/variables \
    --field key="CI_FEEDBACK_REPO_USER" \
    --field value="feedback_repo_user" \
    --field masked="true"

glab api --method POST /groups/ece100/variables \
    --field key="CI_FEEDBACK_REPO_TOKEN" \
    --field value="********************"
    --field masked="true"

glab api --method GET /groups/ece100/variables

# output
[
  {
    "variable_type": "env_var",
    "key": "CI_FEEDBACK_REPO_USER",
    "value": "feedback_repo_user",
    "protected": false,
    "masked": true,
    "raw": false,
    "environment_scope": "*"
  },
  {
    "variable_type": "env_var",
    "key": "CI_FEEDBACK_REPO_TOKEN",
    "value": "E_Hy-sZH4Nmru_whhdY_",
    "protected": false,
    "masked": false,
    "raw": false,
    "environment_scope": "*"
  }
]
```

```shell
git clone https://${CI_FEEDBACK_REPO_USER}:${CI_FEEDBACK_REPO_TOKEN}@git.uwaterloo.ca/ece100/assessment/a0_autofeedback
```

However, we need to be careful when running student's code, which may try to
read the environment variables and log them.

---

### Prevent students from changing the `.gitlab-ci.yml` file

The idea is to configure the environment variable `CI_CONFIG_PATH` so that
gitlab-runner will never run the `.gitlab-ci.yml` inside the student's repo, but
rather than fetching it from a repo that I manage. See [custom CI/CD
configuration
file](https://docs.gitlab.com/ee/ci/pipelines/settings.html#specify-a-custom-cicd-configuration-file)

Since I use `a0_solution` for development, so we can simply refer to the
`.gitlab-ci.yml` of that repo as the `.gitlab-ci.yml` for the `a0_stu_template`
and all students' repos.

```shell
# :id will be properly replaced if we are inside the git repo
cd a0_stu_template
glab api --method PUT /projects/:id
    --field ci_config_path=".gitlab-ci.yml@ece100/assessment/a0_solution"
```

We can try add a malicious `.gitlab-ci.yml` to the `a0_stu_template` repo.
However, GitLab will not use it to create the pipeline.

For example, let's create a malicious `.gitlab-ci.yml` as:

```yaml
welcome:
  stage: build
  script:
    - echo "This line should not be printed"
```

If it gets run, there will be only one stage (build) with one job (welcome).

```shell
user@host:~$ git commit -m 'add .gitlab-ci.yml but it should not run'
[main e4f9f5d] add .gitlab-ci.yml but it should not run
 1 file changed, 4 insertions(+)
 create mode 100644 .gitlab-ci.yml

user@host:~$ git push
Enumerating objects: 4, done.
Counting objects: 100% (4/4), done.
Delta compression using up to 8 threads
Compressing objects: 100% (3/3), done.
Writing objects: 100% (3/3), 411 bytes | 411.00 KiB/s, done.
Total 3 (delta 0), reused 0 (delta 0), pack-reused 0
To git.uwaterloo.ca:ece100/assessment/a0_stu_template.git
   dbd97c7..e4f9f5d  main -> main

user@host:~$ glab ci status
(running) • 00m 04s	test		check
(success) • 00m 03s	build		welcome

https://git.uwaterloo.ca/ece100/assessment/a0_stu_template/-/pipelines/98432
SHA: e4f9f5d3884e2c62ca54174ccee04d46a6818d31
Pipeline State: running

user@host:~$ glab ci status
(success) • 00m 16s	test		check
(success) • 00m 03s	build		welcome

https://git.uwaterloo.ca/ece100/assessment/a0_stu_template/-/pipelines/98432
SHA: e4f9f5d3884e2c62ca54174ccee04d46a6818d31
Pipeline State: success
```

We can see that there are still two stages (build, test) in the pipeline, not
one.

# TODO

However, it seems if the commit was pushed by using an access token at the
project level (`a0_stu_template`), but not at the group level (`ece100`), then
the pipeline will fail to run (possibly due to not able to access the
`.gitlab-ci.yml` file). Two ideas to deal with this:

- Use an external host to host the pipeline file and make it publicly avaiable,
  or simply it put it in a public repo.
- Always make git pushes using the group access token. When client tries to make
  a push, it connects to a validation server using say username and password,
  then the validation server returns the group access token for it to make the
  git push. The validation server can rotate the group access token say every 3
  hours.

(Verified by creating a dummy student with the project scope)
