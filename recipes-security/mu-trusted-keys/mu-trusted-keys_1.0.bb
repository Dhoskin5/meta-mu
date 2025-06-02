SUMMARY = "Trusted public keys for mu-verify signature validation"
DESCRIPTION = "This recipe installs trusted public keys for mu-verify signature validation. \
                These keys are used to verify the authenticity of software updates and system images."
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

FILESEXTRAPATHS:prepend := "${MU_KEYS_DIR}:"

SRC_URI = "file://key-1.pub \
           file://key-2.pub \
           file://key-3.pub"

S = "${WORKDIR}"

FILES:${PN} += "/etc/mu/trusted.d/"

do_install() {
    install -d ${D}/etc/mu/trusted.d
    install -m 0644 ${WORKDIR}/*.pub ${D}/etc/mu/trusted.d/
}