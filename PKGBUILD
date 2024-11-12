# Maintainer: Eric Renfro <erenfro@linux-help.org>
pkgname=kernel-rotate-hook
pkgver=0.1
pkgrel=1
pkgdesc="Rotates kernels after upgrades"
arch=('any')
url="https://github.com/erenfro/kernel-rotate-hook"
license=('UNLICENSE')
depends=('coreutils')
source=("05-kernel-rotate-pre.hook"
        "kernel-rotate-cleanup.conf"
		"kernel-rotate.conf"
		"kernel-rotate.sh"
		"UNLICENSE")
sha256sums=('d8207e3c928af934335ec3a6e34283661db6cb40cf1316d71e0f2332816e64bc'
            'f0ba927be1d1778b1b3dacac32fdc1f76c4a86a438c1208bdfdfe7b20cf51c9a'
            '09a145c2e24172e602854682b906b280cd0bc7eee45ecb199227eac968766e7d'
            '6e9ab43e64b8bd08757fc940db7da7f2b3b18084514aa88bac772723eebe4345'
            '7e12e5df4bae12cb21581ba157ced20e1986a0508dd10d0e8a4ab9a4cf94e85c')
backup=('etc/kernel-rotation.conf')

package() {
    install -Dm644 'kernel-rotate-cleanup.conf' "${pkgdir}/usr/lib/tmpfiles.d/kernel-rotate-cleanup.conf"
    install -Dm644 'kernel-rotation.conf' "${pkgdir}/etc/kernel-rotation.conf"
    install -Dm644 '05-kernel-rotate-pre.hook' "${pkgdir}/usr/share/libalpm/hooks/05-kernel-rotate-pre.hook"
    install -Dm755 'kernel-rotate.sh' "${pkgdir}/usr/share/libalpm/scripts/kernel-rotate.sh"
    install -Dm644 'UNLICENSE' "${pkgdir}/usr/share/licenses/${pkgname}/UNLICENSE"
}
