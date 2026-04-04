# Use the official lightweight NGINX Alpine image
FROM nginx:alpine

# Copy your static website files to the default NGINX directory
COPY index.html /usr/share/nginx/html/

# Expose port 80 to allow external access
EXPOSE 80
EXPOSE 443

# Start NGINX in the foreground (required to keep the container running)
CMD ["nginx", "-g", "daemon off;"]
