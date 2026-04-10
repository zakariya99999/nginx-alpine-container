FROM node:18-alpine

WORKDIR /app

# 1. Install build tools
RUN apk add --no-cache git python3 make g++

# 2. Clone the repo
RUN git clone https://github.com .

# 3. Install production dependencies and TypeScript
RUN npm install --production && npm install -g typescript

# 4. Force port 8081 and compile
RUN sed -i 's/port: [0-9]*/port: 8081/g' src/config.ts && npx tsc

# 5. Clean up build tools to free RAM for the app
RUN apk del git python3 make g++ && rm -rf /root/.npm

EXPOSE 8081

# 6. Run with a strict memory limit for 256MB environment
CMD ["node", "--max-old-space-size=192", "dist/index.js"]
