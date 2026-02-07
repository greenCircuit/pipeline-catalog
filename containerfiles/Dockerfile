FROM docker.io/alpine:latest 
RUN apk add buildah \
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