FROM node:22.12-alpine AS builder

WORKDIR /app
COPY package*.json ./
COPY tsconfig.json ./

RUN chown -R node:node /app
USER node

RUN --mount=type=cache,target=/root/.npm npm install --ignore-scripts

COPY src/ ./src/

RUN npm run build

FROM node:22-alpine AS release

WORKDIR /app
COPY package*.json package-lock.json ./
RUN chown -R node:node /app

USER node
COPY --from=builder /app/dist /app/dist

ENV NODE_ENV=production
RUN npm ci --ignore-scripts --omit-dev

EXPOSE 8081

ENTRYPOINT ["node", "dist/http.js"]
