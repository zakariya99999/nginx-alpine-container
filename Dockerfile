# STAGE 1: Build the proxy from source
FROM node:18-alpine AS builder

# Install build dependencies
RUN apk add --no-progress --no-cache python3 make g++

# Create app directory
WORKDIR /app

# Download the EaglerProxy source directly via curl (avoids git clone issues)
# We use the official master zip to ensure we have the source code
ADD https://github.com /tmp/proxy.tar.gz
RUN tar -xzf /tmp/proxy.tar.gz --strip-components=1 && rm /tmp/proxy.tar.gz

# FIX: moduleResolution=node10 deprecation error
# We inject "ignoreDeprecations": "6.0" into the tsconfig.json
RUN sed -i 's/"compilerOptions": {/"compilerOptions": { "ignoreDeprecations": "6.0",/g' tsconfig.json

# Install dependencies and build
RUN npm install
RUN npm run build

# STAGE 2: Run the proxy
FROM node:18-alpine
WORKDIR /app

# Copy built files and production dependencies
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/package.json ./package.json
COPY --from=builder /app/node_modules ./node_modules

# Create the Config File with your specific MOTD and settings
RUN echo "server:" > config.yml && \
    echo "  host: 0.0.0.0" >> config.yml && \
    echo "  port: 8080" >> config.yml && \
    echo "  motd: '§czakas java proxy'" >> config.yml && \
    echo "  max-players: 2700" >> config.yml && \
    echo "security:" >> config.yml && \
    echo "  enabled: false" >> config.yml && \
    echo "query-auth:" >> config.yml && \
    echo "  enabled: true" >> config.yml && \
    echo "  allow-custom-ip: true" >> config.yml

# Expose the Back4App port
EXPOSE 8080

# Start the proxy
CMD ["node", "dist/index.js"]
