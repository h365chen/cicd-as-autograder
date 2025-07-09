# Create Repos

## Setup repos under ece100/root/a0/

The `ece100/root/a0/` folder (group) contains the two most relevant repositories
for auto-feedback scripts: `assessment/` and `starter/`.

Later, we will set up Continuous Integration (CI) so that whenever a new
submission is made, the auto-feedback scripts run automatically. For now, let's
set up these repositories.

To create a repository, first create the folder, then run `git init`. For
example, we can do the following to set up `root/a0/assessment`.

```bash
home_path=$(pwd) # the parent folder of ece100

mkdir ece100/root/a0/assessment
cd ece100/root/a0/assessment
git init
glab repo create --defaultBranch main --group ece100/root/a0 --readme --private
git pull origin main

cd $home_path
```

Similarily, we can create the `starter` repo.

```bash
home_path=$(pwd)

mkdir ece100/root/a0/starter
cd ece100/root/a0/starter
git init
glab repo create --defaultBranch main --group ece100/root/a0 --readme --private
git pull origin main

cd $home_path
```

The `ece100/root/a0/ci` repo will be discussed later.

To delete the `assessment` repo, do

```bash
user@host:~/ece100/root/a0/assessment$ glab repo delete -y ece100/root/a0/assessment
user@host:~/ece100/root/a0/assessment$ rm -rf ece100/root/a0/assessment
```

To delete the `starter` repo, do

```bash
user@host:~/ece100/root/a0/assessment$ glab repo delete -y ece100/root/a0/starter
user@host:~/ece100/root/a0/assessment$ rm -rf ece100/root/a0/starter
```
