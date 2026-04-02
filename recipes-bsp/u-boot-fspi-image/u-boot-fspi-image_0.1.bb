SUMMARY = "flexspi u-boot image"
SECTION = "devel"

LICENSE = "GPL-2.0-or-later"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/GPL-2.0-only;md5=801f80980d171dd6425610833a22dbe6"

SRC_URI += "file://tek-imx8mp_fspi_u-boot.bin \
	file://tep-imx8mp_fspi_u-boot.bin \
"

inherit deploy

do_deploy() {
    install -d ${DEPLOYDIR}
    if [ "${MACHINE}" = "tek-imx8mp" ];then
        install -m 0755 ${UNPACKDIR}/tek-imx8mp_fspi_u-boot.bin ${DEPLOYDIR}/
    elif [ "${MACHINE}" = "tep-imx8mp" ];then
        install -m 0755 ${UNPACKDIR}/tep-imx8mp_fspi_u-boot.bin ${DEPLOYDIR}/
    fi
}

addtask deploy after do_install

PACKAGE_ARCH = "${MACHINE_ARCH}"
COMPATIBLE_MACHINE = "(mx8mp-nxp-bsp)"
