#!/bin/bash
set -e

SERVICE_NAME="antigravity-manager"
IMAGE="docker.io/lbjlaq/antigravity-manager"
SYSTEMD_DIR="$HOME/.config/containers/systemd"
DATA_DIR="$HOME/.antigravity_tools"

echo ">>> 1. Stopping service..."
systemctl --user stop "$SERVICE_NAME" 2>/dev/null || echo "Service not running."

echo ">>> 2. Removing Quadlet service file..."
rm -f "$SYSTEMD_DIR/${SERVICE_NAME}.container"

echo ">>> 3. Reloading systemd..."
systemctl --user daemon-reload
systemctl --user reset-failed 2>/dev/null || true

echo ">>> 4. Removing container..."
podman rm -f "$SERVICE_NAME" 2>/dev/null || echo "Container not found."

echo ">>> 5. Removing image..."
podman rmi "$IMAGE" 2>/dev/null || echo "Image not found."

echo ""
read -rp ">>> Delete data directory ($DATA_DIR)? [y/N] " answer
if [[ "$answer" =~ ^[Yy]$ ]]; then
    rm -rf "$DATA_DIR"
    echo "Data directory removed."
else
    echo "Data directory kept."
fi

echo ""
echo ">>> Uninstall complete!"
