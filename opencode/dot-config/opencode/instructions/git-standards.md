# Git Standards

## Branching

- Never commit directly to `main`, `master`, `trunk`, or `develop`.
- All changes must be made on a short-lived feature branch.
- Feature branches should represent one logical change.
- Follow GitHub Flow:
  https://docs.github.com/en/get-started/using-github/github-flow

## Commit messages

Commit messages must follow:
https://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html

Rules:
- Subject line <= 50 characters
- Use imperative mood
- Capitalize first letter
- No trailing period
- Blank line between subject and body
- Wrap body at about 72 characters

## Merge requests

MRs should:
- explain why the change is being made
- link relevant Jira tickets if provided
- link relevant Confluence docs if provided
- summarize high-level code changes
- include testing notes
