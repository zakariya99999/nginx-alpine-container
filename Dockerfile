# Use a lightweight OpenJDK image
FROM eclipse-temurin:17-jre-alpine

# Set working directory
WORKDIR /app

# Download the standalone EaglerProxy JAR directly
# We use a direct download to avoid GitHub/NPM registry issues on Back4app
ADD https://github.com proxy.jar

# Create the configuration file automatically to avoid external file dependencies
RUN echo "address: 0.0.0.0" > config.yml && \
    echo "port: 8080" >> config.yml && \
    echo "motd: \"§4zakas java proxy\"" >> config.yml && \
    echo "server_name: \"EaglerProxy\"" >> config.yml && \
    echo "max_players: 7293" >> config.yml && \
    echo "allow_custom_ips: true" >> config.yml && \
    echo "# Redirect all root traffic to use URL params" >> config.yml

# Back4app usually uses port 8080 or provides one via environment variable
EXPOSE 8080

# Start the proxy
# The -Xmx256M flag keeps it within small container limits
CMD ["java", "-Xmx128M", "-Xms128M", "-jar", "proxy.jar"]
