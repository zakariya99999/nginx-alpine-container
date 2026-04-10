# Use Eclipse Temurin as it is more reliable than the deprecated openjdk:17-slim
FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

# Install wget to fetch the jar
RUN apk add --no-cache wget

# Download EaglerXBungee JAR directly (Latest stable 1.3 release)
RUN wget -O EaglerXBungee.jar "https://github.com"

# Create the config.yml file with your specific requirements
# &c is the Minecraft color code for Red
RUN echo "bind: 0.0.0.0:8081" > config.yml && \
    echo "forward_ip: true" >> config.yml && \
    echo "motd: '&czakas java proxy'" >> config.yml && \
    echo "max_players: 64" >> config.yml && \
    echo "allow_query_string: true" >> config.yml && \
    echo "default_server: 'example.com:25565'" >> config.yml && \
    echo "auth_type: 'OFFLINE'" >> config.yml

# Back4App requires the port to be exposed
EXPOSE 8081

# Command to run the proxy
CMD ["java", "-Xmx512M", "-Xms512M", "-jar", "EaglerXBungee.jar"]
