#
# Copied from meta-phytec
#
DESCRIPTION = "Serial test application"
HOMEPAGE = "https://github.com/cbrake/linux-serial-test"
SECTION = "utils"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"
SRCREV = "0685fc53870f52d38af82bdcddaeb6dc0182fb72"

SRC_URI = "git://github.com/cbrake/linux-serial-test.git;branch=master;protocol=https"

S = "${WORKDIR}/git/"

inherit cmake

