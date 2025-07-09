# Group access token

A personal access token may be too powerful for managing a single course.
Additionally, in our previous setup, the token was exposed inside the
`.gitlab-ci.yml` file under the `ece100/root/a0/starter` repository, which is
considered highly insecure, as the starter repository will eventually be
distributed to students.

To improve security, we can use a **group access token** instead.

```json
// group_access_token_config.json
{
  "name": "Course Bot Owner",
  "scopes": [
    "api",
    "read_api",
    "read_repository",
    "write_repository"
  ],
  "expires_at": "2024-05-01",
  // Access level. Valid values are
  // 10 (Guest)
  // 20 (Reporter)
  // 30 (Developer)
  // 40 (Maintainer)
  // and 50 (Owner)
  "access_level": 50
}
```

```bash
glab api --method POST /groups/ece100/access_tokens \
  --header "Content-Type:application/json" \
  --input group_access_token_config.json
```

```json
# output
{
  "id": 12208,
  "name": "Course Bot Owner",
  "revoked": false,
  "created_at": "2023-07-22T23:59:59.000-08:00",
  "scopes": [
    "api",
    "read_api",
    "read_repository",
    "write_repository",
  ],
  "user_id": 20255,
  "last_used_at": null,
  "active": true,
  "expires_at": "2024-05-01",
  "access_level": 50,
  "token": "**************************"
}
```

Group access token is pretty much like a personal access token, but it is
restricted to manage a single group.

To revoke it

```bash
glab api --method DELETE /groups/ece100/access_tokens/<id_in_the_above_output>
```

Put the token into `group_token.txt`

Then we can re-authenticate `glab` (NOTE: this will overwrite your previous
token!)

```bash
glab auth login --hostname git.uwaterloo.ca --stdin < group_token.txt
```

Or you can remove the `~/.config/glab-cli/config.yml` then redo it
interactively.

Now you should only see groups of the course (e.g, `ece100`, `ece100/root`,
`ece100/root/a0`). You can verify it using `glab api /groups`.
