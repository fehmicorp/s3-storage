FROM quay.io/minio/minio:latest

USER root

# copy mc client from official image
COPY --from=minio/mc /usr/bin/mc /usr/bin/mc

WORKDIR /data

EXPOSE 9000
EXPOSE 9001

COPY start.sh /start.sh
COPY config /config

RUN chmod +x /start.sh

ENTRYPOINT ["/start.sh"]