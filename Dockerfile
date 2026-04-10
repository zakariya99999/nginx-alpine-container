# Use Node 18 Alpine to avoid build errors on memory-constrained containers
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Install git only if needed, otherwise skip to avoid "fatal: repository not found"
RUN apk add --no-cache git

# Clone the specific repository and build it
RUN git clone https://github.com/WorldEditAxe/eaglerproxy.git . && \
    npm install -g typescript && \
    npm install && \
    tsc

# Create configuration with custom MOTD
RUN echo '{"port": 8080, "motd": "§c[zakas java proxy]"}' > config.json

# Expose the websocket port
EXPOSE 8080

# Run the proxy
CMD ["node", "build/index.js"]
