---
name: ship
description: Review the diff, then commit and push. User-invoked only — Eli never ships on her own.
disable-model-invocation: true
argument-hint: [commit message]
allowed-tools: Bash(git add *) Bash(git commit *) Bash(git push *) Bash(git status) Bash(git diff *)
---

Ship the current changes. I've reviewed the diff (or am reviewing it with you now).

1. Run `git status` and `git diff` (and `git diff --staged` if anything's already staged) and
   show me exactly what's going out.
2. Stage the intended files with `git add`.
3. Commit: `git commit -m "$ARGUMENTS"`.
   - If `$ARGUMENTS` is empty, propose a concise commit message (conventional-commit style,
     e.g. `fix:` / `feat:` / `refactor:`) from the diff and use it.
4. Push with `git push`.

Stop and check with me first if anything looks off — wrong branch, unstaged surprises,
secrets or large files sneaking in, or a build/test that should run before this ships.
