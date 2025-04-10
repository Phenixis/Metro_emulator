#!/bin/bash

# Function to kill all background processes when the script exits
cleanup() {
    sudo kill $(jobs -p) > /dev/null 2> /dev/null
    sudo kill -9 $$ > /dev/null 2> /dev/null
}

# Trap SIGINT (Ctrl+C) and SIGTERM to trigger cleanup
trap cleanup SIGINT SIGTERM

# Check if the virtual environment is activated
if [[ "$VIRTUAL_ENV" != "$(pwd)/.venv" ]]; then
    source .venv/bin/activate
fi

# Start the processes in the background
sudo echo "You can find all the logs of the programs in the 'Logs' folder."

echo "Opening the Metro Simulation..."
sudo .venv/bin/python metroEmuUI/MetroEmuRun.py > /dev/null &
sleep 1

echo "Opening the junctions PLC Controller..."
sudo .venv/bin/python plcCtrl/signalPlcEmu/plcSimulatorSignal.py > /dev/null &
sleep 1

echo "Opening the stations PLC Controller..."
sudo .venv/bin/python plcCtrl/stationPlcEmu/plcSimulatorStation.py > /dev/null &
sleep 1

echo "Opening the RTU..."
sudo .venv/bin/python rtuCtrl/trainRtuEmu/rtuSimulatorTrain.py > /dev/null &
sleep 1

echo "Opening the trains PLC Controller..."
sudo .venv/bin/python plcCtrl/trainPlcEmu/plcSimulatorTrain.py > /dev/null &
sleep 1

echo "Opening the Scada HMI..."
sudo .venv/bin/python scadaEmuUI/hmiEmuRun.py > /dev/null &
sleep 1

echo "Opening the Train Controller Simulator..."
sudo .venv/bin/python trainCtrlUI/trainCtrlRun.py > /dev/null &

# Wait for all background jobs
echo "All the programs are running, hit 'Ctrl+C' to close them."
wait

