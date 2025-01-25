# Introduction

Git is a popular tool for version control. Almost all software engineering
students know, or at least are recommended to learn it for their group projects.
Recognizing the necessasities, institutions or departments having large potion
of programming content typically take advantage of existing Git repo hosting
services, such as GitHub, GitLab, or Gitea. Some of these Git hosting services
also provide a self-hosting option. For example, University of Waterloo hosts
its own GitLab instance at <https://git.uwaterloo.ca> instead of using the
default one <https://gitlab.com>. Essential features such as repo hosting,
continuous integration and continuous delivery (CI/CD), container registry for
docker images are available in the service regardless whether it is self-hosted
or not.

Interestingly, while students may use a Git host service to manage their code,
they are often required to submit their code to an auto-grading system which is
not integrated with the Git host service for assessment. For example, students
need to submit their code to Marmoset, an Apache Tomcat and MySQL based
auto-grading system for assessment. The assessment procedure is pretty much the
same as a common integration test, that when Marmoset receives a new submission,
it invokes multiple test cases pre-composed by the instructor, and then report
the test outcomes. A test outcome is typically a pass or a fail. If the test
case failed, there will also be some log messages printed to the standard output
by the test case to aid students for code diagnosis.

Comparing Marmoset and CI/CD in the Git hosting service, I consider the most
significant difference, from the student's perspective, is that not all test
outcomes are visible, since the instructor has the control over which test case,
and when a test case can be shown. From an instructor's perspective, Marmoset
provides more convinience for managing students' enrolments. For example, it
allows an instructor to upload a class file to register students. It also allows
an instructor to download the latest submission of every student conveniently.
However, from my experience, the lack of code comparison between consecutive
submissions in Marmoset is a headache. Also, it is neither trivial to comment on
student's code. The latter two features are already supported by many Git
hosting services. Last but not least, many auto-grading systems have not changed
for many years. On contrast, the CI/CD in the Git hosting service has been
constantly improving, such as introducing secret variables and many other useful
features for investigating code analytics.

This project is to explore to what extent we can make use of Git hosting
services as auto-grading systems so that we can take advantage of many useful
features they provide.
