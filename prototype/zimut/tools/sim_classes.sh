#!/bin/bash
# Simulation d'équilibrage par classe : chaque classe est testée dans une équipe type (Tank/Heal en soutien).
# Usage : tools/sim_classes.sh <godot> [niveau] [n combats] [sortie]
G="${1:?chemin de godot}"; LVL="${2:-30}"; N="${3:-4}"; OUT="${4:-/tmp/sim_classes.txt}"
: > "$OUT"
run() {
  c="$1"; sup="Tank,Heal"
  [ "$c" = "Tank" ] && sup="Mage,Heal"; [ "$c" = "Heal" ] && sup="Tank,Mage"
  r=$(timeout 900 xvfb-run -a "$G" --headless --path . -s tests/sim_balance.gd -- 10 "$LVL" "$N" x "$c,$sup" 2>&1 | grep "RÉSUMÉ")
  echo "$c : $r" >> "$OUT"
}
export -f run; export G LVL N OUT
printf '%s\n' Tank Mage Heal Assassin Chasseur Druide Invocateur Sylvain Géomancien Artificier | xargs -P 3 -I{} bash -c 'run {}'
