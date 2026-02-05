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

. sources/meta-imx/tools/setup-utils.sh
. sources/meta-tn-imx-bsp/tools/tn-setup-utils.sh

ROOT_DIR=`pwd`

if [ -d "$ROOT_DIR/sources/meta-boot2qt" ]; then
  # Check if MACHINE has already been exported, if not fail out
  ENVVARS=`printenv`
  if grep -q "MACHINE=" <<< $ENVVARS; then
  PROGNAME="$ROOT_DIR/sources/meta-boot2qt/scripts/setup-environment.sh"
  # Get TechNexion MACHINE configs from boot2qt
  TNCONFIGS=$(ls $ROOT_DIR/sources/meta-boot2qt/meta-boot2qt-distro/conf/distro/include/*.conf | xargs -n 1 basename | grep -E -c "$MACHINE")
  else
    echo -e "Try to setup boot2qt build environment. Please export MACHINE=xxx first."
    return 1
  fi
else
  PROGNAME="$ROOT_DIR/sources/base/setup-environment"
  # Get TechNexion MACHINE configs from yocto
  TNCONFIGS=$(ls $ROOT_DIR/sources/meta-tn-imx-bsp/conf/machine/*.conf | xargs -n 1 basename | grep -E -c "$MACHINE")
fi

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

if [ ! -d "$ROOT_DIR/sources/meta-boot2qt" ]; then
  if [ -z "$DISTRO" ]; then
      echo "Error: DISTRO environment variable not defined"
      return 1
  fi
fi

# Get i.MX MACHINE configs
FSLCONFIGS=$(ls $ROOT_DIR/sources/meta-imx/meta-imx-bsp/conf/machine/*.conf $ROOT_DIR/sources/meta-freescale*/conf/machine/*.conf | xargs -n 1 basename | grep -E -c "$MACHINE")
# Set up the basic yocto environment by sourcing fsl community's setup-environment bash script with/without TEMPLATECONF
if [ -n "${DISTRO}" ]; then
  if [ ${TNCONFIGS} != 0 ]; then
    echo "Setup TechNexion Yocto"
    echo "    TEMPLATECONF=$ROOT_DIR/sources/meta-tn-imx-bsp/conf/templates/default MACHINE=$MACHINE DISTRO=$DISTRO source $PROGNAME $BUILDDIRECTORY"
    echo ""
    TEMPLATECONF="$ROOT_DIR/sources/meta-tn-imx-bsp/conf/templates/default" MACHINE=$MACHINE DISTRO=$DISTRO source $PROGNAME $BUILDDIRECTORY
  elif [ ${FSLCONFIGS} != 0 ]; then
    echo "Setup Freescale/i.MX Yocto"
    echo "    MACHINE=$MACHINE DISTRO=$DISTRO source $PROGNAME $BUILDDIRECTORY"
    echo ""
    MACHINE=$MACHINE DISTRO=$DISTRO source $PROGNAME $BUILDDIRECTORY
  fi
else
  if [ ${TNCONFIGS} != 0 ]; then
    echo "Setup Boot2qt"
    echo "    export MACHINE=$MACHINE"
    echo "    source $PROGNAME $BUILDDIRECTORY"
    echo ""
    source $PROGNAME $BUILDDIRECTORY
  else
    echo "Setup OpenEmbedded Yocto"
    echo "    MACHINE=$MACHINE source $PROGNAME $BUILDDIRECTORY"
    echo ""
    MACHINE=$MACHINE source $PROGNAME $BUILDDIRECTORY
  fi
fi

WORK_DIR=$PWD

#
# For some reason, our modified original bblayers.conf.sample are replaced by
# FSL community's base/conf/bblayer.conf
# So workaround by appending additional layers
#

# both imx and TechNexion MACHINE configs
tn_append_conf $WORK_DIR $HAVE_CONF_ORG "yes" "\n# TechNexion setup-environment.sh wrapper: Further modification to bblayers.conf and local.conf"

if [ ${TNCONFIGS} != 0 -o ${FSLCONFIGS} != 0 ]; then
  if [ -d $WORK_DIR/../sources/meta-imx ]; then
    # copy new EULA(LICENSE.txt) into community so setup uses latest i.MX EULA
    cp $WORK_DIR/../sources/meta-imx/LICENSE.txt $WORK_DIR/../sources/meta-freescale/EULA
    if ! grep -Fq "meta-imx" $WORK_DIR/conf/bblayers.conf; then
      # add i.MX bsp layers to bblayers.conf
      echo -e "\n# setup i.MX Yocto Project Release layers in bblayers.conf" | tee -a $WORK_DIR/conf/bblayers.conf
      hook_in_layer meta-imx/meta-imx-bsp
      hook_in_layer meta-imx/meta-imx-sdk
      hook_in_layer meta-imx/meta-imx-ml
      hook_in_layer meta-imx/meta-imx-v2x
      hook_in_layer meta-nxp-demo-experience
      hook_in_layer meta-arm/meta-arm
      hook_in_layer meta-arm/meta-arm-toolchain
      hook_in_layer meta-security
      hook_in_layer meta-security/meta-tpm
      hook_in_layer meta-security/meta-parsec
      hook_in_layer meta-freescale-ml

      tn_append_layer $WORK_DIR "" ""
      tn_append_layer $WORK_DIR "" "BBLAYERS += \"\${BSPDIR}/sources/meta-browser/meta-chromium\""
      tn_append_layer $WORK_DIR "" "BBLAYERS += \"\${BSPDIR}/sources/meta-clang\""
      tn_append_layer $WORK_DIR "" "BBLAYERS += \"\${BSPDIR}/sources/meta-openembedded/meta-gnome\""
      tn_append_layer $WORK_DIR "" "BBLAYERS += \"\${BSPDIR}/sources/meta-openembedded/meta-networking\""
      tn_append_layer $WORK_DIR "" "BBLAYERS += \"\${BSPDIR}/sources/meta-openembedded/meta-filesystems\""
      tn_append_layer $WORK_DIR "" "BBLAYERS += \"\${BSPDIR}/sources/meta-openembedded/meta-perl\""

      tn_append_layer $WORK_DIR "" "BBLAYERS += \"\${BSPDIR}/sources/meta-qt6\""

      # Enable docker for mx8 machines
      tn_append_layer $WORK_DIR "" "BBLAYERS += \"\${BSPDIR}/sources/meta-virtualization\""

    fi
  fi
  if [ -d ${WORK_DIR}/../sources/meta-ivi ]; then
  if ! grep -Fq "meta-ivi" $WORK_DIR/conf/bblayers.conf; then
      tn_append_layer $WORK_DIR "yes" "\n# setup Genivi layers in bblayers.conf"
      tn_append_layer $WORK_DIR "" "BBLAYERS += \"\${BSPDIR}/sources/meta-gplv2\""
      tn_append_layer $WORK_DIR "" "BBLAYERS += \"\${BSPDIR}/sources/meta-ivi/meta-ivi\""
      tn_append_layer $WORK_DIR "" "BBLAYERS += \"\${BSPDIR}/sources/meta-ivi/meta-ivi-bsp\""
      tn_append_layer $WORK_DIR "" "BBLAYERS += \"\${BSPDIR}/sources/meta-ivi/meta-ivi-test\""
    fi
  fi
fi

# TechNexion MACHINE configs
if [ ${TNCONFIGS} != 0 -o ${FSLCONFIGS} != 0 ] ; then
  # add SWupdate layers to bblayers.conf
  tn_auto_append_layer "$WORK_DIR" "swupdate" "meta-swupdate"

  # add TechNexion bsp layers to bblayers.conf
  tn_auto_append_layer "$WORK_DIR" "i.MX Yocto Project Release" "meta-tn-imx-bsp"

  # add TechNexion wifi layers to bblayers.conf
  tn_auto_append_layer "$WORK_DIR" "wifi" "meta-tn-wifi"

  # add TechNexion vizionsdk layers to bblayers.conf
  tn_auto_append_layer "$WORK_DIR" "vizionsdk" "meta-tn-vizionsdk"

  # add TechNexion nfc bsp layers (from nxp) to bblayers.conf
  tn_auto_append_layer "$WORK_DIR" "nfc" "meta-nxp-nfc"

  # add TechNexion virtualization bsp layers (virtualization/boot2qt) to bblayers.conf
  #if [ -d $WORK_DIR/../sources/meta-virtualization ]; then
  if false; then
    # has meta-virtualization
    if ! grep -Fq "meta-virtualization" $WORK_DIR/conf/bblayers.conf; then
      tn_append_layer $WORK_DIR "" ""
      tn_append_layer $WORK_DIR "yes" "# setup i.MX Container OS and OTA layers in bblayers.conf"
      tn_append_layer $WORK_DIR "" "BBLAYERS += \" \${BSPDIR}/sources/meta-virtualization \""
    fi
    if ! grep -Fq "BBMULTICONFIG" $WORK_DIR/conf/local.conf; then
      mkdir -p $WORK_DIR/conf/multiconfig
      cat > $WORK_DIR/conf/multiconfig/container.conf << EOF
MACHINE = "tn-container"
DISTRO = "fsl-imx-xwayland"
DISTRO_FEATURES:append = " virtualization"
TMPDIR = "\${TOPDIR}/tmp-container"
TN_CONTAINER_IMAGE_TYPE ?= "tar.gz"
EOF
      echo "TN_CONTAINER_IMAGE_TYPE = \"tar.gz\"" >> $WORK_DIR/conf/local.conf
      echo "BBMULTICONFIG = \"container\"" >> $WORK_DIR/conf/local.conf
      echo "# setup BBMULTICONFIG in local.conf with conf/multiconfig/container.conf"
      cat $WORK_DIR/conf/multiconfig/container.conf
    fi
  else
    # no meta-virtualization
    if ! grep -Fq "meta-tn-imx-bsp/recipes-containers/docker-disk/docker-disk.bb" $WORK_DIR/conf/local.conf; then
      echo "BBMASK += \"meta-tn-imx-bsp/recipes-containers/docker-disk/docker-disk.bb\"" >> $WORK_DIR/conf/local.conf
    fi
    if ! grep -Fq "meta-tn-imx-bsp/recipes-containers/docker/docker-ce_%.bbappend" $WORK_DIR/conf/local.conf; then
      echo "BBMASK += \"meta-tn-imx-bsp/recipes-containers/docker/docker-ce_%.bbappend\"" >> $WORK_DIR/conf/local.conf
    fi
    # for boot2qt
    if grep -Fq "DISTRO ?= \"b2qt\"" $WORK_DIR/conf/local.conf; then
      if ! grep -Fq "meta-tn-imx-bsp/recipes-graphics/wayland/weston_%.bbappend" $WORK_DIR/conf/local.conf; then
        echo "BBMASK += \"meta-tn-imx-bsp/recipes-graphics/wayland/weston_%.bbappend\"" >> $WORK_DIR/conf/local.conf
      fi
      if ! grep -Fq "meta-tn-imx-bsp/recipes-qt/qt5/qtbase_%.bbappend" $WORK_DIR/conf/local.conf; then
        echo "BBMASK += \"meta-tn-imx-bsp/recipes-qt/qt5/qtbase_%.bbappend\"" >> $WORK_DIR/conf/local.conf
      fi
    fi
  fi
fi

unset WORK_DIR
unset PROGNAME
unset THIS_SCRIPT
unset TNCONFIGS
unset FSLCONFIGS
unset MACHINE
unset DISTRO
unset BUILDDIRECTORY
unset TEMPLATECONF
unset LAYERSCONF
