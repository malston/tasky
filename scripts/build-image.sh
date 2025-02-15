#!/usr/bin/env bash

# Make sure your PAT has the necessary permissions: read:packages, write:packages, and delete:packages
# Images in GHCR are private by default. You can make them public in your GitHub package settings

set -o errexit
set -o nounset

if [ -z "$GITHUB_TOKEN" ]; then
  echo "GITHUB_PAT is not set. Please set it before running this script."
  exit 1
fi

REGISTRY="${REGISTRY:-ghcr.io}"
GITHUB_USERNAME="${GITHUB_USERNAME:-malston}"
IMAGE_NAME="${IMAGE_NAME:-tasky}"
DOCKER_TAG="${DOCKER_TAG:-latest}"
PLATFORM="${PLATFORM:-linux/amd64}"

echo "$GITHUB_TOKEN" | docker login "$REGISTRY" -u "$GITHUB_USERNAME" --password-stdin

docker build --platform "$PLATFORM" -t "$REGISTRY/$GITHUB_USERNAME/$IMAGE_NAME:$DOCKER_TAG" .

docker push "$REGISTRY/$GITHUB_USERNAME/$IMAGE_NAME:$DOCKER_TAG"
docker pull "$REGISTRY/$GITHUB_USERNAME/$IMAGE_NAME:$DOCKER_TAG"
