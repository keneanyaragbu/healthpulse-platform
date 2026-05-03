# Repository Security

This document describes the version control and repository security controls implemented for the HealthPulse DevOps Platform.

## GitFlow Branching Strategy

The repository uses a GitFlow-based branching model.

| Branch | Purpose |
|--------|---------|
| main | Production-ready code |
| develop | Integration branch for validated changes |
| feature/* | Short-lived branches for new work |
| release/* | Release preparation before production |

## Security Layers

Repository security follows a defense-in-depth model.

| Layer | Control | Purpose |
|------|---------|---------|
| Layer 1 | Local pre-commit hook | Detects secrets before commit |
| Layer 1 | Local pre-push hook | Warns on direct push to protected branches |
| Layer 3 | GitHub branch protection | Enforces pull request workflow |

## Pre-Commit Secret Detection

The repository uses `pre-commit` with `detect-secrets` to scan staged files before commits are created.

Validation completed:

- A fake AWS secret was added to a test file
- The commit was blocked by `detect-secrets`
- The test file was removed after validation

## Pre-Push Hook

A custom pre-push hook was added to warn when pushing directly to protected branches.

Protected branches:

- main
- develop

## Branch Protection

GitHub branch protection rules were configured for both `main` and `develop`.

Enabled controls:

- Pull request required before merging
- Conversation resolution required before merge
- Direct push blocked
- Admin bypass disabled

## Production Workflow

Changes must follow this workflow:

```text
feature branch → pull request → protected branch

Example:

git checkout -b feature/repo-security-setup
git add .
git commit -m "Add repository security controls"
git push -u origin feature/repo-security-setup

The feature branch is then merged through a pull request.
