# 1. Build Phase - Utilizing JDK for compilation
FROM eclipse-temurin:17-jdk-alpine AS builder
WORKDIR /app

# Clone specific reliable fork directly
RUN apk add --no-cache git && \
    git clone --depth 1 https://github.com/LAX1DUDE/eaglercraft-1.8-bungeecord-proxy.git .

# Build the proxy using Maven
RUN ./mvnw clean package

# 2. Production Phase
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app

# Copy built JAR
COPY --from=builder /app/target/eaglercraft-proxy-*.jar app.jar

# Create config files with "zakas java proxy" in red
RUN mkdir -p /app/config && \
    echo '{"motd": "§cZakas Java Proxy", "maxPlayers": 100}' > /app/config/config.json

# Expose proxy port
EXPOSE 8080

# Run with dynamic IP/Port support (appends query params)
ENTRYPOINT ["java", "-jar", "app.jar"]
