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
MACHINEOVERRIDES .= ":tn"
MACHINEOVERRIDES .= "${@'' if d.getVar('RF_FIRMWARES', True) is None else ':%s' % ':'.join([fw.lower() for fw in d.getVar('RF_FIRMWARES', True).split(' ') if fw])}"
MACHINEOVERRIDES .= "${@'' if (d.getVar('SOUNDCARD', True) is None or len(d.getVar('SOUNDCARD', True)) == 0) else ':%s' % d.getVar('SOUNDCARD', True).lower()}"
MACHINEOVERRIDES .= "${@'' if (d.getVar('NFC', True) is None or len(d.getVar('NFC', True)) == 0) else ':%s' % d.getVar('NFC', True).lower()}"

#
# Kernel Specifics
#
PREFERRED_PROVIDER_virtual/kernel_tn = "linux-tn-imx"

#
# Bootloader Specifics
#
PREFERRED_PROVIDER_virtual/bootloader_tn = "u-boot-edm"
UBOOT_CONFIG_mx8 ??= "sd"
SPL_BINARY = "SPL"
SPL_BINARY_mx8 = "spl/u-boot-spl.bin"
UBOOT_SUFFIX = "img"
UBOOT_SUFFIX_mx8 = "bin"
UBOOT_MAKE_TARGET = ""
# UBOOT_SEEK is for dd u-boot.imx to the raw sectors,
# and it should be specified and the same in u-boot c-codes.
UBOOT_SEEK = "69"
BOOT_SPACE_mx8 = "65536"
LOADADDR_mx8 = ""

#
# u-boot env (uEnv.txt + boot.scr.uimg)
#
BOOT_SCRIPTS = ""
UENV_FILENAME_uenv = "uEnv.txt"
BOOT_SCRIPTS_append_uenv = " ${UENV_FILENAME}:uEnv.txt"

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
IMAGE_INSTALL_append = " packagegroup-tn-tools packagegroup-tn-wlan"
IMAGE_INSTALL_append_voicehat = " packagegroup-tn-voicehat"
IMAGE_INSTALL_append_nfc = " packagegroup-tn-nfc"
IMAGE_FSTYPES_append = " ext4 sdcard.xz"
IMAGE_CLASSES_append = " image_types_tn"
SDCARD_GENERATION_COMMAND_mx6ul = "generate_tn_sdcard"
SDCARD_GENERATION_COMMAND_mx6dl = "generate_tn_sdcard"
SDCARD_GENERATION_COMMAND_mx6q = "generate_tn_sdcard"
SDCARD_GENERATION_COMMAND_mx7d = "generate_tn_sdcard"
SDCARD_GENERATION_COMMAND_mx8m = "generate_tn_sdcard"
LICENSE_FLAGS_WHITELIST += "commercial_qca commercial_brcm"

# wic (sdcard) image
WKS_FILE = "tn-spl-bootpart-rootfs.wks.in"
WKS_FILE_mx8 = "tn-imx8-uboot-bootpart-rootfs.wks.in"
WKS_FILE_DEPENDS += "u-boot-edm"
WKS_FILE_DEPENDS_mx8 += "imx-boot"
IMAGE_BOOT_FILES_append_uenv = " ${UENV_FILENAME}"

# xz compression options
XZ_COMPRESSION_LEVEL = "-9"
XZ_INTEGRITY_CHECK = "crc64"

# Additional BitBake/Yocto build tool
HOSTTOOLS_NONFATAL += "git-lfs"

