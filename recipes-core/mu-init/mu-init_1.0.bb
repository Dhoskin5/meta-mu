SUMMARY = "Systemd service for mu-init"
DESCRIPTION = "This recipe installs a systemd service for mu-init, which is a an update checker."
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI += " \
    file://mu-init.service.in \
    file://mu-init.sh \
"


FILES:${PN} += " \
    ${libexecdir}/mu-init/mu-init.sh \
    ${systemd_system_unitdir}/mu-init.service \
    ${MU_UPDATE_INBOX_DIR} \
"

inherit systemd

SYSTEMD_SERVICE:${PN} = "mu-init.service"
SYSTEMD_AUTO_ENABLE:${PN} = "enable"

do_configure:append() {
    sed "s|@MU_UPDATE_INBOX_DIR@|${MU_UPDATE_INBOX_DIR}|g" \
        ${WORKDIR}/mu-init.service.in > ${WORKDIR}/mu-init.service
}

do_install:append() {
    
    install -d ${D}${MU_UPDATE_INBOX_DIR}
    install -d ${D}${systemd_system_unitdir}
    install -d ${D}${libexecdir}/mu-init
    install -m 0644 ${WORKDIR}/mu-init.service ${D}${systemd_system_unitdir}/mu-init.service
    install -m 0755 ${WORKDIR}/mu-init.sh ${D}${libexecdir}/mu-init/mu-init.sh
}
