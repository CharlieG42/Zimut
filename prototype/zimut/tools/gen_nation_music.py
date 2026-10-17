#!/usr/bin/env python3
"""Génère les boucles musicales des 6 nations (combat + exploration) par synthèse additive.

Sortie : assets/audio/nation_<id>_combat.ogg / nation_<id>_explore.ogg (boucles sans couture :
tout est calé sur la durée de la boucle, la réverbération est circulaire).
Dépendances : numpy, scipy, ffmpeg (libvorbis).
"""
import os
import subprocess
import sys
import tempfile

import numpy as np
from scipy.io import wavfile

SR = 44100
OUT = os.path.join(os.path.dirname(__file__), "..", "assets", "audio")

# id : racine MIDI, gamme (demi-tons), progression (degrés en demi-tons + qualité), bpm combat/explo, timbres
NATIONS = {
    "cristaux": dict(root=62, scale=[0, 2, 4, 6, 7, 9, 11], prog=[(0, [0, 4, 7, 11]), (2, [0, 4, 7]), (11, [0, 3, 7, 10]), (7, [0, 4, 7, 11])],
                     bpm=(104, 72), lead="bell", pad="pad", drums="soft", extra=None),
    "marees": dict(root=57, scale=[0, 2, 3, 5, 7, 9, 10], prog=[(0, [0, 3, 7, 10]), (5, [0, 4, 7]), (10, [0, 4, 7, 11]), (3, [0, 4, 7, 11])],
                   bpm=(92, 66), lead="pluck", pad="pad", drums="soft", extra="waves"),
    "vents": dict(root=55, scale=[0, 2, 4, 7, 9], prog=[(0, [0, 7, 14]), (5, [0, 7, 14]), (7, [0, 7, 12]), (0, [0, 7, 14])],
                  bpm=(112, 78), lead="flute", pad="airy", drums="frame", extra="wind"),
    "brasier": dict(root=52, scale=[0, 1, 4, 5, 7, 8, 10], prog=[(0, [0, 3, 7]), (1, [0, 4, 7]), (0, [0, 3, 7]), (10, [0, 4, 7])],
                    bpm=(124, 70), lead="pluck", pad="drone", drums="heavy", extra="rumble"),
    "brumes": dict(root=48, scale=[0, 2, 4, 6, 8, 10], prog=[(0, [0, 3, 7, 14]), (8, [0, 4, 7]), (5, [0, 3, 7, 10]), (7, [0, 4, 7])],
                   bpm=(84, 60), lead="bell", pad="pad", drums="sparse", extra="fog"),
    "ombres": dict(root=54, scale=[0, 2, 3, 5, 7, 8, 10], prog=[(0, [0, 3, 7]), (8, [0, 4, 7]), (3, [0, 4, 7]), (10, [0, 4, 7])],
                   bpm=(86, 62), lead="choir", pad="choir", drums="heavy", extra=None),
}


def hz(m):
    return 440.0 * 2 ** ((m - 69) / 12.0)


def add(buf, start, sig):
    """Mélange `sig` à partir de `start` en bouclant (la queue des notes revient au début)."""
    n = len(buf)
    start = int(start) % n
    end = start + len(sig)
    if end <= n:
        buf[start:end] += sig
    else:
        k = n - start
        buf[start:] += sig[:k]
        rest = sig[k:]
        while len(rest) > 0:
            m = min(len(rest), n)
            buf[:m] += rest[:m]
            rest = rest[m:]


def env(n, a, r, curve=1.0):
    e = np.ones(n)
    na = max(1, int(a * SR))
    nr = max(1, int(r * SR))
    e[:na] = np.linspace(0, 1, na) ** curve
    e[-nr:] *= np.linspace(1, 0, nr)
    return e


def t_arr(dur):
    return np.arange(int(dur * SR)) / SR


def pad_note(m, dur, kind):
    t = t_arr(dur + 1.5)
    f = hz(m)
    sig = np.zeros_like(t)
    if kind in ("pad", "airy"):
        for det in (-0.004, 0.0, 0.004):
            for k, w in ((1, 1.0), (2, 0.45), (3, 0.25), (4, 0.12)):
                sig += w * np.sin(2 * np.pi * f * (1 + det) * k * t + det * 40)
        if kind == "airy":
            sig *= 0.7
    elif kind == "drone":
        for k, w in ((1, 1.0), (2, 0.6), (3, 0.5), (4, 0.4), (5, 0.3), (6, 0.2)):
            sig += w * np.sin(2 * np.pi * f * k * t)
    elif kind == "choir":
        # voyelle « a » : formants ~ 700 et 1150 Hz
        vib = 1 + 0.004 * np.sin(2 * np.pi * 5.2 * t)
        for det in (-0.006, 0.0, 0.006):
            for k in range(1, 22):
                fk = f * k
                g = np.exp(-((fk - 700) / 220) ** 2) + 0.6 * np.exp(-((fk - 1150) / 260) ** 2) + 0.15 / k
                sig += g * np.sin(2 * np.pi * fk * (1 + det) * vib * t) / (k ** 0.3)
    sig *= env(len(t), 1.1, 1.4)
    sig *= 0.85 + 0.15 * np.sin(2 * np.pi * 0.3 * t)
    return sig / 5.0


def bell_note(m, dur=2.5):
    t = t_arr(dur)
    f = hz(m)
    idx = 2.2 * np.exp(-2.5 * t)
    sig = np.sin(2 * np.pi * f * t + idx * np.sin(2 * np.pi * f * 3.5 * t)) * np.exp(-1.6 * t)
    sig += 0.3 * np.sin(2 * np.pi * f * 2.0 * t) * np.exp(-3.0 * t)
    return sig * env(len(t), 0.003, 0.2) * 0.45


def pluck_note(m, dur=1.4):
    t = t_arr(dur)
    f = hz(m)
    sig = np.zeros_like(t)
    for k in range(1, 8):
        sig += np.sin(2 * np.pi * f * k * t) / k * np.exp(-t * (2.5 + 2.2 * k))
    return sig * env(len(t), 0.004, 0.15) * 0.55


def flute_note(m, dur):
    t = t_arr(dur + 0.3)
    f = hz(m)
    vib = np.sin(2 * np.pi * 5.0 * t) * 0.006 * np.minimum(1, t / 0.4)
    ph = 2 * np.pi * np.cumsum(f * (1 + vib)) / SR
    sig = np.sin(ph) + 0.18 * np.sin(2 * ph) + 0.05 * np.sin(3 * ph)
    rng = np.random.default_rng(int(m * 100 + dur * 10))
    breath = rng.standard_normal(len(t))
    breath = np.convolve(breath, np.ones(24) / 24, mode="same") * 0.25
    return (sig + breath) * env(len(t), 0.07, 0.25) * 0.35


def choir_lead(m, dur):
    return pad_note(m, dur, "choir")[: int((dur + 1.5) * SR)] * 1.4


def bass_note(m, dur):
    t = t_arr(dur)
    f = hz(m)
    sig = np.sin(2 * np.pi * f * t) + 0.35 * np.sin(2 * np.pi * 2 * f * t) + 0.12 * np.sin(2 * np.pi * 3 * f * t)
    return sig * env(len(t), 0.012, 0.18) * np.exp(-t * 0.8) * 0.8


def kick():
    t = t_arr(0.45)
    f = 45 + 95 * np.exp(-t * 28)
    ph = 2 * np.pi * np.cumsum(f) / SR
    return np.sin(ph) * np.exp(-t * 9) * 0.95


def tom(base=95, decay=7.0, click=0.2, seed=1):
    t = t_arr(0.6)
    f = base * (1 + 0.8 * np.exp(-t * 18))
    ph = 2 * np.pi * np.cumsum(f) / SR
    rng = np.random.default_rng(seed)
    n = rng.standard_normal(len(t)) * np.exp(-t * 60) * click
    return (np.sin(ph) * np.exp(-t * decay) + n) * 0.9


def hat(seed=3):
    t = t_arr(0.12)
    rng = np.random.default_rng(seed)
    n = np.diff(rng.standard_normal(len(t) + 1))
    return n * np.exp(-t * 55) * 0.35


def noise_bed(n, kind, dur_loop, seed):
    """Lit de bruit (vent / vagues / brume / grondement), périodique sur la boucle."""
    rng = np.random.default_rng(seed)
    w = rng.standard_normal(n)
    spec = np.fft.rfft(w)
    fr = np.fft.rfftfreq(n, 1 / SR)
    if kind == "wind":
        g = np.exp(-((np.log(fr + 1) - np.log(900)) / 0.9) ** 2)
    elif kind == "waves":
        g = 1 / (1 + (fr / 700) ** 2)
    elif kind == "fog":
        g = np.exp(-((np.log(fr + 1) - np.log(350)) / 0.8) ** 2)
    else:  # rumble
        g = 1 / (1 + (fr / 110) ** 2)
    out = np.fft.irfft(spec * g, n)
    out /= np.max(np.abs(out)) + 1e-9
    t = np.arange(n) / SR
    cycles = {"wind": 5, "waves": 8, "fog": 3, "rumble": 4}[kind]
    lfo = 0.5 + 0.5 * np.sin(2 * np.pi * cycles * t / dur_loop + seed)
    if kind == "waves":
        lfo = lfo ** 2
    return out * lfo


def reverb(sig, seconds=2.2, wet=0.28, seed=7):
    """Réverbération circulaire : la fin de la boucle se fond dans son début."""
    n = len(sig)
    rng = np.random.default_rng(seed)
    ir_n = int(seconds * SR)
    ir = rng.standard_normal(ir_n) * np.exp(-np.arange(ir_n) / SR * 3.2 / seconds * 2)
    ir[0] = 0
    ir_full = np.zeros(n)
    ir_full[:ir_n] = ir
    wetsig = np.fft.irfft(np.fft.rfft(sig) * np.fft.rfft(ir_full), n)
    wetsig /= np.max(np.abs(wetsig)) + 1e-9
    peak = np.max(np.abs(sig)) + 1e-9
    return sig * (1 - wet * 0.5) + wetsig * peak * wet


def build(name, cfg, combat, seed):
    rng = np.random.default_rng(seed)
    bpm = cfg["bpm"][0 if combat else 1]
    beat = 60.0 / bpm
    bar = 4 * beat
    prog = cfg["prog"]
    bars_per_chord = 2
    cycle_bars = bars_per_chord * len(prog)
    cycles = max(2, int(round(64.0 / (cycle_bars * bar))))
    total_bars = cycle_bars * cycles
    dur = total_bars * bar
    n = int(dur * SR)
    L = np.zeros(n)
    R = np.zeros(n)

    def put(sig, start, pan=0.0):
        add(L, start * SR, sig * (1 - max(0, pan)))
        add(R, start * SR, sig * (1 + min(0, pan)))

    root = cfg["root"]
    scale = cfg["scale"]
    # --- nappes d'accords + basse
    for c in range(cycles):
        for i, (deg, chord) in enumerate(prog):
            t0 = (c * cycle_bars + i * bars_per_chord) * bar
            cd = bars_per_chord * bar
            for k, iv in enumerate(chord):
                m = root + deg + iv + (0 if iv < 12 else 0)
                put(pad_note(m, cd, cfg["pad"]) * (0.8 if combat else 1.0), t0, pan=(-0.4 + 0.3 * k) * 0.8)
            if combat or cfg["pad"] == "drone":
                for b in range(bars_per_chord * 2):
                    put(bass_note(root + deg - 24, beat * 2 * 0.95), t0 + b * 2 * beat, 0)
            else:
                put(bass_note(root + deg - 24, cd * 0.9), t0, 0)
    # --- mélodie : motif de 8 croches sur la gamme, varié à chaque cycle
    motif_base = [int(rng.integers(0, len(scale))) for _ in range(8)]
    lead = cfg["lead"]
    step = beat / 2 if combat else beat
    steps_per_bar = 8 if combat else 4
    for c in range(cycles):
        motif = list(motif_base)
        for _ in range(2):
            motif[int(rng.integers(0, 8))] = int(rng.integers(0, len(scale)))
        for i, (deg, chord) in enumerate(prog):
            for b in range(bars_per_chord):
                for s in range(steps_per_bar):
                    idx = (b * steps_per_bar + s) % 8
                    if lead in ("flute", "choir"):
                        # phrases plus longues, une note sur deux
                        if s % 2 == 1 or rng.random() < 0.2:
                            continue
                    elif rng.random() < (0.28 if combat else 0.45):
                        continue
                    deg_idx = motif[idx]
                    m = root + 12 + deg + scale[deg_idx % len(scale)] + (12 if (deg_idx > 4 and lead == "bell") else 0)
                    t0 = (c * cycle_bars + i * bars_per_chord + b) * bar + s * step
                    pan = float(rng.uniform(-0.6, 0.6))
                    if lead == "bell":
                        sig = bell_note(m)
                    elif lead == "pluck":
                        sig = pluck_note(m)
                    elif lead == "flute":
                        sig = flute_note(m + 12, step * 3.2)
                    else:
                        sig = choir_lead(m, step * 3.0) * 0.5
                    put(sig, t0, pan)
    # --- percussions (combat seulement)
    if combat:
        style = cfg["drums"]
        for bi in range(total_bars):
            t0 = bi * bar
            if style == "heavy":
                for b in (0, 1, 2, 3):
                    put(kick() if b % 2 == 0 else tom(110, 8, 0.25, bi + b), t0 + b * beat, 0)
                put(tom(80, 6, 0.1, bi), t0 + 3.5 * beat, -0.3)
            elif style == "frame":
                for b in (0, 1.5, 2, 3):
                    put(tom(120 + 10 * (b % 2), 9, 0.3, bi + int(b * 2)), t0 + b * beat, 0.2 * (1 if b < 2 else -1))
                put(hat(bi), t0 + 0.5 * beat, 0.5)
                put(hat(bi + 1), t0 + 2.5 * beat, -0.5)
            elif style == "soft":
                put(kick() * 0.7, t0, 0)
                put(kick() * 0.5, t0 + 2 * beat, 0)
                for b in range(8):
                    put(hat(bi * 8 + b) * 0.8, t0 + b * beat / 2, 0.4 if b % 2 else -0.4)
            else:  # sparse
                put(tom(70, 5, 0.1, bi) * 0.8, t0, 0)
                put(tom(90, 6, 0.1, bi + 9) * 0.5, t0 + 2.5 * beat, 0)
    # --- lit de bruit d'ambiance
    if cfg["extra"]:
        bed = noise_bed(n, cfg["extra"], dur, seed)
        vol = {"wind": 0.20, "waves": 0.22, "fog": 0.12, "rumble": 0.20}[cfg["extra"]] * (0.8 if combat else 1.1)
        L += bed * vol
        R += np.roll(bed, int(0.03 * SR)) * vol
    # --- réverb circulaire + mixage
    L = reverb(L, seed=seed)
    R = reverb(R, seed=seed + 1)
    st = np.stack([L, R], axis=1)
    rms = np.sqrt(np.mean(st ** 2))
    st *= 0.13 / (rms + 1e-9)
    peak = np.max(np.abs(st))
    if peak > 0.92:
        st *= 0.92 / peak
    return st, dur


def main():
    os.makedirs(OUT, exist_ok=True)
    only = sys.argv[1:] or list(NATIONS)
    for i, name in enumerate(NATIONS):
        if name not in only:
            continue
        for combat in (True, False):
            st, dur = build(name, NATIONS[name], combat, 100 + i * 7 + (0 if combat else 3))
            suffix = "combat" if combat else "explore"
            with tempfile.NamedTemporaryFile(suffix=".wav", delete=False) as tf:
                wavfile.write(tf.name, SR, (st * 32767).astype(np.int16))
            out = os.path.join(OUT, f"nation_{name}_{suffix}.ogg")
            subprocess.run(["ffmpeg", "-y", "-loglevel", "error", "-i", tf.name, "-c:a", "libvorbis", "-q:a", "3", out], check=True)
            os.unlink(tf.name)
            print(f"{out}  {dur:.1f}s  {os.path.getsize(out) / 1e6:.2f} Mo")


if __name__ == "__main__":
    main()
