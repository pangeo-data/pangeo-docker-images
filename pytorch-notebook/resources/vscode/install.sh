#!/bin/bash
set -e

# Code server setup
cp resources/vscode/start-notebook-vscode.sh /usr/local/bin/
chmod +x /usr/local/bin/start-notebook-vscode.sh
mkdir -p /opt/code-server
cp resources/vscode/user-settings.py /opt/code-server/user-settings.py
cd /opt/code-server
curl -fsSL https://code-server.dev/install.sh | \
    sh -s -- --prefix /opt/code-server --method standalone

export PATH=/opt/code-server/bin:$PATH
export VSCODE_EXTENSIONS=/opt/code-server/extensions
export NODE_EXTRA_CA_CERTS=/etc/ssl/certs/ca-certificates.crt

# Install extensions with retry
retry() {
  local -r -i max_attempts=10
  local -i attempt_num=1

  until "$@"; do
    if (( attempt_num == max_attempts )); then
      echo "Attempt $attempt_num failed! No more retries left."
      return 1
    else
      echo "Attempt $attempt_num failed! Trying again in 2 seconds..."
      sleep 2
    fi

    attempt_num=$(( attempt_num + 1 ))
  done
}

retry bash -c "mkdir -p $VSCODE_EXTENSIONS && \
    chmod +rX /opt/code-server/user-settings.py && \
    code-server --install-extension ms-toolsai.jupyter --extensions-dir $VSCODE_EXTENSIONS && \
    code-server --install-extension ms-python.python --extensions-dir $VSCODE_EXTENSIONS && \
    code-server --install-extension mhutchie.git-graph --extensions-dir $VSCODE_EXTENSIONS && \
    code-server --install-extension eamodio.gitlens --extensions-dir $VSCODE_EXTENSIONS && \
    layer-cleanup.sh"