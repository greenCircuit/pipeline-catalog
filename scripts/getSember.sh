#!/bin/bash
#!/usr/bin/env bash
 
# Exit script if command fails or uninitialized variables used
set -euo pipefail

# ==================================
# Get latest version from git tags
# ==================================
 
# List git tags sorted lexicographically
# so version numbers sorted correctly
GIT_TAGS=$(git tag --sort=version:refname)
 
# Get last line of output which returns the
# last tag (most recent version)
GIT_TAG_LATEST=$(echo "$GIT_TAGS" | tail -n 1)
 
# If no tag found, set to default
if [ -z "$GIT_TAG_LATEST" ]; then
    echo "Dint find git tag, setting default"
    GIT_TAG_LATEST="0.0.0"
else
    echo "Latest tag found     ${GIT_TAG_LATEST}"
fi
 
# Get version type from first argument passed to script
VERSION_TYPE="${1-}"
VERSION_NEXT=""
 
if [ "$VERSION_TYPE" = "patch" ]; then
  # Increment patch version
  VERSION_NEXT="$(echo "$GIT_TAG_LATEST" | awk -F. '{$NF++; print $1"."$2"."$NF}')"
elif [ "$VERSION_TYPE" = "minor" ]; then
  # Increment minor version
  VERSION_NEXT="$(echo "$GIT_TAG_LATEST" | awk -F. '{$2++; $3=0; print $1"."$2"."$3}')"
elif [ "$VERSION_TYPE" = "major" ]; then
  # Increment major version
  VERSION_NEXT="$(echo "$GIT_TAG_LATEST" | awk -F. '{$1++; $2=0; $3=0; print $1"."$2"."$3}')"
else
  # Print error for unknown versioning type
  printf "\nError: invalid VERSION_TYPE arg passed, must be 'patch', 'minor' or 'major'\n\n"
  # Exit with error code
  exit 1
fi

echo ${VERSION_NEXT}
 
