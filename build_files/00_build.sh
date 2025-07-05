#!/bin/bash

#set -ouex pipefail

export env_debug="false"
debug () {
    if [ "$env_debug" = "true" ];
    then
        echo "DEBUG: $1"
    fi
}


### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
dnf5 install -y tmux 

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

#### Example for enabling a System Unit File

systemctl enable podman.socket

debug "Pre base packages"
debug "TARGET_PLATFORM: ${TARGET_PLATFORM}"
debug "TARGET_DESKTOP: ${TARGET_DESKTOP}"
debug "TARGET_NVIDIA: ${TARGET_NVIDIA}"

source /ctx/05_base_packages.sh

if [ "${TARGET_PLATFORM}" = "server" ];
then
    source /ctx/10s_server_config.sh
fi

if [ "${TARGET_PLATFORM}" = "workstation" ];
then
    debug "Inside if workstation"
    if [ "$TARGET_DESKTOP" = "gnome" ];
    then
        debug "Pre gnome setup"
        source /ctx/10w_gnome_setup.sh
    fi

    if [ "${TARGET_DESKTOP}" = "kde" ];
    then
        source /ctx/10w_kde_setup.sh
    fi

    if [ "${TARGET_DESKTOP}" = "cosmic" ];
    then
        source /ctx/10w_cosmic_setup.sh
    fi

    source /ctx/15w_desktop_apps.sh
fi

if [ "${TARGET_NVIDIA}" = "true" ];
then
    source /ctx/20_install_nvidia.sh
fi

debug "Kernel Version: $(uname -a)"
debug "Kernel version: $(rpm -q --qf "%{VERSION}-%{RELEASE}" kernel)"

# From https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/9/html/using_image_mode_for_rhel_to_build_deploy_and_manage_operating_systems/managing-rhel-bootc-images
RUN set -x; kver=$(cd /usr/lib/modules && echo *); dracut -vf /usr/lib/modules/$kver/initramfs.img $kver
