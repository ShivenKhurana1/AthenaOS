Name: athena-theme
Version: 0.1.0
Release: 1%{?dist}
Summary: AthenaOS GTK and GNOME Shell theme
License: MIT
BuildArch: noarch
Requires: gnome-shell-extension-user-theme
Requires: gnome-shell

Source0: %{name}-%{version}.tar.gz

%description
AthenaOS theme assets including GTK, GNOME Shell styles, wallpaper, and defaults.

%prep
%setup -q

%build

%install
mkdir -p %{buildroot}/usr/share/themes/AthenaOS
cp -a theme/* %{buildroot}/usr/share/themes/AthenaOS/
mkdir -p %{buildroot}/usr/share/backgrounds/athenaos
cp -a branding/* %{buildroot}/usr/share/backgrounds/athenaos/
mkdir -p %{buildroot}/usr/share/glib-2.0/schemas
cp -a config/gsettings/*.gschema.override %{buildroot}/usr/share/glib-2.0/schemas/
mkdir -p %{buildroot}/etc/dconf/db/local.d
cp -a config/dconf/00-athenaos %{buildroot}/etc/dconf/db/local.d/00-athenaos
mkdir -p %{buildroot}/etc/dconf/db/gdm.d
cp -a config/dconf/01-gdm %{buildroot}/etc/dconf/db/gdm.d/01-gdm
mkdir -p %{buildroot}/usr/share/athenaos
cp -a config/system/issue %{buildroot}/usr/share/athenaos/issue

%post
/usr/bin/glib-compile-schemas /usr/share/glib-2.0/schemas || :
/usr/bin/dconf update || :

%files
%license LICENSE
/usr/share/themes/AthenaOS
/usr/share/backgrounds/athenaos
/usr/share/glib-2.0/schemas/00-athenaos.gschema.override
/etc/dconf/db/local.d/00-athenaos
/etc/dconf/db/gdm.d/01-gdm
/usr/share/athenaos/issue

%changelog
* Mon Mar 16 2026 AthenaOS Team <dev@athenaos.local> - 0.1.0-1
- Initial package
