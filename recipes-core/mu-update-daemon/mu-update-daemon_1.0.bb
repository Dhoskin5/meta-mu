SUMMARY = "Systemd daemon for mu-update"
DESCRIPTION = "This recipe installs a systemd daemon for mu-update, which performs system updates."
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=1481aa4a234f193547888585ff6b4386"

SRC_URI = "git://github.com/Dhoskin5/mu-update-daemon.git;branch=master;protocol=https \
           file://mu-update-daemon.service.in \
           file://org.mu.Update.conf \
"
SRCREV = "798c3df272204d4fb25a0470a23abd6dcb97375d"

inherit cmake systemd python3native
DEPENDS = "glib-2.0 pkgconfig-native glib-2.0-native python3-packaging-native python3-native systemd"
RDEPENDS:${PN} += "dbus minisign mu-init libsystemd"

S = "${WORKDIR}/git"

SYSTEMD_SERVICE:${PN} = "mu-update-daemon.service"
SYSTEMD_AUTO_ENABLE:${PN} = "enable"

do_configure:append() {
    sed "s|@MU_UPDATE_INBOX_DIR@|${MU_UPDATE_INBOX_DIR}|g" \
        ${WORKDIR}/mu-update-daemon.service.in > ${WORKDIR}/mu-update-daemon.service
}

do_install:append() {
    install -d ${D}${systemd_system_unitdir}
    install -d ${D}${libexecdir}/mu-update-daemon
    install -d ${D}${sysconfdir}/dbus-1/system.d
    install -m 0644 ${WORKDIR}/mu-update-daemon.service ${D}${systemd_system_unitdir}/mu-update-daemon.service
    install -m 0755 ${WORKDIR}/build/mu-update-daemon ${D}${libexecdir}/mu-update-daemon/mu-update-daemon
    install -m 0644 ${WORKDIR}/org.mu.Update.conf ${D}${sysconfdir}/dbus-1/system.d/org.mu.Update.conf
}

FILES:${PN} += " \
    ${libexecdir}/mu-update-daemon/mu-update-daemon \
    ${systemd_system_unitdir}/mu-update-daemon.service \
"
