#!/usr/bin/env bash

# --------------------------------------------------------------------------------
# title: move.sh
# author: Robin Marques
# date: 2024-12-14
# updated: 2025-12-12
# type: script
# status: active
# tags:
#   - move
#   - organisation
#   - notes
#
# description:
#   Script Bash pour naviguer rapidement entre plusieurs dossiers
#   et ouvrir des fichiers spécifiques avec les applications par défaut.
# --------------------------------------------------------------------------------

# --- SECTION DE CONFIGURATION ---

# Le chemin de base pour tous les déplacements et ouvertures
readonly BASE_PATH="$HOME/documents"

# Liste des options de déplacement (chemins relatifs à BASE_PATH)
readonly DEPLACEMENTS=(
    "outils/"
    "apprentissage/uqtr/session_10"
    "travail/age/acad/"
    "robin/carnet_de_bord/"
)

# Liste des options d'ouverture de fichier (chemins relatifs à BASE_PATH)
readonly OUVERTURES=(
    "outils/documents/2025_mes_bonnes_pratiques.txt"
    "travail/age/acad/interne/rapport/08_rapport_decembre_coordination_aux_affaires_académiques_de_premier_cycle.docx"
    "papiers/banque/mes_depenses/2025_depenses/2025_depenses.ods"
    "travail/age/acad/interne/transition/2025_cahier_de_transition.docx"
)

# Couleurs pour les messages
readonly C_GREEN='\033[0;32m'
readonly C_BLUE='\033[0;34m'
readonly C_RED='\033[0;31m'
readonly C_YELLOW='\033[1;33m'
readonly C_NC='\033[0m' # Pas de couleur

# --- FONCTIONS ---

# Affiche un message d'information
log_info() {
    echo -e "${C_BLUE}INFO: $1${C_NC}"
}

# Affiche un message d'erreur
log_error() {
    echo -e "${C_RED}ERREUR: $1${C_NC}" >&2
}

# Affiche un menu numéroté à partir d'un index de départ
# Usage: display_menu START_INDEX "Titre du menu" "${ARRAY[@]}"
display_menu() {
    local start_index=$1
    local title=$2
    shift 2
    local options=("$@")

    echo -e "${C_GREEN}$title${C_NC}"
    for i in "${!options[@]}"; do
        echo "  $((start_index + i)) - ${options[$i]}"
    done
    echo "" # Laisse un espace
}

# --- SCRIPT PRINCIPAL ---

main() {
    clear # Nettoie l'écran pour afficher le menu proprement

    # Affichage des menus
    local current_index=1
    display_menu $current_index "--- Aller vers un dossier ---" "${DEPLACEMENTS[@]}"
    current_index=$((current_index + ${#DEPLACEMENTS[@]}))
    display_menu $current_index "--- Ouvrir un fichier ---" "${OUVERTURES[@]}"

    # Lecture du choix de l'utilisateur
    read -p "$(echo -e ${C_YELLOW}"Entrez votre choix : "${C_NC})" choix

    # --- TRAITEMENT DU CHOIX ---
    local total_deplacements=${#DEPLACEMENTS[@]}
    local total_options=$((${#DEPLACEMENTS[@]} + ${#OUVERTURES[@]}))

    # Vérification si le choix est bien un nombre
    if ! [[ "$choix" =~ ^[0-9]+$ ]]; then
        log_error "Veuillez entrer un nombre valide."
        return 1
    fi
    
    # Si le choix est pour un déplacement
    if (( choix >= 1 && choix <= total_deplacements )); then
        local index=$((choix - 1))
        local dest_path="${BASE_PATH}/${DEPLACEMENTS[$index]}"

        if [ -d "$dest_path" ]; then
            log_info "Déplacement vers : $dest_path"
            cd "$dest_path"
        else
            log_error "Le dossier n'existe pas : $dest_path"
        fi

    # Si le choix est pour une ouverture
    elif (( choix > total_deplacements && choix <= total_options )); then
        local index=$((choix - 1 - total_deplacements))
        local file_path="${BASE_PATH}/${OUVERTURES[$index]}"

        if [ -f "$file_path" ]; then
            log_info "Ouverture de : $file_path"
            # Utilise xdg-open qui choisit la meilleure application par défaut
            # C'est plus flexible que de tester chaque extension de fichier
            xdg-open "$file_path" &
        else
            log_error "Le fichier n'existe pas : $file_path"
        fi

    # Si le choix est invalide
    else
        log_error "Choix invalide."
        return 1
    fi
}

# Exécution de la fonction principale
main
