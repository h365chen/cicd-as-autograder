# Git-Hosting Service for Auto-Grading

This project explores how Git hosting services can be used as auto-grading
systems in academic environments, particularly in software engineering courses.

## Background

Git is a standard tool for version control, widely used in both industry and
academia. Many institutions adopt Git hosting platforms like **GitHub**,
**GitLab**, or **Gitea**, with self-hosted instances (e.g.,
<https://git.uwaterloo.ca>).

While students typically use these platforms for collaborative development, they
are often required to submit their code to separate auto-grading systems like
**Marmoset**. These systems evaluate code against pre-defined test cases and
reveal test case outcomes as feedback.

## Motivation

Auto-grading platforms like Marmoset, though functional, lack several features
supported by modern Git hosting services:

- No built-in code comparison between submissions
- Limited feedback and commenting tools
- Outdated interfaces and workflows

In contrast, Git hosting platforms with CI/CD support:

- Flexible testing pipelines
- Inline code review and comments
- Secret variables and secure configuration
- Detailed logs and analytics
- Constant improvements and active development

## Objective

This project investigates how Git-based CI/CD tools can replicate or replace
traditional auto-grading systems.
