SUMMARY = "u-boot uEnv.txt"
DESCRIPTION = "u-boot uEnv.txt"
SECTION = "base"
LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://README;md5=6e3b4d22a2346e07c446bc8dca914ae4"

SRC_URI += " \
   file://README \
"
S = "${WORKDIR}"

inherit deploy

# bitbake style python functions
python do_setuenv() {
    def parse_baseboard(mach, bboard):
        supported_boards = {"pico-imx6": ("pi", "dwarf", "hobbit", "nymph"), \
                            "pico-imx7": ("pi", "dwarf", "hobbit", "nymph"), \
                            "pico-imx6ul": ("pi", "dwarf", "hobbit", "nymph"), \
                            "edm-imx6": ("gnome", "fairy", "tc0700", "tc1000"), \
                            "edm-imx7": ("gnome"), \
                            "tep1-imx7": (""), \
                            "tep1-imx6ul": (""), \
                            "tek-imx6": (""), \
                            "tek3-imx6ul": ("")}
        default_boards = {"pico-imx6": "pi", "pico-imx7": "pi", "pico-imx6ul": "pi", \
                          "edm-imx6": "fairy", "edm-imx7": "gnome"}

        if mach in supported_boards.keys():
            if bboard in supported_boards[mach]:
                return bboard
        if mach in default_boards.keys():
            return "{}".format(default_boards[mach])
        if bboard != "":
            return bboard
        return None

    def gen_displayinfo(disp):
        if disp == "custom":
            return "video=mxcfb0:dev=hdmi,1280x720M@60,if=RGB24 fbmem=28M"
        elif disp == "hdmi":
            return "video=mxcfb0:dev=hdmi,1280x720M@60,if=RGB24 fbmem=28M"
        elif disp == "hdmi1080p":
            return "video=mxcfb0:dev=hdmi,1920x1080M@60,if=RGB24 fbmem=28M"
        elif disp == "hdmi720p":
            return "video=mxcfb0:dev=hdmi,1280x720M@60,if=RGB24 fbmem=28M"
        elif disp == "lcd":
            return "video=mxcfb0:dev=lcd,800x480@60,if=RGB24"
        elif disp == "lvds10":
            return "video=mxcfb0:dev=ldb,1280x800@60,if=RGB24"
        elif disp == "lvds15":
            return "video=mxcfb0:dev=ldb,1368x768@60,if=RGB24"
        elif disp == "lvds7":
            return "video=mxcfb0:dev=ldb,1024x600@60,if=RGB24"
        elif disp == "lvds7_hdmi720p":
            return "video=mxcfb0:dev=hdmi,1280x720M@60,if=RGB24 video=mxcfb1:dev=ldb,1024x600@60,if=RGB24"
        elif disp == "mipi5":
            return None
        return None

    def parse_display(mach, bboard, disp):
        supported_displays = {"pico-imx6": ("lcd", "lvds7", "lvds10", "lvds15", \
                                            "hdmi720p", "hdmi1080p", "lcd", \
                                            "lvds7_hdmi720p", "custom"), \
                              "pico-imx7": ("lcd", "custom"), \
                              "pico-imx8": ("mipi5", "hdmi", "custom")}
        default_displays = {"tc0700": "lvds7", "tc1000": "lvds10", \
                            "pico-imx6": "hdmi720p"}
        if mach in supported_displays.keys():
            if disp in supported_displays[mach]:
                return gen_displayinfo(disp)
        if bboard in default_displays.keys():
            return gen_displayinfo(default_displays[bboard])
        if mach in default_displays.keys():
            return gen_displayinfo(default_displays[mach])
        return None

    def parse_radio(radios):
        supported_radios = ("qca", "brcm", "ath-pci")
        radio_list = radios.split(" ") if radios is not None else None
        print("radio_list: {}".format(radio_list))
        if radio_list is not None and radio_list[0] in supported_radios:
            return radio_list[0]
        return None

    def gen_uenvtxt(d):
        envfile = "{}/uEnv.txt".format(d.getVar("S"))
        machine = d.getVar("MACHINE")
        board = d.getVar("BASE_BOARD")
        display = d.getVar("DISPLAY_INFO")
        print("machine:{} board:{} display:{}".format(machine, board, display))
        baseboard = parse_baseboard(machine, d.getVar("BASE_BOARD"))
        displayinfo = parse_display(machine, d.getVar("BASE_BOARD"), d.getVar("DISPLAY_INFO"))
        wifi_module = parse_radio(d.getVar("WIFI_MODULES"))
        print("displayinfo:{} wifi_module:{}".format(displayinfo, wifi_module))
        with open(envfile, 'w') as f:
            if baseboard is not None:
                f.write("baseboard={}\n".format(baseboard))
            if displayinfo is not None:
                f.write("displayinfo={}\n".format(displayinfo))
            if wifi_module is not None:
                f.write("wifi_module={}\n".format(wifi_module))
            f.write("mmcargs=setenv bootargs console=${console},${baudrate} root=${mmcroot} ${displayinfo}\n")
            f.write("bootcmd_mmc=run loadimage;run mmcboot;\n")
            f.write("uenvcmd=run bootcmd_mmc\n")

    # Conjure up appropriate uEnv.txt settings
    gen_uenvtxt(d)
}

addtask setuenv after do_configure before do_compile

do_deploy() {
	install -d ${DEPLOYDIR}
	install ${S}/uEnv.txt ${DEPLOYDIR}/uEnv.txt
}

addtask deploy after do_install before do_build

PACKAGE_ARCH = "${MACHINE_ARCH}"
COMPATIBLE_MACHINE = "(mx6|mx7|mx8)"
