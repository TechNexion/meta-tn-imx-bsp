# Add needed Freescale packages and definitions

# In dizzy_3.14.52-1.1.0_GA, we uses linux 3.14.52, but GPU driver is still 3.14.28
# Remove imx-test to get rid of compiling errors on epdc functionality tests of imx-test

RDEPENDS_${PN}_remove = "imx-test"
