# Use a lightweight Alpine-based Node.js image
FROM node:20-alpine

# Set the working directory
WORKDIR /app

# Install dependencies for building native modules if needed
RUN apk add --no-cache python3 make g++

# Initialize a package.json and install wisp-js and express
RUN npm init -y && \
    npm install @mercuryworkshop/wisp-js express

# Create a simple entry point script (index.js)
# This script runs an Express server on 8080 to satisfy Back4app's health check
# while routing WebSocket upgrades to the Wisp server.
RUN echo 'const { server: wisp } = require("@mercuryworkshop/wisp-js/server"); \
const express = require("express"); \
const app = express(); \
const port = process.env.PORT || 8080; \
\
app.get("/", (req, res) => res.status(200).send("Wisp Server is Running")); \
app.get("/health", (req, res) => res.status(200).send("OK")); \
\
const server = app.listen(port, () => { \
  console.log(`Listening on port: ${port}`); \
}); \
\
server.on("upgrade", (request, socket, head) => { \
  wisp.routeRequest(request, socket, head); \
});' > index.js

# Expose port 8080 (Required for Back4app health checks)
EXPOSE 8080

# Run the server
CMD ["node", "index.js"]
