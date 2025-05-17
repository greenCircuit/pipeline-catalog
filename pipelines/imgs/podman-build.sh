#!/bin/bash
if [ "$CI_COMMIT_REF_NAME" = "$CI_DEFAULT_BRANCH" ]; then
    TAG="latest"
else
    TAG=${CI_COMMIT_BRANCH}
fi