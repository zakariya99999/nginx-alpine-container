# Use a Node.js base image
FROM node:18-alpine

# Set working directory
WORKDIR /app

# 1. Create a dummy package.json to avoid NPM errors
RUN echo '{"name": "eaglerproxy-container", "version": "1.0.0", "dependencies": {"typescript": "^5.0.0"}}' > package.json

# 2. Fix the TypeScript Deprecation Error (moduleResolution node10)
RUN echo '{ "compilerOptions": { "ignoreDeprecations": "6.0", "moduleResolution": "node10" } }' > tsconfig.json

# 3. Download EaglerProxy directly (Avoiding Git Clone/NPM registry errors)
# We use curl to pull the source zip directly from the official repository release
RUN apk add --no-cache curl unzip \
    && curl -L https://github.com -o proxy.zip \
    && unzip proxy.zip \
    && mv eaglerproxy-main/* . \
    && rm -rf proxy.zip eaglerproxy-main

# 4. Install dependencies locally
RUN npm install --omit=dev

# 5. Create the config file with your custom MOTD (Red Text)
# The \u00A74 is the Minecraft color code for Dark Red
RUN echo '{ \
  "port": 8080, \
  "motd": "\u00A74zakas java proxy", \
  "server": { \
    "host": "127.0.0.1", \
    "port": 25565 \
  }, \
  "security": { \
    "enabled": false \
  } \
}' > config.json

# 6. Expose the port Back4app uses
EXPOSE 8080

# 7. Start the proxy
# Note: EaglerProxy naturally supports URL arguments for IP/Port/Auth
CMD ["node", "index.js"]
