# Use Eclipse Temurin as it is more stable than the old 'openjdk' image
FROM eclipse-temurin:17-jre-alpine

# Set the working directory
WORKDIR /app

# 1. Download EaglercraftXBungee (Direct download to avoid GitHub clone errors)
# This is the stable 1.8.8 BungeeCord plugin/standalone jar
ADD https://github.com /app/eaglerproxy.jar

# 2. Create the configuration files directly in the Dockerfile
RUN mkdir -p /app/plugins/EaglercraftXBungee

# Create the listener config with port 8081 and Red MOTD
RUN echo "listeners:" > /app/plugins/EaglercraftXBungee/listeners.yml && \
    echo "  - address: 0.0.0.0" >> /app/plugins/EaglercraftXBungee/listeners.yml && \
    echo "    port: 8081" >> /app/plugins/EaglercraftXBungee/listeners.yml && \
    echo "    motd: '&czakas java proxy'" >> /app/plugins/EaglercraftXBungee/listeners.yml && \
    echo "    # This enables the ?ip= &port= feature you requested" >> /app/plugins/EaglercraftXBungee/listeners.yml && \
    echo "    allow_custom_ips: true" >> /app/plugins/EaglercraftXBungee/listeners.yml

# Create basic Bungee config
RUN echo "stats: $(cat /dev/urandom | tr -dc 'a-f0-9' | fold -w 32 | head -n 1)" > /app/config.yml && \
    echo "groups: {}" >> /app/config.yml && \
    echo "servers:" >> /app/config.yml && \
    echo "  default: {address: localhost:25565, motd: 'Default Server', restricted: false}" >> /app/config.yml && \
    echo "listeners:" >> /app/config.yml && \
    echo "- query_port: 25577" >> /app/config.yml && \
    echo "  host: 0.0.0.0:25577" >> /app/config.yml && \
    echo "  priorities: [default]" >> /app/config.yml && \
    echo "online_mode: false" >> /app/config.yml

# Back4app uses port 8081 per your request
EXPOSE 8081

# Start the proxy
CMD ["java", "-Xmx512M", "-Xms512M", "-jar", "eaglerproxy.jar"]
