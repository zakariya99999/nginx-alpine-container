# Use a lightweight Java runtime to avoid build errors
FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

# 1. Download the latest stable EaglerProxy JAR directly
# This avoids 'git clone' and 'npm install' errors
ADD https://github.com /app/EaglerProxy.jar

# 2. Create the configuration file automatically
# This sets your custom MOTD with red text and enables the URL query redirect
RUN echo 'server {' > /app/config.yml && \
    echo '  host: 0.0.0.0' >> /app/config.yml && \
    echo '  port: 8080' >> /app/config.yml && \
    echo '  motd: "§4zakas java proxy"' >> /app/config.yml && \
    echo '  max-players: 900' >> /app/config.yml && \
    echo '}' >> /app/config.yml && \
    echo 'query_redirect: true' >> /app/config.yml && \
    echo 'auth_type: "OFFLINE"' >> /app/config.yml

# Back4App uses port 8080 by default usually, change if needed
EXPOSE 8080

# Start the proxy
CMD ["java", "-jar", "EaglerProxy.jar"]
