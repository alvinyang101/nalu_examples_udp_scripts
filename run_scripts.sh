#!/bin/bash

# Set environment variables
BOARD_IP="192.168.1.59"
BOARD_PORT="4660"
HOST_IP="192.168.1.1"
HOST_PORT="4660"
TARGET_IP="192.168.1.1"
TARGET_PORT="12345"
MODEL="hdsocv1_evalr2"
READOUT_WINDOW="1 1 1"
TRIGGER_MODE="self"
LOOKBACK_MODE="trig"

# Debug flag (set to 1 for debug, 0 for no debug)
DEBUG=1

# Build the debug flag
DEBUG_FLAG=""
if [ "$DEBUG" -eq 1 ]; then
    DEBUG_FLAG="-d"
fi

# Trigger values (only set if mode is 'self')
TRIGGER_ARGS=""
TRIGGER_REFS_ARGS=""
if [ "$TRIGGER_MODE" == "self" ]; then
    TRIGGER_VALUES="0 0 123 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0"
    TRIGGER_ARGS="-trigval $TRIGGER_VALUES"

    # Trigger references for self trigger mode
    TRIGGER_REFS="3 11 3 11"
    TRIGGER_REFS_ARGS="-trigrefs $TRIGGER_REFS"
fi

# Run the Python scripts
python3 init_board.py -m $MODEL -b $BOARD_IP -bp $BOARD_PORT -host $HOST_IP -hp $HOST_PORT $DEBUG_FLAG
python3 start_capture.py -m $MODEL -b $BOARD_IP -bp $BOARD_PORT -host $HOST_IP -hp $HOST_PORT -t $TARGET_IP -tp $TARGET_PORT --readout_window $READOUT_WINDOW -trig $TRIGGER_MODE -l $LOOKBACK_MODE $TRIGGER_ARGS $TRIGGER_REFS_ARGS $DEBUG_FLAG
python3 stop_capture.py -m $MODEL -b $BOARD_IP -bp $BOARD_PORT -host $HOST_IP -hp $HOST_PORT $DEBUG_FLAG
