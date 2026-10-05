---
name: git-ftp-deploy
description: >
  Use this skill whenever the user wants to deploy a project to production using
  git-ftp. Trigger on requests like "haz deploy", "deploy", "subir a
  producción", "git ftp push", "build y deploy", "deploy por ftp", or any
  mention of deploying a git-ftp-configured project. Always follow the build →
  commit → git ftp push workflow and handle errors at each step.
---

# git-ftp-deploy

Deploy any project to production using the git-ftp workflow.

## When to use

Use this skill when the user asks to deploy a project that is already configured
with git-ftp. The standard workflow is:

1. Build frontend assets.
2. Commit pending changes.
3. Push files via `git ftp push`.

## Prerequisites

- The project must be a git repository.
- `git-ftp` must be installed and configured for the repository.
- A build tool must be available (pnpm, npm, or yarn).
- The working directory should be the project root.

## Detect build command

Before building, detect the correct package manager and build command:

- If `pnpm-lock.yaml` exists or `pnpm` is available, use `pnpm run build`.
- If `package-lock.json` exists, use `npm run build`.
- If `yarn.lock` exists, use `yarn build`.
- If none of the above, try `npm run build` as fallback.

## Deploy workflow

Run the following steps in order. Stop and report if any step fails.

### 1. Build

Run the detected production build command. If this fails, report the error and
stop. Do not commit or push.

### 2. Review changes

Check the repository status:

```bash
git status --short
```

Show the summary to the user so they know what will be committed.

### 3. Commit

If there are changes, commit them. Ask the user for a commit message when
possible. If the user does not provide one, use a descriptive message based on
the changes.

```bash
git add -A
git commit -m "<mensaje>"
```

If there are no changes to commit, skip this step and proceed to push.

### 4. Push via git-ftp

Run:

```bash
git ftp push
```

Report the result, including how many files were uploaded or deleted.

## Relevant project files

- `.git-ftp-ignore` – lists files and folders that git-ftp will not upload.
- `.git-ftp-include` – can force inclusion of generated files that are not
  tracked by git but must be uploaded (for example `public/build`).

## Error handling

- **Build fails**: stop and show error output.
- **No git-ftp remote configured**: ask the user to run `git ftp init` or
  configure the remote first.
- **git ftp push fails after commit**: do not auto-retry. Show the error and
  ask the user how to proceed.

## Notes

- The commit should include all pending changes, including generated build
  assets if they are tracked by git.
- Respect the user's language when writing commit messages and output text.
