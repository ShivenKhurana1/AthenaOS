#!/usr/bin/env bash
# scripts/vnc-setup.sh: Setup VNC server and minimal desktop environment for AthenaOS UI development

set -euo pipefail

log() {
  echo -e "\033[1;34m[ATHENA-VNC]\033[0m $1"
}

# 1. Install dependencies
log "Installing VNC server and graphical dependencies..."
sudo apt update || true
sudo apt install -y tigervnc-standalone-server gnome-shell gnome-session dbus-x11 x11-xserver-utils openbox xterm --fix-missing

# 2. Setup VNC password (defaulting to 'athenaos' for dev)
log "Setting up VNC password..."
mkdir -p ~/.vnc
echo "athenaos" | vncpasswd -f > ~/.vnc/passwd
chmod 600 ~/.vnc/passwd

# 3. Create xstartup file
log "Creating ~/.vnc/xstartup..."
cat <<EOF > ~/.vnc/xstartup
#!/bin/sh
export XDG_SESSION_TYPE=x11
export GDK_BACKEND=x11
export LIBGL_ALWAYS_SOFTWARE=1
export GNOME_SHELL_SESSION_MODE=user

# Ensure a dbus session is available
if [ -z "\$DBUS_SESSION_BUS_ADDRESS" ]; then
    eval \$(dbus-launch --sh-syntax)
fi

# Start Openbox window manager
log "Launching Openbox..."
openbox-session &

# Hint for the user in the log
echo "AthenaOS Phase 2 Dev Environment"
echo "To test GNOME Shell extension, run: gnome-shell --nested --wayland"

# Keep the session alive with a foreground terminal
exec xterm -geometry 120x40+10+10 -ls -title "AthenaOS Dev Console"
EOF
chmod +x ~/.vnc/xstartup

log "VNC setup complete!"
log "Kill any old sessions: vncserver -kill :1 || true"
log "Start server with: vncserver :1 -geometry 1280x720"
log "Forward port 5901 in Codespaces 'Ports' tab and connect via VNC client with password 'athenaos'."
