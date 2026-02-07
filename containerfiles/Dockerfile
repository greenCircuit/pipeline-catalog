FROM docker.io/alpine:latest 
RUN apk add buildah \
            skopeo \
            fuse-overlayfs \ 
            yq \
            jq \
            bash \ 
            wget \
            git \
            gawk \
            curl \
            openssl 

RUN alias awk=gawk
CMD ["bash"]