#!/bin/bash

# Set verbose mode if -v or --verbose is passed
VERBOSE=false
for arg in "$@"; do
    if [[ "$arg" == "-v" || "$arg" == "--verbose" ]]; then
        VERBOSE=true
    fi
done

log() {
    if $VERBOSE; then
        echo "[INFO] $1"
    fi
}

echo "Installation script starting."

WXPYTHON_URL="https://extras.wxpython.org/wxPython4/extras/linux/gtk3/ubuntu-24.04/wxPython-4.2.2-cp312-cp312-linux_x86_64.whl"
WXPYTHON_WHL="wxPython-4.2.2-cp312-cp312-linux_x86_64.whl"

log "Downloading wxPython wheel in the background..."
curl -L "$WXPYTHON_URL" -o "$WXPYTHON_WHL" &
CURL_PID=$!

log "Installing python3.12-venv if not already present..."
sudo apt update -y
sudo apt install -y python3.12-venv

log "Creating virtual environment..."
python3.12 -m venv .venv

log "Activating virtual environment..."
source .venv/bin/activate

log "Installing requirements.txt packages..."
pip install -r requirements.txt

log "Waiting for wxPython wheel to finish downloading..."
wait $CURL_PID

log "Installing wxPython wheel..."
pip install "./$WXPYTHON_WHL"

log "Cleaning up wheel file..."
rm -f "$WXPYTHON_WHL"

log "Installation complete."

