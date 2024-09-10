# Use the official Ubuntu image from the Docker Hub's official repository
FROM ubuntu:22.04 AS base

# Import necessary tools for signature verification and removing unnecessary services
RUN apt-get update && \
    apt-get install -y wget gnupg2 dirmngr && \
    rm -rf /var/lib/apt/lists/*

# Define the public key used for verifying the image signature
# Replace <keyserver> with the appropriate keyserver for your repository, and <key> with the key ID
RUN gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys <key>

# Download the image signature file (if available) and verify it
RUN wget https://path-to-image-signature/signature.asc -O /tmp/signature.asc && \
    wget https://path-to-image-manifest/manifest.asc -O /tmp/manifest.asc && \
    gpg --verify /tmp/signature.asc /tmp/manifest.asc

# Remove unnecessary services (example: remove services like cron, etc.)
RUN apt-get update && \
    apt-get purge -y cron && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Rebuild the verified image without the unnecessary services
FROM base AS final

# Install necessary base tools (you can customize this part depending on your needs)
RUN apt-get update && \
    apt-get install -y curl && \
    rm -rf /var/lib/apt/lists/*


