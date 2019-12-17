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

CWD=$(pwd)
PROGNAME="$CWD/sources/meta-edm-bsp-release/tools/setup-environment.sh"
exit_message ()
{
    echo "To return to this build environment later please run:"
    echo "    source setup-environment <build_dir>"
}

usage()
{
    echo -e "\nUsage: source edm-setup-release.sh
    Optional parameters: [-b build-dir] [-h]"
    echo "
    * [-b build-dir]: Build directory, if unspecified script uses 'build' as output directory
    * [-h]: help
    "
}


clean_up()
{
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
        ?) fsl_setup_error='true';
           ;;
    esac
done

if [ -z "$DISTRO" ]; then
    if [ -z "$FSLDISTRO" ]; then
        FSLDISTRO='fsl-imx-xwayland'
    fi
else
    FSLDISTRO="$DISTRO"
fi

OPTIND=$OLD_OPTIND

# check the "-h" and other not supported options
if test $fsl_setup_error || test $fsl_setup_help; then
    usage && clean_up && return 1
fi

if [ -z "$BUILD_DIR" ]; then
    BUILD_DIR='build'
fi

# Set up the basic yocto environment by calling our setup-environment.sh
if [ -z "$DISTRO" ]; then
   DISTRO=$FSLDISTRO MACHINE=$MACHINE source $PROGNAME $BUILD_DIR
else
   MACHINE=$MACHINE source $PROGNAME $BUILD_DIR
fi

# Point to the current directory since the last command changed the directory to $BUILD_DIR
BUILD_DIR=.

if [ ! -e $BUILD_DIR/conf/local.conf ]; then
    echo -e "\n ERROR - No build directory is set yet. Run the 'setup-environment' script before running this script to create " $BUILD_DIR
    echo -e "\n"
    return 1
fi

# On the first script run, backup the local.conf file
# Consecutive runs, it restores the backup and changes are appended on this one.
if [ ! -e $BUILD_DIR/conf/local.conf.org ]; then
    cp $BUILD_DIR/conf/local.conf $BUILD_DIR/conf/local.conf.org
else
    cp $BUILD_DIR/conf/local.conf.org $BUILD_DIR/conf/local.conf
fi

# swap around the original generated bblayers.conf from fsl community layer
if [ ! -e $BUILD_DIR/conf/bblayers.conf.org ]; then
    cp $BUILD_DIR/conf/bblayers.conf $BUILD_DIR/conf/bblayers.conf.org
else
    cp $BUILD_DIR/conf/bblayers.conf.org $BUILD_DIR/conf/bblayers.conf
fi

# Support integrating community meta-freescale instead of meta-fsl-arm
if [ -d ../sources/meta-freescale ]; then
    echo "meta-freescale directory found"
    # Change settings according to environment
    sed -e "s,meta-fsl-arm\s,meta-freescale ,g" -i conf/bblayers.conf
    sed -e "s,\$.BSPDIR./sources/meta-fsl-arm-extra\s,,g" -i conf/bblayers.conf
fi

# Pass in the extra variables for uEnv.txt recipe
if [ -n "$DISPLAY" ]; then
    export DISPLAY_INFO=$DISPLAY
    export BB_ENV_EXTRAWHITE="$BB_ENV_EXTRAWHITE DISPLAY_INFO"
fi
if [ -n "$BASEBOARD" ]; then
    export BASE_BOARD=$BASEBOARD
    export BB_ENV_EXTRAWHITE="$BB_ENV_EXTRAWHITE BASE_BOARD"
fi

# Identify SOC type
CPU_TYPE=$(echo $MACHINE | sed 's/.*-\(imx[5-8][a-z]*\)[- $]*.*/\1/g')

# Choose corresponding firmware package for different WLAN (QCA or BRCM), e.g. 'linux-firmware-brcm-tn' or 'linux-firmware-qca-tn'
if [ -z "${WIFI_FIRMWARE#"${WIFI_FIRMWARE%%[! ]*}"}" ]; then
    echo "WARNING - No WIFI_FIRMWARE specified"
    export RF_FIRMWARES=""
else
    if [ "$WIFI_FIRMWARE" == "all" ]; then
        if [ "$CPU_TYPE" == 'imx8mq' ] || [ "$CPU_TYPE" == 'imx8mm' ]; then
            echo "WARNING - imx8mq/imx8mm SOM only supports qca wireless module, so load qca firmware"
            export RF_FIRMWARES="qca ath-pci"
        elif [ "$CPU_TYPE" == 'imx6' ] || [ "$CPU_TYPE" == "imx7" ] || [ "$CPU_TYPE" == 'imx6ul' ]; then
            export RF_FIRMWARES="qca brcm ath-pci"
        else
            echo "WARNING - No matched CPU_TYPE: $CPU_TYPE, hence no WIFI_FIRMWARE"
            export RF_FIRMWARES=""
        fi
    elif [ "$WIFI_FIRMWARE" == "y" ] || [ "$WIFI_FIRMWARE" == "Y" ]; then
        if [ "$CPU_TYPE" == 'imx8mq' ] || [ "$CPU_TYPE" == 'imx8mm' ]; then
            echo "WARNING - imx8mq/imx8mm SOM only supports qca wireless module, so load qca firmware"
            export RF_FIRMWARES="qca"
        else
            if  [ -z "${WIFI_MODULE#"${WIFI_MODULE%%[! ]*}"}" ]; then
                echo "WARNING - No WIFI_MODULE specified."
                export RF_FIRMWARES=""
            else
                export RF_FIRMWARES=$WIFI_MODULE
            fi
        fi
    else
        echo "WARNING - Unrecognized WIFI_FIRMWARE specified"
        export RF_FIRMWARES=""
    fi
fi
export BB_ENV_EXTRAWHITE="$BB_ENV_EXTRAWHITE RF_FIRMWARES"
echo "Selected wifi firmwares: $RF_FIRMWARES"

unset WIFI_MODULE
unset WIFI_FIRMWARE
unset DISPLAY
unset BASEBOARD

cd $BUILD_DIR
clean_up
unset FSLDISTRO
