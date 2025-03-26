#!/bin/bash

# Script to synchronize documentation between GitBook and package repositories
# Usage: ./sync-docs.sh [--push|--pull]

set -e

BASE_DIR=$(dirname "$(realpath "$0")")
PACKAGES_DIR=$(realpath "$BASE_DIR/..")

# List of packages
PACKAGES=(
  "flight-check"
  "jolly-packager"
  "porter"
  "second-star" 
  "shadow"
  "sole"
  "tapped"
)

# Function to copy docs from GitBook to packages
function push_docs() {
  echo "Pushing docs from GitBook to packages..."
  
  for package in "${PACKAGES[@]}"; do
    echo "Processing $package..."
    
    # Create docs directory if it doesn't exist
    mkdir -p "$PACKAGES_DIR/$package/docs"
    
    # Copy docs from GitBook to package
    if [ -d "$BASE_DIR/$package" ]; then
      cp -v "$BASE_DIR/$package/"*.md "$PACKAGES_DIR/$package/docs/"
      echo "✅ $package docs updated"
    else
      echo "⚠️ $package directory not found in GitBook"
    fi
  done
}

# Function to copy docs from packages to GitBook
function pull_docs() {
  echo "Pulling docs from packages to GitBook..."
  
  for package in "${PACKAGES[@]}"; do
    echo "Processing $package..."
    
    # Create GitBook package directory if it doesn't exist
    mkdir -p "$BASE_DIR/$package"
    
    # Copy docs from package to GitBook
    if [ -d "$PACKAGES_DIR/$package/docs" ]; then
      cp -v "$PACKAGES_DIR/$package/docs/"*.md "$BASE_DIR/$package/"
      echo "✅ $package docs updated in GitBook"
    else
      echo "⚠️ $package/docs directory not found"
    fi
  done
  
  # Update SUMMARY.md
  echo "Don't forget to update SUMMARY.md if new documentation files were added"
}

# Parse command line arguments
case "$1" in
  --push)
    push_docs
    ;;
  --pull)
    pull_docs
    ;;
  *)
    echo "Usage: $0 [--push|--pull]"
    echo "--push: Copy docs from GitBook to packages"
    echo "--pull: Copy docs from packages to GitBook"
    exit 1
    ;;
esac

echo "Documentation synchronization complete!" 