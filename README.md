<!-- Logo Liberchat -->
<p align="center">
  <img src="https://github.com/Liberchat/Liberchat/blob/Liberchat6.1.20/icon.png?raw=true" alt="Liberchat Logo" width="120" />
</p>

<p align="center">
  <a href="https://hub.docker.com/r/liberchat/liberchat"><img src="https://img.shields.io/docker/pulls/liberchat/liberchat?style=for-the-badge&color=2496ED&logo=docker" alt="Docker Pulls" /></a>
  <a href="https://hub.docker.com/r/liberchat/liberchat"><img src="https://img.shields.io/docker/image-size/liberchat/liberchat/latest?style=for-the-badge&color=2496ED&logo=docker" alt="Docker Image Size" /></a>
  <img src="https://img.shields.io/badge/Platform-Linux%20%7C%20x86--64-informational?style=for-the-badge&logo=linux" alt="Platform" />
  <a href="https://github.com/Liberchat/Liberchat/blob/Liberchat6.1.20/LICENSE"><img src="https://img.shields.io/github/license/Liberchat/Liberchat?color=success&style=for-the-badge" alt="License" /></a>
</p>

---

# Liberchat Docker - Tests locaux uniquement

⚠️ **Ce Docker est conçu uniquement pour les tests en local (localhost )**  
⚠️ **Ne pas utiliser en production - utilisez le dépôt principal Liberchat ou Yunohost pour la prod**

Ce dossier permet de tester Liberchat facilement en local sans avoir besoin du code source: tout est téléchargé automatiquement depuis GitHub lors du build.

## Installation rapide

1. Clonez ce dépôt :
   ```bash
   git clone https://github.com/Liberchat/Liberchat-docker.git
   cd Liberchat-docker
   ```

2. Lancez le script :
   ```bash
   ./configurer.sh
   ```

3. Accédez à l'application :
   - **Local** : http://localhost:3000 (✅ fonctionne parfaitement)
   - **Réseau local** : Utilisez un tunnel SSH ou accès direct au serveur
   - **Important** : Les IP locales peuvent avoir des problèmes de sécurité navigateur

## Avantages pour les tests

- ✅ Configuration automatique des domaines autorisés
- ✅ Pas de certificats SSL à gérer  
- ✅ Accès direct depuis mobile/tablette sur le réseau local
- ✅ Pas de nginx/reverse proxy (HTTP direct)

## Utilisation manuelle

```bash
# Lancement direct
ALLOWED_DOMAINS="http://localhost:3000,http://192.168.x.x:3000" docker compose up --build
```

```bash
# Avec une branche spécifique
BRANCH=dev ALLOWED_DOMAINS="http://localhost:3000,http://192.168.x.x:3000" docker compose up --build
```

## Arrêt du service

```bash
docker compose down
```

## Important

- **Ce setup est uniquement pour les tests locaux**
- **Pour la production, utilisez le dépôt principal Liberchat ou Yunohost**
- Ouvrez le port 3000 dans votre pare-feu si besoin : `sudo ufw allow 3000/tcp`
- Version par défaut : `latest`

## Variables d'environnement

- **ALLOWED_DOMAINS** : Domaines autorisés (HTTP uniquement pour les tests)
- **BRANCH** : Branche/tag à utiliser (défaut: latest)
- **PORT** : Port d'écoute (défaut: 3000)

Pour toute question, consultez le dépôt principal: https://github.com/Liberchat/Liberchat
Pour la production avec Yunohost: https://github.com/YunoHost-Apps/liberchat_ynh