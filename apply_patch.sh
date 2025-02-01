#/bin/bash

remove_symlink() {
    local link_path="$1"
    if [ -L "$link_path" ]; then
        echo "Removing masked symlink: $link_path"
        rm -f "$link_path"
    fi
}

patch /opt/google/chrome-remote-desktop/chrome-remote-desktop < fix_display.patch

SERVICE="chrome-remote-desktop"

# Attempt to restart the service
if ! systemctl restart "$SERVICE" 2>&1 | tee /tmp/crd_restart.log | grep -q "Unit $SERVICE.service is masked"; then
    echo "Service restarted successfully."
    exit 0
fi

MASKED_LINK_ETC="/etc/systemd/system/${SERVICE}.service"
MASKED_LINK_LIB="/usr/lib/systemd/system/${SERVICE}.service"

# Function to remove symlink if it exists
remove_symlink "$MASKED_LINK_ETC"
remove_symlink "$MASKED_LINK_LIB"

# Reload systemd daemon
echo "Reloading systemd daemon..."
systemctl daemon-reexec

echo "Restarting service..."
systemctl restart "$SERVICE"

# Verify status
if systemctl is-active --quiet "$SERVICE"; then
    echo "Service restarted successfully after unmasking."
else
    echo "Failed to restart the service."
    exit 1
fi
