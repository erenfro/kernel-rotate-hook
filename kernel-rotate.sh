#!/bin/bash

all=false
kernels=()
mykver=$(uname -r)
myactive="$(<"/usr/lib/modules/${mykver}/pkgbase")"

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
    $all && continue # Dump the remaining input buffer
    if [[ "${line}" != linux* ]]; then
        echo "Updating all kernels."
        all=true
        continue
    fi

    #echo "Adding ${line} to kernel rotation..."
    kernels+=("${line}")
done

if $all; then  # apparently dracut/mkinitcpio is being updated, so let's just loop all
    kernels=()
    for line in /usr/lib/modules/*; do
        if pacman -Qqo "${line}/pkgbase" &> /dev/null; then
            kernels+=("$(<"${line}/pkgbase")")
        fi
    done
fi


for kernel in "${kernels[@]}"; do
    freeSpace="$(df "${BOOT_PATH}" | awk '{print $4}' | tail -1)"
    sizeUsed="$(du -sc "${BOOT_PATH}/vmlinuz-${kernel}" "${BOOT_PATH}/initramfs-${kernel}.img" "${BOOT_PATH}/initramfs-${kernel}-fallback.img" | grep total | cut -f1)"

    if [[ "${ROTATION_STYLE}" == "active" ]]; then
        # Check if current item is for the active running kernel
        if [[ "$myactive" != "$kernel" ]]; then
            echo "KERNEL ROTATION: Not rotating ${kernel}, not active kernel"
            continue
        fi
    elif [[ "${ROTATION_STYLE}" == "list" ]]; then
        # Check if current item is in the list of kernels to rotate
        found=false
        for i in ${ROTATION_KEEP}; do
            if [[ "$i" == "$kernel" ]]; then
                found=true
                break
            fi
        done

        if ! $found; then
            echo "KERNEL ROTATION: Not rotating $kernel, not in the list"
            continue
        fi
    elif [[ "${ROTATION_STYLE}" == "none" ]]; then
        echo "KERNEL ROTATION: Not rotating ${kernel}, rotation disabled"
        continue
    fi

    echo "KERNEL ROTATION: Rotating ${kernel} to ${BACKUP_PATH}"

    if (( sizeUsed > freeSpace )); then
        # Check if existing kernel backups would free up enough space to be rotated anyway
        freeable="$(du -sc "${BACKUP_PATH}/vmlinuz-${kernel}" "${BACKUP_PATH}/initramfs-${kernel}.img" "${BACKUP_PATH}/initramfs-${kernel}-fallback.img" | grep total | cut -f1)"
        if (( sizeUsed > (freeSpace + freeable) )); then
            echo "KERNEL ROTATION: WARNING: Not enough free space on /boot to perform kernel rotation"
            continue
        fi
    else
        mkdir -p "${BACKUP_PATH}"
        cp --reflink=auto "${BOOT_PATH}/vmlinuz-${kernel}" "${BACKUP_PATH}/vmlinuz-${kernel}"
        cp --reflink=auto "${BOOT_PATH}/initramfs-${kernel}.img" "${BACKUP_PATH}/initramfs-${kernel}.img"
        if [[ -f "${BOOT_PATH}/initramfs-${kernel}-fallback.img" ]]; then
            cp --reflink=auto "${BOOT_PATH}/initramfs-${kernel}-fallback.img" "${BACKUP_PATH}/initramfs-${kernel}-fallback.img"
        fi
    fi
done
