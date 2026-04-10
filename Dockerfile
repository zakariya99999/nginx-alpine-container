# Use a stable Node.js image
FROM node:20-alpine

# Set working directory
WORKDIR /app

# 1. Create package.json to manage dependencies
RUN echo '{"name":"eaglerproxy","version":"1.0.0","dependencies":{"eaglerproxy":"latest"}}' > package.json

# 2. Fix the "moduleResolution" error by creating a tsconfig.json with the ignore flag
RUN echo '{"compilerOptions": {"ignoreDeprecations": "6.0", "moduleResolution": "node10"}}' > tsconfig.json

# 3. Install dependencies (using the specific library instead of the broken git/npm routes)
RUN npm install @eaglercraft/eaglerproxy

# 4. Create the configuration file (config.yml) with your MOTD
RUN echo 'server:' > config.yml && \
    echo '  host: 0.0.0.0' >> config.yml && \
    echo '  port: 8080' >> config.yml && \
    echo '  motd: "§4zakas java proxy"' >> config.yml && \
    echo '  max-players: 20' >> config.yml && \
    echo 'security:' >> config.yml && \
    echo '  allow-dynamic-ports: true' >> config.yml

# 5. Create a small entry script to handle the dynamic URL parameters
# This allows: ws://your-app.back4app.io/?ip=server.com&port=25565
RUN echo 'const { EaglerProxy } = require("@eaglercraft/eaglerproxy");' > index.js && \
    echo 'const proxy = new EaglerProxy({' >> index.js && \
    echo '  configPath: "./config.yml",' >> index.js && \
    echo '  allowDynamic: true' >> index.js && \
    echo '});' >> index.js && \
    echo 'proxy.start();' >> index.js

# Back4App uses port 8080 by default for containers
EXPOSE 8080

# Start the proxy
CMD ["node", "index.js"]
