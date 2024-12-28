#!/bin/bash

echo "-------------------------------------------"
echo "Starting Foundry VTT"
echo "-------------------------------------------"
echo "Port: ${PORT}"
echo "Data dir: ${DATA_PATH}"
echo "-------------------------------------------"
echo
echo "-------------------------------------------"
echo "Data dir contents:"
echo
ls -alh $DATA_PATH
echo
echo "-------------------------------------------"
echo
node main.js --dataPath=$DATA_PATH --noupnp --port=$PORT --adminPassword=$ADMIN_PASSWORD
