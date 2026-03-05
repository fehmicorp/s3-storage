#!/bin/sh

echo "Starting MinIO server..."

minio server /data \
 --address "0.0.0.0:9000" \
 --console-address "0.0.0.0:9001" &

 MINIO_PID=$!

echo "Waiting for MinIO to start..."
sleep 10

echo "Configuring mc alias..."

mc alias set local http://127.0.0.1:9000 $MINIO_ROOT_USER $MINIO_ROOT_PASSWORD

echo "Creating system buckets..."

mc mb --ignore-existing local/system-trash
mc mb --ignore-existing local/system-archive
mc mb --ignore-existing local/assets

mc ilm import local/system-trash /config/lifecycle-trash.json

echo "Setting public readonly access to developer assets..."

mc anonymous set download local/assets

echo "Creating policies..."

mc admin policy create local def-policy /config/def-policy.json
mc admin policy create local asset-policy /config/asset-policy.json

echo "MinIO initialization completed."

wait $MINIO_PID