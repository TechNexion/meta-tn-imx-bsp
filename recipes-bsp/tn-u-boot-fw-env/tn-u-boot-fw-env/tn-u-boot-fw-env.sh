#!/bin/sh
MMC_TAR=$(cat /proc/cmdline | grep -io "mmcblk[[:digit:]]")
QSPI_BOOT=$(cat /proc/cmdline  |grep -Poi "qspi_boot=\w*" |cut -d '=' -f 2)
ARCH=$(uname -m)

if [ -z "$MMC_TAR" ]; then
	echo "Can not find MMC device path from kernel argument!"
	exit 1
fi

if [[ ${QSPI_BOOT} == 'yes' ]];then
	BOOT_DEV='mtd0'
else
	BOOT_DEV=${MMC_TAR}
fi

sed -i "s/\/dev\/[a-z+0-9]*/\/dev\/${BOOT_DEV}/g" /etc/fw_env.config

