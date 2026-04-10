# Use a Node.js base image
FROM node:18-alpine

# Install necessary tools (Git is required for cloning the proxy)
RUN apk add --no-cache git

# Set the working directory
WORKDIR /app

# Clone the EaglerProxy repository directly
# This avoids the "repository not found" error by targeting the specific project
RUN git clone https://github.com .

# Install dependencies and build the TypeScript project
RUN npm install && npm run build

# Create a custom config.yml with your requested MOTD and dynamic settings
RUN echo "bind_host: 0.0.0.0" > config.yml && \
    echo "bind_port: 8080" >> config.yml && \
    echo "motd:" >> config.yml && \
    echo "  icon: false" >> config.yml && \
    echo "  line_1: '&czakas java proxy'" >> config.yml && \
    echo "  line_2: 'Join via URL parameters!'" >> config.yml && \
    echo "plugins:" >> config.yml && \
    echo "  - EagProxyAAS" >> config.yml

# Expose the port Back4app will use (Standard is 8080)
EXPOSE 8080

# Start the proxy
CMD ["node", "build/index.js"]
