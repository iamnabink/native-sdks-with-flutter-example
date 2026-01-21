#!/bin/bash

# Script to move Flutter AAR build outputs to a local maven repository
# This script moves files from ../../flutter_sdk/build/host/outputs/repo to maven-repo/
#
# Usage: ./move_to_maven_repo.sh
# Or: bash move_to_maven_repo.sh

# Don't exit on error immediately - we want to handle errors gracefully
set +e

# Get the script's directory (where the script is located)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR" || exit 1

# Define paths - try multiple possible locations
# First try: relative to script location (flutter_sdk is in same directory)
SOURCE_DIR="flutter_sdk/build/host/outputs/repo"
DEST_DIR="maven-repo"

# If not found, try alternative paths
if [ ! -d "$SOURCE_DIR" ]; then
    # Try: ../../flutter_sdk/build/host/outputs/repo (if script is in a subdirectory)
    if [ -d "../../flutter_sdk/build/host/outputs/repo" ]; then
        SOURCE_DIR="../../flutter_sdk/build/host/outputs/repo"
    # Try: ../flutter_sdk/build/host/outputs/repo
    elif [ -d "../flutter_sdk/build/host/outputs/repo" ]; then
        SOURCE_DIR="../flutter_sdk/build/host/outputs/repo"
    fi
fi

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Debug: Show what we're checking
print_info "Checking for source directory..."
print_info "Current directory: $(pwd)"
print_info "Looking for: $SOURCE_DIR"

# Check if source directory exists
if [ ! -d "$SOURCE_DIR" ]; then
    print_error "Source directory '$SOURCE_DIR' does not exist!"
    print_warning "This usually means you haven't run 'flutter build aar' yet."
    print_info "Please run the following command from the flutter_sdk directory:"
    echo "  cd flutter_sdk"
    echo "  flutter build aar"
    print_info "Then re-run this script."
    print_info ""
    print_info "Searched paths:"
    echo "  - flutter_sdk/build/host/outputs/repo"
    echo "  - ../../flutter_sdk/build/host/outputs/repo"
    echo "  - ../flutter_sdk/build/host/outputs/repo"
    exit 1
fi

# Convert to absolute path for better error messages
SOURCE_DIR_ABS="$(cd "$SOURCE_DIR" && pwd)"
print_info "Found source directory: $SOURCE_DIR_ABS"

# Check if source directory is empty
if [ -z "$(ls -A "$SOURCE_DIR" 2>/dev/null)" ]; then
    print_error "Source directory '$SOURCE_DIR_ABS' is empty!"
    print_warning "This usually means the 'flutter build aar' command didn't complete successfully."
    print_info "Please ensure the Flutter build completed without errors and try again."
    exit 1
fi

# Create destination directory if it doesn't exist
if [ ! -d "$DEST_DIR" ]; then
    print_info "Creating destination directory '$DEST_DIR'..."
    mkdir -p "$DEST_DIR"
    if [ $? -ne 0 ]; then
        print_error "Failed to create destination directory '$DEST_DIR'"
        exit 1
    fi
fi

# Move files from source to destination
print_info "Moving files from '$SOURCE_DIR_ABS' to '$DEST_DIR'..."

# Use absolute path for source to avoid issues
if mv "$SOURCE_DIR_ABS"/* "$DEST_DIR"/ 2>/dev/null; then
    print_info "Successfully moved all files to '$DEST_DIR'"

    # Verify the move was successful
    if [ -z "$(ls -A "$SOURCE_DIR_ABS" 2>/dev/null)" ]; then
        print_info "Source directory is now empty - move completed successfully"
    else
        print_warning "Some files may still remain in the source directory"
    fi
else
    print_error "Failed to move files from '$SOURCE_DIR_ABS' to '$DEST_DIR'"
    print_info "Attempting to list source directory contents..."
    ls -la "$SOURCE_DIR_ABS" 2>&1 | head -10 || true
    exit 1
fi

print_info "Script completed successfully!"
print_info "You can now reference the local maven repository in your build.gradle:"
echo "  maven {"
echo "      url '\$rootDir/$DEST_DIR'"
echo "  }"