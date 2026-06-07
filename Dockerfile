FROM debian:trixie-slim

RUN apt-get update && apt-get install -y \
    sudo \
    # for codex vscode extension
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

ARG UID
ARG GID

RUN set -eux; \
    if ! getent group $GID; then \
        groupadd --gid $GID x; \
    fi; \
    useradd \
        --uid $UID \
        --gid $GID \
        --groups sudo \
        --shell /home/x/.nix-profile/bin/bash \
        --create-home x;

USER $UID

ENV USER=x

WORKDIR /work
