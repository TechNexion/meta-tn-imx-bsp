do_replace () {
	cp ${STAGING_BINDIR_NATIVE}/flex.real ${STAGING_BINDIR_NATIVE}/flex
}

addtask replace before do_configure after do_prepare_recipe_sysroot
