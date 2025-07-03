debug "Inside gnome setup"


dnf group install -y gnome-desktop gnome-games gnome-software-development
dnf install -y "mesa-libGLU" \
    "nautilus-gsconnect" \
    "gnome-shell-extension-appindicator" \
    "gnome-shell-extension-blur-my-shell" \
    "gnome-shell-extension-caffeine" \
    "gnome-shell-extension-dash-to-dock" \
    "gnome-shell-extension-gsconnect" \
    "gnome-shell-extension-logo-menu" \
    "gnome-shell-extension-search-light" \
    "gnome-shell-extension-tailscale-gnome-qs" \
    "gnome-tweaks" \
    "pulseaudio-utils" \
    "adw-gtk3-theme" 

systemctl set-default graphical.target

# Install flaptak, stolen from ublue
flatpak remote-add --system --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
systemctl disable flatpak-add-fedora-repos.service