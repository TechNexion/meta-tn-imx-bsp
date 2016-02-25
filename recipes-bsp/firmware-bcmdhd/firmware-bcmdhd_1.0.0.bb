SUMMARY = "Broadcom Wi-fi & bluetooth firmware"
DESCRIPTION = "Broadcom Wi-fi & bluetooth firmware"
SECTION = "base"
LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://bcmdhd.cal;md5=f1d89ec0a22c12aef01e2ad45c91d9dd"

SRC_URI += " \
   file://fw_bcmdhd.bin \
   file://fw_bcmdhd_apsta.bin \
   file://bcmdhd.cal \
   file://Type_ZP.hcd \
"
S = "${WORKDIR}"

do_install() {
    install -d ${D}/lib/firmware/brcm
    
    #Install BCM4339 bluetooth firmware 
    install -m 0755 fw_bcmdhd.bin ${D}/lib/firmware/brcm
    install -m 0755 fw_bcmdhd_apsta.bin ${D}/lib/firmware/brcm
    install -m 0755 bcmdhd.cal ${D}/lib/firmware/brcm
    install -m 0755 Type_ZP.hcd ${D}/lib/firmware/brcm
}

FILES_${PN}-dbg += "/lib/firmware/.debug"
FILES_${PN} += "/lib/firmware/"

COMPATIBLE_MACHINE = "(picosom-dwarf-imx6)"
