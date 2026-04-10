# STAGE 1: Build the proxy
FROM golang:1.21-alpine AS builder

# Install build dependencies
RUN apk add --no-cache git

# Clone the EaglerProxy repository
WORKDIR /build
RUN git clone https://github.com .

# Build the executable
RUN go build -o eaglerproxy .

# STAGE 2: Create the final production image
FROM alpine:latest
WORKDIR /app

# Copy the binary from the builder stage
COPY --from=builder /build/eaglerproxy .

# Create the configuration file with your specific requirements
RUN echo 'bind_address: "0.0.0.0:8080"' > config.yml && \
    echo 'forward_address: "127.0.0.1:25565"' >> config.yml && \
    echo 'forward_mode: "redirect"' >> config.yml && \
    echo 'motd: "§4zakas java proxy"' >> config.yml && \
    echo 'max_players: 107' >> config.yml

# Back4App uses port 8080 by default for containers
EXPOSE 8080

# Start the proxy
CMD ["./eaglerproxy"]
