#!/usr/bin/env bash
set -euo pipefail

echo 'Starting Druid cluster...'
$DRUID_DIR/run.sh &

# Esperar a que el middleManager esté disponible
check_health() {
    nc -z localhost 8091 || return 1
    [[ "$(curl -s http://localhost:8091/status/health)" == "true" ]]
}

echo "Waiting for Druid to become healthy..."
until check_health; do
    sleep 5
done

echo 'Ingesting data...'
$DRUID_DIR/ingest.sh

# Mantener el contenedor corriendo
wait
