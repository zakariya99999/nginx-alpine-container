# Use Node.js LTS 
FROM node:18-alpine

# Set working directory
WORKDIR /app

# 1. Install dependencies required for downloading/extracting
RUN apk add --no-cache curl tar

# 2. Download the latest Eaglerproxy source directly (Avoiding Git Clone)
# We use the official source tarball to bypass registry/git issues
RUN curl -L https://github.com | tar -xz --strip-components=1

# 3. Install NPM dependencies from the included package.json
RUN npm install --production

# 4. Create the listener configuration
# This enables the dynamic "query parameter" mode for IP/Port/Auth
RUN echo '{\
  "address": "0.0.0.0",\
  "port": 8080,\
  "motd": "§czakas java proxy",\
  "allow_dynamic_ports": true,\
  "max_connections": 100,\
  "logging": true\
}' > config.json

# 5. Create a small entrypoint script to ensure it runs correctly on Back4App
RUN echo '#!/bin/sh\nnode index.js' > entrypoint.sh && chmod +x entrypoint.sh

# Back4App usually uses port 8080 or the PORT env variable
EXPOSE 8080

CMD ["./entrypoint.sh"]
