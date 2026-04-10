# Use Java 17 for BungeeCord compatibility
FROM eclipse-temurin:17-jre-alpine

# Set working directory
WORKDIR /app

# Install curl to download the proxy jar
RUN apk add --no-cache curl

# Download EaglercraftXBungee (Stable version)
# We rename it to proxy.jar for simplicity
RUN curl -L -o proxy.jar "https://github.com"

# Create the BungeeCord config.yml
# This is configured to allow the dynamic ?ip= &port= parameters
RUN echo "server_connect_timeout: 5000" > config.yml && \
    echo "remote_ping_cache: 5000" >> config.yml && \
    echo "forge_support: true" >> config.yml && \
    echo "player_limit: -1" >> config.yml && \
    echo "permissions:" >> config.yml && \
    echo "  default: [bungeecord.command.list]" >> config.yml && \
    echo "timeout: 30000" >> config.yml && \
    echo "log_commands: false" >> config.yml && \
    echo "online_mode: false" >> config.yml && \
    echo "servers:" >> config.yml && \
    echo "  lobby:" >> config.yml && \
    echo "    motd: '&c&lzakas java proxy'" >> config.yml && \
    echo "    address: localhost:25565" >> config.yml && \
    echo "    restricted: false" >> config.yml && \
    echo "listeners:" >> config.yml && \
    echo "- query_port: 8080" >> config.yml && \
    echo "  motd: '&czakas java proxy'" >> config.yml && \
    echo "  priorities: [lobby]" >> config.yml && \
    echo "  bind_local_address: true" >> config.yml && \
    echo "  tab_list: GLOBAL_PING" >> config.yml && \
    echo "  query_enabled: false" >> config.yml && \
    echo "  host: 0.0.0.0:8080" >> config.yml && \
    echo "  forced_hosts: {}" >> config.yml && \
    echo "  max_players: 100" >> config.yml && \
    echo "  tab_size: 60" >> config.yml && \
    echo "  ping_passthrough: false" >> config.yml && \
    echo "  force_default_server: false" >> config.yml && \
    echo "  proxy_protocol: false" >> config.yml && \
    echo "disabled_commands: [disabledcommandhere]" >> config.yml && \
    echo "network_compression_threshold: 256" >> config.yml && \
    echo "groups: {}" >> config.yml && \
    echo "connection_throttle: 4000" >> config.yml && \
    echo "stats: 00000000-0000-0000-0000-000000000000" >> config.yml && \
    echo "connection_throttle_limit: 3" >> config.yml && \
    echo "log_pings: true" >> config.yml && \
    echo "ip_forward: true" >> config.yml && \
    echo "prevent_proxy_connections: false" >> config.yml

# Create the EaglercraftXBungee listeners.yml
# This enables the WebSocket listener on port 8080 for Back4app
RUN mkdir -p plugins/EaglercraftXBungee
RUN echo "external_network_history_allow_all: true" > plugins/EaglercraftXBungee/settings.yml && \
    echo "gateways:" > plugins/EaglercraftXBungee/listeners.yml && \
    echo "- address: 0.0.0.0:8080" >> plugins/EaglercraftXBungee/listeners.yml && \
    echo "  feedback_address: 127.0.0.1:8080" >> plugins/EaglercraftXBungee/listeners.yml && \
    echo "  forward_ip: true" >> plugins/EaglercraftXBungee/listeners.yml && \
    echo "  allow_dynamic_vhosts: true" >> plugins/EaglercraftXBungee/listeners.yml

# Back4app usually uses port 8080
EXPOSE 8080

# Start the proxy
CMD ["java", "-Xmx127m", "-Xms128m", "-jar", "proxy.jar"]
