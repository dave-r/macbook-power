Power tuning for Fedora on Macbook Pro 11,3

### To Do once at install time
1. Enable powertop systemd service
	* ` systemctl enable powertop.service `
1. download gpu-switch
	* https://github.com/0xbb/gpu-switch	

### To install to be run at startup
1. set up gpu
	1. figure out if discrete or integrated gpu is active
		* ` cat /sys/kernel/debug/vgaswitcheroo/switch `
	1. if discrete, run gpu-switch -i to switch to integrated, then reboot 
		* ` gpu-switch -i `
	1. disable and power off discrete gpu
		* ` disablegpu/disable-dgpu.sh `
1. Make macbook sleep better
	* ` echo LID0 > /proc/acpi/wakeup `
	* ` echo XHC1 > /proc/acpi/wakeup `
