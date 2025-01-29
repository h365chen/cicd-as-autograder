# GitLab As An Example

To facilitate using GitLab to implement an auto-grading system, I use three tags
for the features we discussed before, namely *Creation*, *Assessment*, and
*Report*. *Creation* stands for course and assignment creation, *Assessment* is
for how the system will execute test cases, and *Report* is for how the test
outcomes should be reported.

## Creation

- Admin
  - can create courses
    - a course can have multiple assignments
- Instructors (and TAs)
  - can create assignments
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
