# --------------------------------------------------------------------------------
# title: rapport.sh
# author: Robin Marques
# date: 2024-12-14
# updated: 2025-01-06
# type: script
# status: active
# tags:
#   - rapport
#   - organisation
#   - notes
#
# description:
#   Script Bash pour copier un modèle de document depuis un répertoire dédié
#   vers un nouveau document avec un nom spécifié par l'utilisateur.
# --------------------------------------------------------------------------------

#!/usr/bin/env bash

# Chemin de base vers mon dossier :
base_dir="$HOME/documents/outils/templates"


# 1. Récupération de la liste des documents dans le répertoire spécifié
documents=("$base_dir"/*) # Crée un tableau avec les chemins complets des fichiers.
                          # Le caractère * est le 'glob'

# Filtrage pour ne garder que le nom du fichier (basename) et vérifier qu'il y a des fichiers
declare -a noms_documents
for doc in "${documents[@]}"; do
    if [ -f "$doc" ]; then # Vérifie si l'élément est un fichier valide
        noms_documents+=("$(basename "$doc")")
    fi
done

# Vérification si des documents ont été trouvés
if [ ${#noms_documents[@]} -eq 0 ]; then
    echo "Erreur critique : Aucun document trouvé dans le répertoire '$base_dir'." >&2
    exit 1
fi

# 2. Affichage de la liste des documents avec leurs numéros (Noms de fichiers)
echo "Liste des documents modèles disponibles dans '$base_dir' :"
for i in "${!noms_documents[@]}"; do
    echo "$((i+1)). ${noms_documents[$i]}"
done

# 3. Demande à l'utilisateur de choisir un document
while true; do
    read -p "Entrez le numéro du document à copier : " choix
    if [[ $choix =~ ^[0-9]+$ && $choix -ge 1 && $choix -le ${#noms_documents[@]} ]]; then
        break
    else
        echo "Choix invalide. Veuillez entrer un numéro entre 1 et ${#noms_documents[@]}."
    fi
done

# 4. Définition du nom du document source choisi
# On utilise $choix-1 car le tableau est indexé à partir de 0
document_choisi="${noms_documents[$choix-1]}"
chemin_document_source="$base_dir/$document_choisi"


# 5. Demande le nom du nouveau document
read -p "Entrez le nom du nouveau document (destination) : " nom_document_destination

# 6. Copie du fichier choisi avec le nouveau nom
# La source est maintenant le chemin complet, la destination le nom fourni par l'utilisateur
if cp -n "$chemin_document_source" "$nom_document_destination"; then
    # 7. Affichage d'un message de confirmation
    echo "Le modèle '$document_choisi' a été copié sous le nom '$nom_document_destination'."
else
    echo "Erreur lors de la copie du fichier. Vérifiez les permissions et le chemin de destination." >&2
    exit 1
fi
