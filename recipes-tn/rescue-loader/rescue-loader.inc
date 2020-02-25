SUMMARY  = "TechNexion Rescue Loader Python Scripts"
HOMEPAGE = "https://github.com/TechNexion-customization/rescue-loader"
LICENSE = "LGPLv2.1"
LIC_FILES_CHKSUM = "file://LICENSE;md5=a916467b91076e631dd8edb7424769c7"

TECHNEXION_GITHUB_MIRROR ?= "git://github.com/TechNexion-customization/rescue-loader.git"
SRCREV = "rel_rescue_v2018.06.30"

SRC_URI = "${TECHNEXION_GITHUB_MIRROR};branch=${SRCBRANCH}"

S = "${WORKDIR}/git"

RDEPENDS_${PN} += "\
    ${PYTHON_PN}-datetime \
    ${PYTHON_PN}-pickle \
    ${PYTHON_PN}-threading \
    ${PYTHON_PN}-pygobject"

