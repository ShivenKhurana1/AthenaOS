Name: athena-shell-extension
Version: 0.1.0
Release: 1%{?dist}
Summary: AthenaOS GNOME Shell extension
License: MIT
BuildArch: noarch
Requires: gnome-shell

Source0: %{name}-%{version}.tar.gz

%description
Minimal GNOME Shell extension for AthenaOS styling hooks.

%prep
%setup -q

%build

%install
mkdir -p %{buildroot}/usr/share/gnome-shell/extensions/athena-shell@athenaos
cp -a extensions/athena-shell/* %{buildroot}/usr/share/gnome-shell/extensions/athena-shell@athenaos/

%files
%license LICENSE
/usr/share/gnome-shell/extensions/athena-shell@athenaos

%changelog
* Mon Mar 16 2026 AthenaOS Team <dev@athenaos.local> - 0.1.0-1
- Initial package
