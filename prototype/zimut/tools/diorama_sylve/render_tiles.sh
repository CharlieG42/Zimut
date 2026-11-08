#!/bin/bash
# Rendu par tuiles 2x2 (5120x2880 chacune) des passes beauty / depth / normal / id.
# WORK = dossier de travail (objects.json, height2.png, ground4k.png, colormap_warm.png) ; MODES = passes à rendre.
WORK=${WORK:-$DIORAMA_WORK}
export DIORAMA_WORK=$WORK
cd "$(dirname "$0")/../.."
for m in ${MODES:-beauty depth normal}; do for ty in 0 1; do for tx in 0 1; do
  timeout 900 xvfb-run -a -s "-screen 0 1920x1080x24" godot --rendering-method gl_compatibility --path . -s $WORK/scene.gd -- $m $WORK/${m}_${tx}_${ty}.png 5120 2880 2 $tx $ty > /dev/null 2>&1
  echo "$m $tx $ty $(date +%T) $(ls -s $WORK/${m}_${tx}_${ty}.png 2>/dev/null | cut -d' ' -f1)"
done; done; done
echo FIN
