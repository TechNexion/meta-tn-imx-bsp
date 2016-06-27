SUMMARY = "Broadcom Wi-fi & bluetooth firmware"
DESCRIPTION = "Broadcom Wi-fi & bluetooth firmware"
SECTION = "base"
LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://bcm4330.hcd;md5=8e32f9168aaa540467589c153129c57a"

SRC_URI += " \
    https://github.com/CyanogenMod/android_hardware_broadcom_wlan/raw/cm-14.1/bcmdhd/firmware/bcm4330/fw_bcm4330_bg.bin;name=fw_bcm4330_bg.bin \
    https://github.com/CyanogenMod/android_hardware_broadcom_wlan/raw/cm-14.1/bcmdhd/firmware/bcm4330/fw_bcm4330_apsta_bg.bin;name=fw_bcm4330_apsta_bg.bin \
    https://github.com/Freescale/meta-freescale-3rdparty/raw/master/recipes-bsp/broadcom-nvram-config/files/wandboard/brcmfmac4330-sdio.txt;name=brcmfmac4330-sdio.txt \
    https://github.com/OpenELEC/wlan-firmware/raw/master/firmware/brcm/bcm4330.hcd;name=bcm4330.hcd \
    https://github.com/OpenELEC/wlan-firmware/raw/master/firmware/brcm/fw_bcm4339a0_ag.bin;name=fw_bcm4339a0_ag.bin \
    https://github.com/OpenELEC/wlan-firmware/raw/master/firmware/brcm/fw_bcm4339a0_ag_apsta.bin;name=fw_bcm4339a0_ag_apsta.bin \
    https://raw.githubusercontent.com/OpenELEC/wlan-firmware/master/firmware/brcm/nvram_ap6335.txt;name=nvram_ap6335.txt \
    https://github.com/rockchip-linux/rk-rootfs-build/raw/master/overlay-firmware/system/vendor/firmware/bcm4339a0.hcd;name=bcm4339a0.hcd \
"

SRC_URI[fw_bcm4330_bg.bin.md5sum] = "c98f3bc455f8c908edd5323ea9735aad"
SRC_URI[fw_bcm4330_bg.bin.sha256sum] = "3ff582deb5c69909531613eb38d80b3eecf266defa2e28ba4b61e78b904001e9"
SRC_URI[fw_bcm4330_apsta_bg.bin.md5sum] = "1141c88d07b472829509b7423b20363a"
SRC_URI[fw_bcm4330_apsta_bg.bin.sha256sum] = "19f12f4810f1a671567e1d4cf3535734f771ca72eb1590bff732117834b22761"
SRC_URI[brcmfmac4330-sdio.txt.md5sum] = "4d22bdf2b79aec062eb80136b5aed2e1"
SRC_URI[brcmfmac4330-sdio.txt.sha256sum] = "240cb4cbfb37cf516cb6df6373e6fb573ee45e14a22a565bf7d60f42fc40bdd8"
SRC_URI[bcm4330.hcd.md5sum] = "8e32f9168aaa540467589c153129c57a"
SRC_URI[bcm4330.hcd.sha256sum] = "f790c0c981f003a684b2aaea0eb7e475ff33c3b7bc204678fee5efbbe21148a0"
SRC_URI[fw_bcm4339a0_ag.bin.md5sum] = "3be944c0fc046eed127df77fcc43c8c0"
SRC_URI[fw_bcm4339a0_ag.bin.sha256sum] = "f72f330efa7490fdb2c24aa5640a2828f9778923af9a75d1507d138a0e359b30"
SRC_URI[fw_bcm4339a0_ag_apsta.bin.md5sum] = "3be944c0fc046eed127df77fcc43c8c0"
SRC_URI[fw_bcm4339a0_ag_apsta.bin.sha256sum] = "f72f330efa7490fdb2c24aa5640a2828f9778923af9a75d1507d138a0e359b30"
SRC_URI[nvram_ap6335.txt.md5sum] = "d5cf323bde41f3568ef23ea1853a4f13"
SRC_URI[nvram_ap6335.txt.sha256sum] = "faa46d92a3df86843e3ced55cfc064b1008f6f653837633c725505d3a341cc54"
SRC_URI[bcm4339a0.hcd.md5sum] = "3537827c3b934cc986f5eb3e88633d8b"
SRC_URI[bcm4339a0.hcd.sha256sum] = "5538cd96516729f7d35d7eecdedb0d8a0c441f9ce6d27aa873eb95d8adb59603"

S = "${WORKDIR}"

do_install() {
    install -d ${D}/lib/firmware/brcm
    
    #Install BCM4330 bluetooth firmware
    install -m 0755 fw_bcm4330_bg.bin ${D}/lib/firmware/brcm
    install -m 0755 fw_bcm4330_apsta_bg.bin ${D}/lib/firmware/brcm
    install -m 0755 brcmfmac4330-sdio.txt ${D}/lib/firmware/brcm
    install -m 0755 bcm4330.hcd ${D}/lib/firmware/brcm
    
    #Install BCM4339 bluetooth firmware
    install -m 0755 fw_bcm4339a0_ag.bin ${D}/lib/firmware/brcm
    install -m 0755 fw_bcm4339a0_ag_apsta.bin ${D}/lib/firmware/brcm
    install -m 0755 nvram_ap6335.txt ${D}/lib/firmware/brcm
    install -m 0755 bcm4339a0.hcd ${D}/lib/firmware/brcm
}

FILES_${PN}-dbg += "/lib/firmware/.debug"
FILES_${PN} += "/lib/firmware/"

COMPATIBLE_MACHINE = "(mx6|mx6ul|mx7)"
