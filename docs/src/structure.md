# Structure


## What features do we currently have in auto-grading systems?

I will use the auto-grading system **Marmoset** as an example to demonstrate its
features.

### Marmoset Structure (By user types)

- User categories: admin, instructor, teaching assistant (TA), and student.
- Admin
  - can create courses
    - a course can have multiple assignments
- Instructors (and TAs)
  - can create assignments
    - can upload starter files for an assignment
    - can configure assignment deadlines on the web page
  - can manage individual students' enrolments
    - can register a student for a course
    - can remove a student from a course
  - can manage submissions
    - can dowload all submissions
    - can dowload students' last submissions
  - can view grading analytics
    - can see number of submissions of all students
    - can see the number of passed and failed tests of all submissions of a
      student
    - can see detailed test outcomes of a single submission
    - can download grades in a csv file
  - can create test cases for assignments
    - each test case is usually a script that compile and executes student's
      code
    - each test case usually compares the expected output and the actual output
      given the same input
    - a test case is `passed` if outputs match, otherwise is `failed` if outputs
      mismatch
    - each test case is executed separately
    - test cases are uploaded along with a `test.properties` file in a zip
      - each zip file is called a *test setup*
      - a test setup can only be replaced as a whole
      - Marmoset uses `test.properties` to recognize test case scripts among
        others
  - can upload a canonical solution to validate a test setup
  - can mark test setups as broken (remove flawed test setups)
  - can re-test a submission
  - can see inconsistent re-test results
  - can grant a student with time extensions
  - can control visibilities of test outcomes
- Student
  - can see assignment descriptions
  - can see test outcomes

Note that the above features, test case development is entirely up to the
instructor. Marmoset does not provide any support for developing test cases; it
simply uses them, with the `test.properties` file serving as the entry point for
locating the test cases.


## What can be improved?

As you may notice, test case development is actually a separate process from
Marmoset. Therefore, features related to test case development should be
considered independent. Furthermore, it would be better if Marmoset could
*automatically identify* the correct *version* of a test setup, instead of
requiring instructors to repeatedly upload it.

### Are there any features that are redundant?

Based on my experience, managing students' enrollments in Marmoset is
unnecessary. Even worse, Marmoset uses a different class list format from the
one used in the Learning Management System (LMS), which forces instructors to
maintain two separate class lists. If a student drops the course (something that
is automatically updated in the LMS), the instructor must manually reflect that
change in Marmoset. This not only creates extra work but also introduces the
risk of inconsistencies.

There may be scenarios where an instructor intends to use only the auto-grading
features. In such cases, I would argue that setting up a dedicated LMS is better
than using Marmoset as both an LMS and an auto-grading system. At the very
least, LMS-related features should be a service or plugin that can be *enabled*,
rather than *required*.

### Are there any features that are missing?

The most essential missing feature is the lack of support for group assignments.
Marmoset does not allow the creation of group assignments or provide any
features for instructors to manage student groups.


## Ideal structure

Therefore, necessary features of an auto-grading system are as follows.

- Admin
  - can create courses
    - a course can have multiple assignments
- Instructors (and TAs)
  - can create assignments
    - can create group assignments
    - can upload starter files for an assignment
    - can configure assignment deadlines
  - ~can manage individual students' enrolments~
    <!-- - can register a student for a course -->
    <!-- - can remove a student from a course -->
  - Do **NOT** need to manage students' enrolments
  - can manage submissions
    - can dowload all submissions
    - can dowload students' last submissions
  - can view grading analytics
    - can see the number of submissions of all students
    - can see the number of passed and failed tests of all submissions of a
      student
    - can see detailed test outcomes of a single submission
    - can download grades in a csv file
  - **can look for the correct version of the test code and use that for grading**
  - ~can create test cases for assignments~
  <!--   - each test case is usually a script that compile and executes student's -->
  <!--     code -->
  <!--   - each test case usually compares the expected output and the actual output -->
  <!--     given the same input -->
  <!--   - a test case is `passed` if outputs match, otherwise is `failed` if outputs -->
  <!--     mismatch -->
  <!--   - each test case is executed separately -->
  <!--   - test cases are uploaded along with a `test.properties` file in a zip -->
  <!--     - each zip file is called a *test setup* -->
  <!--     - a test setup can only be replaced as a whole -->
  <!--     - Marmoset uses `test.properties` to recognize test case scripts among -->
  <!--       others -->
  <!-- - can upload a canonical solution to validate a test setup -->
  <!-- - can mark test setups as broken (remove flawed test setups) -->
  - can re-test a submission
  - can see inconsistent re-test results
  - can grant a student with time extensions
  - can control visibilities of test outcomes
- Student
  - can see assignment descriptions
  - can see test outcomes
