FROM quay.io/minio/minio:latest

USER root

COPY --from=minio/mc /usr/bin/mc /usr/bin/mc

WORKDIR /data

COPY config /config
COPY start.sh /start.sh
COPY create-bucket.sh /create-bucket.sh

RUN chmod +x /start.sh /create-bucket.sh

EXPOSE 9000
EXPOSE 9001

ENTRYPOINT ["/start.sh"]