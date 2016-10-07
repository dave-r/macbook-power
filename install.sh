#!/bin/bash

# get the directory where the script is located
SCRIPT_DIR=$(cd "$(dirname ${BASH_SOURCE[0]})" && pwd)

GPUSWITCH_SRC_URL="https://raw.githubusercontent.com/0xbb/gpu-switch/master/gpu-switch"

# find out who the user is by asking them
CUR_USER=""
function getuser() {
    read -p "who are you? " CUR_USER

    if [ ! -d /home/$CUR_USER ]; then
        echo "$CUR_USER is not here"
        exit 1
    fi

    echo "damn right you are!"
}

# check to see if needed dependencies are installed.  If not, install them
function ensuredeps() {
	# is powertop installed?
	if [[ ! -x $(which powertop) ]]
	then
		echo "Installing powertop..."
		dnf install powertop
		echo "...Installed powertop"
	fi

	# is curl installed?
	if [[ ! -x $(which curl) ]]
	then
		echo "Installing curl..."
		dnf install curl
		echo "...Installed curl"
	fi

	# is gpu-switch installed?
	if [[ ! -x "$SCRIPT_DIR/gpu-switch" ]]
	then
		echo "Downloading gpu-switch..."
		curl -o $SCRIPT_DIR/gpu-switch $GPUSWITCH_SRC_URL
		chown $CUR_USER:$CUR_USER $SCRIPT_DIR/gpu-switch
		chmod 700 $SCRIPT_DIR/gpu-switch
		echo "...Downloaded gpu-switch"
	fi

	# is our notify from root script installed?

}

getuser
ensuredeps

# is the powertop systemd service already enabled?
if [[ $(systemctl show powertop.service | awk -F "=" '/^UnitFileState/ {print $2}') != 'enabled' ]]
	then
		echo "Enabling powertop auto-tune service..."
		systemctl enable powertop.service
		echo "...Enabled powertop auto-tune service"
fi

# if rc.local exists, back it up.  if not, create rc.local
if [[ -e /etc/rc.d/rc.local ]]
then
	cp /etc/rc.d/rc.local $SCRIPT_DIR/rc.local.backup
	echo "Backed up rc.local to $SCRIPT_DIR/rc.local.backup"
else
	touch /etc/rc.d/rc.local
	chmod +x /etc/rc.d/rc.local
	echo "#!/bin/bash" >> /etc/rc.d/rc.local
fi

# install disablegpu bits
cp -r $SCRIPT_DIR/disablegpu /usr/local/

# install notify from root script
cp $SCRIPT_DIR/notifyfromroot.sh /usr/local/
chmod +x /usr/local/notifyfromroot.sh

# add power management config to rc.local
cat $SCRIPT_DIR/rc.local.template >> /etc/rc.d/rc.local
