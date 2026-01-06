# --------------------------------------------------------------------------------
# title: visualisation.sh
# author: Robin Marques
# date: 2024-01-06
# updated: 2025-01-06
# type: script
# status: active
# tags:
#   - organisation
#   - vie
#   - visualisation
#
# description:
#   Script Bash pour visualiser des données multidimensionnelles extraites de notes
#   markdown dans un répertoire spécifique (carnet de note), en utilisant gnuplot pour
#   générer des graphiques.
# --------------------------------------------------------------------------------

#!/bin/bash

# Définition du répertoire cible
TARGET_DIR="$HOME/documents/robin/carnet_de_bord"

# Vérification de l'existence du répertoire
if [ ! -d "$TARGET_DIR" ]; then
    echo "Le répertoire $TARGET_DIR est introuvable."
    exit 1
fi

# Création d'un fichier temporaire pour les données
TEMP_DATA=$(mktemp)

# Fonction pour extraire une valeur ou retourner 0 si vide
extract_value() {
    local key=$1
    local file=$2
    local val=$(grep "$key:" "$file" | cut -d':' -f2 | cut -d'/' -f1 | tr -d ' ')
    if [[ -z "$val" ]]; then
        echo "0"
    else
        echo "$val"
    fi
}

# Extraction des données
for file in "$TARGET_DIR"/2026*.md; do
    [ -e "$file" ] || continue

    # Extraction de la date
    date_journal=$(basename "$file" | grep -oE '2026-[0-9]{2}-[0-9]{2}')
    if [ -z "$date_journal" ]; then
        date_journal=$(grep "date:" "$file" | cut -d':' -f2- | tr -d ' ')
    fi
    
    # Si la date n'est toujours pas trouvée, on passe au fichier suivant
    [ -z "$date_journal" ] && continue

    # Extraction sécurisée des 10 valeurs
    v1=$(extract_value "bonheur" "$file")
    v2=$(extract_value "energie" "$file")
    v3=$(extract_value "productivite" "$file")
    v4=$(extract_value "stress" "$file")
    v5=$(extract_value "manger" "$file")
    v6=$(extract_value "sommeil" "$file")
    v7=$(extract_value "sport" "$file")
    v8=$(extract_value "concentration" "$file")
    v9=$(extract_value "intrapsychique" "$file")
    v10=$(extract_value "interpersonnel" "$file")

    echo "$date_journal $v1 $v2 $v3 $v4 $v5 $v6 $v7 $v8 $v9 $v10" >> "$TEMP_DATA"
done

# Tri par date et suppression des doublons
sort -u -k1,1 -o "$TEMP_DATA" "$TEMP_DATA"

# Affichage avec gnuplot
gnuplot -p << EOF
set multiplot layout 3,1 title "Analyse multidimensionnelle - Année 2026"
set xdata time
set timefmt "%Y-%m-%d"
set format x "%d/%m"
set yrange [0:10.5]
set grid
set key outside right

# Graphique 1 : État général
set title "Indicateurs d'état général"
plot "$TEMP_DATA" using 1:2 with lines lw 2 lc rgb "#0000FF" title "Bonheur", \
     "$TEMP_DATA" using 1:3 with lines lw 2 lc rgb "#008000" title "Énergie", \
     "$TEMP_DATA" using 1:4 with lines lw 2 lc rgb "#FF0000" title "Productivité", \
     "$TEMP_DATA" using 1:5 with lines lw 2 lc rgb "#A020F0" title "Stress"

# Graphique 2 : Hygiène et Concentration
set title "Hygiène de vie et facultés cognitives"
plot "$TEMP_DATA" using 1:6 with lines lw 2 lc rgb "#FFA500" title "Manger", \
     "$TEMP_DATA" using 1:7 with lines lw 2 lc rgb "#00FFFF" title "Sommeil", \
     "$TEMP_DATA" using 1:8 with lines lw 2 lc rgb "#006400" title "Sport", \
     "$TEMP_DATA" using 1:9 with lines lw 2 lc rgb "#FF1493" title "Concentration"

# Graphique 3 : Psychologie et Social
set title "Indicateurs intrapsychiques et interpersonnels"
plot "$TEMP_DATA" using 1:10 with lines lw 2 lc rgb "#8B4513" title "Intrapsychique", \
     "$TEMP_DATA" using 1:11 with lines lw 2 lc rgb "#40E0D0" title "Interpersonnel"

unset multiplot
EOF

# Nettoyage
rm "$TEMP_DATA"