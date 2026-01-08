# --------------------------------------------------------------------------------
# title: todo.sh
# author: Robin Marques
# date: 2024-12-14
# updated: 2026-01-06
# type: script
# status: active
# tags:
#   - todo
#   - organisation
#   - notes
#
# description:
#   Script Bash pour ouvrir des fichiers TODO (mes todo list) dans plusieurs dossiers
#   avec un éditeur de texte (ici visual studio code) en mode détaché.
# --------------------------------------------------------------------------------

#!/usr/bin/env bash

# --- CONFIGURATION ---
readonly TODO_DIRS=(
    "$HOME/documents/travail/age"
    "$HOME/documents/apprentissage"
    "$HOME/documents/robin"
)

# --- CONFIGURATION DE LA COMMANDE ---
readonly EDITOR_CMD="code"
readonly FILENAME="TODO.md"

# --- SCRIPT PRINCIPAL ---
echo "Lancement des notes TODO avec $EDITOR_CMD (détaché)..."
echo "----------------------------------------------------"

for dir in "${TODO_DIRS[@]}"; do
    FILE_PATH="$dir/$FILENAME"

    if [ -d "$dir" ]; then
        echo "Ouverture du fichier : $FILE_PATH"
        
        # UTILISATION DE NOHUP ET & :
        # - nohup : Détache le processus du terminal (permet de le fermer).
        # - &     : Lance la commande en arrière-plan (vous rend la main).
        nohup "$EDITOR_CMD" "$FILE_PATH" > /dev/null 2>&1 &
    else
        echo "AVERTISSEMENT: Le dossier '$dir' est introuvable. On ignore."
    fi
done

echo "----------------------------------------------------"
echo "Toutes les notes TODO ont été lancées."
