# Create Repos

## Setup repos under ece100/root/a0/

The `ece100/root/a0/` folder (group) contains repos for auto-feedback scripts
`assessment/` and starter code `starter/`.

We will later setup continuous integration (CI) so that whenever a new
submission is made, the auto-feedback scripts get automatically run. For now,
let's setup these repos.

To create a repo, we need to create the folder first, then run `git init`. For
example, for `root/a0/assessment`.

```bash
home_path=$(pwd)

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
