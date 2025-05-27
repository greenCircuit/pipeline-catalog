#!/bin/bash

# Exit script if command fails or uninitialized variables used
# set -euo pipefail
# GLOBAL VARS
UPDATE_SEMVER="false"


# get latest semver for default branch
GIT_TAGS=$(git tag --merged main --list '[0-9]*.[0-9]*.[0-9]*') # use regex to find correct semver tag
GIT_TAG_LATEST=$(echo "$GIT_TAGS" | tail -n 1)                  

# If no tag found, set to default
if [ -z "$GIT_TAG_LATEST" ]; then
    echo "Dint find git tag, setting default"
    GIT_TAG_LATEST="0.0.0"
else
    echo "Latest tag found     ${GIT_TAG_LATEST}"
fi

# not update semver if not default branch
if [[ "$(git branch)" != "${CI_DEFAULT_BRANCH}" ]]; then
    echo "Not updating semver,not on default branch"
    exit 0
fi


VERSION_TYPE=""
latestCommit="$(git log -1 --pretty=%B)" # get commit message
patchRegex="^(fix|docs):"
minorRegex="^(feat|feature):"
majorRegex="^(major):"

# use regex to determine what changed
if [[ $latestCommit =~ ${patchRegex} ]]; then
    VERSION_TYPE="patch"
elif [[ $latestCommit =~ ${minorRegex} ]]; then
    VERSION_TYPE="minor"
elif [[ $latestCommit =~ ${majorRegex} ]]; then
    VERSION_TYPE="major"
fi
echo "VERSION_TYPE:   ${VERSION_TYPE}"

# update semver if forgot to provide string
if [[ $CI_PIPELINE_SOURCE == 'merge_request_event' && ${VERSION_TYPE} == "" ]]; then
    VERSION_TYPE="patch"
fi

# update semver when merge or main was provided with semver
if [[ VERSION_TYPE != "" ]]; then
    VERSION_NEXT=""
    if [ "$VERSION_TYPE" = "patch" ]; then
        VERSION_NEXT="$(echo "$GIT_TAG_LATEST" | awk -F. '{$NF++; print $1"."$2"."$NF}')"           # patch version
    elif [ "$VERSION_TYPE" = "minor" ]; then
        VERSION_NEXT="$(echo "$GIT_TAG_LATEST" | awk -F. '{$2++; $3=0; print $1"."$2"."$3}')"       # minor version
    elif [ "$VERSION_TYPE" = "major" ]; then
        VERSION_NEXT="$(echo "$GIT_TAG_LATEST" | awk -F. '{$1++; $2=0; $3=0; print $1"."$2"."$3}')" # major version
    printf "\nError: invalid VERSION_TYPE arg passed, must be 'patch', 'minor' or 'major'\n\n"
      exit 1
    fi
else
    echo "not updating version"
if 

echo ${VERSION_NEXT}