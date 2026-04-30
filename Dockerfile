
FROM node:20-alpine


WORKDIR /app

RUN apk add --no-cache python3 make g++

RUN npm init -y && \
    npm install @mercuryworkshop/wisp-js express

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
