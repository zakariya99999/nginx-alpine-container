# Use the official lightweight NGINX Alpine image
FROM nginx:alpine

# Install curl (needed to download local.it/ngrok)
RUN apk add --no-cache curl

# Copy your static website files to the default NGINX directory
COPY index.html /usr/share/nginx/html/

# Expose port 80 to allow internal container networking
EXPOSE 80

# --- ADDED FOR TUNNELING ---
# Download and install local.it (or similar tool)
# Example using a typical tunnel binary approach
RUN curl -o /usr/local/bin/localit -s https://local.it/binary-url && \
    chmod +x /usr/local/bin/localit

# Start NGINX and the tunnel, keeping the container alive
CMD ["/bin/sh", "-c", "nginx && localit -p 80 -s zakazaka40"]
