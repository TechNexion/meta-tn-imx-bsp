SUMMARY = "WiFi firmware files for TechNexion QCA module"
SECTION = "kernel"
LICENSE = "Proprietary"
LICENSE_FLAGS = "commercial_qca"
LIC_FILES_CHKSUM = "\
    file://qca9377/CadenceLicense.txt;md5=2d7b27d27db072fdc7383e37e76b848f \
"

SRC_URI += " \
    file://qca9377/CadenceLicense.txt \
    file://qca9377/bdwlan30.bin \
    file://qca9377/otp30.bin \
    file://qca9377/qwlan30.bin \
    file://qca9377/utf30.bin \
    file://qca6174/CadenceLicense.txt \
    file://qca6174/bdwlan30.bin \
    file://qca6174/otp30.bin \
    file://qca6174/qwlan30.bin \
    file://qca6174/utf30.bin \
    file://wlan/cfg.dat \
    file://wlan/qca9377/qcom_cfg.ini \
    file://wlan/qca6174/qcom_cfg.ini \
    file://qca/notice.txt \
    file://qca/nvm_tlv_3.2.bin \
    file://qca/rampatch_tlv_3.2.tlv \
"

S = "${WORKDIR}"

do_install() {
    install -d ${D}/lib/firmware/qca9377/
    install -m 0755 ${S}/qca9377/bdwlan30.bin ${D}/lib/firmware/qca9377/
    install -m 0755 ${S}/qca9377/otp30.bin ${D}/lib/firmware/qca9377/
    install -m 0755 ${S}/qca9377/qwlan30.bin ${D}/lib/firmware/qca9377/
    install -m 0755 ${S}/qca9377/utf30.bin ${D}/lib/firmware/qca9377/
    install -d ${D}/lib/firmware/qca6174/
    install -m 0755 ${S}/qca6174/bdwlan30.bin ${D}/lib/firmware/qca6174/
    install -m 0755 ${S}/qca6174/otp30.bin ${D}/lib/firmware/qca6174/
    install -m 0755 ${S}/qca6174/qwlan30.bin ${D}/lib/firmware/qca6174/
    install -m 0755 ${S}/qca6174/utf30.bin ${D}/lib/firmware/qca6174/
    install -d ${D}/lib/firmware/wlan/qca9377/
    install -d ${D}/lib/firmware/wlan/qca6174/
    install -m 0755 ${S}/wlan/cfg.dat ${D}/lib/firmware/wlan/
    install -m 0755 ${S}/wlan/qca9377/qcom_cfg.ini ${D}/lib/firmware/wlan/qca9377/
    install -m 0755 ${S}/wlan/qca6174/qcom_cfg.ini ${D}/lib/firmware/wlan/qca6174/
    install -d ${D}/lib/firmware/qca
    install -m 0755 ${S}/qca/nvm_tlv_3.2.bin ${D}/lib/firmware/qca
    install -m 0755 ${S}/qca/rampatch_tlv_3.2.tlv ${D}/lib/firmware/qca
}

FILES_${PN}-dbg += "/lib/firmware/.debug"
FILES_${PN} += "/lib/firmware/"

COMPATIBLE_MACHINE = "(mx6|mx6ul|mx7|mx8)"

