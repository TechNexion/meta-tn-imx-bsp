# Copyright 2019 TechNexion
# Released under the MIT license (see COPYING.MIT for the terms)

SUMMARY = "\
 A small image just capable of allowing a device to boot with\
 docker container engine.\
"

DESCRIPTION = "\
 TechNexion Docker OS Image. This image contains everything used\
 to start a docker container, e.g. arm64v8/ubuntu docker container.\
"

IMAGE_INSTALL = "\
	${CORE_IMAGE_EXTRA_INSTALL} \
	packagegroup-core-boot \
	docker \
	libvirt \
	libvirt-python \
	openflow \
	kernel-modules \
	"

# Select Image Features
IMAGE_FEATURES += " \
    hwcodecs \
    ${@bb.utils.contains('DISTRO_FEATURES', 'wayland', '', bb.utils.contains('DISTRO_FEATURES', 'x11', 'x11-base x11-sato', '', d), d)} \
"

CORE_IMAGE_EXTRA_INSTALL += " \
    ${@bb.utils.contains('DISTRO_FEATURES', 'wayland', 'weston-init', '', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'x11 wayland', 'weston-xwayland xterm', '', d)} \
"

IMAGE_ROOTFS_SIZE ?= "8192"
IMAGE_ROOTFS_EXTRA_SPACE = "2048"
IMAGE_ROOTFS_EXTRA_SPACE_append = "${@bb.utils.contains("DISTRO_FEATURES", "systemd", " + 4096", "", d)}"

WKS_FILE = "${@bb.utils.contains("DISTRO_FEATURES", "virtualization", "tn-spl-rootfs-container.wks.in", "tn-spl-bootpart-rootfs.wks.in", d)}"
WKS_FILE_mx8 = "${@bb.utils.contains("DISTRO_FEATURES", "virtualization", "tn-imx8-imxboot-rootfs-container.wks.in", "tn-imx8-imxboot-bootpart-rootfs.wks.in", d)}"

IMAGE_LINGUAS = " "

LICENSE = "MIT"

inherit core-image

