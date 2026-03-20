# LFS build (primary)

This folder contains the LFS/BLFS build pipeline for AthenaOS. The Fedora pipeline under distro/fedora is retained as a legacy reference.

## Requirements

- Linux build host (x86_64)
- Tooling: gcc, g++, make, bison, flex, gawk, tar, xz, curl, sha256sum
- ISO tooling: grub2, xorriso, squashfs-tools (for build-iso.sh)

## Build flow

1) Define source versions and checksums in manifests/versions.lock
2) Download sources: scripts/setup-sources.sh
3) Bootstrap toolchain: scripts/bootstrap-toolchain.sh
4) Build base system: scripts/build-base.sh (BASE_MODE=systemd by default; BASE_MODE=minimal for early testing)
5) Build kernel: scripts/build-kernel.sh
6) Build initramfs: scripts/build-initramfs.sh
7) Build desktop stack: scripts/build-desktop.sh
8) Build ISO: scripts/build-iso.sh

Artifacts are written to output/ and the rootfs is staged in rootfs/.

## Notes

- The ISO build expects a kernel and initramfs under rootfs/boot; you can override
	via KERNEL_IMAGE and INITRAMFS_IMAGE environment variables.
- The systemd base mode runs scripts/run-recipes.sh with recipes/base-systemd.order.
- The minimal base mode uses BusyBox init for early boot testing, not systemd.
- Base recipes expect source tarballs under sources/. Populate manifests/versions.lock
	and run scripts/setup-sources.sh or add tarballs manually.
- The initramfs must mount rootfs.squashfs from the ISO; the default kernel args use
	root=live:CDLABEL=<label> and athenaos.squashfs=/rootfs.squashfs.
- This pipeline is scaffolding and will be expanded with full LFS/BLFS steps.
- If scripts are not executable, run them with bash or chmod +x.
- Legacy Fedora docs: ../fedora/README.md
