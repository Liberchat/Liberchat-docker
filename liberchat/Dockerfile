# Dockerfile pour Liberchat (Node.js + Vite/React) - build distant depuis GitHub
FROM node:20-alpine as build
WORKDIR /app

ARG BRANCH=main
ENV BRANCH=${BRANCH}

# Configuration pour désactiver YunoHost et utiliser en local
ENV VITE_BASE_URL=/
ENV NODE_ENV=production
ENV YNH_APP_ARG_PATH=""
ENV IS_YUNOHOST=false

# Télécharger la branche ou le tag souhaité du projet Liberchat YunoHost
RUN apk add --no-cache wget tar git \
  && wget -O liberchat.tar.gz https://github.com/Liberchat/liberchatserver_ynh/archive/refs/heads/${BRANCH}.tar.gz || wget -O liberchat.tar.gz https://github.com/Liberchat/liberchatserver_ynh/archive/refs/tags/${BRANCH}.tar.gz \
  && tar -xzf liberchat.tar.gz --strip-components=1 \
  && rm liberchat.tar.gz \
  && echo 'import { defineConfig } from "vite"; \
import react from "@vitejs/plugin-react"; \
export default defineConfig({ \
  plugins: [react()], \
  base: "/", \
  build: { \
    outDir: "dist", \
    assetsDir: "assets" \
  } \
});' > vite.config.ts

# Installation des dépendances et build avec configuration locale
RUN npm ci --only=production \
  && VITE_BASE_URL=/ BASE_PATH="" YNH_APP_ARG_PATH="" npm run build

FROM node:20-alpine as prod
WORKDIR /app

# Copier tout depuis l'étape de build
COPY --from=build /app .

# Variables d'environnement pour mode local (pas YunoHost)
ENV NODE_ENV=development
ENV PORT=3000
ENV YNH_APP_ARG_PATH=""
ENV IS_YUNOHOST=false
ENV BASE_PATH=""

EXPOSE 3000

# Utiliser le serveur original du projet
CMD ["npm", "start"]
