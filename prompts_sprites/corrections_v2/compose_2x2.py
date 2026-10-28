#!/usr/bin/env python3
"""
compose_2x2.py — Assemble 4 sprites individuels en une planche 2×2 parfaite.

Usage:
    python3 compose_2x2.py sprite_face_a.png sprite_face_b.png sprite_back_c.png sprite_back_d.png output.png

Options:
    --bg="#E8E8E8"     Couleur de fond (défaut: gris clair)
    --bg="#FFFFFF"     Fond blanc
    --height=880       Hauteur cible des sprites en px (défaut: 880)
    --canvas="2048x1024"  Dimensions du canvas final (défaut: 2048x1024)
    --margin=80        Marge minimale entre sprites en px (défaut: 80)

Le script:
1. Charge les 4 sprites (PNG avec fond uni, potentiellement transparent)
2. Détecte le bounding box de contenu non-fond dans chaque sprite
3. Recadre chaque sprite sur son contenu
4. Redimensionne tous les sprites à la MÊME hauteur (préservant le ratio)
5. Compose sur canvas 2048x1024:
   - Sprite 1 (face A) → quadrant haut-gauche
   - Sprite 2 (face B) → quadrant haut-droite
   - Sprite 3 (back C) → quadrant bas-gauche
   - Sprite 4 (back D) → quadrant bas-droite
6. Centre chaque sprite dans son quadrant avec marges égales
7. Aligne les pieds: même Y pour les sprites d'une même rangée
8. Sauvegarde le résultat
"""

import sys
import argparse
from PIL import Image


def detect_content_bbox(img, bg_color=None, threshold=30):
    """Détecte le bounding box du contenu non-fond dans une image."""
    img_rgb = img.convert("RGB")
    w, h = img_rgb.size
    px = img_rgb.load()

    # Si pas de couleur de fond spécifiée, échantillonner les coins
    if bg_color is None:
        corners = [px[2, 2], px[w - 3, 2], px[2, h - 3], px[w - 3, h - 3]]
        bg_color = tuple(sum(c[i] for c in corners) // 4 for i in range(3))

    br, bg_, bb = bg_color

    def is_bg(c):
        r, g, b = c[:3]
        return abs(r - br) < threshold and abs(g - bg_) < threshold and abs(b - bb) < threshold

    # Si l'image a un canal alpha, l'utiliser
    if img.mode == "RGBA":
        px_a = img.load()
        min_x, min_y, max_x, max_y = w, h, 0, 0
        for y in range(h):
            for x in range(w):
                if px_a[x, y][3] > 10:  # non-transparent
                    min_x = min(min_x, x)
                    max_x = max(max_x, x)
                    min_y = min(min_y, y)
                    max_y = max(max_y, y)
    else:
        min_x, min_y, max_x, max_y = w, h, 0, 0
        for y in range(0, h, 2):
            for x in range(0, w, 2):
                if not is_bg(px[x, y]):
                    min_x = min(min_x, x)
                    max_x = max(max_x, x)
                    min_y = min(min_y, y)
                    max_y = max(max_y, y)

    if max_x <= min_x or max_y <= min_y:
        return (0, 0, w, h)  # fallback: image entière

    # Ajouter une petite marge de sécurité
    pad = 4
    min_x = max(0, min_x - pad)
    min_y = max(0, min_y - pad)
    max_x = min(w, max_x + pad)
    max_y = min(h, max_y + pad)

    return (min_x, min_y, max_x, max_y)


def load_and_crop(path, bg_color=None):
    """Charge un sprite, le recadre sur le contenu, retourne l'image recadrée."""
    img = Image.open(path)
    bbox = detect_content_bbox(img, bg_color)
    cropped = img.crop(bbox)
    return cropped


def resize_to_height(img, target_height):
    """Redimensionne en préservant le ratio, hauteur cible fixe."""
    w, h = img.size
    ratio = target_height / h
    new_w = int(w * ratio)
    new_h = target_height
    return img.resize((new_w, new_h), Image.LANCZOS)


def hex_to_rgb(hex_color):
    """Convertit '#E8E8E8' en (232, 232, 232)."""
    hex_color = hex_color.lstrip("#")
    return tuple(int(hex_color[i : i + 2], 16) for i in (0, 2, 4))


def compose_2x2(sprites, canvas_w=2048, canvas_h=1024, bg_hex="#E8E8E8",
                target_height=880, margin=80):
    """
    Compose 4 sprites en grille 2×2.

    sprites: liste de 4 PIL.Image (dans l'ordre: face_a, face_b, back_c, back_d)
    """
    bg_rgb = hex_to_rgb(bg_hex)

    # Créer le canvas
    canvas = Image.new("RGB", (canvas_w, canvas_h), bg_rgb)

    # Redimensionner tous les sprites à la même hauteur
    resized = []
    for s in sprites:
        # Convertir en RGBA pour préserver la transparence si besoin
        if s.mode != "RGBA":
            s = s.convert("RGBA")
        r = resize_to_height(s, target_height)
        resized.append(r)

    # Calculer les positions
    # Chaque quadrant fait canvas_w/2 x canvas_h/2
    qw = canvas_w // 2  # 1024
    qh = canvas_h // 2  # 512

    # Hauteur max d'un sprite dans un quadrant avec marges
    # On veut: sprite centré horizontalement, pieds alignés en bas du quadrant avec marge
    max_sprite_h = qh - 2 * margin  # 512 - 160 = 352... trop petit!
    # En fait pour 2048x1024, chaque quadrant fait 1024x512
    # Un sprite de 880px de haut ne rentre pas dans 512px!
    # → Il faut un canvas plus grand, ou des sprites plus petits

    # Ajustement: pour 2048x1024, la hauteur max par sprite est ~440px
    # On recalcule target_height si nécessaire
    actual_target = min(target_height, qh - 2 * margin)
    if actual_target < target_height:
        print(f"  Ajustement: hauteur sprite réduite de {target_height} à {actual_target}px "
              f"pour tenir dans les quadrants de {qh}px avec marges de {margin}px")
        resized = [resize_to_height(s, actual_target) for s in sprites]

    positions = [
        (0, 0),           # top-left  (face A)
        (qw, 0),          # top-right (face B)
        (0, qh),          # bot-left  (back C)
        (qw, qh),         # bot-right (back D)
    ]

    for i, (sprite, (qx, qy)) in enumerate(zip(resized, positions)):
        sw, sh = sprite.size

        # Centrer horizontalement dans le quadrant
        cx = qx + (qw - sw) // 2

        # Aligner les pieds en bas du quadrant avec marge
        # Pieds = bas du quadrant - marge
        foot_y = qy + qh - margin
        cy = foot_y - sh

        # Vérifier que le sprite ne dépasse pas en haut
        if cy < qy + margin:
            cy = qy + margin
            print(f"  Sprite {i+1} trop grand, ajusté en haut")

        # Coller le sprite (avec alpha si RGBA)
        if sprite.mode == "RGBA":
            canvas.paste(sprite, (cx, cy), sprite)
        else:
            canvas.paste(sprite.convert("RGB"), (cx, cy))

        print(f"  Sprite {i+1} ({['face A','face B','back C','back D'][i]}): "
              f"{sw}x{sh}px placé à ({cx},{cy}), pieds à Y={cy+sh}")

    return canvas


def main():
    parser = argparse.ArgumentParser(description="Compose 4 sprites en grille 2×2")
    parser.add_argument("sprite1", help="Sprite face pose A (haut-gauche)")
    parser.add_argument("sprite2", help="Sprite face pose B (haut-droite)")
    parser.add_argument("sprite3", help="Sprite back pose C (bas-gauche)")
    parser.add_argument("sprite4", help="Sprite back pose D (bas-droite)")
    parser.add_argument("output", help="Fichier de sortie PNG")
    parser.add_argument("--bg", default="#E8E8E8", help="Couleur de fond (hex)")
    parser.add_argument("--height", type=int, default=420,
                        help="Hauteur cible des sprites en px (défaut: 420 pour 2048x1024)")
    parser.add_argument("--canvas", default="2048x1024", help="Dimensions canvas WxH")
    parser.add_argument("--margin", type=int, default=60, help="Marge minimale en px")

    args = parser.parse_args()

    # Parser les dimensions du canvas
    cw, ch = map(int, args.canvas.lower().split("x"))

    print(f"Chargement des 4 sprites...")
    sprites = []
    for i, path in enumerate([args.sprite1, args.sprite2, args.sprite3, args.sprite4]):
        print(f"  Sprite {i+1}: {path}")
        s = load_and_crop(path)
        print(f"    Taille originale recadrée: {s.size}")
        sprites.append(s)

    print(f"\nComposition sur canvas {cw}x{ch}, fond {args.bg}, "
          f"hauteur sprite cible {args.height}px, marge {args.margin}px...")
    result = compose_2x2(sprites, canvas_w=cw, canvas_h=ch, bg_hex=args.bg,
                         target_height=args.height, margin=args.margin)

    result.save(args.output, "PNG")
    print(f"\nSauvegardé: {args.output} ({result.size[0]}x{result.size[1]})")


if __name__ == "__main__":
    main()