# Use the official lightweight NGINX Alpine image
FROM nginx:alpine

# Install Node.js, npm, and localtunnel
RUN apk add --no-cache nodejs npm && \
    npm install -g localtunnel

# Copy your static website files
COPY index.html /usr/share/nginx/html/

# Expose ports
EXPOSE 80

# Create a startup script to run both NGINX and Localtunnel
RUN echo "#!/bin/sh\nnginx -g 'daemon off;' & sleep 5 && lt --port 80" > /start.sh && \
    chmod +x /start.sh

# Start the script
CMD ["/start.sh"]
