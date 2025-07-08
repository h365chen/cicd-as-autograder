# Prevent students from changing the `.gitlab-ci.yml` file

The idea is to configure the environment variable `CI_CONFIG_PATH` so that
gitlab-runner will never run the `.gitlab-ci.yml` inside the student's repo, but
rather than fetching it from a repo that is only accessible by us. See [custom
CI/CD configuration
file](https://docs.gitlab.com/ee/ci/pipelines/settings.html#specify-a-custom-cicd-configuration-file).

A proper approach is to create a third dedicated repo under the `ece100/root/a0`
group. For example, here I refer it as `ece100/root/a0/ci`.

```bash
home_path=$(pwd)

mkdir ece100/root/a0/ci
cd ece100/root/a0/ci
git init
glab repo create --defaultBranch main --group ece100/root/a0 --readme --private
git pull origin main

cp $home_path/scripts/config/sample_with_env_var.gitlab-ci.yml .gitlab-ci.yml
git add .gitlab-ci.yml
git commit -m "add .gitlab-ci.yml"
git push

cd $home_path
```

```
ece100
│
└── root
    └── a0
        ├── ci
        │   └─ .gitlab-ci.yml  # <- this file will be used
        │
        ├── starter
        │   └─ .gitlab-ci.yml  # <- this file will NOT be used
        │
        └── assessment
```

Then we can configure the `ece100/root/a0/starter` and students' repos to use
that file for pipelines.

```bash
# :id will be properly replaced if we are inside the git repo
cd ece100/root/a0/starter
glab api --method PUT /projects/:id
    --field ci_config_path=".gitlab-ci.yml@ece100/root/a0/ci"
```

## Validate that students are prevented from running their own `.gitlab-ci.yml` files

We can try change the current `.gitlab-ci.yml` under the `starter` repo.
However, GitLab will not use it to create the pipeline.

For example, let's change the `.gitlab-ci.yml` in the `starter` repo as:

```yaml
welcome:
  stage: build
  script:
    - echo "This line should not be printed"
```

If it gets run, there will be only one stage (build) with one job (welcome).

```bash
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
To git.uwaterloo.ca:ece100/root/a0/starter.git
   dbd97c7..e4f9f5d  main -> main

user@host:~$ glab ci status
(running) • 00m 04s	test		check
(success) • 00m 03s	build		welcome

https://git.uwaterloo.ca/ece100/root/a0/starter/-/pipelines/98432
SHA: e4f9f5d3884e2c62ca54174ccee04d46a6818d31
Pipeline State: running

user@host:~$ glab ci status
(success) • 00m 16s	test		check
(success) • 00m 03s	build		welcome

https://git.uwaterloo.ca/ece100/root/a0/starter/-/pipelines/98432
SHA: e4f9f5d3884e2c62ca54174ccee04d46a6818d31
Pipeline State: success
```

We can see that there are still two stages (build, test) in the pipeline, not
one.
