#!/bin/sh
#
# i.MX Yocto Project Build Environment Setup Script
#
# Copyright (C) 2011-2016 Freescale Semiconductor
# Copyright 2017 NXP
# Copyright 2020 TechNexion Ltd.
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

CALLER=`caller`
CWD=`pwd`
PROGNAME="$CWD/sources/meta-tn-imx-bsp/tools/setup-environment.sh"
exit_message ()
{
   echo "To return to this build environment later please run:"
   echo "    source setup-environment <build_dir>"

}

usage()
{
    echo -e "\nUsage: source tn-setup-release.sh
    Optional parameters: [-b build-dir] [-h]"
echo "
    * [-b build-dir]: Build directory, if unspecified script uses 'build' as output directory
    * [-h]: help
"
}

clean_up()
{
    unset OLD_OPTIND
    unset OPTIND
    unset CPU_TYPE
    unset CWD BUILD_DIR FSLDISTRO
    unset fsl_setup_help fsl_setup_error fsl_setup_flag
    unset usage clean_up
    unset ARM_DIR META_FSL_BSP_RELEASE
    exit_message clean_up
}

# get command line options
OLD_OPTIND=$OPTIND
unset FSLDISTRO

while getopts "k:r:t:b:e:gh" fsl_setup_flag
do
    case $fsl_setup_flag in
        b) BUILD_DIR="$OPTARG";
           echo -e "\nBuild directory: $BUILD_DIR"
           ;;
        h) fsl_setup_help='true';
           ;;
        \?) fsl_setup_error='true';
           ;;
    esac
done
shift $((OPTIND-1))
if [ $# -ne 0 ]; then
    fsl_setup_error=true
    echo -e "Invalid command line ending: '$@'"
fi
OPTIND=$OLD_OPTIND
if test $fsl_setup_help; then
    usage && clean_up && return 1
elif test $fsl_setup_error; then
    clean_up && return 1
fi


if [ -z "$DISTRO" ]; then
    if [ -z "$FSLDISTRO" ]; then
        FSLDISTRO='fsl-imx-xwayland'
    fi
else
    FSLDISTRO="$DISTRO"
fi

if [ -z "$BUILD_DIR" ]; then
    BUILD_DIR='build'
fi

if [ -z "$MACHINE" ]; then
    echo setting to default machine
    MACHINE='imx6qpsabresd'
fi

case $MACHINE in
imx8*|imx9*)
    if [ -n "$DISTRO" ]; then
        case $DISTRO in
        *wayland)
            : true
            ;;
        *)
            echo -e "\n ERROR - Only Wayland distros are supported for i.MX 8 or i.MX 8M"
            echo -e "\n"
            return 1
            ;;
        esac
    fi
    ;;
esac

# Override the click-through in meta-freescale
FSL_EULA_FILE=$CWD/sources/meta-imx/LICENSE.txt

# Set up the basic yocto environment by souring our setup-environment.sh
if [ -n "$DISTRO" ]; then
  echo "Source TechNexion setup-environment.sh wrapper scripts"
  echo "    MACHINE=$MACHINE DISTRO=$DISTRO source $PROGNAME $BUILD_DIR"
  echo ""
  DISTRO=$FSLDISTRO MACHINE=$MACHINE source $PROGNAME $BUILD_DIR
else
  echo "Source TechNexion setup-environment.sh wrapper scripts"
  echo "    MACHINE=$MACHINE source $PROGNAME $BUILD_DIR"
  echo ""
  MACHINE=$MACHINE source $PROGNAME $BUILD_DIR
fi

if [ $? != 0 ]; then
  return 1
fi

echo -e "\n# TechNexion Setup BSP Release: Further modification to local.conf and bblayers.conf" | tee -a conf/local.conf
# source setup-environment.sh changes to the build directory, so re-set $BUILD_DIR to current build directory
BUILD_DIR=.

if [ ! -e $BUILD_DIR/conf/local.conf ]; then
    echo -e "\nERROR - No build directory is set yet. Run the 'setup-environment' script before running this script to create " $BUILD_DIR
    echo -e "\n"
    return 1
fi

# When run tn-setup-release.sh script for the first time, backup the local.conf file
# For consecutive script runs, it restores the backup and changes are appended on this one.
if [ ! -e $BUILD_DIR/conf/local.conf.org ]; then
    cp $BUILD_DIR/conf/local.conf $BUILD_DIR/conf/local.conf.org
else
    cp $BUILD_DIR/conf/local.conf.org $BUILD_DIR/conf/local.conf
fi

if [ ! -e $BUILD_DIR/conf/bblayers.conf.org ]; then
    cp $BUILD_DIR/conf/bblayers.conf $BUILD_DIR/conf/bblayers.conf.org
else
    cp $BUILD_DIR/conf/bblayers.conf.org $BUILD_DIR/conf/bblayers.conf
fi

#
# Additional Settings to local.conf and bblayer.conf
#

# for zeus
echo >> conf/local.conf
echo "PACKAGE_CLASSES = \"package_deb\"" >> conf/local.conf
echo "EXTRA_IMAGE_FEATURES += \"package-management\"" >> conf/local.conf

# for scarthgap, need to increase the fetch retry
echo >> conf/local.conf
echo "BBFETCH_RETRYCOUNT = \"5\"" >> conf/local.conf

# for mender, note: below should really be in tn-setup-mender.sh
if grep -q "tn-setup-mender" <<< $CALLER; then
  echo -e "\n# Setup additional mender settings in local.conf" | tee -a conf/local.conf
  if [ -f conf/local.conf ]; then
    if grep -q "DISTRO.*b2qt" conf/local.conf; then
      echo -e "\n# Setup additional local.conf settings for mender boot2qt." | tee -a conf/local.conf
      echo "QBSP_IMAGE_CONTENT:remove = \"\${IMAGE_LINK_NAME}.img\"" >> conf/local.conf
      echo "QBSP_IMAGE_CONTENT:prepend = \"\${IMAGE_LINK_NAME}.sdimg\"" >> conf/local.conf
      echo "IMAGE_CLASSES:remove = \"deploy-conf\"" >> conf/local.conf
      echo "IMAGE_CLASSES:append = \" deploy-conf-b2qt\"" >> conf/local.conf
      echo "BBMASK += \"meta-tn-imx-bsp/recipes-tn/images/tn-image-multimedia-full.bb\"" >> conf/local.conf
    fi
    if grep -q "BBMULTICONFIG.*container" conf/local.conf; then
      echo -e "\n# Setup additional local.conf settings for mender virtualization." | tee -a conf/local.conf
      echo "BBMASK += \"meta-boot2qt/meta-boot2qt-distro/recipes-qt/qt5/ogl-runtime_git.bbappend\"" >> conf/local.conf
    fi
    echo "IMAGE_FSTYPES:remove = \"wic wic.xz\"" >> conf/local.conf
    echo "IMAGE_FSTYPES:append:tn = \" sdimg.gz\"" >> conf/local.conf
    echo "MENDER_UBOOT_STORAGE_DEVICE:tn = \"2\"" >> conf/local.conf
    echo "MENDER_BOOT_PART_NUMBER:tn = \"2\"" >> conf/local.conf
    echo "MENDER_STORAGE_TOTAL_SIZE_MB:tn = \"8176\"" >> conf/local.conf
    echo "MENDER_DATA_PART_SIZE_MB:tn = \"2048\"" >> conf/local.conf
    echo "IMAGE_ROOTFS_MAXSIZE:tn = \"25165824\"" >> conf/local.conf
  fi
fi

# extra variables for BB_ENV_PASSTHROUGH_ADDITIONS
if [ -n "$DISPLAY" ]; then
  echo "Specified DISPLAY_INFO: $DISPLAY"
  export DISPLAY_INFO=$DISPLAY
  if ! grep -qF "DISPLAY_INFO" <<< $BB_ENV_PASSTHROUGH_ADDITIONS; then
    echo "Export DISPLAY_INFO=$DISPLAY to yocto via BB_ENV_PASSTHROUGH_ADDITIONS"
    export BB_ENV_PASSTHROUGH_ADDITIONS="$BB_ENV_PASSTHROUGH_ADDITIONS DISPLAY_INFO"
  fi
fi
if [ -n "$PANEL" ]; then
    export DISPLAY_PANEL=$PANEL
    export BB_ENV_PASSTHROUGH_ADDITIONS="$BB_ENV_PASSTHROUGH_ADDITIONS DISPLAY_PANEL"
fi
if [ -n "$BASEBOARD" ]; then
  echo "Specified BASE_BOARD: $BASEBOARD"
  export BASE_BOARD=$BASEBOARD
  if ! grep -qF "BASE_BOARD" <<< $BB_ENV_PASSTHROUGH_ADDITIONS; then
    echo "Export BASE_BOARD=$BASEBOARD to yocto via BB_ENV_PASSTHROUGH_ADDITIONS"
    export BB_ENV_PASSTHROUGH_ADDITIONS="$BB_ENV_PASSTHROUGH_ADDITIONS BASE_BOARD"
  fi
fi
if [ -n "$FDTNAME" ]; then
    export ALT_FDTNAME=$FDTNAME
    export BB_ENV_PASSTHROUGH_ADDITIONS="$BB_ENV_PASSTHROUGH_ADDITIONS ALT_FDTNAME"
fi

if [ -d $CWD/sources/meta-tn-wifi ]; then
    source $CWD/sources/meta-tn-wifi/tools/tn-wifi-setup.sh $MACHINE $TOKEN $WIFI_MODULE $WIFI_FIRMWARE
fi

# Include meta-nxp-desktop for building imx-image-desktop
if [ "$DISTRO" = "imx-desktop-xwayland" ]; then
    if [ -f conf/local.conf ]; then
        echo ""                                                                       >> conf/local.conf
        echo "# Include ubuntu environment and packages settings"                     >> conf/local.conf
        echo "require conf/machine/include/ubuntubasics.inc"                          >> conf/local.conf
        echo ""                                                                       >> conf/local.conf
        echo "# Switch to rpm packaging to avoid rootfs build break"                  >> conf/local.conf
        echo "PACKAGE_CLASSES = \"package_rpm\""                                      >> conf/local.conf
        echo ""                                                                       >> conf/local.conf
        echo "# Save lots of disk space"                                              >> conf/local.conf
        echo "INHERIT += \"rm_work\""                                                 >> conf/local.conf
        echo ""                                                                       >> conf/local.conf
        echo "# Set your proxy if necessary"                                          >> conf/local.conf
        echo "#ENV_HOST_PROXIES = \"http_proxy=\""                                    >> conf/local.conf
        echo ""                                                                       >> conf/local.conf
        echo "# Set user account and password"                                        >> conf/local.conf
        echo "#APTGET_ADD_USERS = \"user:password:shell\""                            >> conf/local.conf
        echo "#  format 'name:password:shell'."                                       >> conf/local.conf
        echo "#    'name' is the user name."                                          >> conf/local.conf
        echo "#    'password' is an encrypted password (e.g. generated with"          >> conf/local.conf
        echo "#    \`echo \"P4sSw0rD\" \| openssl passwd -stdin\`)."                  >> conf/local.conf
        echo "#    If empty or missing, they'll get an empty password."               >> conf/local.conf
        echo "#    'shell' is the default shell (if empty, default is /bin/sh)."      >> conf/local.conf
        echo -e "\n# Change the default user to 'ubuntu'"                             >> conf/local.conf
        echo "APTGET_ADD_USERS = \"ubuntu:xA5hQLsgw2DlE:/bin/bash\""                  >> conf/local.conf

        echo "BBLAYERS += \"\${BSPDIR}/sources/meta-nxp-desktop\""                    >> conf/bblayers.conf

        echo ""
        echo "IMX Desktop setup complete!"
        echo ""
        echo "You can now build the following Desktop images:"
        echo ""
        echo "$ bitbake imx-image-desktop"
        echo ""
    fi
fi

# Support integrating community meta-freescale instead of meta-fsl-arm
if [ -d ../sources/meta-freescale ]; then
    echo "meta-freescale directory found, so use freescale community bsp bblayer instead."
    # Change settings according to environment
    sed -e "s,meta-fsl-arm\s,meta-freescale ,g" -i conf/bblayers.conf
    sed -e "s,\$.BSPDIR./sources/meta-fsl-arm-extra\s,,g" -i conf/bblayers.conf
fi

if grep -q "tn-setup-mender" <<< $CALLER; then
    echo -e "\n# setup additional mender bsp layer in bblayers.conf" | tee -a conf/bblayers.conf
    if [ -d ../sources/meta-mender-community/meta-mender-update-modules ]; then
      echo "BBLAYERS += \" \${BSPDIR}/sources/meta-mender-community/meta-mender-update-modules \"" >> conf/bblayers.conf
    fi
fi

cd $BUILD_DIR
clean_up
