#!/bin/bash

echo "Starting MinIO..."

minio server /data \
  --address "0.0.0.0:9000" \
  --console-address "0.0.0.0:9001" &

MINIO_PID=$!

echo "Waiting for MinIO..."

until mc alias set local http://127.0.0.1:9000 $MINIO_ROOT_USER $MINIO_ROOT_PASSWORD
do
  sleep 2
done

echo "Creating buckets..."

mc mb --ignore-existing local/system-trash
mc mb --ignore-existing local/system-archive
mc mb --ignore-existing local/assets

echo "Applying lifecycle..."

mc ilm import local/system-trash < /config/lifecycle-trash.json

echo "Public read assets..."

mc anonymous set download local/assets

echo "Starting nginx..."

nginx

wait $MINIO_PID