---
name: garden
description: Capture the current discussion as a note, RFC, or ADR into the digital garden via the garden MCP.
argument-hint: [note|rfc|adr] [optional title]
allowed-tools: mcp__garden__capture_note
---

Capture the current conversation as a garden document by calling the `garden` MCP.
The MCP owns file placement, naming, dates, and frontmatter — your job is to
decide the type, write a good title + body, and hand it over.

## 1. Determine document type

Infer from $ARGUMENTS or conversation context:
- "note" / "capture this" / "capture it" / no qualifier → **note**
- "rfc" / "write an RFC" / "proposal" → **rfc**
- "adr" / "write an ADR" / "record this decision" → **adr**

If ambiguous, ask once: "Note, RFC, or ADR?"

## 2. Title, description, tags

- **title**: extract from $ARGUMENTS or the conversation. If none is obvious, propose one and confirm.
- **description**: one sentence synthesized from the conversation. Never a hollow placeholder.
- **tags**: 2–5 lowercase kebab-case tags inferred from content. Omit if you cannot derive 2+ meaningful ones. Never invent.

(No slug, date, or filename work — the MCP derives the slug from the title and stamps the date.)

## 3. Body

**note** — generate content directly from the conversation: summary, insights, code snippets, links.
Free-form, no forced structure.

**rfc** and **adr** — invoke the `architect` skill to generate the document body.
Pass the document type and topic as context. The architect skill uses its own `templates/rfc.md`
and `templates/adr.md` — use the generated body as-is, do not restructure it.
The architect skill produces Mermaid diagrams where appropriate; they render natively in the garden.

## 4. Capture

Call `mcp__garden__capture_note` once with:
- `type`: `note` | `rfc` | `adr`
- `title`: the title from step 2
- `content`: the body from step 3 (markdown; do not include frontmatter — the MCP adds it)
- `description`: from step 2
- `tags`: from step 2 (omit if <2)
- `model`: the model that produced it; `source`: `chat`

The MCP routes it to `docs/notes|rfc|adr/<date>-...md`, adds the site frontmatter,
and commits to the garden repo. It returns `{ status, path }`.

## 5. After capturing

Report:
- The `path` the MCP returned
- One-line summary of what was captured

Do not print the file contents back. If the MCP returns an error (auth, GitHub write, timeout),
surface it plainly — do not fall back to writing files directly.
