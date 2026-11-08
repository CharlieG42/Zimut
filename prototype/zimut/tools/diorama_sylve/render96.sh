#!/bin/bash
# Rendu des passes (beauty / depth / normal / id) en 4x4 tuiles de 5120x2880 -> $DIORAMA_WORK/render/
# Usage : DIORAMA_WORK=<dossier> [MODES="beauty depth"] ./render96.sh
export DIORAMA_WORK=${DIORAMA_WORK:?dossier de travail}
mkdir -p "$DIORAMA_WORK/render"
cd "$(dirname "$0")/../.."
for m in ${MODES:-beauty depth normal id}; do
  timeout 3000 xvfb-run -a -s "-screen 0 1920x1080x24" godot --rendering-method gl_compatibility --path . \
    -s tools/diorama_sylve/scene96.gd -- $m "$DIORAMA_WORK/render" 5120 2880 4 > "$DIORAMA_WORK/render_$m.log" 2>&1
  echo "$m : $(ls "$DIORAMA_WORK"/render/${m}_*.png 2>/dev/null | wc -l) tuiles"
done
