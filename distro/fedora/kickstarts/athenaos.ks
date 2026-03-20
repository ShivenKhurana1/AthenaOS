#version=F40
lang en_US.UTF-8
keyboard us
timezone UTC --utc
network --bootproto=dhcp --device=link --activate
authselect --useshadow --passalgo=sha512
selinux --enforcing
firewall --enabled --service=ssh
services --enabled=NetworkManager,bluetooth,sshd
firstboot --enable
bootloader --timeout=1 --append="rhgb quiet"
clearpart --all --initlabel
autopart --type=btrfs
user --name=athena --groups=wheel --password=athena --plaintext --gecos="Athena User"

liveimg --compression=lz4

%packages
@^workstation-product-environment
@gnome-desktop
NetworkManager-wifi
bluez
pipewire
wireplumber
gnome-shell-extension-user-theme
gnome-tweaks
flatpak
xdg-desktop-portal
xdg-desktop-portal-gnome
firefox
nautilus
gnome-terminal
gnome-control-center
gnome-system-monitor
gnome-software
power-profiles-daemon
fwupd
athena-theme
athena-shell-extension
%end

%post --erroronfail
/usr/bin/glib-compile-schemas /usr/share/glib-2.0/schemas || :
/usr/bin/dconf update || :
%end
