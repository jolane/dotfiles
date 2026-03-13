---
name: snyk-fix-single
description: Find the single most critical fixable Snyk vulnerability in the current repo, apply the least destructive fix, run tests and linter, create a GitLab MR via glab, and poll CI/CD until green
---

## What I do

Fix exactly one vulnerability at a time — the most critical fixable issue in the current repo. I apply the smallest possible semver bump, validate the fix with tests and linting, open a GitLab MR, and monitor CI/CD until the pipeline passes.

## Workflow

### Step 1 — Scan and identify the single target vulnerability

Use the `snyk_sca_scan` MCP tool on the current working directory.

From the results:
- Filter to vulnerabilities that have a **fixable upgrade path** only (ignore unfixable/no-fix-available issues)
- Rank by severity: Critical > High > Medium > Low
- Within the same severity, prefer the **smallest semver bump** (e.g. patch > minor > major)
- Select **exactly one** — the top-ranked issue

If no fixable vulnerabilities exist, stop and tell the user: "No fixable vulnerabilities found in this repo."

Record the following for use in later steps:
- Package name and current version
- Target fix version
- Vulnerability title and ID (CVE or Snyk ID)
- Snyk issue URL (if available in scan output)
- Manifest file path (e.g. `package.json`, `requirements.txt`)

---

### Step 2 — Apply the least destructive fix

**Never edit a lockfile directly.** Only modify the manifest file.

#### Detect the ecosystem and manifest

| Ecosystem | Manifest file | Install command |
|-----------|--------------|-----------------|
| Node.js (npm) | `package.json` | `npm install` |
| Node.js (yarn) | `package.json` | `yarn install` |
| Node.js (pnpm) | `package.json` | `pnpm install` |
| Python (pip) | `requirements.txt` / `requirements/*.txt` | `pip install -r requirements.txt` |
| Python (pipenv) | `Pipfile` | `pipenv install` |
| Python (poetry) | `pyproject.toml` | `poetry update <package>` |
| Java (Maven) | `pom.xml` | `mvn install -DskipTests` |
| Java (Gradle) | `build.gradle` / `build.gradle.kts` | `gradle dependencies` |
| Ruby | `Gemfile` | `bundle install` |
| Go | `go.mod` | `go mod tidy` |
| PHP | `composer.json` | `composer update <package> --with-dependencies` |

For Node.js, detect the package manager by checking for the presence of:
- `package-lock.json` → npm
- `yarn.lock` → yarn
- `pnpm-lock.yaml` → pnpm

#### Update the manifest

- For `package.json`: update the version constraint for the affected package in `dependencies` or `devDependencies` to the target fix version. Use the same constraint style already present (e.g. `^`, `~`, or exact).
- For `requirements.txt`: update the pinned version or version specifier for the package.
- For `pom.xml`: update the `<version>` tag for the affected `<dependency>`.
- For `Gemfile`: update the version constraint for the affected gem.
- For `go.mod`: run `go get <package>@<version>` to update.
- For `pyproject.toml`: update the version constraint under `[tool.poetry.dependencies]`.
- For `composer.json`: update the version constraint for the affected package.

After updating the manifest, run the appropriate install command to regenerate the lockfile.

---

### Step 3 — Run tests and fix until green

#### Auto-detect the test command

Check in this order:
1. `package.json` → look for a `test` script under `scripts`
2. Presence of `pytest.ini`, `setup.cfg` with `[tool:pytest]`, or `pyproject.toml` with `[tool.pytest]` → `pytest`
3. Presence of `Makefile` with a `test` target → `make test`
4. Presence of `pom.xml` → `mvn test`
5. Presence of `build.gradle` or `build.gradle.kts` → `./gradlew test`
6. Presence of `Gemfile` → `bundle exec rspec`
7. Presence of `go.mod` → `go test ./...`
8. If no test command can be detected, skip this step and note it in the MR description.

#### Run and fix loop

- Run the detected test command
- If tests pass: proceed to Step 4
- If tests fail:
  - Analyse the failure output
  - Attempt to fix the issue (e.g. update test snapshots, fix API incompatibilities introduced by the version bump)
  - Re-run tests
  - Repeat until passing
  - If after 3 attempts tests still fail, stop and tell the user: the fix causes test failures that require manual resolution. Do not create an MR.

---

### Step 4 — Run linter and fix until clean

#### Auto-detect the lint command

Check in this order:
1. `package.json` → look for a `lint` script under `scripts`
2. Presence of `.eslintrc`, `.eslintrc.js`, `.eslintrc.json`, `.eslintrc.yml` → `npx eslint .`
3. Presence of `.flake8` or `[flake8]` in `setup.cfg` → `flake8`
4. Presence of `pyproject.toml` with `[tool.ruff]` → `ruff check .`
5. Presence of `.rubocop.yml` → `bundle exec rubocop`
6. Presence of `.golangci.yml` or `.golangci.yaml` → `golangci-lint run`
7. Presence of `phpcs.xml` or `.phpcs.xml` → `phpcs`
8. If no linter can be detected, skip this step.

#### Run and fix loop

- Run the detected lint command
- If clean: proceed to Step 5
- If lint errors exist:
  - Attempt auto-fix first (e.g. `eslint --fix`, `ruff check --fix`, `rubocop -a`, `gofmt -w`)
  - Re-run linter to check for remaining issues
  - Manually fix any remaining errors
  - Repeat until clean

---

### Step 5 — Create a branch and commit

```bash
# Determine the default branch
git remote show origin | grep 'HEAD branch' | awk '{print $NF}'
# Use 'main' if above fails, fall back to 'master' if 'main' doesn't exist

# Create and push the fix branch
git checkout -b fix/snyk-<package-name>-<vuln-id>

# Stage only the manifest and lockfile
git add <manifest-file> <lockfile>

# Commit
git commit -m "fix: bump <package> from <old-version> to <new-version>

Fixes <vuln-title> (<vuln-id>)"
```

Use lowercase kebab-case for the branch name. Replace any characters that are not alphanumeric or hyphens with hyphens in the package name and vuln ID.

---

### Step 6 — Create the GitLab MR using glab

```bash
glab mr create \
  --title "fix: bump <package> from <old-version> to <new-version>" \
  --description "## Security Fix

Bumps \`<package>\` from \`<old-version>\` to \`<new-version>\` to resolve a <severity> severity vulnerability.

### Vulnerability
- **Title:** <vuln-title>
- **ID:** <vuln-id>
- **Severity:** <severity>
- **Snyk Issue:** <snyk-issue-url>

### Fix
- Updated \`<manifest-file>\` to require \`<package>@<new-version>\`
- Regenerated lockfile

### Verification
- Unit tests: passing
- Linter: clean" \
  --target-branch <default-branch> \
  --push
```

Record the MR URL returned by `glab`.

---

### Step 7 — Poll GitLab CI/CD until green

Poll every 30 seconds using:

```bash
glab ci status --branch fix/snyk-<package-name>-<vuln-id>
```

- **Pipeline passes:** report success to the user with the MR URL. Done.
- **Pipeline fails:**
  1. Get the failed job logs: `glab ci view` or `glab ci trace`
  2. Analyse the failure
  3. Apply a fix (e.g. update config, fix a test, resolve a build error)
  4. Commit and push the fix to the same branch
  5. Resume polling
  6. Repeat until green
- **Timeout (10 minutes):** stop polling and report the current pipeline status and MR URL to the user. Tell them to check the pipeline manually.

---

## Error handling

- **`SNYK_TOKEN` not set:** stop and tell the user "SNYK_TOKEN is not set. Please ensure it is exported in your shell from 1Password."
- **No fixable vulnerabilities:** stop and tell the user clearly.
- **Tests fail after 3 fix attempts:** stop, do not create MR, tell the user which tests are failing and why.
- **`glab` not installed or not authenticated:** tell the user to install `glab` and run `glab auth login`.
- **CI timeout after 10 minutes:** report MR URL and final pipeline status, advise manual review.
