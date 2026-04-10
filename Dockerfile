# Use a specific Node version to avoid "manifest unknown" and TS version issues
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Install dependencies needed for some native builds
RUN apk add --no-cache python3 make g++

# Initialize a clean npm project and install the proxy
# We use the direct github link to avoid the 404 npm registry error
RUN npm init -y && \
    npm install https://github.com

# Create the configuration file automatically
# This sets the MOTD, port 8081, and allows the dynamic URL params you requested
RUN cat <<EOF > config.json
{
  "serverName": "zakas java proxy",
  "motd": "§czakas java proxy",
  "port": 8081,
  "host": "0.0.0.0",
  "maxPlayers": 20,
  "origins": [],
  "forwardIP": true,
  "auth": {
    "enabled": false
  }
}
EOF

# Expose the port Back4App is looking for
EXPOSE 8081

# Start the proxy
# The proxy by default supports the ?ip= &port= URL parameters
CMD ["npx", "eaglercraft-proxy", "--config", "config.json"]
