#
# Image for building static site
#
FROM alpine:latest AS builder

RUN apk update && apk add make hugo bash wget && rm -rf /var/cache/apk/*

#
# Image for pushing to s3
#
FROM alpine:latest AS pusher

ENV MINIO_DOWNLOAD_PAGE https://dl.min.io/client/mc/release/linux-amd64/mc
ENV MINIO_RELEASE RELEASE.2020-08-20T00-23-01Z
ENV MINIO_SHA256SUM 1d3b0fa2eda000c15ec3600ecd691b95e1d8ea216dcf7425fa5706fef9db6162

RUN apk update && apk add make wget && rm -rf /var/cache/apk/*
# Install minio client for uploading to S3
RUN wget --quiet ${MINIO_DOWNLOAD_PAGE}.${MINIO_RELEASE} && \
  echo "${MINIO_SHA256SUM}  mc.${MINIO_RELEASE}" > mc-sha256sum && \
  sha256sum -c mc-sha256sum -s && \
  mv mc.${MINIO_RELEASE} /bin/mc && \
  chmod +x /bin/mc
