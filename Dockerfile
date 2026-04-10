# Use a reliable Java 17 base to avoid "manifest unknown" errors
FROM eclipse-temurin:17-jre-alpine

# Set working directory
WORKDIR /app

# Install curl to download the proxy directly (bypassing git/npm issues)
RUN apk add --no-cache curl

# Download EaglerXBungee - the latest stable version
# This avoids the "npm error 404" and "git clone" failures
RUN curl -L -o EaglerXBungee.jar https://github.com

# Create the configuration file automatically to avoid startup errors
# This sets the port to 8081 and sets your custom MOTD
RUN echo "server_name: '&c&lEagProxy AAS'" > settings.yml && \
    echo "address: 0.0.0.0" >> settings.yml && \
    echo "port: 8081" >> settings.yml && \
    echo "allow_custom_ips: true" >> settings.yml && \
    echo "max_players: 64" >> settings.yml

# Back4app health check requirement
EXPOSE 8081

# Run the proxy
# EaglerXBungee supports the ?ip= &port= &authType= params by default 
# when 'allow_custom_ips' is set to true.
CMD ["java", "-jar", "EaglerXBungee.jar"]
