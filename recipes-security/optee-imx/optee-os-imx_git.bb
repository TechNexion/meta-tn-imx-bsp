# Copyright (C) 2017-2018 NXP

SUMMARY = "OPTEE OS"
DESCRIPTION = "OPTEE OS"
HOMEPAGE = "http://www.optee.org/"
LICENSE = "BSD"
LIC_FILES_CHKSUM = "file://LICENSE;md5=69663ab153298557a59c67a60a743e5b"

inherit deploy pythonnative autotools
DEPENDS = "python-pycrypto-native u-boot-mkimage-native"

SRCBRANCH = "imx_4.9.88_2.0.0_ga"
OPTEE_OS_SRC ?= "git://source.codeaurora.org/external/imx/imx-optee-os.git;protocol=https"
SRC_URI = "${OPTEE_OS_SRC};branch=${SRCBRANCH}"
SRCREV = "17fec4d15572a06f354b00bf7ec9be08123ba3db"

S = "${WORKDIR}/git"
B = "${WORKDIR}/build.${OPTEE_PLATFORM}"

python () {
	machine = d.getVar("MACHINE", True)
	machineoverrides=(d.getVar('MACHINEOVERRIDES', True) or '').split(':')

	# NXP official supported board list is in imx-optee-os/scripts/imx_build.sh
	# git://source.codeaurora.org/external/imx/imx-optee-os.git
	supported_board_list = ['mx6ulevk','mx6ul9x9evk', 'mx6ullevk', 'mx6slevk', 'mx6sllevk', 'mx6sxsabreauto', \
	'mx6sxsabresd', 'mx6qsabrelite', 'mx6qsabresd', 'mx6qsabreauto', 'mx6qpsabresd', 'mx6qpsabreauto', \
	'mx6dlsabresd', 'mx6dlsabreauto', 'mx7dsabresd', 'mx7ulpevk', 'mx8mqevk']

	default_soc_board = {'mx8mq': 'mx8mqevk', 'mx7ulp': 'mx7ulpevk', 'mx7d': 'mx7dsabresd', \
	'mx6dl': 'mx6dlsabresd', 'mx6qp': 'mx6qpsabresd', 'mx6q': 'mx6qsabresd', 'mx6sx': 'mx6sxsabresd', \
	'mx6sll': 'mx6sllevk', 'mx6sl': 'mx6slevk', 'mx6ul': 'mx6ulevk'}

	import re
	if re.match('imx6qpdlsolox',machine):
		subplatform = 'mx6qsabresd'
	elif re.match('imx6ul7d',machine):
		subplatform = 'mx6ulevk'
	elif re.match('imx6ull',machine):
		subplatform = 'mx6ullevk'
	elif re.match('imx',machine):
		subplatform = machine[1:]
	elif re.search('imx',machine):
		subplatform = machine
		if subplatform not in supported_board_list:
				for type in default_soc_board.keys():
					if type in machineoverrides:
						subplatform = default_soc_board.get(type, 0)
	else:
		bb.fatal("optee-os-imx doesn't recognize this MACHINE")

	d.setVar("OPTEE_PLATFORM", subplatform)
}

OPTEE_ARCH ?= "arm32"
OPTEE_ARCH_armv7a = "arm32"
OPTEE_ARCH_aarch64 = "arm64"

# Optee-os can be built for 32 bits and 64 bits at the same time
# as long as the compilers are correctly defined.
# For 64bits, CROSS_COMPILE64 must be set
# When defining CROSS_COMPILE and CROSS_COMPILE64, we assure that
# any 32 or 64 bits builds will pass
EXTRA_OEMAKE = "PLATFORM=imx PLATFORM_FLAVOR=${OPTEE_PLATFORM} \
                CROSS_COMPILE=${HOST_PREFIX} \
                CROSS_COMPILE64=${HOST_PREFIX} \
                NOWERROR=1 \
                LDFLAGS= \
		O=${B} \
        "

do_compile () {
    unset LDFLAGS
    export CFLAGS="${CFLAGS} --sysroot=${STAGING_DIR_HOST}"
    oe_runmake -C ${S} all CFG_TEE_TA_LOG_LEVEL=0
}


do_deploy () {
   install -d ${DEPLOYDIR}
   ${TARGET_PREFIX}objcopy -O binary ${B}/core/tee.elf ${DEPLOYDIR}/tee.${OPTEE_PLATFORM}.bin

   IMX_LOAD_ADDR=`cat ${B}/core/tee-init_load_addr.txt` && \
   uboot-mkimage -A arm -O linux -C none -a ${IMX_LOAD_ADDR} -e ${IMX_LOAD_ADDR} \
    -d ${DEPLOYDIR}/tee.${OPTEE_PLATFORM}.bin ${DEPLOYDIR}/uTee-${OPTEE_BIN_EXT}

    cd ${DEPLOYDIR}
    ln -sf tee.${OPTEE_PLATFORM}.bin tee.bin
    cd -
}

do_install () {
    install -d ${D}/lib/firmware/
    install -m 644 ${B}/core/*.bin ${D}/lib/firmware/

    # Install the TA devkit
    install -d ${D}/usr/include/optee/export-user_ta_${OPTEE_ARCH}/

    for f in ${B}/export-ta_${OPTEE_ARCH}/*; do
        cp -aR $f ${D}/usr/include/optee/export-user_ta_${OPTEE_ARCH}/
    done
}

addtask deploy after do_compile before do_install


FILES_${PN} = "/lib/firmware/"
FILES_${PN}-dev = "/usr/include/optee"
INSANE_SKIP_${PN}-dev = "staticdev"

COMPATIBLE_MACHINE = "(mx6|mx7|mx8m)"

