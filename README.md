# AthenaOS

AthenaOS is a Linux-based desktop OS focused on a modern glasskit interface with clean depth, soft motion, and an airy layout. This repo holds design docs, design tokens, a static UI prototype, and Fedora build scaffolding.

## Status

LFS/BLFS build scaffolding plus a browser-based shell mockup and design system. The Fedora pipeline remains as a legacy reference.

## Repo layout

- docs: vision, roadmap, stack choices, build plan
- design: design tokens and usage notes
- prototype: static HTML/CSS/JS mock desktop
- distro/lfs: LFS toolchain, recipes, and ISO build scripts (primary)
- distro/fedora: legacy Fedora kickstart, packaging, theme, and ISO build scripts

## Quick start

Open prototype/index.html in a browser to view the mock desktop. See distro/lfs/README.md for LFS build steps.

## Next goals

- Bootstrap LFS toolchain and base rootfs
- Bring up GNOME via BLFS and apply Athena assets
- Build a bootable ISO and validate in a VM
