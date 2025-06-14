FROM docker.io/alpine:latest 
RUN apk add podman \
            fuse-overlayfs \
            yq \
            jq \
            bash \ 
            wget \
            git \
            gawk \
            curl 
RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
RUN chmod 700 get_helm.sh
RUN ./get_helm.sh
RUN brew install kubeconform


# Create the insecure registry config


RUN alias awk=gawk
CMD ["bash"]