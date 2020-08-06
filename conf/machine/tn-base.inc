############################################################################
##
## Copyright (C) 2019 TechNexion.
## Contact: https://www.technexion.com/
##
## This file is part of the TechNexion bitbake/yocto meta-layer
##
## GNU General Public License Usage
## Alternatively, this file may be used under the terms of the GNU
## General Public License version 3 or (at your option) any later version
## approved by the KDE Free Qt Foundation. The licenses are as published by
## the Free Software Foundation and appearing in the file LICENSE.GPL3
## included in the packaging of this file. Please review the following
## information to ensure the GNU General Public License requirements will
## be met: https://www.gnu.org/licenses/gpl-3.0.html.
##
############################################################################

# Extra MACHINEOVERRIDES for External Kernel Firmwares/Modules
OVERRIDES_append = ":tn"
OVERRIDES_append = "${@'' if (d.getVar('RF_FIRMWARES', True) is None or len(d.getVar('RF_FIRMWARES', True)) == 0) else ':%s' % ':'.join([fw.lower() for fw in d.getVar('RF_FIRMWARES', True).split(' ') if fw])}"
OVERRIDES_append = "${@'' if (d.getVar('SOUNDCARD', True) is None or len(d.getVar('SOUNDCARD', True)) == 0) else ':%s' % d.getVar('SOUNDCARD', True).lower()}"
OVERRIDES_append = "${@'' if (d.getVar('NFC', True) is None or len(d.getVar('NFC', True)) == 0) else ':%s' % d.getVar('NFC', True).lower()}"
OVERRIDES_append = "${@bb.utils.contains('BBLAYERS', '${BSPDIR}/sources/meta-virtualization', ':virtualization', '', d)}"
OVERRIDES_append = "${@':tools' if (d.getVar('DISTRO', True) == 'fsl-imx-xwayland' or d.getVar('DISTRO', True) == 'fsl-imx-wayland' or d.getVar('DISTRO', True) == 'fsl-imx-x11') else ''}"
OVERRIDES_append = "${@':rescue' if (d.getVar('INITRAMFS_IMAGE', True) == 'tn-image-rescue-initramfs') else ''}"

#
# Kernel Specifics
#
PREFERRED_PROVIDER_kernel_tn = "linux-tn-imx"
PREFERRED_PROVIDER_virtual/kernel_tn = "linux-tn-imx"
KERNEL_CLASSES_append_rescue = " kernel-fitimage"
KERNEL_IMAGETYPES_append_rescue = " fitImage"
RDEPENDS_${KERNEL_PACKAGE_NAME}-base_rescue = ""

#
# Bootloader Specifics
#
PREFERRED_PROVIDER_u-boot_tn = "u-boot-tn-imx"
PREFERRED_PROVIDER_virtual/bootloader_tn = "u-boot-tn-imx"
UBOOT_CONFIG_mx8 ??= "sd"
SPL_BINARY = "SPL"
SPL_BINARY_mx8 = "spl/u-boot-spl.bin"
UBOOT_SUFFIX = "img"
UBOOT_SUFFIX_mx8 = "bin"
UBOOT_MAKE_TARGET = ""
# UBOOT_SEEK is for dd u-boot.imx to the raw sectors,
# and it should be specified and the same in u-boot c-codes.
UBOOT_SEEK = "69"
BOOT_SPACE_mx6 = "16384"
BOOT_SPACE_mx7 = "16384"
BOOT_SPACE_mx8 = "32768"
LOADADDR_mx8 = ""
# u-boot splash file
SPLASH_FILENAME = "splash.bmp"
BOOT_SCRIPTS_append = " ${SPLASH_FILENAME}:splash.bmp"

#
# u-boot env (uEnv.txt + boot.scr.uimg)
#
BOOT_SCRIPTS = ""
UENV_FILENAME_uenv = "uEnv.txt"
BOOT_SCRIPTS_append_uenv = " ${UENV_FILENAME}:uEnv.txt"
UENV_SCRNAME_bootscr = "boot.scr.uimg"
BOOT_SCRIPTS_append_bootscr = " ${UENV_SCRNAME}:boot.scr.uimg"

#
# DDR Firmware Name (NXP firmwares)
#
DDR_FIRMWARE_NAME_mx8 = "lpddr4_pmu_train_1d_imem.bin lpddr4_pmu_train_1d_dmem.bin lpddr4_pmu_train_2d_imem.bin lpddr4_pmu_train_2d_dmem.bin"

#
# IMX-BOOT specifics (NXP u-boot packaged binary, i.e. a.k.a flash.bin)
#
IMXBOOT_TARGETS = "flash_evk"
IMXBOOT_TARGETS_mx8mm = "flash_evk_no_hdmi"
IMAGE_BOOTLOADER_mx8 = "imx-boot"
IMX_BOOT_SEEK = "1"
IMX_BOOT_SEEK_mx8 = "33"
OPTEE_BIN_EXT_mx8mm = "8mm"

#
# Extra Stuff for TechNexion
#
MACHINE_FIRMWARE_remove_mx8 = "linux-firmware-ath10k"
MACHINE_FEATURES_append = " pci wifi bluetooth touchscreen"
MACHINE_FEATURES_remove_mx8 = "touchscreen"
MACHINE_EXTRA_RRECOMMENDS_append = " broadcom-bluetooth"
MACHINE_EXTRA_RRECOMMENDS_remove_mx8 = "broadcom-bluetooth"
IMAGE_INSTALL_append = " get-support-info"
IMAGE_INSTALL_append = " packagegroup-tn-wlan"
IMAGE_INSTALL_append_tools = " packagegroup-tn-tools"
IMAGE_INSTALL_append_voicehat = " packagegroup-tn-voicehat"
IMAGE_INSTALL_append_nfc = " packagegroup-tn-nfc"
IMAGE_FSTYPES_append = " ext4 wic.md5sum"
LICENSE_FLAGS_WHITELIST += "commercial_qca commercial_brcm"

# wic (sdcard) image
WKS_FILE = "tn-spl-bootpart-rootfs.wks.in"
WKS_FILE_mx8 = "tn-imx8-imxboot-bootpart-rootfs.wks.in"
WKS_FILE_DEPENDS += "u-boot-edm"
WKS_FILE_DEPENDS_mx8 += "imx-boot"
IMAGE_BOOT_FILES_append = " ${SPLASH_FILENAME}"
IMAGE_BOOT_FILES_append_uenv = " ${UENV_FILENAME}"
IMAGE_BOOT_FILES_append_bootscr = " ${UENV_SCRNAME}"

# xz compression options
XZ_COMPRESSION_LEVEL = "-9"
XZ_INTEGRITY_CHECK = "crc64"

# Additional BitBake/Yocto build tool
HOSTTOOLS_NONFATAL += "git-lfs"

# meta-virtualization
DISTRO_FEATURES_append_virtualization = " virtualization"

# technexion rescue-loader
DISTRO_FEATURES_remove_rescue = "x11 wayland"
DISTRO_FEATURES_append_rescue = " directfb"