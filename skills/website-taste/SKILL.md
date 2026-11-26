---
name: website-taste
description: Use when creating or redesigning a product's marketing site, landing page, homepage or a marketing section, or when asked to make a site "look premium", "look better" or "less like a template". Also use when a product dashboard's visual layout is being designed.
---

# Website taste

The goal is a site that feels engineered for **this** product, not assembled from a template. Every
site gets its own taste, built from its own brand and a reference teardown. This skill is the
**process**; the visual-direction skill (`untaste` when available, else `provenship:frontend-design`)
still owns the look. Load that one too, once, for the build.

Nothing here is product-specific. Every product noun (colours, widgets, chip copy, illustration
subjects) is **derived from the product brief** in step 0. If a rule seems to need a fact you don't
have, it goes in the brief as an open question, not a guess.

## When to use

- New marketing site, landing page, product homepage, section redesign, "make it look better".
- Dashboards: jump to **Dashboards** below. It overrides the stage, widget, illustration and motion rules.
- Skip for app UI inside a logged-in product (use the project design system) and copy-only edits.

## 0. Product brief (before anything else)

Write `docs/plans/<date>-<product>-site-brief.md`, short, from the repo, README, existing site and
the user. Ask once, batched, for what you can't find. It holds:

- **Product:** category, buyer and user (often different), the one job it does, the moment it pays off.
- **Capabilities, each with a status:** `Live` / `In the demo` / `Coming next`. This list gates every
  claim and every widget later.
- **Proof you may cite:** numbers, logos, quotes, certifications, with permission noted. Empty is fine.
- **Brand assets:** name, logo, ground colour, accent, fonts, voice, existing illustrations.
- **References:** 1–2 best-in-class competitors or admired sites. Ask if none are named.
- **Taboos:** words, claims or competitor features that must not appear.

## 1. Reference teardown (before designing)

- Run a section-by-section teardown of each reference in parallel subagents (homepage, then key
  subpages), with gstack `/browse` screenshots of every section at 1440 and 390 wide. Give each
  parallel agent its own `BROWSE_STATE_FILE`.
- Per section record: verbatim headline, visual type (UI mock, illustration, logos, stats), motion
  (trigger and style), proof used, layout pattern.
- End with a **top 10 things that make it feel mature** list and a gap table:
  `theirs | ours | gap | recommendation`.
- **Borrow structure, never look.** Structure: proof before product, a pinned product tour, an
  integrations hub, numbered steps, time to value. Never copy colours, fonts, copy, illustrations or
  signature objects.
- Output `docs/plans/<date>-<reference>-gap-report.md`, grouped into **waves**. The user picks the
  waves (autonomous run: take wave 1, log the choice). Feeds Phase 2 of the plan.

## 2. Taste comes from the brand

- Keep the brand's own ground colour if it is distinctive; a warm or tinted ground usually beats
  default blue-white. Don't swap it on taste alone.
- **Brand changes are tested, not asserted.** Build gated variants (`html[data-exp="…"]` in one
  `experiments.css`), screenshot them side by side, give an honest opinion. Ship nothing that changes
  ground, accent, fonts or voice until the user says go.
- Glass only where there is colour behind it: a frosted sticky header (~80% opaque) and chips on dark
  stages. Frosted cards on light, flat sections look washed out.
- Type: one display face (a serif reads premium for most B2B; pick what fits the brand) plus one sans,
  at most one mono for kickers. One accent colour.
- **Copy:** specific over grand. Name the job, the user and the outcome in the product's own nouns.
  No slop words (seamless, leverage, unlock, revolutionize, cutting-edge, supercharge, game-changing).
  No em dashes in site copy.

## 3. The showcase stage (one reusable backdrop)

Build one `StageBackdrop` component and reuse it behind every showcase section, tinted from the brand:

- a deep radial gradient in a dark shade of the brand (navy, ink, forest…);
- two slowly drifting blurred orbs in brand-adjacent colours;
- a panning dot grid faded with a mask;
- slow rotating orbit lines plus one dashed ring;
- a faint conic light sweep.

White product cards read clearly on it; this one change fixes most "cards blend into the background"
complaints. Small glass chips at the stage corners, bobbing gently, state the product's sharpest
promises in 2–4 words each, taken from the brief's **Live** capabilities only.

## 4. Draw the product in code

- Public pages: **no real product screenshots** (they go stale and competitors copy them). Build small
  product widgets in code on sample data, one per key capability in the brief. Choose the moment that
  shows the job being done: a number changing, a match lining up, a gate unlocking, a form filling,
  an approval chain advancing, a score converging.
- Each widget is a white card: title, one context line, a **"Sample data"** chip. Its entrance
  animates when its `.reveal` root gains `.is-visible`. Every widget has a complete final state with
  no JS and with reduced motion.
- Draw a status-labelled mock only for **Live** capabilities. `Coming next` stays out of hero moments.
- Real screenshots only in sales-only assets (decks, sales video), kept out of git.

## 5. Pattern menu (pick what the brief needs)

| Pattern | Use for |
|---|---|
| Sticky scroll tour: copy scrolls left, widget swaps on a pinned stage, progress bar per item | Modules or features (usually the biggest single upgrade) |
| Alternating split cards (copy + widget), each widget on a mini stage | "Your week with X", feature blocks |
| Phone stage: message on a phone, tap animation, result stamp, a timeline that draws | Any mobile or one-tap moment |
| Integrations orbit: logo at centre, tool nodes orbiting, live links with flowing dashes, planned ones dashed and dim | Integrations, honest status per item |
| Coverage span chart: product rows with bars across lifecycle stages, bars grow on scroll | Comparison sections |
| Before/after converge: messy sources (with counts) flow along lines into one record card | Problem → solution |
| Measured SVG connectors: measure positions with `ResizeObserver`, draw in real pixels | Any line joining two elements. Never stretch a fixed viewBox |
| Marquee: icon chips on an endless strip that pauses on hover and focus | Long lists of industries or audiences |
| Hero: status badge + trust list (from the brief: e.g. data region, no login needed) + a light motion backdrop behind the product | Hero |
| Footer: demo card, balanced columns built from nav data, region tags, wordmark with a light sweep | Footer |

## 6. Illustrations (only if the brand uses them)

- One fixed **style preamble** per brand, written once into the brief: line weight, a single accent
  colour, background, and "no text, no logos, no faces, no UI screens". Subjects come from the
  product's world.
- Default generator, if the user has it: Gemini through Antigravity,
  `agy -p "<STYLE PREAMBLE> + <subject>" --model <current Gemini image model> --dangerously-skip-permissions --add-dir <dir>`.
  End the prompt with: "Generate the image with your image generation tool (if you use the
  image-generator subagent, WAIT for it to finish before ending your turn)". Without it, `agy` exits
  before the image exists. Any other image generator the user names works the same way.
- **Quota guard:** on a quota error the generator may silently draw a substitute in code. Detect
  `error generating image`, `ResourceExhausted`, or a stray SVG, and publish nothing for that job.
  Quotas are often shared across models and reset after hours: batch 3 at a time, queue the rest in a
  jobs file.
- Review every image by eye on a contact sheet (e.g. ImageMagick `montage`). Publish as WebP to
  `public/illustrations/` with a README manifest of prompts. Ship a code-drawn icon-scene fallback so
  a missing file never shows an empty box.

## 7. Motion rules

- CSS first: `IntersectionObserver` reveals, `animation-timeline: view()` behind `@supports`, sticky
  positioning, SVG `animateMotion`. No animation library unless the project already has one or the
  user asks.
- Every animation has a `prefers-reduced-motion` final state. Content is complete without JS: hide
  pre-entrance states only under a `.js-reveal` class that JS sets.
- Replayable entrances: key everything off `.is-visible` on the widget root so a tour can remove and
  re-add it.

## 8. Honesty gate (every wave)

Run `claims-check.sh` (next to this file) from the site's root: `bash <this-dir>/claims-check.sh [dir]`.
It fails on certification claims, ROI or customer-result claims, em dashes in copy, internal
epic/phase/ticket numbers, raster files outside allowed folders, and slop words. Per-project rules
(competitor features, stale status words like "pre-launch" after launch, extra allowed folders) go in
a `.claims-check` file at the site root; the script prints its format with `--help`.

Status is per capability (`Live` / `In the demo` / `Coming next`). Check every new page and widget
against the brief. A claim with permission can be allow-listed in `.claims-check`, with the reason.

## 9. Performance, accessibility, SEO (every wave)

Premium dies on a janky first paint. Budget, measured on the built site (gstack `/benchmark` or
Lighthouse):

- LCP < 2.5 s, CLS < 0.1, INP < 200 ms on mobile. Backdrops are CSS/SVG, not video. Illustrations
  lazy-load below the fold; the hero has no layout shift from entrance animations.
- Contrast AA on every stage (including chips over orbs), visible focus, the tour and marquee usable
  by keyboard, the marquee pausable, decorative SVG `aria-hidden`.
- Title, meta description, Open Graph image per page, one `h1`, semantic landmarks.

## 10. The quality loop (every section)

1. Build the change.
2. Screenshot in a real browser at 1440×900 and 390×844 (gstack `/browse`).
3. Read every screenshot yourself.
4. Fix overlap, contrast, blending, cut-off text, misaligned lines; screenshot again. 2–3 rounds is normal.
5. Check: no horizontal overflow, no console errors, typecheck and build pass, claims check passes,
   budget holds.
6. Show before/after screenshots to the user. Anything that changes the brand goes to the user first.

## Dashboards (overrides sections 3–6)

- Visual reference: BoardUI (boardui.com) patterns. It is React-only: on other stacks borrow patterns,
  install nothing. Never copy paid template source.
- Load `dashboard-design` and `dataviz` skills when available, before any chart, KPI tile or layout.
  Use the project's design-system tokens.
- Data first: chart type from the dataviz form heuristics, validated palette, labelled axes and units,
  an empty and a loading state for every widget.
- Motion: subtle only. Number tweens on first load, chart draw-in once. No backdrops, orbits, marquees.
- No illustrations inside data views; one is allowed in an empty state.
- Real data or clearly labelled sample data. Never invent metrics.
- QA at 1440 and 1280 wide, plus a dense-data and an empty-data case. Check overflow, truncation and
  table scroll on mobile.

## Optional: product intro video (only when asked)

- **Stack:** Remotion or HyperFrames (whichever the project or installed skills support; the
  `hyperframes` skills cover render, animation and audio) in a `video/` folder kept out of the site
  build. Public cut: code-drawn UI. Sales cut: real screenshots, kept out of git.
- **Script:** draft it, get a critique from a second model (e.g. Gemini), merge. Short, punchy lines,
  ~125–145 words per 60 s, built from the brief's job and proof.
- **Voice:** fish.audio, licensed voices only (`licensed=true`). Default voice **Hannah** unless the
  user or brand names another. Use the most expressive model available with plain-language direction
  per line. One clip per scene; time scenes to clips. Verify with speech-to-text that direction tags
  were not read aloud; use word timestamps to sync animations and effects.
- **Music and sound effects:** use a Claude skill, in this order: one the user names; `media-use`
  (music bed and SFX, catalogue or generated) with `hyperframes-audio` for mixing; otherwise a
  community audio skill (MusicGen/AudioCraft locally, or an ElevenLabs SFX skill). Check licences.
- **Voice polish:** the user's own voice-processing skill if they have one; else `hyperframes-audio`;
  else an ffmpeg chain. Chain: EQ → de-esser → compressor → light room sound.
- **Mix:** music bed ducks under the voice; word-timed effects (whoosh on scene change, pop when a line
  lands, build-up into an impact on the logo); loudness -16 LUFS integrated (override per platform).
- Send a sample audio file for approval **before** re-rendering the video.

## Common mistakes

- Designing before the brief and teardown exist, so the site inherits a template's taste.
- Copying a reference's look (colours, fonts, signature object) instead of its structure.
- Frosted glass on flat light sections; product cards on a background that eats them.
- A widget or chip for a `Coming next` capability in a hero moment.
- Animations with no reduced-motion or no-JS final state; hidden content when JS fails.
- Shipping a brand change (ground, accent, fonts, voice) without user sign-off.
- Skipping the claims check because "the copy looked fine".
