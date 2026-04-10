# Use OpenJDK 17 for modern BungeeCord compatibility
FROM openjdk:17-slim

WORKDIR /app

# 1. Download the latest stable EaglerXBungee standalone JAR
# We use a direct mirror to avoid GitHub/NPM build failures
ADD https://github.com /app/proxy.jar

# 2. Create the configuration file directly
# We set listeners to 8081 and enable the redirect query feature
RUN echo 'server_name: "zakas java proxy"' > config.yml && \
    echo 'listeners:' >> config.yml && \
    echo '  - port: 8081' >> config.yml && \
    echo '    host: 0.0.0.0' >> config.yml && \
    echo '    motd: "&4zakas java proxy"' >> config.yml && \
    echo '    max_players: 64' >> config.yml && \
    echo '    force_default_server: false' >> config.yml && \
    echo 'auth_system:' >> config.yml && \
    echo '  enabled: false' >> config.yml && \
    echo 'enable_query_redirect: true' >> config.yml && \
    echo 'origins: []' >> config.yml

# 3. Fix permissions for Back4App's non-root environment
RUN chmod 777 /app/proxy.jar && chmod 666 /app/config.yml

EXPOSE 8081

# Run the proxy with enough memory for a container
CMD ["java", "-Xmx113M", "-Xms128M", "-jar", "proxy.jar"]
