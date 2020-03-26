SUMMARY = "Package a minimal container image"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

PACKAGE_ARCH = "${MACHINE_ARCH}"

do_install[mcdepends] = "multiconfig:container:tn-container-image-glmark2:do_image_complete"
do_compile[noexec] = "1"

do_install () {
	install -d ${D}/var/lib/machines
	install ${TOPDIR}/tmp-container/deploy/images/tn-container/tn-container-image-glmark2-tn-container.ext4 ${D}/var/lib/machines
}

RDEPENDS_${PN} += "systemd-container"
