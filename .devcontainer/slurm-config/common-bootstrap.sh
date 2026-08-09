#!/bin/bash
# Shared boot steps for every SLURM container (login node, worker nodes,
# and slurmdbd): sync our custom config, install nano, and create the
# trainee OS accounts. Must be `source`d (not executed) so it runs in the
# caller's shell before that script `exec`s the real SLURM daemon.
#
# Logs everything to a file inside the mounted repo checkout (when
# present) so boot failures are debuggable even though the container
# that crashed is gone by the time Codespaces reports the error. Kept
# outside .devcontainer/ so writing it doesn't trip VS Code's "the
# devcontainer configuration changed" rebuild prompt on every boot.
WORKSPACE_LOG_DIR=/workspaces/Introduction_to_Scientific_Computing
if [ -d "$WORKSPACE_LOG_DIR" ]; then
  exec > >(tee -a "$WORKSPACE_LOG_DIR/.bootstrap-debug.log") 2>&1
fi
echo "=== common-bootstrap.sh start: $(date -u) on $(hostname) ==="
set -x

cp -f /etc/slurm-custom/*.conf /etc/slurm-custom/*.lua /etc/slurm/

command -v nano >/dev/null 2>&1 || dnf install -y nano sudo >/dev/null 2>&1 || true

create_trainee() {
  local name="$1" uid="$2"
  id -u "$name" >/dev/null 2>&1 && return 0
  command -v useradd >/dev/null 2>&1 || dnf install -y shadow-utils >/dev/null 2>&1 || true
  useradd -m -u "$uid" -s /bin/bash -d "/home/$name" "$name" 2>&1 || true
}

# "codespace" is the devcontainer's remoteUser (submits real jobs) -
# matches the default user on the other sessions' devcontainers. The
# rest are fake trainees whose jobs give squeue/sacct realistic-looking
# output instead of an empty queue - see seed-fake-jobs.sh.
create_trainee codespace 2000
create_trainee alice     2001
create_trainee bob       2002
create_trainee carol     2003
create_trainee dave      2004
create_trainee eve       2005

mkdir -p /etc/sudoers.d 2>/dev/null || true
echo "codespace ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/codespace 2>/dev/null || true
chmod 440 /etc/sudoers.d/codespace 2>/dev/null || true

# The repo checkout is bind-mounted at /workspaces/... (separate from
# /home/codespace, so it doesn't collide with useradd's skeleton-file
# setup above) - make it writable by the trainee user.
chown -R codespace:codespace /workspaces/Introduction_to_Scientific_Computing 2>/dev/null || true

set +x
echo "=== common-bootstrap.sh done: $(date -u) ==="
