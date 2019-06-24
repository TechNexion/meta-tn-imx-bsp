# Copyright 2017-2018 TN
# Released under the GPLv2 license (see COPYING.MIT for the terms)

SUMMARY = "Build an external Linux kernel module"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-2.0;md5=801f80980d171dd6425610833a22dbe6"

inherit packagegroup

# Extra Kernel Firmwares for voicehat

VOICEHAT = "${@'' if d.getVar('SOUNDCARD', True) is None else '%s' % d.getVar('SOUNDCARD', True).lower()}"
OVERRIDES .= ":${VOICEHAT}"

DTBS_flex-imx8mm = " freescale/imx8mm-flex-pi-voicehat.dtb "
DTBS_pico-imx8mm = " freescale/imx8mm-pico-pi-voicehat.dtb "
DTBS_edm-imx8mq = " freescale/imx8mq-edm-wizard-voicehat.dtb "
DTBS_pico-imx8mq = " freescale/imx8mq-pico-pi-voicehat.dtb "

KERNEL_DEVICETREE_append_voicehat = " ${DTBS} "
RRECOMMENDS_${PN} += " kernel-module-tfa98xx "
