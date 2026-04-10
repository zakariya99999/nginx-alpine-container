# STAGE 1: Build the Proxy
FROM maven:3.9-eclipse-temurin-17 AS builder

# Download the source directly from a mirror/source to avoid git clone issues
WORKDIR /build
RUN curl -L https://github.com | tar -xz --strip-components=1
RUN mvn clean package -DskipTests

# STAGE 2: Runtime
FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

# Copy the built jar from the builder stage
COPY --from=builder /build/target/eaglercraft-1.8-proxy-*.jar ./proxy.jar

# Create the startup script to handle dynamic URL parameters
RUN echo '#!/bin/sh' > entrypoint.sh && \
    echo 'cat <<EOF > config.yml' >> entrypoint.sh && \
    echo 'bind_address: 0.0.0.0' >> entrypoint.sh && \
    echo 'bind_port: 8080' >> entrypoint.sh && \
    echo 'motd: "§czakas java proxy"' >> entrypoint.sh && \
    echo '# Logic to allow dynamic connecting via URL params' >> entrypoint.sh && \
    echo 'allow_command_line_params: true' >> entrypoint.sh && \
    echo 'EOF' >> entrypoint.sh && \
    echo 'exec java -Xmx512M -jar proxy.jar' >> entrypoint.sh && \
    chmod +x entrypoint.sh

# Back4App typically uses port 8080
EXPOSE 8080

ENTRYPOINT ["./entrypoint.sh"]
