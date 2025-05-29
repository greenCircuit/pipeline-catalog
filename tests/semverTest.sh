#!/bin/bash
export CI_DEFAULT_BRANCH="main"
export CI_COMMIT_BRANCH="main"
export CI_COMMIT_MESSAGE="fix: test"
./scripts/getSemver.sh