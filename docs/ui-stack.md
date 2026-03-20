# UI stack

AthenaOS will start on a GNOME stack with Wayland, GTK4, and libadwaita. This gives a solid base for performance, accessibility, and app compatibility while we focus on the glasskit experience.

## Shell approach

- Start with GNOME Shell theming and a focused extension
- Implement glass surfaces, blur, and depth on shell panels
- Add a custom launcher and quick settings layout

## Apps and toolkit

- GTK4 for core apps and settings
- libadwaita for consistent spacing, typography, and widgets
- A small set of custom widgets for glass surfaces

## Why this stack

- Stable, widely supported, and Wayland-first
- Easier to prototype and ship early releases
- Keeps focus on design and UX quality
