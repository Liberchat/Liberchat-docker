#!/bin/bash
# Toujours exécuter le script depuis son propre dossier (docker/)
cd "$(dirname "$0")"
# Script interactif pour configurer, builder et lancer Liberchat avec Docker

# Banner stylisée moderne
clear
echo -e "\e[1;31m╔══════════════════════════════════════════════════════╗\e[0m"
echo -e "\e[1;31m║\e[0m        \e[1;37mConfiguration Liberchat Docker\e[0m         \e[1;31m║\e[0m"
echo -e "\e[1;31m╚══════════════════════════════════════════════════════╝\e[0m"
echo
# Message anarco-syndicaliste stylisé
sleep 0.3
echo -e "\e[1;33mⒶ Bienvenue camarade, ce déploiement Docker est autogéré et libre !\e[0m"
sleep 0.3
echo -e "\e[1;36mⒶ Chaque utilisateur est libre de son instance, vive l'autonomie numérique !\e[0m"
sleep 0.3
echo

# Mode de déploiement
CONFIG_FILE=".env.liberchat"

# Chargement config existante si présente (prod uniquement)
if [ -f "$CONFIG_FILE" ]; then
  source "$CONFIG_FILE"
  CONFIG_EXIST=1
else
  CONFIG_EXIST=0
fi

# Configuration automatique en mode développement
IP=$(hostname -I | awk '{print $1}')
ALLOWED_DOMAINS="http://localhost:3000"
echo "Domaines autorisés : $ALLOWED_DOMAINS"

# Choix de la branche/tag
read -p "Voulez-vous une branche ou un tag spécifique ? (laisser vide pour la version par défaut) : " BRANCH

# Test des permissions Docker
if ! docker ps >/dev/null 2>&1; then
  echo -e "\e[1;33m⚠️  Permissions Docker manquantes. Utilisation de sudo...\e[0m"
  COMPOSE_CMD="sudo docker compose"
else
  COMPOSE_CMD="docker compose"
fi

# Lancement direct avec l'image officielle
echo -e "\nLancement de l'application..."
RUN_CMD="ALLOWED_DOMAINS=\"$ALLOWED_DOMAINS\" $COMPOSE_CMD up --remove-orphans"

# Affichage des informations d'accès AVANT le lancement
echo -e "\n\e[1;32m✅ Liberchat sera accessible sur :\e[0m"
echo -e "   • Local : \e[1;32mhttp://localhost:3000\e[0m"
echo -e "\n\e[1;33m⚠️  Accès réseau local non supporté (problèmes navigateur)\e[0m"
echo -e "\e[1;33m⚠️  Utilisez uniquement localhost pour éviter les erreurs SSL\e[0m"
echo -e "\n\e[1;36m🚀 Lancement en cours... (Arrêt avec Ctrl+C)\e[0m\n"

eval $RUN_CMD
