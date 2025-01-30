# Course and Assignment Creation

GitLab allows users to create groups. A GitLab group can have multiple Git
repos. It can also have one or more subgroups. The purpose of a group is to fold
Git repos so that it will not appear too messy for a user's homepage. It is like
creating a folder to manage files.

## Course Creation

A course is just a GitLab group.

## Assignment Creation

A course may have multiple assignments, and an assignment may have multiple Git
repos. Therefore, an assignment is also a group.

In addition, it has Git repos served for special purposes:

- A template repo for storing starter files
- An assessment repo for storing assessment code
- One or many student repos

If we use folder structure to present the idea, it looks like the following.

### Structure #1

```
  course
  │
  ├── README.md
  │
  ├── root
  │   ├── a0
  │   │   ├── starter
  │   │   └── assessment
  │   └── a1
  │       ├── starter
  │       └── assessment
  │
  ├── term0
  │   ├── a0
  │   │   ├── stu0
  │   │   ├── stu1
  │   │   └── ...
  │   └── a1
  │       ├── stu0
  │       ├── stu1
  │       └── ...
  │
  ├── term1
  │   ├── a0
  │   │   ├── stu0
  │   │   ├── stu1
  │   │   └── ...
  │   └── a1
  │       ├── stu0
  │       ├── stu1
  │       └── ...
  │
  └── ...
```

In terms of which are GitLab groups and which are Git repos, it depends on the
complexities of assignments. One can consider each folder is a GitLab group and
each file (leaf node) is a Git repo. However, making everything inside the
`course` group as a Git repo would also work, such as:

### Structure #2

```
  course
  │
  ├── README.md
  │
  ├── root-a0-starter
  ├── root-a0-assessment
  ├── root-a1-starter
  ├── root-a1-assessment
  │
  ├── term0-a0-stu0
  ├── term0-a0-stu1
  ├── term0-a1-stu0
  ├── term0-a1-stu1
  │
  ├── term1-a0-stu0
  ├── term1-a0-stu1
  ├── term1-a1-stu0
  ├── term1-a1-stu1
  │
  └── ...
```

Even using a single Git repo to manage starter code and assessments, such as:

### Structure #3

```
  course
  │
  ├── README.md
  │
  ├── root (containing starter code and assessments for all assignments)
  │
  ├── term0-a0-stu0
  ├── term0-a0-stu1
  ├── term0-a1-stu0
  ├── term0-a1-stu1
  │
  ├── term1-a0-stu0
  ├── term1-a0-stu1
  ├── term1-a1-stu0
  ├── term1-a1-stu1
  │
  └── ...
```

For demonstration purpose, I will only discuss the first structure.

## Setting assignment deadlines

TODO

## Summary

- Admin
  - can create courses [&check;]
    - a course can have multiple assignments [&check;]
- Instructors (and TAs)
  - can create assignments [&check;]
    - can create group assignments [&check;]
    - can upload starter files for an assignment [&check;]
    - can configure assignment deadlines
- Student
  - can see assignment descriptions [&check;]
