# Maintainer: Eric Renfro <erenfro@linux-help.org>
pkgname=kernel-rotate-hook
pkgver=0.2.6
pkgrel=1
pkgdesc="Rotates kernels after upgrades"
arch=('any')
url="https://github.com/erenfro/kernel-rotate-hook"
license=('UNLICENSE')
depends=('coreutils' "kernel-modules-hook")
optdepends=('snap-pac-grub: Grub update automation with kernel updates with snap-pac'
            'grub-hook: Alternative grub update automation')
source=("07-kernel-rotate-pre.hook"
        "kernel-rotate-cleanup.conf"
		"kernel-rotate.conf"
		"kernel-rotate.sh"
		"UNLICENSE")
sha256sums=('06c9a59974cbc6aaa3c8767243710fc10c79801d4b38d18835d32131fc762025'
            'c5eb0d36010392da393d706d98beff332e3162446496ed13010532312270dbe0'
            '10f0a300c02df7ebef947e3fd39c09b4e3285ccc908cc71715beb066da875d93'
            'ae9889cf813aa97b7cbdbb15823e04978df33ba96509704bf5b1391b36be26aa'
            '7e12e5df4bae12cb21581ba157ced20e1986a0508dd10d0e8a4ab9a4cf94e85c')
backup=('etc/kernel-rotate.conf')

package() {
    install -Dm644 'kernel-rotate-cleanup.conf' "${pkgdir}/usr/lib/tmpfiles.d/kernel-rotate-cleanup.conf"
    install -Dm644 'kernel-rotate.conf' "${pkgdir}/etc/kernel-rotate.conf"
    install -Dm644 '07-kernel-rotate-pre.hook' "${pkgdir}/usr/share/libalpm/hooks/07-kernel-rotate-pre.hook"
    install -Dm755 'kernel-rotate.sh' "${pkgdir}/usr/share/libalpm/scripts/kernel-rotate.sh"
    install -Dm644 'UNLICENSE' "${pkgdir}/usr/share/licenses/${pkgname}/UNLICENSE"
}
