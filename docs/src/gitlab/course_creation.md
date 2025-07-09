# Course and Assignment Creation

As mentioned earlier, the features we aim to implement are:

- Admin
  - can create courses
    - a course can have multiple assignments
- Instructors (and TAs)
  - can create assignments
    - can create group assignments
    - can upload starter files for an assignment
    - can configure assignment deadlines
- Student
  - can see assignment descriptions

## Course Creation

GitLab allows users to create *group*s. A GitLab group can contain multiple Git
repositories and may also include one or more subgroups. The purpose of a group
is to organize repositories, making a user's homepage less cluttered, similar to
using folders to manage files. Here, a course is simply a GitLab group.

## Assignment Creation

A course may have multiple assignments, and an assignment may include multiple
Git repositories. Therefore, an assignment is also represented as a group.

Additionally, each assignment group contains Git repositories for specific purposes:

- A repository for storing starter files
- A repository for storing assessment code
- One or more student repositories

Using a folder structure to illustrate the idea, it would look like the following:

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
  ├── term-00
  │   ├── a0
  │   │   ├── stu-00
  │   │   ├── stu-01
  │   │   └── ...
  │   └── a1
  │       ├── stu-00
  │       ├── stu-01
  │       └── ...
  │
  ├── term-01
  │   ├── a0
  │   │   ├── stu-00
  │   │   ├── stu-01
  │   │   └── ...
  │   └── a1
  │       ├── stu-00
  │       ├── stu-01
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
  ├── root
  │   ├── a0-starter
  │   ├── a0-assessment
  │   ├── a1-starter
  │   └── a1-assessment
  │
  ├── term-00
  │   ├── a0-stu-00
  │   ├── a0-stu-01
  │   ├── a1-stu-00
  │   └── a1-stu-01
  │
  ├── term-01
  │   ├── a0-stu-00
  │   ├── a0-stu-01
  │   ├── a1-stu-00
  │   └── a1-stu-01
  │
  └── ...
```

Or

### Structure #3

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
  ├── term-00-a0-stu-00
  ├── term-00-a0-stu-01
  ├── term-00-a1-stu-00
  ├── term-00-a1-stu-01
  │
  ├── term-01-a0-stu-00
  ├── term-01-a0-stu-01
  ├── term-01-a1-stu-00
  ├── term-01-a1-stu-01
  │
  └── ...
```

Even using a single Git repo to manage starter code and assessments, such as:

### Structure #4

```
  course
  │
  ├── README.md
  │
  ├── root (containing starter code and assessment code for all assignments)
  │
  ├── term-00-a0-stu-00
  ├── term-00-a0-stu-01
  ├── term-00-a1-stu-00
  ├── term-00-a1-stu-01
  │
  ├── term-01-a0-stu-00
  ├── term-01-a0-stu-01
  ├── term-01-a1-stu-00
  ├── term-01-a1-stu-01
  │
  └── ...
```

For demonstration purposes, I will only discuss the first structure. Other
structures can be implemented in a similar manner.

## Setting Assignment Deadlines

Since students will use Git to track their assignment progress, instructors can
simply filter out the last commits made before the assignment deadline for
grading. Using GitLab, instead of configuring an assignment deadline within the
system, we only need a script that filters commits based on their commit time.

## Summary

- Admin
  - can create courses [&check;]
    - a course can have multiple assignments [&check;]
- Instructors (and TAs)
  - can create assignments [&check;]
    - can create group assignments [&check;]
    - can upload starter files for an assignment [&check;]
    - can filter out Git commits by commit time ~configure assignment deadlines~ [&check;]
- Student
  - can see assignment descriptions [&check;]
