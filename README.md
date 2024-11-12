# Kernel Rotation Hooks

This is a kernel rotation alpm-hook for saving backups of kernels for use in recovery situations.

It's capable of doing all kernels being installed/upgraded, a specific list of kernel packages, or only the active, along with being able to be disabled, which it is by default.

## Configuration

Configuration is managed in /etc/kernel-rotation.conf and is self documented within.

There is a tmpfiles.d component to this configuration, and can be seen in:
/usr/lib/tmpfiles.d/kernel-rotate-cleanup.conf

And overridden in:
/etc/tmpfiles.d/kernel-rotate-cleanup.conf
