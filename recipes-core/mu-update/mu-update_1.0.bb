SUMMARY = "Systemd service for mu-update"
DESCRIPTION = "This recipe installs a systemd service for mu-update, which performs system updates."
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI += " \
    file://mu-update.service \
    file://mu-update.sh \
"

FILES:${PN} += " \
    ${libexecdir}/mu-update/mu-update.sh \
"

inherit systemd

SYSTEMD_SERVICE:${PN} = "mu-update.service"
SYSTEMD_AUTO_ENABLE:${PN} = "disable"

do_install:append() {
    
    install -d ${D}${systemd_system_unitdir}
    install -d ${D}${libexecdir}/mu-update
    install -m 0644 ${WORKDIR}/mu-update.service ${D}${systemd_system_unitdir}/mu-update.service
    install -m 0755 ${WORKDIR}/mu-update.sh ${D}${libexecdir}/mu-update/mu-update.sh
}
