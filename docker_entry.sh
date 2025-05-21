#!/bin/bash
set -e

# Load config
source ./config.env

echo "Base image: $BASE_IMAGE"
echo "Image name: $IMAGE_NAME"

# Build image
echo "👉 Building Docker image..."
docker build \
  --build-arg BASE_IMAGE=$BASE_IMAGE \
  --build-arg DEV_PACKAGES="$DEV_PACKAGES" \
  --build-arg USER_ID=$(id -u) \
  --build-arg GROUP_ID=$(id -g) \
  -t $IMAGE_NAME \
  -f Dockerfile .

# Run container
echo "🚀 Starting Docker container..."
docker run --rm -it \
  --name $CONTAINER_NAME \
  -v $HOST_SRC_PATH:$CONTAINER_SRC_PATH \
  -w $CONTAINER_SRC_PATH \
  $IMAGE_NAME \
  /bin/bash