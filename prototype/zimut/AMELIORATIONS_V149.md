# V149 — Conquête : écran de ville

Sans nouvel asset (trois arbres de décor redessinés en SVG). Concerne surtout les quatre Nations existantes.

- **Sol par Nation** (`ConquestCityView.GROUND_LOOK`) : plaques irrégulières aux couleurs de la Nation (texture
  de bruit calculée une fois par Nation) et détails semés dessus — fleurs (Sylve), congères et éclats de neige
  (Cimes), fissures et braises rougeoyantes (Brasier), flaques et joncs (Brumes). Le sol des Cimes passe en
  neige, celui du Brasier en cendre. La texture s'efface en douceur vers l'horizon. Les autres Nations gardent
  un sol uni légèrement marbré.
- **Rues courbes** (`_draw_street`) : elles partent du bord de la place et s'incurvent vers chaque bâtiment, avec
  des pavés, au lieu de rayons droits depuis l'hôtel de ville.
- **Chantiers** (`_empty_plot`) : un emplacement vide est un chantier — terre retournée, piquets et corde, pile
  de planches, tas de pierres, avec le « + » doré. Verrouillé : terrain nu et cadenas.
- **Arbres** (`assets/ui/conquest/city/<nation>/deco_tree.svg`) : sapins enneigés aux Cimes, arbres calcinés aux
  braises au Brasier, saules des marais aux Brumes (avant : le même feuillu partout).

## Tests

`tests/test_v149_ecran_ville.gd` (nouveau, inscrit au workflow par `tests/ci/`).
