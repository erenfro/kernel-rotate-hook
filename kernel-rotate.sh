#!/bin/bash

all=false
kernels=()
mykver=$(uname -r)

# Read the optional config file for automation
[[ -f /etc/kernel-rotate.conf ]] && source /etc/kernel-rotate.conf

# Define defaults and insure sanity with lowercasing forced.
BOOT_PATH="${BOOT_PATH:-/boot}"
BACKUP_PATH="${BACKUP_PATH:-${BOOT_PATH}/.old}"
ROTATION_STYLE="${ROTATION_STYLE:-none}"
ROTATION_STYLE="${ROTATION_STYLE,,}"
ROTATION_KEEP="linux"
ROTATION_KEEP="${ROTATION_KEEP,,}"


# Code begins
while read -r line; do  # build a list of kernels being updated this transaction
    if [[ "${line}" != */vmlinuz ]]; then
        # triggers when it's a change to dracut
        all=true
        break
    fi

    kernels+=("/${line%/vmlinuz}")
done

if $all; then  # apparently dracut is being updated, so let's just loop all
    kernels=(/usr/lib/modules/*)
fi

for line in "${kernels[@]}"; do
    if ! pacman -Qqo "${line}/pkgbase" &> /dev/null; then
        # if pkgbase does not belong to any package then skip this kernel
        continue
    fi

    pkgbase="$(<"${line}/pkgbase")"
    kver="${line##*/}"
    kvern="${kver%%-*}"
    freeSpace="$(df "${BOOT_PATH}" | awk '{print $4}' | tail -1)"
    sizeUsed="$(du -sc "${BOOT_PATH}/vmlinuz-${pkgbase}" "${BOOT_PATH}/initramfs-${pkgbase}.img" "${BOOT_PATH}/initramfs-${pkgbase}-fallback.img" | grep total | cut -f1)"

    if [[ "${ROTATION_STYLE}" == "active" ]]; then
        # Check if current item is for the active running kernel
        if [[ "$mykver" != "$kver" ]]; then
            echo "KERNEL ROTATION: Not rotating ${pkgbase} (${kver}), not active kernel"
            continue
        fi
    elif [[ "${ROTATION_STYLE}" == "list" ]]; then
        # Check if current item is in the list of kernels to rotate
        found=false
        for i in ${ROTATION_KEEP}; do
            if [[ "$i" == "$pkgbase" ]]; then
                found=true
                break
            fi
        done

        if ! $found; then
            echo "KERNEL ROTATION: Not rotating ${pkgbase} (${kver}), not in the list"
            continue
        fi
    elif [[ "${ROTATION_STYLE}" == "none" ]]; then
        echo "KERNEL ROTATION: Not rotating ${pkgbase} (${kver}), rotation disabled"
        continue
    fi

    echo "KERNEL ROTATION: Rotating ${pkgbase} (${kver}) to ${BACKUP_PATH}"

    if (( sizeUsed > freeSpace )); then
        # Check if existing kernel backups would free up enough space to be rotated anyway
        freeable="$(du -sc "${BACKUP_PATH}/vmlinuz-${pkgbase}" "${BACKUP_PATH}/initramfs-${pkgbase}.img" "${BACKUP_PATH}/initramfs-${pkgbase}-fallback.img" | grep total | cut -f1)"
        if (( sizeUsed > (freeSpace + freeable) )); then
            echo "KERNEL ROTATION: WARNING: Not enough free space on /boot to perform kernel rotation"
            continue
        fi
    else
        mkdir -p "${BACKUP_PATH}/.old"
        cp --reflink "${BOOT_PATH}/vmlinuz-${pkgbase}" "${BACKUP_PATH}/vmlinuz-${pkgbase}"
        cp --reflink "${BOOT_PATH}/initramfs-${pkgbase}.img" "${BACKUP_PATH}/initramfs-${pkgbase}.img"
        cp --reflink "${BOOT_PATH}/initramfs-${pkgbase}-fallback.img" "${BACKUP_PATH}/initramfs-${pkgbase}-fallback.img"
    fi
done
