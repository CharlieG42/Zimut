"""
Script : injection de fichiers CSV dans un classeur Excel (un onglet par CSV)

Prérequis :
    pip install pandas openpyxl

Utilisation :
    Placer ce script dans le même dossier que les fichiers .csv et le fichier Excel cible,
    puis lancer : python csv_vers_excel.py
"""

import pandas as pd
from pathlib import Path

# --- Configuration -----------------------------------------------------
DOSSIER = Path(__file__).parent
NOM_FICHIER_EXCEL = "_donnees.xlsx" # <- adapte ce nom si ton fichier Excel s'appelle autrement
FICHIER_EXCEL = DOSSIER / NOM_FICHIER_EXCEL
# -------------------------------------------------------------------------


def nettoyer_nom_onglet(nom, max_length=31):
    """Excel interdit certains caractères dans les noms d'onglets et limite à 31 caractères."""
    for c in ['\\', '/', '*', '?', ':', '[', ']']:
        nom = nom.replace(c, '_')
    return nom[:max_length]


def lire_csv_avec_encodage(chemin_fichier):
    """Essaie plusieurs encodages courants pour lire un CSV sans corrompre les accents."""
    encodages = ['utf-8-sig', 'cp1252', 'latin-1']
    derniere_erreur = None

    for encodage in encodages:
        try:
            df = pd.read_csv(chemin_fichier, encoding=encodage, sep=None, engine='python')
            return df, encodage
        except (UnicodeDecodeError, UnicodeError) as e:
            derniere_erreur = e
            continue

    raise derniere_erreur


def main():
    fichiers_csv = sorted(DOSSIER.glob("*.csv"))

    if not fichiers_csv:
        print("Aucun fichier CSV trouvé dans ce dossier.")
        return

    print(f"{len(fichiers_csv)} fichier(s) CSV trouvé(s) :")
    for f in fichiers_csv:
        print(f" - {f.name}")

    excel_existe = FICHIER_EXCEL.exists()
    mode = 'a' if excel_existe else 'w'
    kwargs = {'if_sheet_exists': 'replace'} if excel_existe else {}

    with pd.ExcelWriter(FICHIER_EXCEL, engine='openpyxl', mode=mode, **kwargs) as writer:
        for fichier_csv in fichiers_csv:
            nom_onglet = nettoyer_nom_onglet(fichier_csv.stem)
            try:
                df, encodage_utilise = lire_csv_avec_encodage(fichier_csv)
            except Exception as e:
                print(f"⚠ Erreur lors de la lecture de {fichier_csv.name} : {e}")
                continue

            df.to_excel(writer, sheet_name=nom_onglet, index=False)
            print(f"✓ '{fichier_csv.name}' (encodage : {encodage_utilise}) → onglet '{nom_onglet}' ({len(df)} lignes)")

    print(f"\nTerminé. Fichier Excel : {FICHIER_EXCEL.resolve()}")


if __name__ == "__main__":
    main()
