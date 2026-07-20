# Copyright (C) 2013-2016 Freescale Semiconductor
# Copyright 2018 (C) O.S. Systems Software LTDA.
# Copyright 2017-2026 NXP
# Copyright 2026 TechNexion Ltd.

DESCRIPTION = "i.MX U-Boot suppporting TechNexion i.MX boards."

require recipes-bsp/u-boot/u-boot.inc

LICENSE = "GPL-2.0-or-later"
LIC_FILES_CHKSUM = "file://Licenses/gpl-2.0.txt;md5=b234ee4d69f5fce4486a80fdaf4a4263"

SRC_URI = "${UBOOT_SRC};branch=${SRCBRANCH}"

UBOOT_SRC = "git://github.com/TechNexion/u-boot-tn-imx.git;protocol=https"
SRCBRANCH = "tn-imx_v2026.04_6.18.20_2.0.0-next"
LOCALVERSION ?= "-${SRCREV}"
SRCREV = "08ca9088e62d4f697bf70bad376eeea1a96c77b9"

SRC_URI:append = " file://splash.bmp"
SRC_URI:append:rescue = " file://rescue-fragment-uboot.cfg"

DEPENDS += " \
    bc-native \
    bison-native \
    dtc-native \
    flex-native \
    gnutls-native \
    python3-setuptools-native \
    xxd-native \
    efitools-native \
"
RDEPENDS:${PN}:append:uenv = " u-boot-uenv"
RDEPENDS:${PN}:append:bootscr = " u-boot-script-technexion"

B = "${WORKDIR}/build"

inherit fsl-u-boot-localversion pkgconfig

BOOT_TOOLS = "imx-boot-tools"

PROVIDES += "u-boot u-boot-mfgtool"

inherit uuu_bootloader_tag

# The UUU tag goes on the boot partition. For 8+, the boot partition image
# is imx-boot, so disable UUU-tagging here
UUU_BOOTLOADER:mx8-generic-bsp = ""
UUU_BOOTLOADER:mx9-generic-bsp = ""

TOOLCHAIN_OPTIONS:append = " -Wno-error=implicit-function-declaration"

do_deploy:append () {
	install -d ${DEPLOYDIR}
	install ${UNPACKDIR}/splash.bmp ${DEPLOYDIR}/splash.bmp
}

do_deploy:append:mx8m-generic-bsp() {
    # Deploy u-boot-nodtb.bin and fsl-imx8m*-XX.dtb for mkimage to generate boot binary
    if [ -n "${UBOOT_CONFIG}" ]
    then
        for config in ${UBOOT_MACHINE}; do
            i=$(expr $i + 1);
            for type in ${UBOOT_CONFIG}; do
                builddir="${config}-${type}"
                j=$(expr $j + 1);
                if [ $j -eq $i ]
                then
                    builddir="${config}-${type}"
                    install -d ${DEPLOYDIR}/${BOOT_TOOLS}
                    install -m 0644 ${B}/${builddir}/u-boot-nodtb.bin  ${DEPLOYDIR}/${BOOT_TOOLS}/u-boot-nodtb.bin-${MACHINE}-${UBOOT_CONFIG}
                    for DTB in ${UBOOT_DTB_NAME}; do
                        install -m 0644 ${B}/${builddir}/arch/arm/dts/${DTB}  ${DEPLOYDIR}/${BOOT_TOOLS}
                    done
                fi
            done
            unset  j
        done
        unset  i
    fi

    # Deploy CRT.* from u-boot for stmm
    install -m 0644 ${S}/CRT.*     ${DEPLOYDIR}
}

do_deploy:append:mx93-generic-bsp() {
    # Deploy CRT.* from u-boot for stmm
    install -m 0644 ${S}/CRT.*     ${DEPLOYDIR}
}

do_deploy:append:mx95-generic-bsp() {
    # Deploy CRT.* from u-boot for stmm
    install -m 0644 ${S}/CRT.*     ${DEPLOYDIR}
}

PACKAGE_ARCH = "${MACHINE_ARCH}"
COMPATIBLE_MACHINE = "(imx-nxp-bsp)"
