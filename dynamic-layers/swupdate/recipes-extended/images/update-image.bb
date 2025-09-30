DESCRIPTION = "Example image demonstrating how to build SWUpdate compound image"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

inherit swupdate

SRC_URI = "\
    file://sw-description \
    file://swu_priv.pem \
    file://passphrase \
"

SWU_TARGET_IMAGE ?= "imx-image-full"
SWU_TARGET_BLOCK_DEVICE ?= "mmcblk2"

SWUPDATE_SIGNING = "RSA"
SWUPDATE_PRIVATE_KEY = "${UNPACKDIR}/swu_priv.pem"
SWUPDATE_PASSWORD_FILE = "${UNPACKDIR}/passphrase"

# images to build before building swupdate image
IMAGE_DEPENDS = ""

# images and files that will be included in the .swu image
SWUPDATE_IMAGES = "Image-${MACHINE}.bin ${SWU_DEFAULT_KERNEL_DEVICETREE} ${SWU_TARGET_IMAGE}"

SWUPDATE_IMAGES_FSTYPES[imx-image-core] = ".rootfs.ext4.gz"
SWUPDATE_IMAGES_FSTYPES[imx-image-multimedia] = ".rootfs.ext4.gz"
SWUPDATE_IMAGES_FSTYPES[imx-image-full] = ".rootfs.ext4.gz"
