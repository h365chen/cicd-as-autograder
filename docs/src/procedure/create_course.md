## Create a course (e.g., ece100)

The structure I use is as:

```
ece100
│
├── root
│   └── a0
│       ├── ci
│       ├── starter
│       └── assessment
│
└── term-00
    └── a0
        ├── stu-00
        ├── stu-01
        └── ...
```

It shows the folder structure on my local file system as well as the group
structure on GitLab.

You may notice an additional `ece100/root/a0/ci` folder. We will discuss the
purpose of creating this folder in a later chapter.

### Setup folders and groups

```bash
# create folder structure
mkdir ece100
mkdir ece100/root/
mkdir ece100/root/a0/
mkdir ece100/root/a0/ci
mkdir ece100/root/a0/starter
mkdir ece100/root/a0/assessment
```

```bash
# create groups on GitLab
# such operations can be done using the REST API, too
# refer to the GitLab document for how to achieve it
glab api --method POST /groups --field path="ece100" --field name="ece100"

# output
{
  "id": 94728,
  "web_url": "https://git.uwaterloo.ca/groups/ece100",
  "name": "ece100",
  "path": "ece100",
  "description": "",
  "visibility": "private",
  "share_with_group_lock": false,
  "require_two_factor_authentication": false,
  "two_factor_grace_period": 48,
  "project_creation_level": "developer",
  "auto_devops_enabled": null,
  "subgroup_creation_level": "maintainer",
  "emails_disabled": null,
  "mentions_disabled": null,
  "lfs_enabled": true,
  "default_branch_protection": 2,
  "avatar_url": null,
  "request_access_enabled": true,
  "full_name": "ece100",
  "full_path": "ece100",
  "created_at": "2023-07-22T10:00:00.000-04:00",
  "parent_id": null,
  "ldap_cn": null,
  "ldap_access": null,
  "wiki_access_level": "enabled",
  "shared_with_groups": [],
  "prevent_sharing_groups_outside_hierarchy": false,
  "shared_runners_minutes_limit": null,
  "extra_shared_runners_minutes_limit": null,
  "prevent_forking_outside_group": null,
  "membership_lock": false
}
```

Note down the `id`, we will use it for creating subgroups `root`.

```bash
glab api \
    --method POST /groups \
    --field path="root" \
    --field name="root" \
    --field parent_id=94728
```

This process will be repeated once more for the `a0` subgroup.

```bash
glab api \
    --method POST /groups \
    --field path="a0" \
    --field name="a0" \
    --field parent_id=<id_of_the_root_group>
```

To query existing groups

```bash
glab api /groups
```

To delete the group (e.g., ece100), use following:

```bash
glab api --method DELETE /groups/94728
```
