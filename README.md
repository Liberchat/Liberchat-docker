# Liberchat Docker

Image Docker officielle pour [Liberchat](https://github.com/Liberchat/Liberchat) — un serveur de chat moderne, simple à déployer et à personnaliser.

## Lancement rapide

```bash
docker run -d -p 3000:3000 -e ALLOWED_DOMAINS="https://votre-domaine.com" liberchat/liberchat:6.1.16
```

## Variables d’environnement

- `ALLOWED_DOMAINS` : Domaines autorisés pour les images, WebSocket, etc.
- `BRANCH` : Branche ou tag à builder (par défaut : `Liberchat6.1.16`).

## Documentation

Consultez la documentation complète sur [GitHub](https://github.com/Liberchat/Liberchat).

---

Pour toute question ou contribution, ouvrez une issue sur le dépôt officiel.
