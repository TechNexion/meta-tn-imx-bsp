DEPENDS:append: = " patchelf-native"

do_install:append() {
    for elf in \
        "${D}${libdir}/libmedia_server.so" \
        "${D}/opt/imx8-isp/bin/isp_media_server" \
        "${D}/opt/imx8-isp/bin/tuningext"
    do
        if [ -f "$elf" ]; then
            "${STAGING_BINDIR_NATIVE}/patchelf" \
                --replace-needed libjsoncpp.so.25 libjsoncpp.so.27 "$elf"
        fi
    done
}
