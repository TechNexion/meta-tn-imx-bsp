# Copyright (C) 2013-2016 Freescale Semiconductor
# Copyright 2018 TechNexion Ltd.
# Copyright 2017-2018 NXP
# Released under the MIT license (see COPYING.MIT for the terms)

SUMMARY = "Linux Kernel provided and supported by NXP"
DESCRIPTION = "Linux Kernel provided and supported by NXP with focus on \
i.MX Family Reference Boards. It includes support for many IPs such as GPU, VPU and IPU."

require recipes-kernel/linux/linux-imx.inc
require recipes-kernel/linux/linux-imx-src.inc

DEPENDS += "lzop-native bc-native"

TECHNEXION_GITHUB_MIRROR ?= "git://github.com/TechNexion/linux.git"

SRCBRANCH = "tn-imx_4.9.88_2.0.0_ga-test"

SRC_URI = "${TECHNEXION_GITHUB_MIRROR};branch=${SRCBRANCH}"

SRCREV = "2c2b3f4bb468664ab0085107a21756f041173da5"
LOCALVERSION = "-${SRCBRANCH}"

DEFAULT_PREFERENCE = "1"

DO_CONFIG_V7_COPY = "no"
DO_CONFIG_V7_COPY_mx6 = "yes"
DO_CONFIG_V7_COPY_mx7 = "yes"
DO_CONFIG_V7_COPY_mx8 = "no"

addtask copy_defconfig after do_unpack before do_preconfigure
do_copy_defconfig () {
    install -d ${B}
	if [ ${DO_CONFIG_V7_COPY} = "yes" ]; then
        # copy latest imx_v7_defconfig to use for mx6, mx6ul and mx7
        mkdir -p ${B}
        cp ${S}/arch/arm/configs/tn_imx_defconfig ${B}/.config
        cp ${S}/arch/arm/configs/tn_imx_defconfig ${B}/../defconfig
    else
    	# copy latest defconfig to use for mx8
    	mkdir -p ${B}
    	cp ${S}/arch/arm64/configs/tn_imx8_defconfig ${B}/.config
    	cp ${S}/arch/arm64/configs/tn_imx8_defconfig ${B}/../defconfig
	fi
}

COMPATIBLE_MACHINE = "(mx6|mx7|mx8)"
EXTRA_OEMAKE_append_mx6 = " ARCH=arm"
EXTRA_OEMAKE_append_mx7 = " ARCH=arm"
EXTRA_OEMAKE_append_mx8 = " ARCH=arm64"
