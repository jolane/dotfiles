---
name: create-gitlab-mr
description: Create a high quality GitLab merge request by ensuring work is on a feature branch, committing changes properly, pushing the branch, and opening an MR using glab.
---

# Create Merge Request

## What I do

I help create a GitLab Merge Request safely and consistently.

I will:

1. Verify the repository is in a valid git worktree.
2. Ensure work is on a **feature branch**.
3. Review current changes.
4. Stage and commit changes with a **proper git commit message**.
5. Push the branch to `origin`.
6. Generate a **high-quality Merge Request title and description**.
7. Create the Merge Request using the `glab` CLI.

When generating the MR content I will:

- Explain **why the change is being made**
- Ask for context if the reason for the change is unclear
- Link to **relevant Jira tickets**
- Link to **relevant Confluence documentation**
- Provide a **high-level summary of the code changes**
- Provide **testing notes**
- Write the MR so it is **easy for reviewers to understand**

---

# Rules

- Never execute this skill in `Plan` mode
- Only execute this skill in `Build` mode
- Never create a merge request directly from `main`, `master`, `trunk`, or `develop`.
- Never discard user changes.
- Stop immediately if there are no changes to commit.
- Prefer explicit commands over clever shell one-liners.
- Do not invent Jira tickets or Confluence links.
- Commit messages must follow the guidance here: https://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html
- Merge requests should follow the GitHub Flow pattern: https://docs.github.com/en/get-started/using-github/github-flow
- Merge Requests must clearly explain:
  - why the change exists
  - what changed
  - how it was tested
- Use the `--draft` flag by default when using `glab mr create` CLI command.

---

# GitHub Flow Expectations

The merge request workflow should follow **GitHub Flow** principles.

https://docs.github.com/en/get-started/using-github/github-flow

Key ideas:

- All work happens on a **feature branch** created from the main branch.
- The branch should represent **one logical change**.
- The branch should be **short-lived**.
- The MR should be opened once the change is ready for review.
- Reviews should happen before merging.
- Additional commits should address review feedback.

This skill should enforce these principles whenever possible.

---

# Commit Message Guidelines

Commit messages should follow:

https://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html

Key rules:

- Subject line ≤ 50 characters
- Use the **imperative mood**
- Capitalize the first letter
- Do not end the subject with a period
- Leave a blank line between subject and body
- Wrap body text at ~72 characters

