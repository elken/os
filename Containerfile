ARG FEDORA_VERSION=39

FROM quay.io/fedora-ostree-desktops/sericea:$FEDORA_VERSION

COPY usr /usr

COPY --from=ghcr.io/babashka/babashka:latest /usr/local/bin/bb /usr/bin/bb

RUN rpm-ostree override remove firefox firefox-langpacks toolbox && \
    rpm-ostree install distrobox && \

    # Enable automatic update staging
    sed -i 's/#AutomaticUpdatePolicy.*/AutomaticUpdatePolicy=stage/' /etc/rpm-ostreed.conf && \
    systemctl enable rpm-ostreed-automatic.timer && \
    rpm-ostree cleanup -m && \

    # Build the image
    ostree container commit