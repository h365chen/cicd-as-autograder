# Setup Repos

## Setup repos under ece100/root/a0/

The `ece100/root/a0/` folder (group) contains repos for auto-feedback scripts
`assessment/` and starter code `starter/`.

We will later setup continuous integration (CI) so that whenever a new
submission is made, the auto-feedback scripts get automatically run. For now,
let's setup these repos.

To create a repo, we need to create the folder first, then run `git init`. For
example, for `root/a0/assessment`.

```shell
home_path=$(pwd)

mkdir ece100/root/a0/assessment
cd ece100/root/a0/assessment
git init
glab repo create --defaultBranch main --group ece100/root/a0 --readme --private
git pull origin main

cd $home_path
```

Similarily, we can create the `starter` repo.

```shell
home_path=$(pwd)

mkdir ece100/root/a0/starter
cd ece100/root/a0/starter
git init
glab repo create --defaultBranch main --group ece100/root/a0 --readme --private
git pull origin main

cd $home_path
```

To delete the `assessment` repo, do

```shell
user@host:~/ece100/root/a0/assessment$ glab repo delete -y ece100/root/a0/assessment
user@host:~/ece100/root/a0/assessment$ rm -rf ece100/root/a0/assessment
```

To delete the `starter` repo, do

```shell
user@host:~/ece100/root/a0/assessment$ glab repo delete -y ece100/root/a0/starter
user@host:~/ece100/root/a0/assessment$ rm -rf ece100/root/a0/starter
```

## Setup repos under offerings/

After we have the feedback scripts and starter code ready, we can then
distribute the starter code (`root/a0/starter`) to students' repos.
