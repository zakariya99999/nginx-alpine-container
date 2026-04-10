# Use a Node.js base image
FROM node:18-alpine

# Install git to clone the repository
RUN apk add --no-cache git

# Clone the EagProxyAAS repository (the specific version for dynamic parameters)
RUN git clone https://github.com /app
WORKDIR /app

# Install dependencies and TypeScript
RUN npm install
RUN npm install -g typescript

# Configure the MOTD to "zakas java proxy" in red
# Minecraft color code §4 (dark red) or §c (bright red)
# We use sed to modify the MOTD in the config.ts file
RUN sed -i 's/motd: ".*"/motd: "§czakas java proxy"/' src/config.ts

# Compile the TypeScript code
RUN tsc

# Back4App containers typically use port 8080 or the PORT environment variable
# EaglerProxy defaults to 8080 in many AAS configurations
EXPOSE 8080

# Start the proxy
CMD ["node", "build/index.js"]
