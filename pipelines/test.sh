#!/bin/bash
echo "FILE_PATH:         ${FILE_PATH}"
echo "REGISTRY_PATH:     ${REGISTRY_PATH}"


if [[ "$CI_COMMIT_REF_NAME" = "$CI_DEFAULT_BRANCH" ]]; then
    TAG="latest"
else
    TAG=${CI_COMMIT_BRANCH}
fi

if [[ $REGISTRY_PATH != "" ]]; then
    echo "pushing image to sub registry"
    CI_REGISTRY_IMAGE="${CI_REGISTRY_IMAGE}/${REGISTRY_PATH}"
else  
    echo "uploading to root path of registry"    
fi


echo "IMG tag:         ${TAG}"
echo "Registry:        ${CI_REGISTRY_IMAGE}"
buildah login --tls-verify=false $CI_REGISTRY_IMAGE -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD
echo "Building the image..."
buildah bud -t "${CI_REGISTRY_IMAGE}:${TAG}" -f "${FILE_PATH}"

echo "Pushing the image..."
buildah push --tls-verify=false  "${CI_REGISTRY_IMAGE}:${TAG}"
