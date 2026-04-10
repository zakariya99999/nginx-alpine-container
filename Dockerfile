# Use a lightweight OpenJDK image
FROM eclipse-temurin:17-jre-alpine

# Set working directory
WORKDIR /app

# Install wget to download the proxy jar
RUN apk add --no-cache wget

# Download the latest EaglerProxy stable jar directly 
# This avoids the "git clone" and "npm install" errors you were seeing
RUN wget -O EaglerProxy.jar https://github.com

# Create the configuration file automatically
# This sets the MOTD with red text code (§c) and enables the redirect feature
RUN echo 'server-ip: 0.0.0.0' > config.yml && \
    echo 'server-port: 8080' >> config.yml && \
    echo 'motd: "§czakas java proxy"' >> config.yml && \
    echo 'max-players: 100' >> config.yml && \
    echo '# Enable URL parameter redirection (ws://.../?ip=...)' >> config.yml && \
    echo 'allow-redirect: true' >> config.yml && \
    echo 'auth-type: ONLINE' >> config.yml

# Back4App usually uses port 8080
EXPOSE 8080

# Start the proxy
CMD ["java", "-jar", "EaglerProxy.jar"]
