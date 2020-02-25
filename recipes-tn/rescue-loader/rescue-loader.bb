# Copyright 2020 TechNexion Ltd.
# Released under the MIT license

SUMMARY = "Rescue Loader"
DESCRIPTION = "Python scripts to run on target board to download sdcard image and program the eMMC"
DEPENDS = ""
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302 \
                    file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

require rescue-loader.inc
inherit pypi setuptools3

