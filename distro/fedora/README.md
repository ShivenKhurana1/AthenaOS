# Fedora build (legacy)

This folder contains AthenaOS Fedora build assets based on lorax and livemedia-creator. It is retained as a legacy reference; the primary build pipeline is now LFS-based under distro/lfs.

## Requirements

- Fedora build host (x86_64)
- Packages: lorax, lorax-lmc-novirt, pykickstart, anaconda, createrepo_c, rpmdevtools, git

## Build steps

1) Build Athena packages:

./distro/fedora/scripts/build-packages.sh

2) Build the ISO:

RELEASEVER=40 VERSION=0.1 ./distro/fedora/scripts/build-iso.sh

Output is written to distro/fedora/out.

## Customize

- Kickstart: kickstarts/athenaos.ks
- Package lists: package-lists/
- Theme assets: theme/
- Shell extension: extensions/athena-shell
- Defaults: config/
- Wallpaper: branding/aurora.svg

## Notes

- Build scripts use sudo.
- Update the default user password in the kickstart before release.
