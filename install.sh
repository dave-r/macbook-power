#!/bin/bash

# is powertop installed?
[[ -x $(which powertop) ]] && echo 'powertop is installed'

# is the powertop systemd service already enabled?
[[ $(systemctl show powertop.service | awk -F "=" '/^UnitFileState/ {print $2}') == 'enabled' ]] && echo 'powertop service enabled'

