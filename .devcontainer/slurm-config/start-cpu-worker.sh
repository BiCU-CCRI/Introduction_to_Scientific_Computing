#!/bin/bash
# Custom cpu-worker startup, replacing the image's built-in `slurmd-cpu`
# command so nodes register as node001, node002, ... instead of c1, c2.
set -e

source /etc/slurm-custom/common-bootstrap.sh

echo "---> Starting the MUNGE Authentication service (munged) ..."
gosu munge /usr/sbin/munged

echo "---> Waiting for slurmctld to become active before starting dynamic slurmd..."
until 2>/dev/null >/dev/tcp/slurmctld/6817; do
  echo "-- slurmctld is not available. Sleeping ..."
  sleep 2
done
echo "-- slurmctld is now active ..."

# Same replica-detection trick the base image uses: Compose names scaled
# containers <project>-cpu-worker-<N>, so match our own IP against that
# DNS pattern to recover N deterministically.
detect_replica_number() {
  local service_name="$1" max_replicas="${2:-64}" my_ip resolved i
  my_ip=$(hostname -i 2>/dev/null | awk '{print $1}')
  for i in $(seq 1 "$max_replicas"); do
    resolved=$(getent hosts "${COMPOSE_PROJECT_NAME}-${service_name}-${i}" 2>/dev/null | awk '{print $1}')
    if [ "$resolved" = "$my_ip" ]; then
      echo "$i"
      return 0
    elif [ -z "$resolved" ]; then
      break
    fi
  done
  hostname
  return 1
}

REPLICA=$(detect_replica_number "cpu-worker")
NODE_NAME=$(printf "node%03d" "$REPLICA")
hostname "${NODE_NAME}"

echo "---> Dynamic CPU worker registering as: ${NODE_NAME}"
exec /usr/sbin/slurmd -Z -Dvvv --conf "Feature=cpu"
