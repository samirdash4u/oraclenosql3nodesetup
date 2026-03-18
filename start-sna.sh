#!/bin/bash
set -e

KVHOME=$(ls -d /app/kv-*)
cd $KVHOME

echo "Starting SNA on $SN_NAME..."

# Ensure directories exist (CRITICAL FIX)
mkdir -p /kvroot/data
mkdir -p /kvroot/admin
mkdir -p /kvroot/logs

# Fix permissions (important for container user)
chmod -R 755 /kvroot

# Create boot config (idempotent)
if [ ! -f /kvroot/config.xml ]; then
  echo "Creating boot config..."

  java -jar lib/kvstore.jar makebootconfig \
  -root /kvroot \
  -host $SN_NAME \
  -port $SN_PORT \
  -harange ${SN_HA_RANGE/-/,} \
  -servicerange ${SN_SERVICE_RANGE/-/,} \
  -storagedir /kvroot/data \
  -storagedirsize 10_gb \
  -admindir /kvroot/admin \
  -admindirsize 1_gb \
  -rnlogdir /kvroot/logs \
  -capacity 1 \
  -memory_mb 2048 \
  -num_cpus 2 \
  -store-security none \
  -mgmt jmx \
  -force 
fi

echo "Starting Storage Node Agent..."

java -Xmx256m -Xms128m -jar lib/kvstore.jar start -root /kvroot &

echo "SNA started on $SN_NAME"

# Keep container alive
tail -f /dev/null
