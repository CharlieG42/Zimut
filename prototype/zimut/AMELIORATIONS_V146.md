# V146 — Conquête : un empire qui vit, que l'on joue ou non

But : jouer la Conquête fait progresser, la délaisser fait perdre des villes peu à peu — sans jamais tout
perdre d'un coup. Toutes les valeurs sont des constantes en tête de la section « Empire vivant » de
`ConquestSystem.gd`.

## 1. Absence

« Absence » = temps écoulé depuis la dernière **bataille de Conquête** (gagnée ou perdue). Ouvrir la carte
sans se battre ne remet pas le compteur à zéro.

- **Délai de grâce : 3 jours** (`ABSENCE_GRACE_DAYS`). Rien ne se passe avant.
- Au bout de 3 jours, une offensive ; puis **une de plus tous les 2 jours** (`ABSENCE_STEP_DAYS`), 5 au plus
  (`ABSENCE_MAX_OFFENSIVES`). Chacune vise la ville la moins défendue, jamais la capitale.
- Les offensives manquées se règlent aux chiffres, comme une offensive normale (repoussée, brèche, ville
  perdue). **La dernière reste en attente** : trois batailles pour renforcer la ville ou la défendre en
  personne (V145).
- **Au plus 2 villes perdues** entre deux batailles (`ABSENCE_MAX_LOST`) ; au-delà, au pire une brèche.
- Une ville tombée est « perdue » au sens habituel : une seule bataille pour la reprendre, ruinée au retour.
- Rien ne se passe tant que l'empire compte moins de 3 villes conquises (même seuil que les offensives).
- Au retour, la carte ouvre le bilan **« Pendant votre absence »**.

Exemple : 8 jours sans jouer, villes sans garnison → 2 villes tombées et une offensive en attente. Les
mêmes villes bien gardées repoussent tout, seules.

## 2. Présence

- **Impôts** : un jour de revenus de l'empire par jour écoulé, encaissé en ouvrant la carte, plafonné à
  3 jours (`ABSENCE_TAX_DAYS_MAX`).
- **Première victoire de Conquête du jour** : revenus de l'empire doublés.

## 3. Pendant les autres modes

Toutes les 3 victoires en Aventure ou en Tactique (`OUTSIDE_WINS_PER_TICK`), l'empire avance d'un cran :
une offensive en cours approche d'une bataille, sinon une nouvelle peut être annoncée (une chance sur
deux). L'alerte s'affiche sur l'écran de victoire et dans les nouvelles de la carte. Ces victoires ne
comptent pas comme une présence en Conquête.

## 4. Notification Android : préparée, pas encore active

`scripts/Notifier.gd` calcule le rappel (un jour avant la première offensive d'absence) et l'envoie à un
module Android « ZimutNotify » **s'il existe**. Il n'existe pas encore : Godot ne peut pas programmer une
notification sans module natif, et l'APK est exporté sans Gradle, ce qui interdit d'en embarquer un. Sans
module, l'appel ne fait rien. Voir `TODO.md`.

## Horloge

Tout repose sur l'horloge du téléphone. La reculer ne rapporte rien : le compteur repart de l'heure
affichée, sans impôts ni offensive. L'avancer ne fait que déclencher les offensives plus tôt.

## Sauvegarde

Clés optionnelles de `conquest` : `last_active`, `last_tax`, `absence_done`, `absence_lost`, `bonus_day`,
`outside_wins`. Une sauvegarde existante démarre son compteur à la première ouverture de la carte.

## Tests

`tests/test_v146_empire_vivant.gd` (nouveau, 28 vérifications, horloge simulée).
