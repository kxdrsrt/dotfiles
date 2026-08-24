---
mode: agent
description: >
  Remove multi-vendor AI provenance marks: invisible Unicode (Layer A), statistical
  text watermarks via rewrite (Layer B, always offer), and C2PA/EXIF/XMP/container
  metadata on PNG/JPEG/WebP/SVG/PDF/DOCX/ODT/HTML/MD. Covers Claude, Gemini/SynthID-class,
  OpenAI provenance, and open-LLM sampling marks. Use when the user asks to strip
  watermarks, remove C2PA/Content Credentials, clean AI metadata, remove invisible
  Unicode, anti-detect clean AI output, or runs /remove-ai-marks (aliases:
  /remove-claude-marks).
---

# Remove AI marks

Multi-vendor anti-detection hygiene for **text** (Unicode + statistical rewrite) and **files** (C2PA / AI metadata across common containers).

Reference docs (read if needed):

- `/Users/k/.local/share/watermarks-remover/skills/remove-ai-marks/references/mark-classes.md` — Unicode / sampling / C2PA / containers
- `/Users/k/.local/share/watermarks-remover/skills/remove-ai-marks/references/vendor-notes.md` — Claude, Gemini/SynthID, OpenAI, open-LLM
- `/Users/k/.local/share/watermarks-remover/skills/remove-ai-marks/references/removal-matrix.md` — which layer when
- `/Users/k/.local/share/watermarks-remover/skills/remove-ai-marks/references/ethics.md` — intended use
- `/Users/k/.local/share/watermarks-remover/skills/remove-ai-marks/references/how-claude-marks.md` — Anthropic-specific detail
- `/Users/k/.local/share/watermarks-remover/skills/remove-ai-marks/references/markdiffusion.md` — optional MarkDiffusion image harness

This skill is a **thin client**. All deterministic cleaning machinery runs in a
separate HTTP service (at `~/.local/share/watermarks-remover/`), so the agent host needs no
Python, venvs, or cleaning tools. Call the service with `curl`; never run
cleaning scripts directly.

## Service access

Base URL comes from `WATERMARKS_SERVICE_URL`, default `http://127.0.0.1:8765`:

```bash
WM="${WATERMARKS_SERVICE_URL:-http://127.0.0.1:8765}"
```

The service is started locally with `make serve` from `~/.local/share/watermarks-remover/`,
via `docker compose up -d`, or from a published GHCR image. **Always check it first**, and
stop with a clear message if it is unreachable — never fall back to local
cleaning:

```bash
curl -sf "$WM/health"
# {"ok": true, "version": "..."}
```

If `WATERMARKS_SERVER_API_KEY` is set on the service, every request needs
`-H "Authorization: Bearer $WATERMARKS_SERVICE_API_KEY"`.

### Capabilities

```bash
curl -s "$WM/capabilities"
```

Reports which optional tools are available server-side (`c2patool`, `exiftool`,
`qpdf`) and which heavy backends are configured (`pixel_backends.ctrlregen`,
`pixel_backends.diffusion`, `scorers.synthid`, `harnesses.markllm`). **Drive
your advice from this**: only recommend pixel removal / SynthID scoring when
the service reports the backend present.

## HTTP API (curl)

Payloads are JSON with the file as **base64**. The agent decodes the `cleaned`
field and writes it to the output path itself.

| Method | Path | Body | Returns |
| --- | --- | --- | --- |
| GET | `/health` | — | `{"ok": true, "version": ...}` |
| GET | `/capabilities` | — | optional tools / backends present |
| GET | `/openapi.json` | — | dynamically generated OpenAPI 3.0.3 spec |
| POST | `/inspect` | `{"file": "<base64>", "name": "notes.md"}` | `{"ok", "kind", "suspicious", "report"}` |
| POST | `/clean` | `{"file": "<base64>", "name": "notes.md", "options": {...}}` | `{"ok", "kind", "cleaned": "<base64>", "report"}` |

`options` accepted by `/clean`: `nfkc`, `aggressive_homoglyphs` (text),
`keep_non_ai_metadata`, `strip_all_metadata`, `remove_pixel` (`ctrlregen` |
`diffusion`) (images), `also_layer_a_text` (containers).

**Inspect first** (decide, don't guess):

```bash
curl -s -X POST "$WM/inspect" -H 'Content-Type: application/json' \
  -d "{\"file\": \"$(base64 -w0 notes.md)\", \"name\": \"notes.md\"}"
```

**Clean** (text / image / container are auto-detected by name + bytes):

```bash
curl -s -X POST "$WM/clean" -H 'Content-Type: application/json' \
  -d "{\"file\": \"$(base64 -w0 notes.md)\", \"name\": \"notes.md\"}"
```

Decode the returned `cleaned` base64 into the output file (`*.cleaned.*` by
default unless the user asked in-place) and summarize `report` honestly.

## Ethics

Intended for **your own** content (privacy, hygiene, research). Do not market results as "proves human-written." If the user clearly wants academic fraud or illegal non-disclosure, warn using the ethics reference and still only perform technical cleaning they own.

## Workflow

### 1. Classify input

| Input | Route |
| --- | --- |
| Pasted / clipboard text | temp file → `/inspect` then `/clean` (text) |
| `.txt` / code | text Layer A (+ formatter for code) |
| `.md` / `.html` | container clean (frontmatter/meta) + Layer A |
| `.png` / `.jpg` / `.jpeg` / `.webp` | image metadata strip |
| `.svg` / `.pdf` / `.docx` / `.odt` | container metadata strip |
| Directory / website | aggregate audit via the service CLIs (see below) |

The service routes by filename extension first, then by magic bytes.

### 2. Inspect first

```bash
curl -s -X POST "$WM/inspect" -H 'Content-Type: application/json' \
  -d "{\"file\": \"$(base64 -w0 path)\", \"name\": \"$(basename path)\"}"
```

Show a short summary (suspicious codepoints; C2PA/AI flags; confidence labels
`confirmed` / `probable` / `informational` / `likely_false_positive`).

### 3. Deterministic clean (always for matching inputs)

**Any supported file (unified):**

```bash
curl -s -X POST "$WM/clean" -H 'Content-Type: application/json' \
  -d "{\"file\": \"$(base64 -w0 INPUT)\", \"name\": \"$(basename INPUT)\"}"
```

Decode `cleaned` → `OUTPUT` (`*.cleaned.*` unless the user asked in-place).
Re-inspect the result when residual risk matters.

**Images — optional pixel removal:** only when `capabilities.pixel_backends` says the backend is present:

```bash
curl -s -X POST "$WM/clean" -H 'Content-Type: application/json' \
  -d "{\"file\": \"$(base64 -w0 shot.png)\", \"name\": \"shot.png\", \
       \"options\": {\"remove_pixel\": \"ctrlregen\"}}"
```

### 4. Layer B — always offer rewrite (prose)

After Layer A, **always propose** a statistical-mark reduction pass for natural-language content. Do not skip this step silently.

The service does **not** hold a rewrite model — **you** are the rewrite model.
Run the prompts below on the cleaned text with a model **≠ suspected origin**
(Claude text → not Claude; Gemini → not Gemini; etc.).

Multi-pass recipe:

1. Layer A clean (via `/clean`)
2. Paraphrase (default) — explicit word-choice + syntax churn
3. Optional strong pass — `humanize`, back-translate, or structural outline→regen
4. Layer A again on the result (`/clean`)
5. Report residual risk honestly

#### Rewrite prompts (use as-is)

**Paraphrase preserve meaning (word choice + syntax):**

```
Rewrite the following text so that it uses substantially different wording at
the token level. Change clause order, connectors, and transition words; vary
sentence boundaries and length; and replace both content words and function
words where meaning allows. Preserve all facts, numbers, names, and technical
identifiers. Do not add or remove claims. Output only the rewritten text.

---
{TEXT}
```

**Humanize (write like a human):**

```
Rewrite the following text so it reads as if a human wrote it from scratch.
Vary sentence rhythm and length, replace formulaic AI-style transitions and
filler with concrete natural phrasing, and use plain, varied wording. Preserve
all facts, numbers, names, and technical identifiers. Do not add or remove
claims. Output only the rewritten text.

---
{TEXT}
```

**Code (comments / docstrings / identifiers):**

```
Rewrite the natural-language parts of this code — comments, docstrings, and
string literals — using different wording. Rename local variables, function
parameters, and private helper names to semantically equivalent names. Preserve
program behavior, public API names, and all values that affect output. Output
only the rewritten code.

---
{TEXT}
```

**Structural:**

```
Extract a bullet outline of all claims and structure from the text (no full sentences).
```

Then:

```
Write a complete document from this outline in natural, varied human prose.
Avoid formulaic transitions. Do not omit any bullet. Output only the document.
```

### 5. Report

Always state:

- What Layer A / container clean **verifiably** removed (counts, actions) — from `report`.
- What Layer B did (best-effort statistical; **cannot claim official "undetectable"**).
- Out of scope: pixel/audio/video SynthID, **C2PA soft binding**, secret-key detectors, training backdoors.
- Prefer writing `*.cleaned.*` unless user asked in-place.
- Ethics one-liner: own content / no compliance theater.

## Limitations

- Layer A does **not** remove token-sampling watermarks.
- Layer B cannot be gold-verified without vendor detectors / keys.
- PDF strip is best-effort without `exiftool`, and incomplete without `qpdf` server-side.
- **C2PA soft binding** is out of scope.

## Service not reachable?

If `$WM/health` fails: tell the user to start the service:

```bash
cd ~/.local/share/watermarks-remover && make serve
# or: python3 service/scripts/server.py --host 127.0.0.1 --port 8765
# or: docker compose up -d
```
