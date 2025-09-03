FROM alpine:3.20

ENV REVIEWDOG_VERSION=v0.21.0
ENV GITLEAKS_VERSION=8.18.0

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

# hadolint ignore=DL3018
RUN apk --no-cache add git jq

RUN wget -O - -q https://raw.githubusercontent.com/reviewdog/reviewdog/fd59714416d6d9a1c0692d872e38e7f8448df4fc/install.sh \
    | sh -s -- -b /usr/local/bin/ ${REVIEWDOG_VERSION}

RUN mkdir -p /opt/gitleaks

RUN if [ "$(uname -m)" = "aarch64" ]; then \
      DIST="linux_arm64"; \
    else \
      DIST="linux_x64"; \
    fi && \
    wget -O - -q "https://github.com/gitleaks/gitleaks/releases/download/v${GITLEAKS_VERSION}/gitleaks_${GITLEAKS_VERSION}_${DIST}.tar.gz" \
    | tar -xvz -C /opt/gitleaks

RUN ln -s /opt/gitleaks/gitleaks /usr/local/bin/gitleaks

COPY gitleaks-to-rdjson.jq /gitleaks-to-rdjson.jq

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
