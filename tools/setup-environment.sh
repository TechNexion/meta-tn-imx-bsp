#!/bin/sh
#
# i.MX Yocto Project Build Environment Setup Script
#
# Copyright (C) 2011-2016 Freescale Semiconductor
# Copyright 2018 TechNexion Ltd.
# Copyright 2017 NXP
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

. sources/meta-fsl-bsp-release/imx/tools/setup-utils.sh

CWD=`pwd`
PROGNAME="$CWD/sources/base/setup-environment"

usage ()
{
  echo -e "Usage: . $0 [build directory]"
}

if [ $? != 0 -o $# -lt 1 ]; then
  usage
  return 1
fi

while test -n "$1"; do
  case "$1" in
    "--help" | "-h")
      usage
      return 0
      ;;
    *)
      BUILDDIRECTORY=$1
    ;;
  esac
  shift
done

THIS_SCRIPT="setup-environment.sh"
if [ "$(basename -- $0)" = "${THIS_SCRIPT}" ]; then
    echo "Error: This script needs to be sourced. Please run as '. $0'"
    return 1
fi

if [ -z "$MACHINE" ]; then
  echo "Error: MACHINE environment variable not defined"
  return 1
fi

if [ -z "$DISTRO" ]; then
  echo "Error: DISTRO environment variable not defined"
  return 1
fi

# copy new EULA into community so setup uses latest i.MX EULA
cp sources/meta-fsl-bsp-release/imx/EULA.txt sources/meta-freescale/EULA

# Set up the basic yocto environment via fsl community's version of setup-environment
TEMPLATECONF="$CWD/sources/meta-edm-bsp-release/conf" MACHINE=$MACHINE DISTRO=$DISTRO source $PROGNAME $BUILDDIRECTORY

#
# For some reason, our modified original bblayers.conf.sample are replaced by
# FSL community's base/conf/bblayer.conf
# So work around by appending additional layers
#
if ! grep -Fq "meta-edm-bsp-release" $PWD/conf/bblayers.conf; then
  echo "" >> $PWD/conf/bblayers.conf
  echo "# i.MX Yocto Project Release TechNexion Layers" >> $PWD/conf/bblayers.conf
  echo "BBLAYERS += \" \${BSPDIR}/sources/meta-edm-bsp-release \"" >> $PWD/conf/bblayers.conf
  echo "" >> $PWD/conf/bblayers.conf

  echo "# i.MX Yocto Project Release layers" >> $PWD/conf/bblayers.conf
  hook_in_layer meta-fsl-bsp-release/imx/meta-bsp
  hook_in_layer meta-fsl-bsp-release/imx/meta-sdk
  echo "BBLAYERS += \" \${BSPDIR}/sources/meta-browser \"" >> $PWD/conf/bblayers.conf
  echo "BBLAYERS += \" \${BSPDIR}/sources/meta-openembedded/meta-gnome \"" >> $PWD/conf/bblayers.conf
  echo "BBLAYERS += \" \${BSPDIR}/sources/meta-openembedded/meta-networking \"" >> $PWD/conf/bblayers.conf
  echo "BBLAYERS += \" \${BSPDIR}/sources/meta-openembedded/meta-python \"" >> $PWD/conf/bblayers.conf
  echo "BBLAYERS += \" \${BSPDIR}/sources/meta-openembedded/meta-filesystems \"" >> $PWD/conf/bblayers.conf
  echo "BBLAYERS += \" \${BSPDIR}/sources/meta-qt5 \"" >> $PWD/conf/bblayers.conf
fi

unset BUILDDIRECTORY
unset TEMPLATECONF
unset LAYERSCONF
