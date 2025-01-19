ARG FEDORA_VERSION=41

FROM quay.io/fedora-ostree-desktops/sway-atomic:$FEDORA_VERSION

COPY usr /usr

COPY --from=ghcr.io/babashka/babashka:latest /usr/local/bin/bb /usr/bin/bb
COPY --from=ghcr.io/charmbracelet/gum:latest /usr/local/bin/gum /usr/bin/gum

RUN rpm-ostree override remove firefox firefox-langpacks toolbox && \
    rpm-ostree install bat direnv lsd keychain zsh distrobox && \

    # Enable automatic update staging
    sed -i 's/#AutomaticUpdatePolicy.*/AutomaticUpdatePolicy=stage/' /etc/rpm-ostreed.conf && \
    systemctl enable rpm-ostreed-automatic.timer && \
    rpm-ostree cleanup -m && \

    # Build the image
    ostree container commit
