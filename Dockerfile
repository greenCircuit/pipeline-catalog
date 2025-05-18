FROM quay.io/podman/stable:latest

# Create the insecure registry config
RUN mkdir -p /etc/containers && \
    echo 'unqualified-search-registries = ["docker.io"]' > /etc/containers/registries.conf && \
    echo '' >> /etc/containers/registries.conf && \
    echo '[[registry]]' >> /etc/containers/registries.conf && \
    echo 'location = "registry.dev.local"' >> /etc/containers/registries.conf && \
    echo 'insecure = true' >> /etc/containers/registries.conf