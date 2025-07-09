# Continuous integration, delivery, and deployment (CI/CD)

Although CI/CD is commonly used for various types of testing in industry, I
prefer not to overly rely on it to run my feedback scripts. One reason is that I
want to be able to conveniently run the scripts manually on my local machine.

Therefore, GitLab's CI/CD serves only two purposes:

- To invoke a sandbox environment, such as a GitLab Runner Docker container, to
  run the feedback scripts
- To provide a single entry point (e.g., `feedback.sh`) for the feedback
  process. The container runs `./feedback.sh` and then collects the results.

The logic for generating feedback is entirely scripted within the
`ece100/root/a0/assessment` repository.

## GitLab Job Runners

A GitLab Runner is an executor that runs CI/CD jobs on machines outside of
GitLab. There are two main steps to create a runner:

1. **Register the runner on GitLab** This step involves creating a runner entry
   in GitLab. It's essentially requesting a runner token or ID that the actual
   runner will use to authenticate and communicate with GitLab.

2. **Set up the actual runner on an external machine** The runner can be
   installed on your laptop or any other machine. For simplicity, I will create
   a GitLab Runner Docker container running on my laptop.

See the [execution flow](https://docs.gitlab.com/runner/#runner-execution-flow)

## Create a runner on GitLab

Here I create a shared runner for the entire course, the `group_id` is the same
as above.

I set `run_untagged` to `true` for simplicity. It means the runner can be used
for any repo inside the group.

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
