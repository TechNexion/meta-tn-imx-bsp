SUMMARY = "A minimal container image"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

inherit core-image image-container

# Enough free space for a full image update
IMAGE_OVERHEAD_FACTOR = "2.3"

PACKAGE_ARCH = "${MACHINE_ARCH}"

IMAGE_FSTYPES = "container"
IMAGE_TYPEDEP_container += "ext4"

IMAGE_FEATURES = ""
IMAGE_LINGUAS = ""
NO_RECOMMENDATIONS = "1"

# Base packages
CORE_IMAGE_BASE_INSTALL += " \
  coreutils \
  cpufrequtils \
  ipstables \
"

IMAGE_INSTALL = "\
  base-files \
  base-passwd \
  netbase \
  openssh-sftp-server \
  packagegroup-core-full-cmdline-utils \
  packagegroup-core-full-cmdline-extended \
  packagegroup-core-full-cmdline-multiuser \
  glmark2 \
"

# Workaround /var/volatile for now
ROOTFS_POSTPROCESS_COMMAND += "rootfs_fixup_var_volatile ; "

rootfs_fixup_var_volatile () {
	install -m 1777 -d ${IMAGE_ROOTFS}/${localstatedir}/volatile/tmp
	install -m 755 -d ${IMAGE_ROOTFS}/${localstatedir}/volatile/log
}
