#!/bin/bash

function donotify() {
	X_APP_NAME=gconfd-2
	X_APP_PID=$(pgrep $X_APP_NAME)
	export $(grep -z ^DBUS_SESSION_BUS_ADDRESS /proc/$X_APP_PID/environ)
	eval $(grep -z ^USER= /proc/$X_APP_PID/environ)

	allargs=""
	[[ ! -z $1 && $1 != "_" ]] && allargs="$allargs -u $1"
	[[ ! -z $2 && $2 != "_"  ]] && allargs="$allargs -t $2"
	[[ ! -z $3 && $3 != "_"  ]] && allargs="$allargs -a $3"
	[[ ! -z $4 && $4 != "_"  ]] && allargs="$allargs -i $4"
	[[ ! -z $5 && $5 != "_"  ]] && allargs="$allargs -c $5"
	[[ ! -z $6 && $6 != "_"  ]] && allargs="$allargs -h $6"
	[[ ! -z $7 && $7 != "_"  ]] && allargs="$allargs '$7'"
	[[ ! -z $8 && $8 != "_"  ]] && allargs="$allargs '$8'"

	su -c "notify-send $allargs" $USER
}

URGENCY="_"
EXPIRETIME="_"
APPNAME="_"
ICON="_"
CATEGORY="_"
HINT="_"

while getopts u:t:a:i:c:h: opt; do
	case $opt in
		u)
			URGENCY=$OPTARG
			;;
		t)
			EXPIRETIME=$OPTARG
			;;
		a)
			APPNAME=$OPTARG
			;;
		i)
			ICON=$OPTARG
			;;
		c)
			CATEGORY=$OPTARG
			;;
		h)
			HINT=$OPTARG
			;;
		\?)
			echo "invalid arg : $OPTARG"
			;;
	esac	
done

SUMMARY=${@:$OPTIND:1}
BODY=${@:$OPTIND+1:1}

donotify $URGENCY $EXPIRETIME $APPNAME $ICON $CATEGORY $HINT $SUMMARY $BODY

