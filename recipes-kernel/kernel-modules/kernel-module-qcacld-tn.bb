# Copyright 2018 TechNexion Ltd.
SUMMARY = "QCACLD driver for QCA9377-based BD-SDMAC module"
LICENSE = "ISC"
LIC_FILES_CHKSUM = "file://${S}/CORE/HDD/src/wlan_hdd_main.c;beginline=1;endline=20;md5=ec8d62116b13db773825ebf7cf91be1d"

inherit module

SRCREV = "dbb7f950cccc3a4a955e8b49455c2eb27c3b371e"

SRC_URI = "git://github.com/TechNexion/qcacld-2.0.git;branch=${SRCBRANCH} \
"
SRCBRANCH = "caf-wlan/CNSS.LEA.NRT_3.0"

S = "${WORKDIR}/git"

EXTRA_OEMAKE_append = " CONFIG_CLD_HL_SDIO_CORE=y"

COMPATIBLE_MACHINE = "mx6|mx7|mx8"
