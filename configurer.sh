#!/bin/bash
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
echo
while true; do
    read -p "Voulez-vous le mode développement local (hot reload) ? [o/N] : " dev
    case $dev in
        [oO]* ) MODE_DEV=1; break;;
        [nN]* | "" ) MODE_DEV=0; break;;
        * ) echo "Répondez par o (oui) ou n (non).";;
    esac
done

# Domaine autorisé
IP=$(hostname -I | awk '{print $1}')
if [ $MODE_DEV -eq 1 ]; then
  ALLOWED_DOMAINS="https://localhost:3000,https://$IP:3000"
  echo "Le domaine autorisé par défaut pour le développement local est : $ALLOWED_DOMAINS"
else
  read -p "Entrez le(s) domaine(s) autorisé(s) (ex: https://votre-domaine.com) : " ALLOWED_DOMAINS
  # Avertissement si l'utilisateur met https sur une IP locale
  if [[ $ALLOWED_DOMAINS =~ https://$IP ]]; then
    echo -e "\e[1;33m⚠️  Attention : L'accès direct en HTTPS sur une IP locale nécessite un certificat valide ou auto-signé.\e[0m"
  fi
  read -p "Voulez-vous aussi autoriser l'accès réseau local (https://$IP:3000) ? [o/N] : " addlocal
  if [[ $addlocal =~ ^[oO]$ ]]; then
    ALLOWED_DOMAINS="$ALLOWED_DOMAINS,https://$IP:3000"
    echo "Ajout de https://$IP:3000 aux domaines autorisés."
  fi
fi

# Choix de la branche/tag
read -p "Voulez-vous une branche ou un tag spécifique ? (laisser vide pour la version par défaut) : " BRANCH

# Build de l'image
echo -e "\nConstruction de l'image Docker..."
BUILD_CMD="ALLOWED_DOMAINS=\"$ALLOWED_DOMAINS\""
if [ ! -z "$BRANCH" ]; then
  BUILD_CMD="$BUILD_CMD BRANCH=$BRANCH"
fi
if [ $MODE_DEV -eq 1 ]; then
  BUILD_CMD="$BUILD_CMD NODE_ENV=development docker-compose build"
else
  BUILD_CMD="$BUILD_CMD docker-compose build"
fi

eval $BUILD_CMD

# Lancement du conteneur
echo -e "\nLancement de l'application..."
RUN_CMD="ALLOWED_DOMAINS=\"$ALLOWED_DOMAINS\""
if [ ! -z "$BRANCH" ]; then
  RUN_CMD="$RUN_CMD BRANCH=$BRANCH"
fi
if [ $MODE_DEV -eq 1 ]; then
  RUN_CMD="$RUN_CMD NODE_ENV=development docker-compose up"
else
  RUN_CMD="$RUN_CMD docker-compose up -d"
fi

eval $RUN_CMD

# Affichage de l'adresse d'accès
if [ $MODE_DEV -eq 1 ]; then
  echo -e "\nLiberchat est lancé en mode développement !"
  echo -e "Utilisez \e[1;32mhttps://localhost:3000\e[0m ou \e[1;32mhttps://$IP:3000\e[0m depuis un autre appareil du réseau local."
  echo -e "\e[1;33m⚠️  Si le navigateur affiche un avertissement, acceptez le certificat auto-signé.\e[0m"
  echo "\n⚠️  Si vous n'arrivez pas à accéder depuis un autre appareil, vérifiez que le port 3000 est ouvert dans le pare-feu de votre machine."
  echo "  Exemple pour ouvrir le port sur Linux (ufw) : sudo ufw allow 3000/tcp"
else
  echo -e "\nLiberchat est lancé en mode production !"
  echo "Accédez à l'application sur : $ALLOWED_DOMAINS"
  echo "Ou, depuis le réseau local : https://$IP:3000 (si autorisé dans ALLOWED_DOMAINS)"
  echo -e "\e[1;33m⚠️  N'utilisez pas https:// sur l'IP locale sans certificat valide ou auto-signé.\e[0m"
  echo "\n⚠️  Si vous n'arrivez pas à accéder depuis un autre appareil, vérifiez que le port 3000 est ouvert dans le pare-feu de votre machine."
  echo "  Exemple pour ouvrir le port sur Linux (ufw) : sudo ufw allow 3000/tcp"
fi
if [ $MODE_DEV -eq 1 ]; then
  echo "(Mode développement : logs affichés, arrêt avec Ctrl+C)"
else
  echo "(Mode production : conteneur en arrière-plan, arrêtez avec 'docker-compose down')"
fi

