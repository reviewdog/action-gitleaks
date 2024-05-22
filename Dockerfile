FROM alpine:3.20

ENV REVIEWDOG_VERSION=v0.15.0
ENV GITLEAKS_VERSION=8.18.0

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

# hadolint ignore=DL3018
RUN apk --no-cache add git jq

RUN wget -O - -q https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh \
    | sh -s -- -b /usr/local/bin/ ${REVIEWDOG_VERSION}

RUN mkdir -p /opt/gitleaks

RUN wget -O - -q "https://github.com/gitleaks/gitleaks/releases/download/v${GITLEAKS_VERSION}/gitleaks_${GITLEAKS_VERSION}_linux_x64.tar.gz" \
    | tar -xvz -C /opt/gitleaks

RUN ln -s /opt/gitleaks/gitleaks /usr/local/bin/gitleaks

COPY gitleaks-to-rdjson.jq /gitleaks-to-rdjson.jq

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
