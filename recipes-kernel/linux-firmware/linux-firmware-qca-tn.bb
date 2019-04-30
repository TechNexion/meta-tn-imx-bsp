SUMMARY = "WiFi firmware files for TechNexion QCA module"
SECTION = "kernel"
LICENSE = "Proprietary"
LICENSE_FLAGS = "commercial_qca"
LIC_FILES_CHKSUM = "\
    file://CadenceLicense.txt;md5=2d7b27d27db072fdc7383e37e76b848f \
"

SRC_URI += " \
    file://CadenceLicense.txt \
    file://bdwlan30.bin \
    file://otp30.bin \
    file://qwlan30.bin \
    file://utf30.bin \
    file://wlan/cfg.dat \
    file://wlan/qcom_cfg.ini \
"

S = "${WORKDIR}"

do_install() {
    install -d ${D}/lib/firmware
    install -m 0755 ${S}/bdwlan30.bin ${D}/lib/firmware
    install -m 0755 ${S}/otp30.bin ${D}/lib/firmware
    install -m 0755 ${S}/qwlan30.bin ${D}/lib/firmware
    install -m 0755 ${S}/utf30.bin ${D}/lib/firmware
    install -d ${D}/lib/firmware/wlan
    install -m 0755 ${S}/wlan/cfg.dat ${D}/lib/firmware/wlan
    install -m 0755 ${S}/wlan/qcom_cfg.ini ${D}/lib/firmware/wlan
    install -d ${D}/lib/firmware/qca
    install -m 0755 ${S}/qca/nvm_tlv_3.2.bin ${D}/lib/firmware/qca
    install -m 0755 ${S}/qca/rampatch_tlv_3.2.tlv ${D}/lib/firmware/qca
}

FILES_${PN}-dbg += "/lib/firmware/.debug"
FILES_${PN} += "/lib/firmware/"

COMPATIBLE_MACHINE = "(mx6|mx6ul|mx7|mx8)"

