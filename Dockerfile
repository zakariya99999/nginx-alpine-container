# Use a standard Java 17 image
FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

# Expose the proxy port
EXPOSE 8081

# Download EaglerProxy (EagPAAS) JAR directly
# Note: Ensure this URL points to a direct download of the EaglerProxy.jar
ADD https://github.com /app/EaglerProxy.jar

# Create the configuration file with your red MOTD
# Use \u00A74 for dark red color in Minecraft/Eaglercraft
RUN echo '{ \
  "port": 8081, \
  "motd": "\u00A74zakas java proxy", \
  "allow_url_parameters": true, \
  "default_ip": "127.0.0.1", \
  "default_port": 25565 \
}' > /app/config.json

# Run the proxy
CMD ["java", "-jar", "EaglerProxy.jar"]
