#!/bin/sh
#
# FSL Build Enviroment Setup Script
#
# Copyright (C) 2011-2015 Freescale Semiconductor
# Copyright (C) 2015-2016 Technexion Ltd.
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

CWD=`pwd`
PROGNAME="setup-environment"
exit_message ()
{
   echo "To return to this build environment later please run:"
   echo "    source setup-environment <build_dir>"

}

usage()
{
    echo -e "\nUsage: source fsl-setup-release.sh
    Optional parameters: [-b build-dir] [-e back-end] [-h]"
echo "
    * [-b build-dir]: Build directory, if unspecified script uses 'build' as output directory
    * [-e back-end]: Options are 'fb', 'dfb', 'x11, 'wayland'
    * [-h]: help
"
}


clean_up()
{

    unset CWD BUILD_DIR BACKEND FSLDISTRO
    unset fsl_setup_help fsl_setup_error fsl_setup_flag
    unset usage clean_up
    unset ARM_DIR META_FSL_BSP_RELEASE
    exit_message clean_up
}

# Patch recipes to fix bugs
patch -Np1 -r - sources/meta-fsl-bsp-release/imx/meta-sdk/conf/distro/include/fsl-imx-preferred-env.inc < sources/meta-edm-bsp-release/patches/0001-remove-preferred-provider-for-u-boot-and-kernel-to-l.patch
patch -Np1 -r - sources/meta-fsl-arm/classes/image_types_fsl.bbclass < sources/meta-edm-bsp-release/patches/0002-image_types_fsl.bbclass-modify-to-put-u-boot.img-int.patch
patch -Np1 -r - sources/meta-fsl-bsp-release/imx/meta-bsp/recipes-multimedia/gstreamer/gstreamer1.0-plugins-bad_%.bbappend < sources/meta-edm-bsp-release/patches/0003-gstreamer1.0-plugins-bad-add-support-for-multi-platf.patch
patch -Np1 -r - sources/meta-fsl-bsp-release/imx/meta-bsp/recipes-graphics/mesa/mesa-demos_%.bbappend < sources/meta-edm-bsp-release/patches/0004-mesa-demos-add-support-for-multi-platform.patch
patch -Np1 -r - sources/meta-fsl-arm/recipes-multimedia/gstreamer/gst1.0-fsl-plugin_4.0.7.bb < sources/meta-edm-bsp-release/patches/0005-meta-fsl-arm-gst1.0-fsl-plugin-libfslvpuwrap-is-alre.patch
patch -Np1 -r - sources/meta-fsl-bsp-release/imx/meta-sdk/recipes-qt5/qt5/qtbase_%.bbappend < sources/meta-edm-bsp-release/patches/0006-imx-meta-sdk-recipes-qt5-qt5-qtbase-add-linuxfb-supp.patch

## Upgrde chromium from 40 to 48
patch -Np1 -r - sources/meta-browser/recipes-browser/chromium/chromium_48.0.2548.0.bb < sources/meta-edm-bsp-release/patches/chromium48_0001-Remove-chromium_48-from-blacklist-to-compile-it-in-Y.patch
cp sources/meta-edm-bsp-release/patches/meta-fsl-arm_chromium_48.0.2548.0.bbappend sources/meta-fsl-arm/browser-layer/recipes-browser/chromium/chromium_48.0.2548.0.bbappend
cp sources/meta-edm-bsp-release/patches/meta-fsl-bsp-release_chromium_48.0.2548.0.bbappend sources/meta-fsl-bsp-release/imx/meta-bsp/recipes-browser/chromium/chromium_48.0.2548.0.bbappend
rm sources/meta-fsl-arm/browser-layer/recipes-browser/chromium/chromium_40.0.2214.91.bbappend
rm sources/meta-fsl-bsp-release/imx/meta-bsp/recipes-browser/chromium/chromium_40.0.2214.91.bbappend

# get command line options
OLD_OPTIND=$OPTIND
unset FSLDISTRO

while getopts "k:r:t:b:e:gh" fsl_setup_flag
do
    case $fsl_setup_flag in
        b) BUILD_DIR="$OPTARG";
           echo -e "\n Build directory is " $BUILD_DIR
           ;;
        e)
            # Determine what distro needs to be used.
            BACKEND="$OPTARG"
            if [ "$BACKEND" = "fb" ]; then
                if [ -z "$DISTRO" ]; then
                    FSLDISTRO='fsl-imx-fb'
                    echo -e "\n Using FB backend with FB DIST_FEATURES to override poky X11 DIST FEATURES"
                elif [ ! "$DISTRO" = "fsl-imx-fb" ]; then
                    echo -e "\n DISTRO specified conflicts with -e. Please use just one or the other."
                    fsl_setup_error='true'
                fi

            elif [ "$BACKEND" = "dfb" ]; then
                if [ -z "$DISTRO" ]; then
                    FSLDISTRO='fsl-imx-dfb'
                    echo -e "\n Using DirectFB backend with DirectFB DIST_FEATURES to override poky X11 DIST FEATURES"
                elif [ ! "$DISTRO" = "fsl-imx-dfb" ]; then
                    echo -e "\n DISTRO specified conflicts with -e. Please use just one or the other."
                    fsl_setup_error='true'
                fi

            elif [ "$BACKEND" = "wayland" ]; then
                if [ -z "$DISTRO" ]; then
                    FSLDISTRO='fsl-imx-wayland'
                    echo -e "\n Using Wayland backend."
                elif [ ! "$DISTRO" = "fsl-imx-wayland" ]; then
                    echo -e "\n DISTRO specified conflicts with -e. Please use just one or the other."
                    fsl_setup_error='true'
                fi

            elif [ "$BACKEND" = "x11" ]; then
                if [ -z "$DISTRO" ]; then
                    FSLDISTRO='fsl-imx-x11'
                    echo -e  "\n Using X11 backend with poky DIST_FEATURES"
                elif [ ! "$DISTRO" = "fsl-imx-x11" ]; then
                    echo -e "\n DISTRO specified conflicts with -e. Please use just one or the other."
                    fsl_setup_error='true'
                fi

            else
                echo -e "\n Invalid backend specified with -e.  Use fb, dfb, wayland, or x11"
                fsl_setup_error='true'
            fi
           ;;
        h) fsl_setup_help='true';
           ;;
        ?) fsl_setup_error='true';
           ;;
    esac
done


if [ -z "$DISTRO" ]; then
    if [ -z "$FSLDISTRO" ]; then
        FSLDISTRO='fsl-imx-x11'
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
    MACHINE='edm1-cf-imx6'
fi

# New machine definitions may need to be added to the expected location
if [ -d ./sources/meta-freescale ]; then
   cp -r sources/meta-fsl-bsp-release/imx/meta-bsp/conf/machine/* sources/meta-freescale/conf/machine
else
   cp -r sources/meta-fsl-bsp-release/imx/meta-bsp/conf/machine/* sources/meta-fsl-arm/conf/machine
fi

cp -r sources/meta-fsl-bsp-release/imx/meta-bsp/conf/machine/* sources/meta-fsl-arm/conf/machine

# copy new EULA into community so setup uses latest i.MX EULA
if [ -d ./sources/meta-freescale ]; then
   cp sources/meta-fsl-bsp-release/imx/EULA.txt sources/meta-freescale/EULA
else
   cp sources/meta-fsl-bsp-release/imx/EULA.txt sources/meta-fsl-arm/EULA
fi

# copy unpack class with md5sum that matches new EULA
if [ -d ./sources/meta-freescale ]; then
   cp sources/meta-fsl-bsp-release/imx/classes/fsl-eula-unpack.bbclass sources/meta-freescale/classes
else
   cp sources/meta-fsl-bsp-release/imx/classes/fsl-eula-unpack.bbclass sources/meta-fsl-arm/classes
fi

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
echo "##Freescale Yocto Project Release layer" >> $BUILD_DIR/conf/bblayers.conf
echo "BBLAYERS += \" \${BSPDIR}/sources/meta-fsl-bsp-release/imx/meta-bsp \"" >> $BUILD_DIR/conf/bblayers.conf
echo "BBLAYERS += \" \${BSPDIR}/sources/meta-fsl-bsp-release/imx/meta-sdk \"" >> $BUILD_DIR/conf/bblayers.conf

echo "BBLAYERS += \" \${BSPDIR}/sources/meta-browser \"" >> $BUILD_DIR/conf/bblayers.conf
echo "BBLAYERS += \" \${BSPDIR}/sources/meta-openembedded/meta-gnome \"" >> $BUILD_DIR/conf/bblayers.conf
echo "BBLAYERS += \" \${BSPDIR}/sources/meta-openembedded/meta-networking \"" >> $BUILD_DIR/conf/bblayers.conf
echo "BBLAYERS += \" \${BSPDIR}/sources/meta-openembedded/meta-python \"" >> $BUILD_DIR/conf/bblayers.conf
echo "BBLAYERS += \" \${BSPDIR}/sources/meta-openembedded/meta-ruby \"" >> $BUILD_DIR/conf/bblayers.conf
echo "BBLAYERS += \" \${BSPDIR}/sources/meta-openembedded/meta-filesystems \"" >> $BUILD_DIR/conf/bblayers.conf
echo "BBLAYERS += \" \${BSPDIR}/sources/meta-openembedded/meta-xfce \"" >> $BUILD_DIR/conf/bblayers.conf

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

# Generate uEnv.txt for u-boot
UENV_PATH="../sources/meta-edm-bsp-release/recipes-bsp/u-boot/u-boot-uenv"

echo UENV_PATH=$UENV_PATH

if [ "$DISPLAY" != "lvds7" ] && [ "$DISPLAY" != "lvds10" ] && [ "$DISPLAY" != "hdmi720p" ] && [ "$DISPLAY" != "hdmi1080p" ]  \
&& [ "$DISPLAY" != "lcd" ] && [ "$DISPLAY" != "lvds7_hdmi720p" ] && [ "$DISPLAY" != "custom" ] \
&& [ "$MACHINE" != "pico-imx6ul-emmc" ]; then
	echo "Display is wrong. Please assign DISPLAY as one of lvds7, lvds10, hdmi720p, hdmi1080p, lcd, lvds7_hdmi720p, lcd, custom"
	if [ "$BASEBOARD" == "tc0700" ]; then
		echo "setting lvds7 as default display"
		DISPLAY="lvds7"
	else
		echo "setting hdmi720p as default display"
		DISPLAY="hdmi720p"
	fi
fi

# i.mx6ul only has LCDIF interface and can't change display type by uEnv.txt
if [ "$MACHINE" == "pico-imx6ul-emmc" ]; then
		DISPLAY="lcd"
fi

echo DISPLAY=$DISPLAY

if [ -f $UENV_PATH/uEnv.txt ] ; then
	rm $UENV_PATH/uEnv.txt
fi

cp $UENV_PATH/uEnv_${DISPLAY}.txt $UENV_PATH/uEnv.txt

if [ "$MACHINE" == "edm1-cf-imx6" ] || [ "$MACHINE" == "edm1-cf-imx6-no-console" ] ; then
	if [ "$BASEBOARD" != "fairy" ] && [ "$BASEBOARD" != "tc0700" ] ; then
		echo "BASEBOARD is wrong. Please assign BASEBOARD as one of fairy, tc0700"
		echo "setting fairy as default baseboard"
		BASEBOARD="fairy"
	fi

	sed -i "1s/^/baseboard=$BASEBOARD\n/" $UENV_PATH/uEnv.txt

	echo BASEBOARD=$BASEBOARD
fi

if [ "$MACHINE" == "pico-imx6" ] ; then
	if [ "$BASEBOARD" != "dwarf" ] && [ "$BASEBOARD" != "hobbit" ] && [ "$BASEBOARD" != "nymph" ] ; then
		echo "BASEBOARD is wrong. Please assign BASEBOARD as one of dwarf, hobbit, nymph"
		echo "setting dwarf as default baseboard"
		BASEBOARD="dwarf"
	fi

	sed -i "1s/^/baseboard=$BASEBOARD\n/" $UENV_PATH/uEnv.txt

	echo BASEBOARD=$BASEBOARD
fi

# Set default audio output device by display type for pulseaudio
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

unset DISPLAY
unset BASEBOARD

cd  $BUILD_DIR
clean_up
unset FSLDISTRO
