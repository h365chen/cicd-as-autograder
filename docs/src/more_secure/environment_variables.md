# Use environment variables in gitlab-runner

If students are only allowed to interactive with their own repos, then by
default, the CI/CD job token will not grant access to the assessment repo (e.g.
`ece100/root/a0/assessment`) as mentioned in the page [GitLab CI/CD job
token](https://docs.gitlab.com/ee/ci/jobs/ci_job_token.html).

> The token has the same permissions to access the API as the user that caused
> the job to run.

However, we can create a deploy token for the assessment repo
(`ece100/root/a0/assessment`), allowing CI job to access the assessment repo.

The deploy token is like creating a fake account which has access to the
specified repo.

To create a deploy token

```bash
cp deploy_token_config.json ece100/root/a0/assessment

# :id will be properly replaced if we are inside the git repo
cd ece100/root/a0/assessment
glab api --method POST /projects/:id/deploy_tokens \
  --header "Content-Type:application/json" \
  --input deploy_token_config.json
```

```json
# output
{
  "id": 212,
  "name": "Deploy Token",
  "username": "feedback_repo_user",
  "expires_at": null,
  "scopes": ["read_repository", "read_registry"],
  "revoked": false,
  "expired": false,
  "token": "E_Hy-sZH4Nmru_whhdY_"
}
```

Note down the token.

Now, we can access the repo by

```bash
git clone https://<USERNAME>:<DEPLOY_TOKEN>@git.uwaterloo.ca/ece100/root/a0/assessment
```

However, we don't want to expose them inside the `.gitlab-ci.yml`. We can use
environment variables in this case.

```bash
glab api --method POST /groups/ece100/variables \
    --field key="CI_FEEDBACK_REPO_USER" \
    --field value="feedback_repo_user" \
    --field masked="true"

glab api --method POST /groups/ece100/variables \
    --field key="CI_FEEDBACK_REPO_TOKEN" \
    --field value="E_Hy-sZH4Nmru_whhdY_"
    --field masked="true"

glab api --method GET /groups/ece100/variables
```

```json
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

```bash
git clone https://${CI_FEEDBACK_REPO_USER}:${CI_FEEDBACK_REPO_TOKEN}@git.uwaterloo.ca/ece100/root/a0/assessment
```

(See `config/sample_with_env_var.gitlab-ci.yml`)

However, we still need to be careful when running student's code, which may try
to read the environment variables and log them, although GitLab will try its
best to mask them in the logs.
