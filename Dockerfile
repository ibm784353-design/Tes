# Stremio Web - Railway Ready

ARG NODE_VERSION=20-alpine
FROM node:${NODE_VERSION}

# Setup pnpm
ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"

RUN corepack enable
RUN apk add --no-cache git

# App directory
WORKDIR /var/www/stremio-web

# Copy package files
COPY package.json pnpm-lock.yaml ./

# Install dependencies
RUN pnpm install --frozen-lockfile

# Copy project files
COPY . .

# Build app
RUN pnpm build

# Expose Railway port
EXPOSE 8080

# Railway automatically injects PORT
ENV PORT=8080

# Start server
CMD ["node", "http_server.js"]