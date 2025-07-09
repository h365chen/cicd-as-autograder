# GitLab As An Example

I chose GitLab as the Git hosting service because it allows the creation of a
self-hosted instance for free. It also supports various external authentication
and authorization methods, making it straightforward to integrate with your own
authentication system or LMS for user logins.

To facilitate the use of GitLab in implementing an auto-grading system, I have
grouped the features discussed in the previous chapter into three categories:
*Course and Assignment Creation*, *Assessment*, and *Report*. I will discuss how
the features in each category can be implemented.

## Course and Assignment Creation

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

## Assessment

- Instructors (and TAs)
  - can look for the correct version of the test code and use that for grading
  - can re-test a submission
  - can grant a student with time extensions

## Report

- Instructors (and TAs)
  - can manage submissions
    - can dowload all submissions
    - can dowload students' last submissions
  - can view grading analytics
    - can see the number of submissions of all students
    - can see the number of passed and failed tests of all submissions of a
      student
    - can see detailed test outcomes of a single submission
    - can download grades in a csv file
  - can see inconsistent re-test results
  - can control visibilities of test outcomes
- Student
  - can see test outcomes
