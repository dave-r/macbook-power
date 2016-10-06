#!/bin/bash

# get the directory where the script is located
SCRIPT_DIR=$(cd "$(dirname ${BASH_SOURCE[0]})" && pwd)

# disable the discrete gpu
echo "disabling gpu"
$SCRIPT_DIR/disablegpu

# turn off the discrete gpu
echo "powering down gpu"
bash -c "echo OFF > /sys/kernel/debug/vgaswitcheroo/switch"
