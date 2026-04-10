# Use a lighter Node.js image to avoid 'openjdk' manifest errors
FROM node:18-alpine

# Install git only if absolutely needed for dependencies, 
# otherwise skip to prevent "repository not found"
RUN apk add --no-cache git

# Create app directory
WORKDIR /app

# Clone the proxy directly from the repo's specific directory structure
# This skips `npm install` failures by using a pre-configured branch/file structure
RUN git clone https://github.com .

# Install dependencies (ensure package.json exists)
RUN npm install

# Create config.ts with desired MOTD and 8081 port
RUN echo "export const config = { \
    port: 8081, \
    motd: '§cZakas Java Proxy', \
    maxPlayers: 64, \
    adapter: { \
        useNatives: false \
    } \
};" > src/config.ts

# Build the TypeScript project
RUN npm run build

# Expose the port
EXPOSE 8081

# No Healthcheck
HEALTHCHECK NONE

# Start the proxy
CMD ["node", "dist/index.js"]
