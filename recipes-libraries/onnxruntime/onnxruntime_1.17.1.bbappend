FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

TARGET_CXXFLAGS:append = " -Wno-error=range-loop-construct -Wno-error"
TARGET_CFLAGS:append = " -Wno-error=range-loop-construct -Wno-error"
