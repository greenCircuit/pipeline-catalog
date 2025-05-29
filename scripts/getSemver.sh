#!/bin/bash

# Exit script if command fails or uninitialized variables used
# set -euo pipefail
# GLOBAL VARS
patchRegex="^(fix|docs):"
minorRegex="^(feat|feature):"
majorRegex="^(major):"
# get latest semver for default branch
git fetch --all  # get tags from remote 
GIT_TAGS=$(git tag --merged origin/main --list '[0-9]*.[0-9]*.[0-9]*') # use regex to find correct semver tag

GIT_TAG_LATEST=$(echo "$GIT_TAGS" | tail -n 1)                  
echo "GIT_TAG_LATEST:      ${GIT_TAG_LATEST}"
# If no tag found, set to default
if [ -z "$GIT_TAG_LATEST" ]; then
    echo "Dint find git tag, setting default"
    GIT_TAG_LATEST="0.0.0"
else
    echo "Latest tag found     ${GIT_TAG_LATEST}"
fi

# not update semver if not default branch
if [[ "$(git rev-parse --abbrev-ref HEAD)" != "${CI_DEFAULT_BRANCH}" ]]; then
    echo "Not updating semver,not on default branch"
    echo "SEMVER=${VERSION_NEXT}"
    echo "SEMVER=${GIT_TAG_LATEST}" > semver.env
    exit 0
fi


VERSION_TYPE=""
latestCommit="$(git log -1 --pretty=%B)" # get commit message
echo "commit message:      ${latestCommit}"

# use regex to determine what changed
if [[ $latestCommit =~ ${patchRegex} ]]; then
    VERSION_TYPE="patch"
elif [[ $latestCommit =~ ${minorRegex} ]]; then
    VERSION_TYPE="minor"
elif [[ $latestCommit =~ ${majorRegex} ]]; then
    VERSION_TYPE="major"
fi

echo "VERSION_TYPE:        ${VERSION_TYPE}"
# update semver if forgot to provide string
if [[ $CI_PIPELINE_SOURCE == 'merge_request_event' && ${VERSION_TYPE} == "" ]]; then
    VERSION_TYPE="patch"
else
    echo version cant be determined, exiting
    exit 1
fi
echo "Final Version Type  ${VERSION_TYPE}"
# update semver when merge or main was provided with semver
VERSION_NEXT=""
if [[ $VERSION_TYPE != "" ]]; then
    echo "updating semver"
    if [ "$VERSION_TYPE" = "patch" ]; then
        VERSION_NEXT=$(echo "$GIT_TAG_LATEST" | awk -F. '{ $NF++; print $1 "." $2 "." $NF }')
    elif [ "$VERSION_TYPE" = "minor" ]; then
        VERSION_NEXT=$(echo "$GIT_TAG_LATEST" | awk -F. '{ $2++; $3=0; print $1 "." $2 "." $3 }')
    elif [ "$VERSION_TYPE" = "major" ]; then
        VERSION_NEXT=$(echo "$GIT_TAG_LATEST" | awk -F. '{ $1++; $2=0; $3=0; print $1 "." $2 "." $3 }')
    else
        echo "Not updating version, VERSION_TYPE can only be patch, minor, major"
    fi
fi

echo "Next Version: ${VERSION_NEXT}"
echo "SEMVER=${VERSION_NEXT}" > semver.env