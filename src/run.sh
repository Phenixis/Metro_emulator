#!/bin/bash

# Function to kill all background processes when the script exits
cleanup() {
    sudo kill $(jobs -p)
    sudo kill -9 $$
}

# Trap SIGINT (Ctrl+C) and SIGTERM to trigger cleanup
trap cleanup SIGINT SIGTERM

# Check if the virtual environment is activated
if [[ "$VIRTUAL_ENV" != "$(pwd)/.venv" ]]; then
    echo "Activating virtual environment..."
    source .venv/bin/activate
fi

# Start the processes in the background
sudo .venv/bin/python metroEmuUI/MetroEmuRun.py &
sleep 5

sudo .venv/bin/python plcCtrl/signalPlcEmu/plcSimulatorSignal.py &
sleep 5

sudo .venv/bin/python plcCtrl/stationPlcEmu/plcSimulatorStation.py &
sleep 5

sudo .venv/bin/python plcCtrl/trainPlcEmu/plcSimulatorTrain.py &
sleep 5

sudo .venv/bin/python scadaEmuUI/hmiEmuRun.py &
sleep 5

sudo .venv/bin/python trainCtrlUI/trainCtrlRun.py &

# Wait for all background jobs
wait

