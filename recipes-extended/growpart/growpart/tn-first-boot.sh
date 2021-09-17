#!/bin/bash
##########################
# Author: Wig Cheng      #
# Date: 11/25/2020       #
##########################

MMC_DEV=$(lsblk | grep mmcblk | head -n 1 |  awk '{print $1}')
ROOTFS_SIZE=$(lsblk | grep "$MMC_DEV"p2 | awk '{print $4}' | awk -F. '{print $1}')

if [ $ROOTFS_SIZE -lt 4 ]; then

  sleep 5

  if [[ "$(cat /proc/device-tree/model  | grep "AXON-IMX8MP")" ]] || [[ "$(cat /proc/device-tree/model  | grep "EDM-G-IMX8MP")" ]] ; then
    gst-launch-1.0 -v filesrc location=/etc/xdg/weston/tn-standby.jpg ! decodebin ! imagefreeze ! autovideosink &
  elif [[ "$(cat /proc/device-tree/model  | grep "PICO-IMX8MM")" ]]; then
    gst-launch-1.0 -v filesrc location=/etc/xdg/weston/tn-standby.jpg ! decodebin ! imagefreeze ! glimagesink render-rectangle="<1,1,1280,720>" &
  elif [[ "$(cat /proc/device-tree/model  | grep "PICO-IMX8MQ")" ]] || [[ "$(cat /proc/device-tree/model  | grep "EDM-IMX8MQ")" ]] ; then
    if [[ "$(grep -rn "ili9881c" /proc/device-tree/)" ]]; then
      gst-launch-1.0 -v filesrc location=/etc/xdg/weston/tn-standby.jpg ! jpegdec ! imagefreeze ! glimagesink render-rectangle="<1,1,1280,720>" &
    else
      gst-launch-1.0 -v filesrc location=/etc/xdg/weston/tn-standby.jpg ! jpegdec ! imagefreeze ! glimagesink render-rectangle="<1,1,1920,1080>" &
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

    PID=$(ps aux | grep "gst-launch" | sed -n 2p | awk '{print $2}')
    kill -9 "$PID"
    reboot
  fi
fi
