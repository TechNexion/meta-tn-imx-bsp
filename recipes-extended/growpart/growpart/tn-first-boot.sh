#!/bin/bash
##########################
# Author: Wig Cheng      #
# Date: 11/25/2020       #
##########################

CPID=""
MMC_DEV=$(lsblk | grep mmcblk | head -n 1 |  awk '{print $1}')
TOTAL_SIZE=$(lsblk -b | grep "$MMC_DEV " | awk '{print $4}')
ROOTFS_SIZE=$(lsblk -b | grep "$MMC_DEV"p2 | awk '{print $4}')
# spare = total - rootfs - 500MB
SPARE_SIZE=$((($TOTAL_SIZE-$ROOTFS_SIZE)-524288000))

if [ $SPARE_SIZE -gt 0 -a $SPARE_SIZE -gt $ROOTFS_SIZE ]; then

  sleep 5

  if grep -q "AXON-IMX8MP" /proc/device-tree/model || grep -q "EDM-G-IMX8MP" /proc/device-tree/model ; then
    gst-launch-1.0 -v filesrc location=/etc/xdg/weston/tn-standby.jpg ! decodebin ! imagefreeze ! autovideosink & CPID="$!"
  elif grep -q "PICO-IMX8MM" /proc/device-tree/model ; then
    gst-launch-1.0 -v filesrc location=/etc/xdg/weston/tn-standby.jpg ! decodebin ! imagefreeze ! glimagesink render-rectangle="<1,1,1280,720>" & CPID="$!"
  elif grep -q "PICO-IMX8MQ" /proc/device-tree/model || grep -q "EDM-IMX8MQ" /proc/device-tree/model ; then
    if grep -q -rn "ili9881c" /proc/device-tree/ ; then
      gst-launch-1.0 -v filesrc location=/etc/xdg/weston/tn-standby.jpg ! jpegdec ! imagefreeze ! glimagesink render-rectangle="<1,1,1280,720>" & CPID="$!"
    else
      gst-launch-1.0 -v filesrc location=/etc/xdg/weston/tn-standby.jpg ! jpegdec ! imagefreeze ! glimagesink render-rectangle="<1,1,1920,1080>" & CPID="$!"
    fi
  fi
  sleep 5
  sync
  growpart /dev/"$MMC_DEV" 2
  if [ $? -eq 0 ]; then
    sync
    resize2fs /dev/"$MMC_DEV"p2
    sync
    sleep 2
    if ps -p $CPID > /dev/null; then
      kill -9 $CPID
    fi
    reboot
  fi
fi
