#!/bin/bash

# Build and push the validator function image

set -e  # Exit on error

echo "=== Building validator-function image ==="

# Check if Docker is available
if ! command -v docker &> /dev/null; then
    echo "Error: Docker is not installed or not in PATH"
    exit 1
fi

# Build the image
echo "Building validator-function:latest..."
docker build -t validator-function:latest .

echo "Image built successfully."
echo "To push to a registry, use:"
echo "docker tag validator-function:latest <registry>/validator-function:latest"
echo "docker push <registry>/validator-function:latest"
echo
echo "For local kind cluster, use:"
echo "kind load docker-image validator-function:latest"