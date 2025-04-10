#!/bin/bash

# Set verbose mode if -v or --verbose is passed
VERBOSE=false
for arg in "$@"; do
    if [[ "$arg" == "-v" || "$arg" == "--verbose" ]]; then
        VERBOSE=true
    fi
done

log() {
    echo "[INFO] $1"
}

run_cmd() {
    if $VERBOSE; then
        eval "$1"
    else
        eval "$1" > /dev/null
    fi
}

echo "Installation script starting."

WXPYTHON_URL="https://extras.wxpython.org/wxPython4/extras/linux/gtk3/ubuntu-24.04/wxPython-4.2.2-cp312-cp312-linux_x86_64.whl"
WXPYTHON_WHL="wxPython-4.2.2-cp312-cp312-linux_x86_64.whl"

log "Downloading curl package..."
run_cmd "sudo apt install -y curl"

log "Downloading wxPython wheel in the background..."
# Specifically redirect the output of curl command
if $VERBOSE; then
    curl -L "$WXPYTHON_URL" -o "$WXPYTHON_WHL"
else
    curl -L "$WXPYTHON_URL" -o "$WXPYTHON_WHL" > /dev/null
fi &
CURL_PID=$!

log "Installing packages if not already present..."
run_cmd "sudo apt update -y"
run_cmd "sudo apt install -y \
  python3.12-venv \
  libsdl2-2.0-0 \
  libgtk-3-dev \
  libglib2.0-dev \
  libsm-dev \
  libx11-dev \
  libjpeg-dev \
  libtiff-dev \
  libpng-dev \
  libexpat1-dev \
  libgstreamer1.0-dev \
  libgstreamer-plugins-base1.0-dev"

log "Creating virtual environment..."
run_cmd "python3.12 -m venv .venv"

log "Activating virtual environment..."
source .venv/bin/activate

log "Installing requirements.txt packages..."
run_cmd "pip install -r requirements.txt"

log "Waiting for wxPython wheel to finish downloading..."
wait $CURL_PID

log "Installing wxPython wheel..."
run_cmd "pip install ./$WXPYTHON_WHL"

log "Cleaning up wheel file..."
run_cmd "rm -f $WXPYTHON_WHL"

log "Installation complete."

