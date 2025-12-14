#!/usr/bin/env bash

# --------------------------------------------------------------------------------
# title: carnet.sh
# author: Robin Marques
# date: 2024-12-14
# updated: 2025-12-13
# type: script
# status: active
# tags:
#   - journal
#   - organisation
#   - notes
#
# description:
#   Script Bash pour gérer un carnet de bord quotidien.
# --------------------------------------------------------------------------------

set -o errexit -o nounset -o pipefail

# --- CONFIGURATION ---
readonly DOSSIER_JOURNAL="$HOME/documents/robin/carnet_de_bord"
readonly AUTEUR="Robin Marques"
readonly DATE_ACTUELLE=$(date +%Y-%m-%d)
readonly NOM_FICHIER="${DATE_ACTUELLE}.md"
readonly CHEMIN_COMPLET="$DOSSIER_JOURNAL/$NOM_FICHIER"

# --- SCRIPT PRINCIPAL ---

main() {
    # 1. Création du répertoire si inexistant
    mkdir -p "$DOSSIER_JOURNAL"

    # 2. Vérification de l'existence du fichier
    if [ -f "$CHEMIN_COMPLET" ]; then
        echo "Le fichier du jour ($NOM_FICHIER) existe déjà. Ouverture..."
    else
        echo "Création d'une nouvelle entrée pour le $DATE_ACTUELLE..."
        
        # Écriture des métadonnées
        cat <<EOF > "$CHEMIN_COMPLET"
# --------------------------------------------------------------------------------
# title: $DATE_ACTUELLE
# author: $AUTEUR
# date: $DATE_ACTUELLE
# type: journal
# status: active
# tags:
#   - journal
#
# description:
#   Carnet qui fait le point sur la journée du $DATE_ACTUELLE
# --------------------------------------------------------------------------------

EOF
    fi

    # 3. Ouverture avec VS Code (dans tous les cas)
    if command -v code &> /dev/null; then
        code "$CHEMIN_COMPLET"
    else
        echo "Erreur : La commande 'code' (VS Code) est introuvable."
        exit 1
    fi
}

main