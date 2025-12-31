#!/bin/bash

TAG="latest"
CI_REGISTRY_IMAGE="registry.dev.local/home-lab/pipeline-catalog"
full_path="${CI_REGISTRY_IMAGE}:${TAG}"
podman login "$CI_REGISTRY_IMAGE" -u "${GITLAB_USER}" -p "${GITLAB_TOKEN}"
podman build -t "${full_path}" .
podman push "${full_path}"