#!/bin/sh
CALFILE="/pointercal"

if [ -e $CALFILE ] ; then
    TOUCH_INPUT=`cat /proc/bus/input/devices | grep -A9 'ADS7846 Touchscreen' | grep 'Sysfs' | grep -o 'input[0-9]'`
    if [ "$?" == "0" ];then
        cat ${CALFILE} > /sys/class/input/${TOUCH_INPUT}/calibration
        echo -e "\nFeed calibration data to ADS7846 driver\n"
    fi
fi

exit 0

