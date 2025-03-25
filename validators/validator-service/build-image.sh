#!/bin/bash

# Build and push the validator base image

set -e  # Exit on error

echo "=== Building validator-base image ==="

# Check if Docker is available
if ! command -v docker &> /dev/null; then
    echo "Error: Docker is not installed or not in PATH"
    exit 1
fi

# Build the image
echo "Building validator-base:latest..."
docker build -t validator-base:latest .

echo "Image built successfully."
echo "To push to a registry, use:"
echo "docker tag validator-base:latest <registry>/validator-base:latest"
echo "docker push <registry>/validator-base:latest"
echo
echo "For local kind cluster, use:"
echo "kind load docker-image validator-base:latest"