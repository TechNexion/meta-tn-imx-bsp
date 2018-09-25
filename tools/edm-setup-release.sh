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
PROGNAME="setup-environment"
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

# Patch recipes to fix bugs
patch -Np1 -r - sources/meta-fsl-bsp-release/imx/meta-bsp/recipes-bsp/imx-mkimage/imx-boot_0.2.bb < sources/meta-edm-bsp-release/patches/0001-imx-boot-pass-dtb-name-to-imx-mkimage-when-making-fl.patch
patch -Np1 -r - sources/meta-fsl-bsp-release/imx/meta-bsp/recipes-security/optee-imx/optee-os-imx_git.bb < sources/meta-edm-bsp-release/patches/0002-optee-os-imx-fix-build-failure-when-the-board-isn-t-.patch
patch -Np1 -r - sources/meta-fsl-bsp-release/imx/meta-bsp/classes/image_types_fsl.bbclass < sources/meta-edm-bsp-release/patches/0003-image_types_fsl.bbclass-change-to-put-u-boot.img-int.patch

# get command line options
OLD_OPTIND=$OPTIND
unset FSLDISTRO

while getopts "k:r:t:b:e:gh" fsl_setup_flag
do
    case $fsl_setup_flag in
        b) BUILD_DIR="$OPTARG";
           echo -e "\n Build directory is " $BUILD_DIR
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

if [ -z "$MACHINE" ]; then
    echo setting to default machine
    MACHINE='pico-imx6-qca'
fi

# copy new EULA into community so setup uses latest i.MX EULA
cp sources/meta-fsl-bsp-release/imx/EULA.txt sources/meta-freescale/EULA

# Set up the basic yocto environment
if [ -z "$DISTRO" ]; then
   DISTRO=$FSLDISTRO MACHINE=$MACHINE . ./$PROGNAME $BUILD_DIR
else
   MACHINE=$MACHINE . ./$PROGNAME $BUILD_DIR
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


if [ ! -e $BUILD_DIR/conf/bblayers.conf.org ]; then
    cp $BUILD_DIR/conf/bblayers.conf $BUILD_DIR/conf/bblayers.conf.org
else
    cp $BUILD_DIR/conf/bblayers.conf.org $BUILD_DIR/conf/bblayers.conf
fi


META_FSL_BSP_RELEASE="${CWD}/sources/meta-fsl-bsp-release/imx/meta-bsp"

echo "" >> $BUILD_DIR/conf/bblayers.conf
echo "# i.MX Yocto Project Release layers" >> $BUILD_DIR/conf/bblayers.conf
hook_in_layer meta-fsl-bsp-release/imx/meta-bsp
hook_in_layer meta-fsl-bsp-release/imx/meta-sdk

echo "" >> $BUILD_DIR/conf/bblayers.conf
echo "BBLAYERS += \" \${BSPDIR}/sources/meta-browser \"" >> $BUILD_DIR/conf/bblayers.conf
echo "BBLAYERS += \" \${BSPDIR}/sources/meta-openembedded/meta-gnome \"" >> $BUILD_DIR/conf/bblayers.conf
echo "BBLAYERS += \" \${BSPDIR}/sources/meta-openembedded/meta-networking \"" >> $BUILD_DIR/conf/bblayers.conf
echo "BBLAYERS += \" \${BSPDIR}/sources/meta-openembedded/meta-python \"" >> $BUILD_DIR/conf/bblayers.conf
echo "BBLAYERS += \" \${BSPDIR}/sources/meta-openembedded/meta-filesystems \"" >> $BUILD_DIR/conf/bblayers.conf

echo "BBLAYERS += \" \${BSPDIR}/sources/meta-qt5 \"" >> $BUILD_DIR/conf/bblayers.conf
echo "BBLAYERS += \" \${BSPDIR}/sources/meta-edm-bsp-release \"" >> $BUILD_DIR/conf/bblayers.conf

echo BSPDIR=$BSPDIR
echo BUILD_DIR=$BUILD_DIR

# Support integrating community meta-freescale instead of meta-fsl-arm
if [ -d ../sources/meta-freescale ]; then
    echo meta-freescale directory found
    # Change settings according to environment
    sed -e "s,meta-fsl-arm\s,meta-freescale ,g" -i conf/bblayers.conf
    sed -e "s,\$.BSPDIR./sources/meta-fsl-arm-extra\s,,g" -i conf/bblayers.conf
fi

#Identify SOC type
CPU_TYPE=`echo $MACHINE | sed 's/.*-\(imx[5-8][a-z]*\)[- $]*.*/\1/g'`
echo CPU_TYPE=$CPU_TYPE

# Generate uEnv.txt for u-boot
UENV_PATH="../sources/meta-edm-bsp-release/recipes-bsp/u-boot/u-boot-uenv"

echo UENV_PATH=$UENV_PATH

if [ -f $UENV_PATH/uEnv.txt ] ; then
	rm $UENV_PATH/uEnv.txt
fi

if [ "$CPU_TYPE" == 'imx6' ]; then
	if [ "$DISPLAY" != "lvds7" ] && [ "$DISPLAY" != "lvds10" ] && [ "$DISPLAY" != "lvds15" ] \
	&& [ "$DISPLAY" != "hdmi720p" ] && [ "$DISPLAY" != "hdmi1080p" ]  \
	&& [ "$DISPLAY" != "lcd" ] && [ "$DISPLAY" != "lvds7_hdmi720p" ] && [ "$DISPLAY" != "custom" ]; then
		echo "Display is wrong. Please assign DISPLAY as one of lvds7, lvds10, lvds15, hdmi720p, hdmi1080p, lcd, lvds7_hdmi720p, lcd, custom"
		if [ "$BASEBOARD" == "tc0700" ]; then
			echo "setting lvds7 as default display"
			DISPLAY="lvds7"
		else
			echo "setting hdmi720p as default display"
			DISPLAY="hdmi720p"
		fi
	fi

	cp $UENV_PATH/uEnv_${DISPLAY}.txt $UENV_PATH/uEnv.txt

	# Set default baseboard type for 'edm1-cf-imx6' and 'pico-imx6'
	if [ "$MACHINE" == "edm1-cf-imx6" ] || [ "$MACHINE" == "edm1-cf-imx6-no-console" ] ; then
		if [ "$BASEBOARD" != "fairy" ] && [ "$BASEBOARD" != "tc0700" ] ; then
			echo "BASEBOARD is wrong. Please assign BASEBOARD as one of fairy, tc0700"
			echo "setting fairy as default baseboard"
			BASEBOARD="fairy"
		fi
		sed -i "1s/^/baseboard=$BASEBOARD\n/" $UENV_PATH/uEnv.txt
		echo BASEBOARD=$BASEBOARD
	fi

	if [ "$MACHINE" == "pico-imx6-qca" ] || [ "$MACHINE" == "pico-imx6-brcm" ] ; then
		if [ "$BASEBOARD" != "dwarf" ] && [ "$BASEBOARD" != "hobbit" ] && [ "$BASEBOARD" != "nymph" ] && [ "$BASEBOARD" != "pi" ]; then
			echo "BASEBOARD is wrong. Please assign BASEBOARD as one of pi, nymph, dwarf, hobbit"
			echo "setting pi as default baseboard"
			BASEBOARD="pi"
		fi
		sed -i "1s/^/baseboard=$BASEBOARD\n/" $UENV_PATH/uEnv.txt
		echo BASEBOARD=$BASEBOARD
	fi
fi

if [ "$CPU_TYPE" == 'imx7' ]; then
	if [ "$MACHINE" == "pico-imx7-qca" ] || [ "$MACHINE" == "pico-imx7-brcm" ] ; then
		if [ "$BASEBOARD" != "dwarf" ] && [ "$BASEBOARD" != "hobbit" ] && [ "$BASEBOARD" != "nymph" ] && [ "$BASEBOARD" != "pi" ]; then
			echo "BASEBOARD is wrong. Please assign BASEBOARD as one of pi, nymph, dwarf, hobbit"
			echo "setting pi as default baseboard"
			BASEBOARD="pi"
		fi
		cp $UENV_PATH/uEnv_empty.txt $UENV_PATH/uEnv.txt
		sed -i "1s/^/baseboard=$BASEBOARD\n/" $UENV_PATH/uEnv.txt
		echo BASEBOARD=$BASEBOARD
	fi
fi

if [ "$CPU_TYPE" == 'imx6ul' ]; then
	if [ "$MACHINE" == "pico-imx6ul-qca" ] || [ "$MACHINE" == "pico-imx6ul-brcm" ] ; then
		if [ "$BASEBOARD" != "dwarf" ] && [ "$BASEBOARD" != "hobbit" ] && [ "$BASEBOARD" != "nymph" ] && [ "$BASEBOARD" != "pi" ]; then
			echo "BASEBOARD is wrong. Please assign BASEBOARD as one of pi, nymph, dwarf, hobbit"
			echo "setting hobbit as default baseboard"
			BASEBOARD="pi"
		fi
		cp $UENV_PATH/uEnv_empty.txt $UENV_PATH/uEnv.txt
		sed -i "1s/^/baseboard=$BASEBOARD\n/" $UENV_PATH/uEnv.txt
		echo BASEBOARD=$BASEBOARD
	fi
fi

# i.mx6ul can only output to TTL LCD panel and can't change display settings by uEnv.txt
if [ "$CPU_TYPE" == 'imx6ul' ] ; then
		DISPLAY="lcd"
fi

# i.mx6sx can only output to LVDS and TTL LCD and can't change display settings by uEnv.txt
# it requires to change device tree file to enable output to TTL LCD
if [ "$CPU_TYPE" == 'imx6sx' ]; then
		DISPLAY="lvds7"
fi

# i.mx7 can only output to TTL LCD panel
if [ "$CPU_TYPE" == 'imx7' ] ; then
		DISPLAY="lcd"
fi

echo DISPLAY=$DISPLAY

# Set default audio output device by display type for pulseaudio
# imx6 may output to LVDS/TTL_LCD or HDMI, and the default audio output device also depends on them.
# LVDS/TTL_LCD: output to audio codec(SGTL5k), HDMI: output to HDMI audio
if [ "$CPU_TYPE" == 'imx6' ]; then
	PULSEAUDIO_PATH="../sources/meta-edm-bsp-release/recipes-multimedia/pulseaudio/pulseaudio"
	if [ -f $PULSEAUDIO_PATH/default.pa ] ; then
		rm $PULSEAUDIO_PATH/default.pa
	fi

	cp $PULSEAUDIO_PATH/default_template.pa $PULSEAUDIO_PATH/default.pa

	if [ "$DISPLAY" == "hdmi720p" ] || [ "$DISPLAY" == "hdmi1080p" ]  || [ "$DISPLAY" == "lvds7_hdmi720p" ]; then
		sed -i -e 's/.*#set-default-sink output.*/set-default-sink alsa_output.platform-sound-hdmi.analog-stereo/' $PULSEAUDIO_PATH/default.pa
		echo default audio output device is hdmi
	else
		sed -i -e 's/.*#set-default-sink output.*/set-default-sink alsa_output.platform-sound.analog-stereo/' $PULSEAUDIO_PATH/default.pa
		echo default audio output device is audio codec
	fi
fi

unset DISPLAY
unset BASEBOARD

cd  $BUILD_DIR
clean_up
unset FSLDISTRO
