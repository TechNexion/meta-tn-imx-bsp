SUMMARY = "OV7251 Kernel Module Driver"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://LICENSE;md5=393a5ca445f6965873eca0259a17f833"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

inherit module

SRC_URI = "file://ov7251_driver.tar.gz"

SRCBRANCH = "tn-imx_4.14.x"

S = "${WORKDIR}/ov7251_driver"

# Gitlab Personal Access Token
OVERRIDES_append = "${@'' if (d.getVar('OV_TOKEN', True) is None or len(d.getVar('OV_TOKEN', True)) == 0) else ':token'}"
TOKEN = "${@'' if (d.getVar('OV_TOKEN', True) is None or len(d.getVar('OV_TOKEN', True)) == 0) else '%s' % d.getVar('OV_TOKEN', True)}"
SRCSERVER_token = "git://gitlab.com/technexion-imx/ov7251_driver.git"
SRCOPTION_token = ";protocol=https;user=oauth2:${TOKEN}"
SRC_URI_token = "${SRCSERVER};branch=${SRCBRANCH}${SRCOPTION}"
SRCREV_token = "f2be64ef8e63015ef4a93d6ec58a02d69fc78ac6"
S_token = "${WORKDIR}/git"

python do_pre_fetch() {
    # check for existing ov7251 driver source files and use them if available
    src_uri = (d.getVar('SRC_URI') or "").split()
    if all(('file://' in p and os.path.exists(p.replace('file://', d.getVar('FILE_DIRNAME') + '/' + d.getVar('PN') + '/'))) for p in src_uri):
        bb.warn("Using existing OV7251 source from %s (Please contact TechNexion: sales@technexion.com for newer OV7251 camera driver source files)" % (d.getVar('FILE_DIRNAME') + '/' + d.getVar('PN') + '/'))
    else:
        bb.warn("find not ov7251_driver.tar.gz,try to clone source code at internet")
        #if token has been declared, use token to get latest camera ov7251 driver source files
        token = d.getVar('OV_TOKEN')
        if token is None or len(token) == 0:
            bb.fatal("Download OV7251 camera driver requires personal access token (Please contact TechNexion: sales@technexion.com)")
}
addtask pre_fetch before do_fetch

COMPATIBLE_MACHINE = "mx8"
