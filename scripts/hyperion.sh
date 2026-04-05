#!/bin/bash
# update system & install core packages
pacman -Syyu --noconfirm
# Switch to pacman.conf from files 
cp -r /tmp/pacman.conf /etc/pacman.conf
pacman -Syyu --noconfirm
# Install core packages 
pacman -Sy --noconfirm jupiter-main/gamescope steam xdg-desktop-portal xdg-desktop-portal-kde xdg-desktop-portal-gamescope base-devel systemd
# NOTE - SystemD is needed for ds-inhibit 
# Install drivers - NVIDIA support should be baked in thorough distrobox
pacman -Sy --noconfirm vulkan-intel vulkan-radeon vulkan-headers lib32-vulkan-radeon lib32-vulkan-intel
# Install Steam and other gaming utilities through AUR and Chaotic AUR 
pacman -Sy --noconfirm steam mangohud scx-scheds scx-tools
# Install System-Wide fonts & Codecs
pacman -Sy --noconfirm noto-fonts ttf-dejavu ttf-liberation noto-fonts-emohi noto-fonts-cjk
# Codecs
pacman -Sy --noconfirm flac wavpack lame libmad faac libwebp libavif libheif libjxl aom libde265 x264

# Setup Chaotic AUR
pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
pacman-key --lsign-key 3056513887B78AEB 
pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst'
pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
cp -r /tmp/pacman.conf.chaotic /etc/pacman.conf
pacman -Syyu

# Install AUR and gaming packages
sudo pacman -S paru heroic-games-launcher-bin faugus-launcher proton-cachyos proton-cachyos-slr protonplus bottles gamescope-git mesa-tkg-git paru


# Switch & Create build user - Similar to Docker 
sudo useradd -m -s -G /bin/bash builduser wheel
su builduser
# As builduser
# make temp build dir 
cd ~ && mkdir -p ~/tmp/build-aur 
cd ~/tmp/build-aur
paru -S --noconfirm scopebuddy scopebuddy-gui-git ds-inhibit goverlay-git
# Cleanup 
paru -Rns --noconfirm $(paru -Qtdq)
paru -Scc --noconfirm
sudo su #Switch back to root
pkill -u builduser
userdel -r builduser
