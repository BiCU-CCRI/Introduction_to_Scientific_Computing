FROM giovtorres/slurm-docker-cluster:25.11.4

RUN dnf install -y nano sudo shadow-utils openssh-server && dnf clean all \
    && ssh-keygen -A
