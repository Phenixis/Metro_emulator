#!/bin/bash

export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
source .venv/bin/activate

sudo -E .venv/bin/python metroEmuUI/MetroEmuRun.py &
sleep 5

sudo -E .venv/bin/python plcCtrl/signalPlcEmu/plcSimulatorSignal.py &
sleep 5

sudo -E .venv/bin/python plcCtrl/stationPlcEmu/plcSimulatorStation.py &
sleep 5

sudo -E .venv/bin/python plcCtrl/trainPlcEmu/plcSimulatorTrain.py &
sleep 5

sudo -E .venv/bin/python scadaEmuUI/hmiEmuRun.py &
sleep 5

sudo -E .venv/bin/python trainCtrlUI/trainCtrlRun.py &

wait
