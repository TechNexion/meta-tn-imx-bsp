SUMMARY = "A minimal container image"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302 \
                    file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"

PACKAGE_ARCH = "${MACHINE_ARCH}"

IMAGE_FSTYPES = "container"
IMAGE_TYPEDEP_container += "ext4"

IMAGE_FEATURES = ""
IMAGE_LINGUAS = ""
NO_RECOMMENDATIONS = "1"

IMAGE_INSTALL = "\
	base-files \
	base-passwd \
	netbase \
"

# Workaround /var/volatile for now
ROOTFS_POSTPROCESS_COMMAND += "rootfs_fixup_var_volatile ; "

rootfs_fixup_var_volatile () {
	install -m 1777 -d ${IMAGE_ROOTFS}/${localstatedir}/volatile/tmp
	install -m 755 -d ${IMAGE_ROOTFS}/${localstatedir}/volatile/log
}

inherit core-image

################################################################################
#
# In comparison to core-image-minimal.bb and packagegroup-core-boot.bb
#

#SUMMARY = "A small image just capable of allowing a device to boot."
#
#IMAGE_INSTALL = "packagegroup-core-boot ${CORE_IMAGE_EXTRA_INSTALL}"
#
#IMAGE_LINGUAS = " "
#
#LICENSE = "MIT"
#
#inherit core-image
#
#IMAGE_ROOTFS_SIZE ?= "8192"
#IMAGE_ROOTFS_EXTRA_SPACE_append = "${@bb.utils.contains("DISTRO_FEATURES", "systemd", " + 4096", "" ,d)}"

#SUMMARY = "Minimal boot requirements"
#DESCRIPTION = "The minimal set of packages required to boot the system"
#PR = "r17"
#
#PACKAGE_ARCH = "${MACHINE_ARCH}"
#
#inherit packagegroup
#
##
## Set by the machine configuration with packages essential for device bootup
##
#MACHINE_ESSENTIAL_EXTRA_RDEPENDS ?= ""
#MACHINE_ESSENTIAL_EXTRA_RRECOMMENDS ?= ""
#
## Distro can override the following VIRTUAL-RUNTIME providers:
#VIRTUAL-RUNTIME_dev_manager ?= "udev"
#VIRTUAL-RUNTIME_login_manager ?= "busybox"
#VIRTUAL-RUNTIME_init_manager ?= "sysvinit"
#VIRTUAL-RUNTIME_initscripts ?= "initscripts"
#VIRTUAL-RUNTIME_keymaps ?= "keymaps"
#
#EFI_PROVIDER ??= "grub-efi"
#
#SYSVINIT_SCRIPTS = "${@bb.utils.contains('MACHINE_FEATURES', 'rtc', '${VIRTUAL-RUNTIME_base-utils-hwclock}', '', d)} \
#                    modutils-initscripts \
#                    init-ifupdown \
#                    ${VIRTUAL-RUNTIME_initscripts} \
#                   "
#
#RDEPENDS_${PN} = "\
#    base-files \
#    base-passwd \
#    ${VIRTUAL-RUNTIME_base-utils} \
#    ${@bb.utils.contains("DISTRO_FEATURES", "sysvinit", "${SYSVINIT_SCRIPTS}", "", d)} \
#    ${@bb.utils.contains("MACHINE_FEATURES", "keyboard", "${VIRTUAL-RUNTIME_keymaps}", "", d)} \
#    ${@bb.utils.contains("MACHINE_FEATURES", "efi", "${EFI_PROVIDER} kernel", "", d)} \
#    netbase \
#    ${VIRTUAL-RUNTIME_login_manager} \
#    ${VIRTUAL-RUNTIME_init_manager} \
#    ${VIRTUAL-RUNTIME_dev_manager} \
#    ${VIRTUAL-RUNTIME_update-alternatives} \
#    ${MACHINE_ESSENTIAL_EXTRA_RDEPENDS}"
#
#RRECOMMENDS_${PN} = "\
#    ${MACHINE_ESSENTIAL_EXTRA_RRECOMMENDS}"
#
