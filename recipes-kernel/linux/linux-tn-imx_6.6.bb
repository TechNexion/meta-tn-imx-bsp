# Copyright 2013-2016 Freescale Semiconductor
# Copyright 2017-2023 NXP
# Copyright 2024 TechNexion Ltd.
# Copyright 2018 O.S. Systems Software LTDA.
# Released under the MIT license (see COPYING.MIT for the terms)
#
# SPDX-License-Identifier: MIT
#

FILESEXTRAPATHS:prepend := "${THISDIR}/file:"

SUMMARY = "Linux Kernel provided and supported by NXP"
DESCRIPTION = "Linux Kernel provided and supported by NXP with focus on \
i.MX Family Reference Boards. It includes support for many IPs such as GPU, VPU and IPU."

require recipes-kernel/linux/linux-imx.inc

LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = "file://COPYING;md5=6bc538ed5bd9a7fc9398086aedcd7e46"

DEPENDS += "lzop-native bc-native"

SRC_URI = "${KERNEL_SRC}"
KERNEL_SRC ?= "git://github.com/TechNexion/linux-tn-imx.git;protocol=https;branch=${SRCBRANCH}"
KBRANCH = "${SRCBRANCH}"
SRCBRANCH = "tn-imx_6.6.36_2.1.0-next"
LOCALVERSION = "${@'-%s' % '-'.join(d.getVar('KBRANCH', True).split('_')[2:]).lower()}"
SRCREV = "c0cf1971a2f65f3f65a5c214784d06735aa8b817"

SRC_URI:append:virtualization = " file://0001-ARM64-configs-tn_imx8_defconfig-btrfs-fuse-overlayfs.patch"

# PV is defined in the base in linux-imx.inc file and uses the LINUX_VERSION definition
# required by kernel-yocto.bbclass.
#
# LINUX_VERSION define should match to the kernel version referenced by SRC_URI and
# should be updated once patchlevel is merged.
LINUX_VERSION = "6.6.23"

KERNEL_CONFIG_COMMAND = "oe_runmake_call -C ${S} CC="${KERNEL_CC}" O=${B} olddefconfig"

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

DEFAULT_PREFERENCE = "1"

DO_CONFIG_V7_COPY = "no"
DO_CONFIG_V7_COPY:mx6-nxp-bsp = "yes"
DO_CONFIG_V7_COPY:mx7-nxp-bsp = "yes"
DO_CONFIG_V7_COPY:mx8-nxp-bsp = "no"
DO_CONFIG_V7_COPY:mx9-nxp-bsp = "no"

# Add setting for LF Mainline build
IMX_KERNEL_CONFIG_AARCH32 = "tn_imx_defconfig"
IMX_KERNEL_CONFIG_AARCH64 = "tn_imx8_defconfig"
KBUILD_DEFCONFIG ?= ""
KBUILD_DEFCONFIG:mx6-nxp-bsp= "${IMX_KERNEL_CONFIG_AARCH32}"
KBUILD_DEFCONFIG:mx7-nxp-bsp= "${IMX_KERNEL_CONFIG_AARCH32}"
KBUILD_DEFCONFIG:mx8-nxp-bsp= "${IMX_KERNEL_CONFIG_AARCH64}"
KBUILD_DEFCONFIG:mx9-nxp-bsp= "${IMX_KERNEL_CONFIG_AARCH64}"


# Use a verbatim copy of the defconfig from the linux-imx repo.
# IMPORTANT: This task effectively disables kernel config fragments
# since the config fragments applied in do_kernel_configme are replaced.
addtask copy_defconfig after do_kernel_configme before do_kernel_localversion
do_copy_defconfig () {
    install -d ${B}
    if [ ${DO_CONFIG_V7_COPY} = "yes" ]; then
        # copy latest IMX_KERNEL_CONFIG_AARCH32 to use for mx6, mx6ul and mx7
        mkdir -p ${B}
        cp ${S}/arch/arm/configs/${IMX_KERNEL_CONFIG_AARCH32} ${B}/.config
    else
        # copy latest IMX_KERNEL_CONFIG_AARCH64 to use for mx8
        mkdir -p ${B}
        cp ${S}/arch/arm64/configs/${IMX_KERNEL_CONFIG_AARCH64} ${B}/.config
    fi
}

DELTA_KERNEL_DEFCONFIG ?= ""
#DELTA_KERNEL_DEFCONFIG:mx8-nxp-bsp = "imx.config"

do_merge_delta_config[dirs] = "${B}"
do_merge_delta_config[depends] += " \
    flex-native:do_populate_sysroot \
    bison-native:do_populate_sysroot \
"
do_merge_delta_config() {
    for deltacfg in ${DELTA_KERNEL_DEFCONFIG}; do
        if [ -f ${S}/arch/${ARCH}/configs/${deltacfg} ]; then
            ${KERNEL_CONFIG_COMMAND}
            oe_runmake_call -C ${S} CC="${KERNEL_CC}" O=${B} ${deltacfg}
        elif [ -f "${WORKDIR}/${deltacfg}" ]; then
            ${S}/scripts/kconfig/merge_config.sh -m .config ${WORKDIR}/${deltacfg}
        elif [ -f "${deltacfg}" ]; then
            ${S}/scripts/kconfig/merge_config.sh -m .config ${deltacfg}
        fi
    done
    cp .config ${WORKDIR}/defconfig
}
addtask merge_delta_config before do_kernel_localversion after do_copy_defconfig

do_kernel_configcheck[noexec] = "1"

KERNEL_VERSION_SANITY_SKIP="1"
COMPATIBLE_MACHINE = "(imx-nxp-bsp)"
