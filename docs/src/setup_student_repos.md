# Setup Student Repos

Forking the `ece100/root/a0/starter` repository is likely the most convenient
way to create student repositories. However, this step cannot be easily
performed through `glab`. Although `glab` supports forking a repository via the
command line, it does not allow control over the target group. That said, the
repository is always forked into your personal namespace by default.

Therefore, we have two options:

1. Ask students to manually fork the `starter` repository using the GitLab web
   interface.
2. Copy the contents of the `starter` repository into a local folder (e.g.,
   `stu-00`), and then push it to the desired target group, such as
   `ece100/term-00/a0/stu-00`.

We will go with the second option here. There are many tools available to
automate this process. Here, I will demonstrate the second approach to create
students' repos.

For example, if we want to set up the repo for student `stu-00`, then we can do:

```bash
home_path=$(pwd)

glab repo clone ece100/root/a0/starter ece100/term-00/a0/stu-00
cd ece100/term-00/a0/stu-00
git remote remove origin
git reset $(git commit-tree HEAD^{tree} -m "Initial commit")
glab repo create --group ece100/term-00/a0 --name stu-00 --private
git push --set-upstream origin main

cd $home_path
```

We then need to set up its CI/CD.

```bash
glab api --method PUT /projects/:id \
    --field ci_config_path=".gitlab-ci.yml@ece100/root/a0/ci"
```
