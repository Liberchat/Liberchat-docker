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
if [ $MODE_DEV -eq 1 ]; then
  IP=$(hostname -I | awk '{print $1}')
  ALLOWED_DOMAINS="http://localhost:3000,http://$IP:3000"
  echo "Le domaine autorisé par défaut pour le développement local est : $ALLOWED_DOMAINS"
else
  IP=$(hostname -I | awk '{print $1}')
  read -p "Entrez le(s) domaine(s) autorisé(s) (ex: https://votre-domaine.com) : " ALLOWED_DOMAINS
  read -p "Voulez-vous aussi autoriser l'accès réseau local (http://$IP:3000) ? [o/N] : " addlocal
  if [[ $addlocal =~ ^[oO]$ ]]; then
    ALLOWED_DOMAINS="$ALLOWED_DOMAINS,http://$IP:3000"
    echo "Ajout de http://$IP:3000 aux domaines autorisés."
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
  IP=$(hostname -I | awk '{print $1}')
  echo -e "\nLiberchat est lancé en mode développement !"
  echo "Accédez à l'application sur : http://localhost:3000 ou http://$IP:3000 depuis un autre appareil du réseau local"
  echo "\n⚠️  Si vous n'arrivez pas à accéder depuis un autre appareil, vérifiez que le port 3000 est ouvert dans le pare-feu de votre machine."
  echo "  Exemple pour ouvrir le port sur Linux (ufw) : sudo ufw allow 3000/tcp"
else
  IP=$(hostname -I | awk '{print $1}')
  echo -e "\nLiberchat est lancé en mode production !"
  echo "Accédez à l'application sur : $ALLOWED_DOMAINS"
  echo "Ou, depuis le réseau local : http://$IP:3000 (si autorisé dans ALLOWED_DOMAINS)"
  echo "\n⚠️  Si vous n'arrivez pas à accéder depuis un autre appareil, vérifiez que le port 3000 est ouvert dans le pare-feu de votre machine."
  echo "  Exemple pour ouvrir le port sur Linux (ufw) : sudo ufw allow 3000/tcp"
fi
if [ $MODE_DEV -eq 1 ]; then
  echo "(Mode développement : logs affichés, arrêt avec Ctrl+C)"
else
  echo "(Mode production : conteneur en arrière-plan, arrêtez avec 'docker-compose down')"
fi
