#!/bin/bash
# Shared boot steps for every SLURM container (login node, worker nodes,
# and slurmdbd): sync our custom config, install nano, and create the
# trainee OS accounts. Must be `source`d (not executed) so it runs in the
# caller's shell before that script `exec`s the real SLURM daemon.
set -e

cp -f /etc/slurm-custom/*.conf /etc/slurm-custom/*.lua /etc/slurm/

command -v nano >/dev/null 2>&1 || dnf install -y nano sudo >/dev/null 2>&1 || true

create_trainee() {
  local name="$1" uid="$2"
  id -u "$name" >/dev/null 2>&1 || useradd -m -u "$uid" -s /bin/bash -d "/home/$name" "$name"
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

mkdir -p /etc/sudoers.d
echo "codespace ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/codespace
chmod 440 /etc/sudoers.d/codespace

# The repo checkout is bind-mounted at /workspaces/... (separate from
# /home/codespace, so it doesn't collide with useradd's skeleton-file
# setup above) - make it writable by the trainee user.
chown -R codespace:codespace /workspaces/Introduction_to_Scientific_Computing 2>/dev/null || true
