#!/bin/sh

CLIENT_ID=$1

mc mb local/$CLIENT_ID
mc mb local/system-trash/$CLIENT_ID
mc mb local/system-archive/$CLIENT_ID

mc version enable local/$CLIENT_ID

echo "Client storage created for $CLIENT_ID"