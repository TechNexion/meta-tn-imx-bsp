SUMMARY = "Broadcom Wi-fi & bluetooth firmware"
DESCRIPTION = "Broadcom Wi-fi & bluetooth firmware"
SECTION = "base"
LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://bcm4339a0.hcd;md5=4f7c69519cfef5643a08e39851d30a41"

SRC_URI += " \
   file://fw_bcm4339a0_ag.bin \
   file://nvram_ap6335.txt \
   file://bcm4339a0.hcd \
"
S = "${WORKDIR}"

do_install() {
    install -d ${D}/lib/firmware/brcm
    
    #Install BCM4339 bluetooth firmware 
    install -m 0755 fw_bcm4339a0_ag.bin ${D}/lib/firmware/brcm
    install -m 0755 nvram_ap6335.txt ${D}/lib/firmware/brcm
    install -m 0755 bcm4339a0.hcd ${D}/lib/firmware/brcm
}

FILES_${PN}-dbg += "/lib/firmware/.debug"
FILES_${PN} += "/lib/firmware/"

COMPATIBLE_MACHINE = "(picosom-dwarf-imx6)"
