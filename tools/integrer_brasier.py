#!/usr/bin/env python3
"""Intègre les planches Mistral de la Nation Brasier (essai V44) : découpe, échelle commune, doublons écartés.
Usage : integrer_brasier.py <dossier_planches_découpées> <racine assets/sprites>
(les planches sont d'abord découpées par couper_planche.py ; la table ci-dessous dit quelle case devient quelle pose)."""
import os, sys, glob, numpy as np
from PIL import Image

SRC, DST = sys.argv[1], sys.argv[2]
H = 'chasseur'
# personnage -> (hauteur cible d'une pose de repos, dossier de sortie, {pose: (planche, case)})
CHARS = {
 'chasseur': (300, 'players', {
   '': ('h4', 'r1c2'), '_idle_2': ('h4', 'r1c1'), '_idle_3': ('h4', 'r2c2'), '_walk': ('h4', 'r1c3'),
   '_attack': ('h3', 'r1c1'), '_attack_2': ('h3', 'r1c2'), '_attack_3': ('h3', 'r2c1'), '_cast': ('h3', 'r2c3'),
   '_back': ('h4', 'r1c4'), '_back_idle_2': ('h4', 'r2c4')}),
 'salamandre': (235, 'nations/ennemis/brasier', {
   '': ('sa1', 'r1c2'), '_idle_2': ('sa1', 'r2c2'), '_idle_3': ('sa2', 'r1c2'), '_walk': ('sa1', 'r1c1'),
   '_attack': ('sa2', 'r1c3'), '_attack_2': ('sa1', 'r2c3'), '_attack_3': ('sa2', 'r2c1'), '_cast': ('sa2', 'r2c3')}),
 'devoreur_de_flammes': (330, 'nations/ennemis/brasier', {
   '': ('de2', 'r1c2'), '_idle_2': ('de2', 'r2c2'), '_idle_3': ('de2', 'r1c3'), '_walk': ('de1', 'r1c2'),
   '_attack': ('de2', 'r1c1'), '_attack_2': ('de2', 'r2c1'), '_attack_3': ('de1', 'r1c1'), '_cast': ('de2', 'r2c3')}),
 'golem_de_lave': (295, 'nations/ennemis/brasier', {
   '': ('go2', 'r1c2'), '_idle_2': ('go2', 'r1c3'), '_idle_3': ('go1', 'r1c2'), '_walk': ('go1', 'r1c1'),
   '_attack': ('go2', 'r1c1'), '_attack_2': ('go2', 'r2c1'), '_attack_3': ('go2', 'r2c3'), '_cast': ('go2', 'r2c2')}),
 'lieutenant': (285, 'nations/ennemis/brasier', {
   '': ('k1', 'r1c2'), '_idle_2': ('k1', 'r1c1'), '_idle_3': ('k1', 'r2c2'), '_walk': ('k1', 'r2c1'),
   '_attack': ('k3', 'r1c1'), '_attack_2': ('k3', 'r1c2'), '_attack_3': ('k3', 'r2c1'), '_attack_4': ('k3', 'r2c2'),
   '_cast': ('k3', 'r1c3'), '_cast_2': ('k3', 'r2c3'), '_back': ('k1', 'r1c3'), '_back_idle_2': ('k1', 'r2c3')}),
 'brasier': (340, 'nations/boss', {
   '': ('k2', 'r1c1'), '_idle_2': ('k2', 'r2c1'), '_back': ('k2', 'r1c2'), '_back_idle_2': ('k2', 'r2c2')}),
}

def load(sheet, cell):
    return Image.open(os.path.join(SRC, sheet, f'{sheet}_{cell}.png')).convert('RGBA')

def median_h(sheet):
    hs = [Image.open(f).size[1] for f in glob.glob(os.path.join(SRC, sheet, f'{sheet}_r*.png'))]
    return float(np.median(hs))

def sig(im):
    t = im.resize((32, 32)); a = np.array(t).astype(float)
    return np.dstack([a[..., 3] / 255, a[..., :3].mean(-1) / 255 * (a[..., 3] > 0)])

report = []
for name, (target, folder, poses) in CHARS.items():
    kept, sigs = {}, []
    for pose, (sheet, cell) in poses.items():
        im = load(sheet, cell)
        s = target / median_h(sheet)
        im = im.resize((max(1, round(im.width * s)), max(1, round(im.height * s))), Image.LANCZOS)
        sg = sig(im)
        if any(np.abs(sg - o).mean() < 0.05 for o in sigs):
            report.append(f'{name}{pose}: doublon écarté'); continue
        sigs.append(sg); kept[pose] = im
    outdirs = [os.path.join(DST, folder)]
    if folder == 'players':
        outdirs += [os.path.join(DST, 'nations/heros'), os.path.join(DST, 'nations/heros/poses')]
    # nettoyage des anciennes poses du personnage
    for d in outdirs:
        for f in glob.glob(os.path.join(d, name + '*.png*')):
            if os.path.basename(f).startswith(name + '_') or os.path.basename(f).startswith(name + '.png'):
                os.remove(f)
    for pose, im in kept.items():
        fn = name + pose + '.png'
        if folder == 'players':
            im.save(os.path.join(DST, 'players', fn))
            if pose == '':
                im.save(os.path.join(DST, 'nations/heros', fn))
            else:
                im.save(os.path.join(DST, 'nations/heros/poses', fn))
        else:
            im.save(os.path.join(DST, folder, fn))
    report.append(f'{name}: {len(kept)} poses ({", ".join(p or "repos" for p in kept)})')
print('\n'.join(report))
