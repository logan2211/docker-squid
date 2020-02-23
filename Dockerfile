FROM busybox:latest as entrypoint

ENV TINI_VERSION v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

FROM debian:latest
ARG SQUID_VERSION=4.6-1+deb10u1

LABEL maintainer="Logan V. <logan2211@gmail.com>"

COPY --from=entrypoint /tini /entrypoint.sh /

RUN apt-get update && \
    apt-get install -y --no-install-recommends squid=${SQUID_VERSION} && \
    rm -rf /var/lib/apt/lists/*

EXPOSE 3128/tcp

USER proxy
ENTRYPOINT ["/tini", "--", "/entrypoint.sh"]
