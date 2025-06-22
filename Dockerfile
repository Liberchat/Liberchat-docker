# Dockerfile autonome pour Liberchat (téléchargement auto depuis GitHub, branche ou tag au choix)
FROM node:20-alpine as build
WORKDIR /app

ARG BRANCH=Liberchat6.1.16
ENV BRANCH=${BRANCH}

# Télécharger la branche ou le tag souhaité du projet Liberchat
RUN apk add --no-cache wget tar \
  && wget -O liberchat.tar.gz https://github.com/Liberchat/Liberchat/archive/refs/heads/${BRANCH}.tar.gz || wget -O liberchat.tar.gz https://github.com/Liberchat/Liberchat/archive/refs/tags/${BRANCH}.tar.gz \
  && tar -xzf liberchat.tar.gz --strip-components=1 \
  && rm liberchat.tar.gz

RUN npm install --production && npm run build

FROM node:20-alpine as prod
WORKDIR /app
COPY --from=build /app/dist ./dist
COPY --from=build /app/package*.json ./
RUN npm install --production && npm cache clean --force;
EXPOSE 3000
ENV NODE_ENV=production
CMD ["node", "dist/server.js"]
