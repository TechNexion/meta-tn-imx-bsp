SUMMARY = "A small docker container image with lighttpd"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

inherit core-image

# Enough free space for a full image update
IMAGE_OVERHEAD_FACTOR = "2.3"

PACKAGE_ARCH = "${MACHINE_ARCH}"

IMAGE_FSTYPES = "${TN_CONTAINER_IMAGE_TYPE}"
IMAGE_TYPEDEP_container += "${TN_CONTAINER_IMAGE_TYPE}"

IMAGE_FEATURES = ""
IMAGE_LINGUAS = ""
NO_RECOMMENDATIONS = "1"

# Note that busybox is required to satisfy /bin/sh requirement of lighttpd,
# and the access* modules need to be explicitly specified since RECOMMENDATIONS
# are disabled.
IMAGE_INSTALL = " \
	busybox \
	netbase \
	lighttpd \
	lighttpd-module-access \
	lighttpd-module-accesslog \
"

# Workaround /var/volatile for now
ROOTFS_POSTPROCESS_COMMAND += "rootfs_fixup_var_volatile ; "

rootfs_fixup_var_volatile () {
	install -m 1777 -d ${IMAGE_ROOTFS}/${localstatedir}/volatile/tmp
	install -m 755 -d ${IMAGE_ROOTFS}/${localstatedir}/volatile/log
}

COMPATIBLE_MACHINE = "tn-container"
