# Maintainer: Eric Renfro <erenfro@linux-help.org>
pkgname=kernel-rotate-hook
pkgver=0.2.3
pkgrel=1
pkgdesc="Rotates kernels after upgrades"
arch=('any')
url="https://github.com/erenfro/kernel-rotate-hook"
license=('UNLICENSE')
depends=('coreutils' "kernel-modules-hook")
source=("07-kernel-rotate-pre.hook"
        "kernel-rotate-cleanup.conf"
		"kernel-rotate.conf"
		"kernel-rotate.sh"
		"UNLICENSE")
sha256sums=('41fdd5abb4b7633fb20ce13717c98258bf428b57ea8c0dc2d0e986036612b6e1'
            'f0ba927be1d1778b1b3dacac32fdc1f76c4a86a438c1208bdfdfe7b20cf51c9a'
            '09a145c2e24172e602854682b906b280cd0bc7eee45ecb199227eac968766e7d'
            '2672594547f8ffc9849978ba1c0fb3e86a83f6b10c67687f008d0d2034a8e24f'
            '7e12e5df4bae12cb21581ba157ced20e1986a0508dd10d0e8a4ab9a4cf94e85c')
backup=('etc/kernel-rotate.conf')

package() {
    install -Dm644 'kernel-rotate-cleanup.conf' "${pkgdir}/usr/lib/tmpfiles.d/kernel-rotate-cleanup.conf"
    install -Dm644 'kernel-rotate.conf' "${pkgdir}/etc/kernel-rotate.conf"
    install -Dm644 '07-kernel-rotate-pre.hook' "${pkgdir}/usr/share/libalpm/hooks/07-kernel-rotate-pre.hook"
    install -Dm755 'kernel-rotate.sh' "${pkgdir}/usr/share/libalpm/scripts/kernel-rotate.sh"
    install -Dm644 'UNLICENSE' "${pkgdir}/usr/share/licenses/${pkgname}/UNLICENSE"
}
