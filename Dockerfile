FROM node:18-alpine
WORKDIR /app
RUN apk add --no-cache python3 make g++
COPY . .
RUN npm install --production && npm install -g typescript
RUN sed -i 's/port: [0-9]*/port: 8081/g' src/config.ts && npx tsc
RUN apk del python3 make g++ && rm -rf /root/.npm
EXPOSE 8081
CMD ["node", "--max-old-space-size=192", "dist/index.js"]
