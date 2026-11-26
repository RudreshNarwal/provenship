#!/usr/bin/env bash
# claims-check.sh: honesty gate for a marketing site. Exit 1 on any hit.
# Usage: bash claims-check.sh [site-root]     (default: current directory)
# Grep heuristics, so false positives are expected; silence them with `allow` lines.
set -euo pipefail

if [ "${1:-}" = "-h" ] || [ "${1:-}" = "--help" ]; then
  cat <<'EOF'
claims-check.sh [site-root]

Scans site copy (html, md, mdx, vue, tsx, jsx, ts, js, astro, svelte, json, yml) for:
certification claims, ROI / customer-result claims, em dashes, internal epic/phase/sprint
numbers, slop words, and raster images outside allowed folders.

Per-project rules: a `.claims-check` file at the site root, one directive per line:
  deny <label>|<regex>   extra rule, e.g.  deny stale status|pre-launch|coming soon
                                           deny competitor feature|reverse auction
  allow <regex>          drop hits whose "file:line:text" matches (say why in a # comment)
  raster-dir <path>      another folder (relative to root) where png/jpg/gif/webp/avif may live
Lines starting with # are comments. Regexes are grep -E, case-insensitive.
Default raster folders: public/illustrations public/og public/brand; favicon*, apple-touch-icon*
and og-image* files are allowed anywhere.
EOF
  exit 0
fi

ROOT="${1:-.}"
CONF="$ROOT/.claims-check"
SKIP_DIRS=(node_modules .git dist build .next .nuxt .output .vercel coverage docs video)

rules=(
  "certification claim|\b(SOC ?2|ISO ?27001|HIPAA[- ]compliant|GDPR[- ]compliant|PCI[- ]DSS|FedRAMP|certified)\b"
  "ROI / customer result|\b[0-9]+(\.[0-9]+)? ?(%|x) (faster|cheaper|less|more|fewer|reduction|savings|increase|ROI)\b|\bROI\b|\bsaved? \\\$[0-9]"
  "em dash in copy|—"
  "internal epic/phase/sprint number|\b(epic|phase|sprint|wave) ?[0-9]+\b"
  "slop word|\b(seamless(ly)?|leverag(e|es|ing)|unlock(s|ing)?|revolutioni[sz](e|es|ing)|cutting-edge|supercharg(e|es|ed)|game-chang(er|ing)|next-gen(eration)?|best-in-class|world-class|synerg(y|ies))\b"
)
allows=()
raster_dirs=(public/illustrations public/og public/brand)

if [ -f "$CONF" ]; then
  while IFS= read -r line || [ -n "$line" ]; do
    case "$line" in
      ''|'#'*) ;;
      deny\ *) rules+=("${line#deny }") ;;
      allow\ *) allows+=("${line#allow }") ;;
      raster-dir\ *) raster_dirs+=("${line#raster-dir }") ;;
      *) echo "claims-check: ignoring unknown directive: $line" >&2 ;;
    esac
  done < "$CONF"
fi

grep_args=(-rEIni)
for d in "${SKIP_DIRS[@]}"; do grep_args+=("--exclude-dir=$d"); done
for e in html md mdx vue tsx jsx ts js astro svelte json yml yaml; do grep_args+=("--include=*.$e"); done
grep_args+=("--exclude=*lock*" "--exclude=claims-check.sh")

drop_allowed() {
  if [ "${#allows[@]}" -eq 0 ]; then cat; return; fi
  local a=()
  for p in "${allows[@]}"; do a+=(-e "$p"); done
  grep -Eiv "${a[@]}" || true
}

fail=0
for rule in "${rules[@]}"; do
  label="${rule%%|*}"; regex="${rule#*|}"
  hits="$(grep "${grep_args[@]}" -e "$regex" "$ROOT" 2>/dev/null | drop_allowed || true)"
  if [ -n "$hits" ]; then
    echo "FAIL [$label]"; echo "$hits" | sed 's/^/  /'; fail=1
  fi
done

prune=()
for d in "${SKIP_DIRS[@]}"; do prune+=(-name "$d" -o); done
rasters="$(find "$ROOT" \( "${prune[@]}" -false \) -prune -o -type f \
  \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.gif' -o -iname '*.webp' -o -iname '*.avif' \) \
  ! -iname 'favicon*' ! -iname 'apple-touch-icon*' ! -iname 'og-image*' -print)"
bad_rasters=""
while IFS= read -r f; do
  [ -z "$f" ] && continue
  rel="${f#"$ROOT"/}"; ok=0
  for d in "${raster_dirs[@]}"; do case "$rel" in "$d"/*) ok=1 ;; esac; done
  [ "$ok" -eq 0 ] && bad_rasters+="  $rel"$'\n'
done <<< "$rasters"
if [ -n "$bad_rasters" ]; then
  echo "FAIL [raster outside allowed folders: ${raster_dirs[*]}]"; printf '%s' "$bad_rasters"; fail=1
fi

[ "$fail" -eq 0 ] && echo "claims-check: OK" || echo "claims-check: FAILED (run with --help to allow a hit with a reason)"
exit "$fail"
