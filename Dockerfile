# Use node alpine for small image size
FROM node:18-alpine

# Install git to clone the proxy
RUN apk add --no-cache git

# Clone the specific repository
RUN git clone https://github.com/Eaglercraft-Archive/eaglerproxy.git /eaglerproxy

WORKDIR /eaglerproxy

# Install dependencies
RUN npm install

# Create config from example
RUN cp config.example.ts config.ts

# Expose the default WebSocket port
EXPOSE 8080

# Command to run the proxy
CMD ["node", "index.js"]
