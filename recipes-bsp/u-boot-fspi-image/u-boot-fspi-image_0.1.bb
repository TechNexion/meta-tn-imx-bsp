SUMMARY = "flexspi u-boot image"
SECTION = "devel"

LICENSE = "GPL-2.0-or-later"
LIC_FILES_CHKSUM = "file://tek3-imx8mp_fspi_u-boot.bin;md5=401ae7718fe883ba4ed2477c61ceb2bc"

SRC_URI += "file://tek3-imx8mp_fspi_u-boot.bin \
	file://hmi-imx8mp_fspi_u-boot.bin \
"

S = "${WORKDIR}"

inherit deploy

do_deploy() {
    install -d ${DEPLOYDIR}
    if [ "${MACHINE}" = "tek3-imx8mp" ];then
        install -m 0755 ${S}/tek3-imx8mp_fspi_u-boot.bin ${DEPLOYDIR}/
    elif [ "${MACHINE}" = "hmi-imx8mp" ];then
        install -m 0755 ${S}/hmi-imx8mp_fspi_u-boot.bin ${DEPLOYDIR}/
    fi
}

addtask deploy after do_install

PACKAGE_ARCH = "${MACHINE_ARCH}"
COMPATIBLE_MACHINE = "(mx8mp-nxp-bsp)"
