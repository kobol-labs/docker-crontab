FROM alpine:latest

ENV HOME_DIR=/opt/crontab

RUN apk add --no-cache \
    bash \
    curl \
    gettext \
    jq \
    yq \
    tini \
    tzdata \
    docker-cli \
    && mkdir -p ${HOME_DIR}/jobs ${HOME_DIR}/projects \
    && adduser -S docker -D

COPY docker-entrypoint /docker-entrypoint
RUN chmod +x /docker-entrypoint

ENTRYPOINT ["/sbin/tini", "--", "/docker-entrypoint"]

HEALTHCHECK --interval=5s --timeout=3s \
    CMD ps aux | grep '[c]rond' || exit 1

CMD ["crond", "-f", "-d", "6", "-c", "/etc/crontabs"]
