# Plan — `website-taste` skill (v0.3.0)

**Goal:** when Provenship builds or redesigns a product's marketing site or landing page, it loads a
process skill that makes the site feel engineered for *that* product (reference teardown → brand-led
taste → code-drawn product → honest claims → screenshot loop), instead of a template.

**Scope gate:** Small. The requirement is the user's own written rules (it is the spec), the change is
markdown + one Bash script, and it touches no risk-list area. Short plan + one self-review, no
brainstorm, no `/autoplan`.

## Assumptions

- Source rules came from one product's site; every product-specific noun (names, colours, widget
  subjects, chip copy) becomes a rule for *deriving* that thing from the current product's brief.
- The user's explicit preferences stay as defaults, not hard-codes: fish.audio voice "Hannah",
  -16 LUFS, Gemini-through-`agy` for illustrations. Each is overridable per project.
- "Polished" (the user's voice-effects reference) was not found on disk or on the web. The skill
  routes voice polish to the user's own skill when one is named, else to installed audio skills,
  else to a plain ffmpeg chain. Flag this to the user.
- Music/SFX: use Claude skills already present when available (`media-use` for BGM/SFX/voice
  sourcing, `hyperframes-audio` for ducking/EQ/compression); community alternatives listed, not bundled.
- First-party skill (like `skills/update`), not vendored. `sync-vendored.sh` only touches named
  vendored dirs, so it is safe.

## Tasks

| # | File | Change | Check |
|---|---|---|---|
| 1 | `skills/website-taste/SKILL.md` | New skill: triggers-only description; product brief; teardown; brand taste; showcase stage; code-drawn product; pattern menu; illustrations; motion; honesty gate; perf/a11y/SEO budget (new); dashboards override; screenshot loop; optional video + audio | lint 2 + 5 |
| 2 | `skills/website-taste/claims-check.sh` | Generic honesty gate: built-in rules + project `.claims-check` overrides (extra banned phrases, allowed raster dirs, stale status words) | `bash -n`; run on a fixture |
| 3 | `skills/provenship/SKILL.md` | Route landing/marketing-site work to `provenship:website-taste` in Phase 1/2 (teardown feeds the plan), Phase 3 (build rules), Phase 5 (screenshot loop + claims check); add to skill references + preflight | lint 2 |
| 4 | `scripts/lint.sh` | Personal-reference check also covers `skills/website-taste`; `bash -n` the claims script | lint passes |
| 5 | `README.md`, `CLAUDE.md`, `CHANGELOG.md` | Document the skill; first-party list; 0.3.0 entry | read |
| 6 | 3 manifests | 0.2.3 → 0.3.0 | lint 4 |
| 7 | release | PR → merge → tag `v0.3.0` → GitHub release → `claude plugin marketplace update` + `claude plugin update` locally | installed version shows 0.3.0 |

## Additions beyond the source rules (why)

- **Product brief first** — the generic replacement for every hard-coded noun: category, buyer,
  the one job, proof you may cite, live vs coming capabilities, brand assets. Everything later reads it.
- **Performance, accessibility and SEO budget** — premium dies on a janky LCP or a marquee a keyboard
  can't pause. LCP, CLS, contrast, focus, reduced motion, meta/OG.
- **Copy rules + slop-word check** — generic AI copy ("seamless", "unlock") reads as template as fast
  as a stock gradient does; the claims script flags it.
- **Shipped `claims-check.sh`** — the honesty gate becomes runnable, not a reminder.

## Self-review

- Every task traces to the goal or to the release request. No speculative config beyond the one
  overrides file the gate needs to stay generic.
- No product names, people or personal paths left in the new skill (lint enforces).
- Description is triggers-only (repo rule for discipline skills).
