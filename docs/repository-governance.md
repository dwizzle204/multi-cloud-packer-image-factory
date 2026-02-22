# Repository governance

This document defines the recommended GitHub repository configuration for this template.

## Branching strategy

Recommended model:

- `main`
  - protected, releasable, always deployable template state
- short-lived feature branches
  - naming examples: `feat/*`, `fix/*`, `docs/*`, `chore/*`
- pull requests for all changes into `main`

Avoid long-lived integration branches unless your organization requires them.

## Pull request requirements

Require the following before merge to `main`:

- At least **2 approving reviews**
- All required status checks pass
- No unresolved review conversations
- Branch is up to date with `main`

## Main branch protection

Enable branch protection (or ruleset) on `main` with:

- Require pull request before merging
- Require **2 approvals**
- Dismiss stale approvals on new commits
- Require approval of most recent reviewable push
- Require status checks to pass
- Require conversation resolution
- Include administrators
- Restrict force pushes
- Restrict deletions
- Disable direct pushes to `main`

## Suggested required status checks

Use stable, non-transient check names. Suggested baseline:

- Static validation (`make test`)
- Workflow YAML validation
- Terratest compile/smoke gate (environment-gated as needed)

## CODEOWNERS and review routing

Add a `CODEOWNERS` file so workflow/image/security changes route to the right reviewers.

Suggested ownership areas:

- `.github/workflows/*` -> platform/DevOps owners
- `images/common/ansible/*` -> security + OS build owners
- `images/*/*.pkr.hcl` -> image engineering owners
- `tests/terratest/*` -> platform test owners
- `docs/*` -> docs/platform owners

## Merge strategy

Recommended:

- Squash merge for feature/fix branches
- Conventional PR titles or consistent changelog labels
- Update `CHANGELOG.md` and `VERSION` for user-visible/release-relevant changes

## Environment controls

For promotion workflows:

- Keep `prod` GitHub Environment approval enabled
- Require designated approvers for `prod`
- Scope secrets/variables to environment where applicable
