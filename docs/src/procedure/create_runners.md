# Continuous integration, delivery, and deployment (CI/CD)

Although CI/CD is commonly used for various testing in industry, I consider I
don't want to over-relying on it to run my feedback scripts. Another reason is I
would like to be able to manually run the scripts conveniently locally.

Therefore, GitLab's CI/CD only serves two purposes:

- Invoke a sandbox environment such as a gitlab-runner docker container to run
  my feedback scripts
- There is only one single entry such as `feedback.sh` to my feedback scripts,
  the container will call `./feedback.sh`, then collect its results

The logic about how to provide feedback is completely scripted in the
`ece100/root/a0/assessment` repo.

## GitLab Job Runners

A gitlab-runner is an executor to run CI/CD jobs on machines outside GitLab.
There are two steps to create a runner.

1. Create a runner instance on GitLab. This is more like to ask GitLab for an
   runner id so that the actual runner can use that to communicate with GitLab.
1. Create the actual runner running outside of GitLab. It can be on your laptop,
   or other machines. For simplicity, I will create a gitlab-runner docker
   container running on my laptop here.

See the [execution flow](https://docs.gitlab.com/runner/#runner-execution-flow)

## Create a runner on GitLab

Here I create a shared runner for the entire course, the `group_id` is the same
as above.

I set `run_untagged` to `true` for simplicity. It means the runner can be used
for any repo.

```bash
glab api --method POST /user/runners \
    --field runner_type="group_type" \
    --field group_id=94733 \
    --field description="ece100_runner_0" \
    --field run_untagged=true

# output
{
  "id": 1245,
  "token": "*************************",
  "token_expires_at": null
}
```

The runner authentication token will only show up here, so make sure you note it
down.

In case you forgot to note it down, you can reset it by

```bash
glab api --method POST /runners/1245/reset_authentication_token
```

## Create the gitlab-runner docker container

With the docker engine running on my local machine, then I do:

```bash
TOKEN=<RUNNER_TOKEN>

docker volume create gitlab-runner-config

# Step 1: start a gitlab-runner daemon (run in a container)
docker run -d --name gitlab-runner --restart always \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v gitlab-runner-config:/etc/gitlab-runner \
    --env TZ=America/Toronto \
    gitlab/gitlab-runner:latest

# Step 2: register runner workers
# Given the executor is "docker", so the job is executed in
# `dind` (Docker-in-Docker) mode
docker run --rm -it \
    -v gitlab-runner-config:/etc/gitlab-runner \
    gitlab/gitlab-runner register \
    --non-interactive \
    --url "https://git.uwaterloo.ca" \
    --token "$TOKEN" \
    --executor "docker" \
    --docker-image ubuntu:latest
```

If gitlab-runner is in a container while you still want to use docker as the
executor, then you need to provide the login info for gitlab-runner to access
the docker hub.
