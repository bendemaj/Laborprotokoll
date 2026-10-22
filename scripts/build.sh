#!/bin/sh
# Funktioniert auch mit Leerzeichen im Projektpfad und ohne VS-Code-PATH.
set -eu
project_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
cd "$project_dir"
mkdir -p build
export PATH="/Library/TeX/texbin:/opt/homebrew/bin:/usr/local/bin:$PATH"
if [ -x "$project_dir/.tools/tectonic" ]; then
  compiler="$project_dir/.tools/tectonic"
elif command -v tectonic >/dev/null 2>&1; then
  compiler=tectonic
elif command -v latexmk >/dev/null 2>&1; then
  exec latexmk -pdf -synctex=1 -interaction=nonstopmode -halt-on-error -outdir=build main.tex
else
  printf '%s\n' 'Kein LaTeX-Compiler gefunden. Siehe README.md (Tectonic oder MacTeX installieren).' >&2
  exit 1
fi
# Paketcache bleibt im Projekt; erster Lauf benötigt Internetzugang.
export TECTONIC_CACHE_DIR="$project_dir/.tools/cache"
exec "$compiler" --synctex --keep-logs --keep-intermediates --outdir build main.tex
