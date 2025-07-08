# Setup `.gitlab-ci.yml`

Create a `.gitlab-ci.yml` with following content and put it as
`ece100/root/a0/starter/.gitlab-ci.yml`.

(A sample file is `config/sample.gitlab-ci.yml`)

```yaml
welcome:
  stage: build
  image: ubuntu:latest
  script:
    - echo "Hello, $GITLAB_USER_LOGIN!"

check:
  stage: test
  image: ubuntu:latest
  before_script:
    - apt-get update
    - apt-get install -y git
  script:
    - echo "Fetching feedback scripts ..."
    - git clone https://oauth2:<ACCESS_TOKEN>@git.uwaterloo.ca/<COURSE>/root/a0/assessment
    - echo "Setting up runtime environment ..."
    - echo "Generating feedback ..."
    - echo "The files under assessment/ are:"
    - ls assessment/
    - echo "Done"
```

Replace `<ACCESS_TOKEN>` to your personal access token for now. (**NOTE: THIS IS
HIGHLY UNSAFE**)

We will make it more secure afterwards.

Finally, git add, commit, and push.

```bash
git add .gitlab-ci.yml
git commit -m 'try sample ci'
git push --set-upstream origin main
```

For this commit and all afterwards commits, the pipeline will be triggered, and
GitLab will refer to this `.gitlab-ci.yml` for executing the pipeline.

The pipeline status can be checked on the web, or using `glab ci trace` through
the command line.
