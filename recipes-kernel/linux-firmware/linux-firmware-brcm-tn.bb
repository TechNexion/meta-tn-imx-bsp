SUMMARY = "WiFi firmware files for Broadcom WLAN/BT module"
DESCRIPTION = "Broadcom Wi-fi & bluetooth firmware"
SECTION = "kernel"
LICENSE = "Proprietary"
LICENSE_FLAGS = "commercial_brcm"
LIC_FILES_CHKSUM = "file://nvram_ap6335.txt;md5=340d39854632bdd68f9dc8aa3d1447b9"

SRC_URI += " \
    file://fw_bcm4339a0_ag.bin \
    file://fw_bcm4339a0_ag_apsta.bin \
    file://nvram_ap6335.txt \
    file://bcm4339a0.hcd \
    file://fw_bcm43438a0.bin \
    file://fw_bcm43438a0_apsta.bin \
    file://nvram_ap6212.txt \
    file://bcm43438a0.hcd \
"

S = "${WORKDIR}"

do_install() {
    install -d ${D}/lib/firmware/brcm

    #Install AP6335 wifi and bluetooth firmware
    install -m 0755 fw_bcm4339a0_ag.bin ${D}/lib/firmware/brcm
    install -m 0755 fw_bcm4339a0_ag_apsta.bin ${D}/lib/firmware/brcm
    install -m 0755 nvram_ap6335.txt ${D}/lib/firmware/brcm
    install -m 0755 bcm4339a0.hcd ${D}/lib/firmware/brcm

    #Install AP6212 wifi and bluetooth firmware
    install -m 0755 fw_bcm43438a0.bin ${D}/lib/firmware/brcm
    install -m 0755 fw_bcm43438a0_apsta.bin ${D}/lib/firmware/brcm
    install -m 0755 nvram_ap6212.txt ${D}/lib/firmware/brcm
    install -m 0755 bcm43438a0.hcd ${D}/lib/firmware/brcm
}

FILES_${PN}-dbg += "/lib/firmware/.debug"
FILES_${PN} += "/lib/firmware/"

COMPATIBLE_MACHINE = "(mx6|mx6ul|mx7)"
