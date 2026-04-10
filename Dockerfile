# Use official Node.js Alpine image
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Initialize npm and install EaglerProxy directly via NPM to avoid Git
RUN npm init -y && \
    npm install eaglerproxy

# Create the configuration file (listener.yml)
# This enables the 'redirect' feature for dynamic IP/Port/Auth joining
RUN echo 'bind_host: 0.0.0.0' > listener.yml && \
    echo 'bind_port: 8080' >> listener.yml && \
    echo 'max_connections: 256' >> listener.yml && \
    echo 'motd: "§czakas java proxy"' >> listener.yml && \
    echo 'server:' >> listener.yml && \
    echo '  host: 127.0.0.1' >> listener.yml && \
    echo '  port: 25565' >> listener.yml && \
    echo 'auth_type: offline' >> listener.yml && \
    echo '# Enable URL parameter redirection' >> listener.yml && \
    echo 'redirect:' >> listener.yml && \
    echo '  enabled: true' >> listener.yml && \
    echo '  allow_custom_ip: true' >> listener.yml

# Expose the port Back4app uses
EXPOSE 8080

# Start the proxy using the installed node module
CMD ["npx", "eaglerproxy"]
