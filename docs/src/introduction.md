# Introduction

Git is a popular tool for version control. Almost every software engineering
student knows it or has at least been encouraged to learn it for group projects.
Recognizing this need, institutions or departments with a significant amount of
programming content typically take advantage of existing Git hosting services,
such as GitHub, GitLab, or Gitea. Some of these services also offer self-hosting
options. For example, the University of Waterloo hosts its own GitLab instance
at <https://git.uwaterloo.ca> instead of using the default instance at
<https://gitlab.com>. Essential features such as repository hosting, continuous
integration and continuous delivery (CI/CD), and container registries for Docker
images are available, whether the service is self-hosted or externally hosted.

Interestingly, while students may use a Git hosting service to manage their
code, they are often required to submit it to an auto-grading system that is not
integrated with the Git service. For example, students may need to submit their
code to Marmoset, an auto-grading system based on Apache Tomcat and MySQL. The
assessment procedure in Marmoset is similar to a typical integration test: when
Marmoset receives a new submission, it runs multiple pre-written test cases
prepared by the instructor and reports the outcomes. A test result is typically
either a pass or a fail. If a test case fails, log messages printed to standard
output help students diagnose bugs.

Comparing Marmoset to CI/CD pipelines in Git hosting services, the most
significant difference from a student's perspective is visibility. Not all test
results are visible in Marmoset, as instructors control which test cases are
shown and when. From an instructor's perspective, Marmoset offers more
convenience in managing student enrollments (although I would argue this is not
a critical feature for an auto-grading system). For instance, instructors can
upload a class file to register students and easily download each student's
latest submission.

However, in my experience, the lack of code comparison between consecutive
submissions in Marmoset is a major drawback. It is also not straightforward to
comment on a student's code. These features, however, are already well-supported
by many Git hosting services. Furthermore, many auto-grading systems have not
seen meaningful updates in years. In contrast, CI/CD features in Git hosting
services are continually improving, with additions like secret variables and
advanced analytics tools.

This project explores the extent to which Git hosting services can be used as
auto-grading systems, allowing us to leverage the many valuable features they
offer.
