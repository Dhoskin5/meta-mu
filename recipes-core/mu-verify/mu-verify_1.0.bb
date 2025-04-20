SUMMARY = "mu-verify: manifest and payload verification script"
DESCRIPTION = ""
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "file://mu-verify.sh"

RDEPENDS:${PN} += "minisign"

FILES:${PN} += " \
    ${libexecdir}/mu-verify/mu-verify.sh \
"

do_install() {
    install -d ${D}${libexecdir}/mu-verify
    install -m 0755 ${WORKDIR}/mu-verify.sh ${D}${libexecdir}/mu-verify/mu-verify.sh
}
