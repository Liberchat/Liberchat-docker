# Liberchat Docker

<p align="center">
  <img src="https://github.com/Liberchat/Liberchat/blob/Liberchat6.1.16/icon.png?raw=true" alt="Liberchat Logo" width="120" />
</p>

<p align="center">
  <!-- Badge Docker Pulls désactivé car non supporté pour les dépôts Docker Hub créés après 2023 -->
  <!-- <a href="https://hub.docker.com/r/liberchat/liberchat"><img src="https://img.shields.io/docker/pulls/liberchat/liberchat?style=for-the-badge&color=2496ED&logo=docker" alt="Docker Pulls" /></a> -->
  <a href="https://hub.docker.com/r/liberchat/liberchat/tags"><img src="https://img.shields.io/docker/image-size/liberchat/liberchat/6.1.16?style=for-the-badge&color=2496ED&logo=docker" alt="Docker Image Size" /></a>
  <img src="https://img.shields.io/badge/Platform-Linux%20%7C%20x86--64-informational?style=for-the-badge&logo=linux" alt="Platform" />
  <a href="https://github.com/Liberchat/Liberchat/blob/Liberchat6.1.16/LICENSE"><img src="https://img.shields.io/github/license/Liberchat/Liberchat?color=success&style=for-the-badge" alt="License" /></a>
</p>

---

Image Docker officielle pour [Liberchat](https://github.com/Liberchat/Liberchat) — serveur de chat moderne, simple à déployer et à personnaliser.

## Fonctionnalités principales
- Déploiement rapide (production ou développement)
- Accès local ou réseau (LAN) en mode production
- Accès sécurisé en production (HTTPS recommandé)
- Configuration par variables d’environnement
- Support Linux, x86-64
- Image légère et optimisée

## Lancement rapide

```bash
docker run -d \
  -p 3000:3000 \
  -e ALLOWED_DOMAINS="https://votre-domaine.com" \
  liberchat/liberchat:6.1.16
```

- Accès local : http://localhost:3000
- Accès réseau local (LAN) : http://IP_DE_VOTRE_MACHINE:3000 (en production, autorisez l’IP dans ALLOWED_DOMAINS)
- Accès production : https://votre-domaine.com (configuré dans ALLOWED_DOMAINS)
- Ouvrez le port 3000 sur votre pare-feu si besoin.

## Variables d’environnement

- `ALLOWED_DOMAINS` : Domaines autorisés pour images/WebSocket (ex : https://votre-domaine.com ou http://192.168.x.x:3000)
- `BRANCH` : Branche ou tag à builder (défaut : `Liberchat6.1.16`)
- `NODE_ENV` : `production` (défaut) ou `development` (pour hot reload)

## Exemples d’utilisation

### Production (mode autonome, domaine public)
```bash
ALLOWED_DOMAINS="https://votre-domaine.com" docker-compose up --build -d
```

### Production (accès local + domaine public)
```bash
ALLOWED_DOMAINS="https://votre-domaine.com, http://192.168.x.x:3000" docker-compose up --build -d
```

### Développement (hot reload)
- Décommentez la section `volumes:` dans `docker-compose.yml` pour monter le code local.
```bash
NODE_ENV=development ALLOWED_DOMAINS="http://localhost:3000" docker-compose up --build
```

- Par défaut, la variable BRANCH vaut `Liberchat6.1.16` (ou la branche/tag définie dans le Dockerfile).
- Pour builder une branche ou un tag spécifique :
```bash
BRANCH=dev docker-compose up --build -d
```

## Arrêt du service
```bash
docker-compose down
```

## Mise à jour
```bash
docker pull liberchat/liberchat:6.1.16
```
Ou, pour une stack compose :
```bash
docker-compose up --build -d
```

## Personnalisation
- Modifiez le port, le nom du conteneur ou les variables dans `docker-compose.yml`.
- Pour plusieurs instances : dupliquez le service ou adaptez les ports.

## Documentation

- [Documentation complète sur GitHub](https://github.com/Liberchat/Liberchat)
- [Exemple de configuration avancée](https://github.com/Liberchat/Liberchat/blob/Liberchat6.1.16/docker/docker-compose.yml)

---

Pour toute question ou contribution, ouvrez une issue sur le dépôt officiel.
