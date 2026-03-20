# Overview

AthenaOS is a Linux distro that prioritizes a glasskit interface inspired by macOS style translucency, with modern depth, calm motion, and readable surfaces.

## Goals

- Deliver a cohesive glass UI across the shell and core apps
- Maintain clarity and performance on mid-range hardware
- Keep the base system stable and easy to update

## Non-goals (for now)

- Writing a custom kernel or drivers from scratch
- Replacing the entire GNOME stack in the first releases

## Principles

- Clarity first: translucent, but always readable
- Depth with restraint: subtle elevation, soft shadows
- Motion as guidance: small, informative transitions
- Fast and clean: avoid heavy effects at rest

## Target

- Base: LFS + BLFS
- Architecture: x86_64
- Display server: Wayland
- UI toolkit: GTK4 + libadwaita
- Init system: systemd
