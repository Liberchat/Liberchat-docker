FROM liberchat/liberchat:latest

# Configuration pour tests locaux uniquement
ENV ALLOWED_DOMAINS=http://localhost:3000
ENV NODE_ENV=development
ENV PORT=3000

EXPOSE 3000

# Pas de modifications nécessaires, utilise l'image officielle
CMD ["node", "server.js"]