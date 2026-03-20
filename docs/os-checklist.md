# OS checklist

Use this as a completeness checklist for AthenaOS. Items should be planned, implemented, and validated before calling the system a proper OS release.

## Core system

- [ ] Bootloader configured and signed
- [ ] LTS kernel selected and patched
- [ ] Init system and base services configured
- [ ] Filesystem layout and fstab defaults
- [ ] User management and privilege escalation
- [ ] Time sync and logging configured

## Packaging and updates

- [ ] Package manager configured with signed repos
- [ ] Base repo mirror strategy in place
- [ ] Update channels defined (stable, beta, dev)
- [ ] Delta or offline update flow validated

## Hardware enablement

- [ ] GPU drivers for Intel and AMD
- [ ] Optional Nvidia stack decision
- [ ] Audio stack with PipeWire + WirePlumber
- [ ] Networking with NetworkManager
- [ ] Bluetooth stack and UI integration
- [ ] Power management tuned for laptops
- [ ] Input device tuning (touchpad, keyboard, tablet)

## Desktop experience

- [ ] Display server (Wayland) configured
- [ ] Display manager themed and working
- [ ] GNOME Shell theme + extension installed
- [ ] Core apps installed and branded
- [ ] First-run setup wizard completed
- [ ] Default fonts, icons, and sounds set

## Security and privacy

- [ ] Secure Boot compatibility
- [ ] LUKS disk encryption option
- [ ] Firewall enabled by default
- [ ] Sandboxing with Flatpak and portals
- [ ] Telemetry and crash reporting opt-in only

## Installer and recovery

- [ ] Installer supports partitioning and encryption
- [ ] Live ISO boots on target hardware
- [ ] Recovery tools and diagnostics included
- [ ] Snapshot rollback if Btrfs is used

## Quality and release

- [ ] ISO build automation and signing
- [ ] Automated smoke tests and basic QA
- [ ] Performance and battery benchmarks
- [ ] Accessibility checks and localization
- [ ] Licensing and third-party notices
- [ ] Release notes and support docs
