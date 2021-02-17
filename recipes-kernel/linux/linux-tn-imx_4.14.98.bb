# Copyright (C) 2013-2016 Freescale Semiconductor
# Copyright 2018 TechNexion Ltd.
# Copyright 2017-2018 NXP
# Released under the MIT license (see COPYING.MIT for the terms)

FILESEXTRAPATHS_prepend := "${THISDIR}/file:"

require recipes-kernel/linux/linux-imx.inc
require recipes-kernel/linux/linux-tn-src_${PV}.inc

SUMMARY = "Linux Kernel provided and supported by NXP"
DESCRIPTION = "Linux Kernel provided and supported by NXP with focus on \
i.MX Family Reference Boards. It includes support for many IPs such as GPU, VPU and IPU."

DEPENDS += "lzop-native bc-native"

DEFAULT_PREFERENCE = "1"

DO_CONFIG_V7_COPY = "no"
DO_CONFIG_V7_COPY_mx6 = "yes"
DO_CONFIG_V7_COPY_mx7 = "yes"
DO_CONFIG_V7_COPY_mx8 = "no"

addtask copy_defconfig after do_patch before do_preconfigure

# change do_copy_defconfig to use source code from our tn-kernel repository
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

do_copy_defconfig_append_rescue () {
    cp ${WORKDIR}/logo.ppm ${S}/drivers/video/logo/logo_linux_clut224.ppm
}

SRC_URI_append_rescue = " \
	file://0001-imx8mm-patch-to-reduce-cma-size-to-100MB.patch \
	file://0002-imx8mq-patch-to-reduce-cma-size-to-100MB.patch \
	file://0001-imx7d-patch-to-reduce-cmd-size-to-50MB.patch \
	file://0002-imx6dl-patch-to-reduce-cmd-size-to-50MB.patch \
	file://0003-imx6q-patch-to-reduce-cmd-size-to-50MB.patch \
	file://0001-fbdev-fbmem-add-config-option-to-center-the-bootup-l.patch \
	file://0002-ARM64-config-enable-FB_LOGO_CENTER-for-rescue-bootup.patch \
	file://0001-ARM-config-enable-FB_LOGO_CENTER-for-rescue-bootup.patch \
	file://0004-video-fbdev-core-fbmem-modify-to-a-single-graph.patch \
	file://logo.ppm \
	"

COMPATIBLE_MACHINE = "(mx6|mx7|mx8)"
