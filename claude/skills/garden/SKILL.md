---
name: garden
description: Capture the current discussion as a note, RFC, or ADR into ~/garden/docs.
argument-hint: [note|rfc|adr] [optional title]
allowed-tools: Write Bash(mkdir *) Bash(ls *) Bash(date *)
---

Capture the current conversation as a garden document and write it to ~/garden/docs.

## 1. Determine document type

Infer from $ARGUMENTS or conversation context:
- "note" / "capture this" / "capture it" / no qualifier → **note**
- "rfc" / "write an RFC" / "proposal" → **rfc**
- "adr" / "write an ADR" / "record this decision" → **adr**

If ambiguous, ask once: "Note, RFC, or ADR?"

## 2. Derive title and slug

Extract a title from $ARGUMENTS or the conversation. If none is obvious, propose one and confirm.

Slug = title → lowercase → replace non-alphanumeric chars with `-` → collapse consecutive `-` → strip leading/trailing `-`.
Example: "Use Redis for session storage" → `use-redis-for-session-storage`

## 3. File path

Get today's date: run `date +%Y-%m-%d` → yields `YYYY-MM-DD`.

**note**
- Filename: `YYYY-MM-DD-<slug>.md`
- Path: `~/garden/docs/notes/YYYY-MM-DD-<slug>.md`

**rfc**
- Run `ls ~/garden/docs/rfc/????-??-??-rfc-*.md 2>/dev/null | sort | tail -1` to find the last new-format file.
- Also run `ls ~/garden/docs/rfc/rfc-*.md 2>/dev/null | sort | tail -1` to catch old-format files.
- Extract NN from whichever gives the higher number. Start at 1 if nothing exists.
- Next NN = last + 1, zero-padded to 2 digits.
- Filename: `YYYY-MM-DD-rfc-NN-<slug>.md`
- Path: `~/garden/docs/rfc/YYYY-MM-DD-rfc-NN-<slug>.md`

**adr**
- Run `mkdir -p ~/garden/docs/adr`
- Same NN logic: `ls ~/garden/docs/adr/????-??-??-adr-*.md 2>/dev/null | sort | tail -1`
- Filename: `YYYY-MM-DD-adr-NN-<slug>.md`
- Path: `~/garden/docs/adr/YYYY-MM-DD-adr-NN-<slug>.md`

## 4. Frontmatter

All three required fields must be present. Tags are optional.

```yaml
---
title: '<title>'
description: '<one-sentence summary from context>'
slug: '<type>/<slug>'
tags: ['tag1', 'tag2']
---
```

- `slug` format: `type/kebab-slug` — e.g. `rfc/adaptive-router`, `note/redis-notes`, `adr/use-postgres`
- `tags`: 2–5 lowercase kebab-case tags inferred from content. Omit if you cannot derive 2+ meaningful ones. Never invent.
- `description`: one sentence synthesized from the conversation. Never write a hollow placeholder.

## 5. Body by document type

**note** — generate content directly from the conversation: summary, insights, code snippets, links.
Free-form, no forced structure.

**rfc** and **adr** — invoke the `architect` skill to generate the document body.
Pass the document type and topic as context. The architect skill uses its own `templates/rfc.md`
and `templates/adr.md` — use the generated body as-is, do not restructure it.
The architect skill produces Mermaid diagrams where appropriate; they render natively in the garden.

## 6. After writing

Report:
- Full path written
- Doc type + number (if rfc/adr)
- One-line summary of what was captured

Do not print the file contents back.
