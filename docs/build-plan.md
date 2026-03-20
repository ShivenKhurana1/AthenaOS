# Build plan

This document defines the system plan for a production-ready AthenaOS distro. It covers base selection, toolchain bootstrap, core services, desktop stack, installer, updates, QA, and the LFS build workflow.

## Scope and goals

- LFS + BLFS based desktop distro with GNOME shell customization
- Reproducible ISO build with signed artifacts
- Stable update channel with beta and dev lanes (initially manual)
- Target arch: x86_64 for v0.1, additional architectures later

## Current repo anchors

- LFS build docs: [../distro/lfs/README.md](../distro/lfs/README.md)
- LFS scripts: [../distro/lfs/scripts/bootstrap-toolchain.sh](../distro/lfs/scripts/bootstrap-toolchain.sh), [../distro/lfs/scripts/build-base.sh](../distro/lfs/scripts/build-base.sh), [../distro/lfs/scripts/build-desktop.sh](../distro/lfs/scripts/build-desktop.sh), [../distro/lfs/scripts/build-iso.sh](../distro/lfs/scripts/build-iso.sh)
- LFS recipes: [../distro/lfs/recipes/README.md](../distro/lfs/recipes/README.md)
- LFS manifests: [../distro/lfs/manifests/versions.lock](../distro/lfs/manifests/versions.lock)
- Legacy Fedora pipeline: [../distro/fedora/README.md](../distro/fedora/README.md)

## Base selection

- Base: Linux From Scratch (LFS) + Beyond Linux From Scratch (BLFS)
- Build host: Linux with gcc, make, bison, flex, and other LFS prerequisites
- Toolchain: LFS bootstrap toolchain and controlled chroot build
- Build inputs: recipe manifests, source tarballs, and Athena assets

## Toolchain bootstrap

- Bootstrap binutils, gcc, glibc using LFS book order
- Build in isolated directories and switch to a chroot environment
- Produce a reproducible rootfs tarball and a build manifest

## Boot and kernel

- Bootloader: GRUB2 for EFI, Secure Boot support in later phases
- Kernel policy: build from source using LFS guidance
- Initramfs: dracut or mkinitramfs as required by the ISO layout

## Init and core services

- systemd, logind, udev, dbus, polkit
- journald logging with rotation and size-based retention
- time sync: chrony
- user management: shadow + sudo (doas optional)

## Filesystems and storage

- Default root filesystem: Btrfs with subvolumes for /, /home, /var
- Optional ext4 profile for minimal systems
- Memory pressure: zram by default, swapfile optional
- Disk encryption: LUKS2 with passphrase; TPM unlock in later phases
- Snapshot tooling: snapper or timeshift when Btrfs is enabled

## Packaging and recipes

- Recipe-based build scripts with version lock and checksums
- Local package DB and build manifest for reproducibility
- Future: signed binary repo and update channels

## Graphics and multimedia

- Wayland + Mutter + GTK4 + libadwaita
- Mesa for 3D, PipeWire + WirePlumber for audio and video
- GPU drivers: Intel/AMD open drivers, optional Nvidia stack
- Font stack: default UI, display, and mono families defined in theme

## Desktop shell and login

- GNOME Shell theme + Athena extension for glasskit layout
- GSettings overrides and dconf defaults for consistent UX
- Display manager: GDM

## Core apps

- Settings, Files, Terminal, Browser, App Center, Text, Media
- First-run setup wizard and account creation flow
- Flatpak as the default app delivery for third-party apps

## Networking and connectivity

- NetworkManager for wired, Wi-Fi, and VPN
- Bluetooth stack (bluez) with GNOME integration

## Power and hardware enablement

- power-profiles-daemon, lid and battery handling
- Fractional scaling, input device defaults, touchpad tuning
- Optional printing stack (CUPS) and scanning support

## Security and privacy

- Secure Boot support and signed images (later phase)
- Firewall: firewalld (default), ufw optional
- App sandboxing: Flatpak + portal configuration
- Crash reporting and telemetry: opt-in only

## Installer and recovery

- Installer: TBD (manual install or minimal installer for v0.1)
- Partitioning, encryption, locale, and user creation
- Live ISO with recovery tools and diagnostics
- Snapshot rollback if Btrfs is enabled

## Updates and release pipeline

- ISO build automation and artifact signing
- Build manifests and versioned release tags
- Offline updates for core system components when available
- Release notes and migration guides per release

## Build workflow

1) Sync sources and verify checksums
2) Bootstrap toolchain in isolated build root
3) Build base rootfs and core services
4) Build GNOME desktop stack and Athena assets
5) Build live ISO
6) Smoke test install + first boot

## QA and release readiness

- Automated ISO smoke tests and hardware matrix
- Performance and battery benchmarks
- Accessibility and localization reviews
- Licensing and third-party notice bundle

## Open decisions (resolve before v0.1 lock)

- Installer approach (manual vs minimal installer)
- Packaging format for update channels
- Secure Boot signing pipeline
- Nvidia driver packaging policy
- Default filesystem: Btrfs vs ext4

## Definition of done (v0.1)

- Bootable ISO with live session
- GNOME-based shell with glasskit theme + extension
- Core apps installed and first-run flow complete
- Build manifest verified against source checksums
