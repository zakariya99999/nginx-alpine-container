# Use the official lightweight NGINX Alpine image
FROM nginx:alpine

# Install Node.js and the localtunnel client
RUN apk add --no-cache nodejs npm && \
    npm install -g localtunnel

# Copy your static website files
COPY index.html /usr/share/nginx/html/

# Expose port 80 for NGINX
EXPOSE 80

# Start NGINX in the background and then start localtunnel
# localtunnel will request the specific subdomain 'zakazaka40'
CMD nginx -g "daemon on;" && lt --port 80 --subdomain zakazaka40
