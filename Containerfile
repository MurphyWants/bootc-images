# ENV VARs
ARG TARGET_PLATFORM="${TARGET_PLATFORM:-workstation}" # alt server
ARG TARGET_DESKTOP="${TARGET_DESKTOP:-gnome}" # alt kde cosmic
ARG TARGET_NVIDIA="${TARGET_NVIDIA:-false}" # or true

# Allow build scripts to be referenced without being copied into the final image
FROM scratch AS ctx
COPY build_files /

# Base Image
#FROM ghcr.io/ublue-os/bazzite:stable
FROM quay.io/fedora/fedora-bootc:42

## Other possible base images include:
# FROM ghcr.io/ublue-os/bazzite:latest
# FROM ghcr.io/ublue-os/bluefin-nvidia:stable
# 
# ... and so on, here are more base images
# Universal Blue Images: https://github.com/orgs/ublue-os/packages
# Fedora base image: quay.io/fedora/fedora-bootc:41
# CentOS base images: quay.io/centos-bootc/centos-bootc:stream10

### MODIFICATIONS
## make modifications desired in your image and install packages by modifying the build.sh script
## the following RUN directive does all the things required to run "build.sh" as recommended.

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/00_build.sh && \
    ostree container commit
    
### LINTING
## Verify final image and contents are correct.
RUN bootc container lint