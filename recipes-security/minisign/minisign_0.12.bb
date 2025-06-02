SUMMARY = "Minisign - simple, secure, lightweight Ed25519 signing tool"
HOMEPAGE = "https://jedisct1.github.io/minisign/"
LICENSE = "ISC"
LIC_FILES_CHKSUM = "file://LICENSE;md5=0ae5258ce978a2a6df50571a88687b53"

SRC_URI = "git://github.com/jedisct1/minisign.git;protocol=ssh;branch=master"
SRCREV = "b85e15d45ac9eab34e44596fd309f5b07db9545c"
PV = "0.12+git${SRCPV}"

S = "${WORKDIR}/git"

DEPENDS = "libsodium"

inherit cmake pkgconfig

RDEPENDS:${PN} += "libsodium"

FILES:${PN} += "${bindir}/minisign"

INSANE_SKIP:${PN} = "already-stripped"
