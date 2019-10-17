
do_replace () {
	sed -i 's|dtbs = fsl-$(PLAT)-evk.dtb|dtbs = ${UBOOT_DTB_NAME}|g' ${S}/${SOC_DIR}/soc.mak
}

addtask replace before do_compile after do_configure
