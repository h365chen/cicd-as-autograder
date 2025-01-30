# GitLab As An Example

I choose GitLab as the Git hosting service since it is free to create a
self-hosting instance using GitLab. It also supports various external
authentication and authorization so it should be trivial to use your own
authentication and authorization service or LMS for user logins.

To facilitate using GitLab to implement an auto-grading system, I group features
that have been discussed in the previous chapter into three categories, namely
*Course and Assignment Creation*, *Assessment*, and *Report*, and I will discuss
how features in each category can be implemented.

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
