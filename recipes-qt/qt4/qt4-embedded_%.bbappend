FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

QT_EMBEDDED_EXTRA_FLAGS_append = " -plugin-gfx-linuxfb"

QT_CONFIG_FLAGS_remove = "-webkit -pulseaudio -qvfb -eglfs -system-sqlite -qt3support -plugin-sql-sqlite -plugin-gfx-qvfb -plugin-gfx-vnc -qt-mouse-qvfb -xmlpatterns"

QT_CONFIG_FLAGS_append = " -no-qt3support -no-webkit -no-audio-backend -no-qvfb -no-mouse-qvfb -no-libmng -svg -no-xmlpatterns"

QT_CONFIG_FLAGS_append = " ${@bb.utils.contains('MACHINE_FEATURES', 'touchscreen', '-qt-mouse-tslib', '', d)}"

# Reverse meta-freescale/dynamic-layers/qt4-layer/reciepes-qt4/qt4/qt4-imx-support.inc
# of imxgpu2d overrides, specifically for building mx8 series which are wayland based
# and intricately configured by the fsl/freescale conf files
DEPENDS_remove = "virtual/libgles2"
QT_GLFLAGS_remove = "-opengl es2 -openvg"
QT_CONFIG_FLAGS_remove = "-DEGL_API_FB=1"

SRC_URI += "file://0001-QWS-Change-default-QWS-background-brush-to-black.patch"

