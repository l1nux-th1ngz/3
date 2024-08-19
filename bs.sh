#!/bin/bash

# Ensure the script is run as a regular user, not root
if [[ $EUID -eq 0 ]]; then
   echo "Please do not run this script as root."
   exit 1
fi

# Update and install necessary packages
sudo apt-get update
sudo apt-get -y install bspwm nemo ranger xdg-user-dirs xdg-user-dirs-gtk \
# Setup XDG user directories
xdg-user-dirs-update
sleep 5
xdg-user-dirs-gtk-update sleep 10

sudo apt-get -y install libconfig-dev libdbus-1-dev libegl-dev libev-dev libgl-dev libepoxy-dev libpcre2-dev \
  libpixman-1-dev libx11-xcb-dev libxcb1-dev libxcb-composite0-dev libxcb-damage0-dev \
  libxcb-dpms0-dev libxcb-glx0-dev libxcb-image0-dev libxcb-present-dev libxcb-randr0-dev brightnessvtl \
  libxcb-render0-dev libxcb-render-util0-dev libxcb-shape0-dev libxcb-util-dev playerctl \
  libxcb-xfixes0-dev libxext-dev meson ninja-build uthash-dev ffmpeg xorg xserver-xorg-video-intel \
  menu suckless-tools acpid avahi-daemon fontconfig bspwm geany vlc rofi gsimplecal tint2 uxplay \
  nitrogen neofetch xfce4-power-manager rxvt-unicode ttf-ubuntu-font-family fonts-material-design-icons-webfont \
  fonts-hack-ttf policykit-1-gnome dmenu viewnior lxappearance dex  yad zenity kitty \
  alacritty lolcat ascii figlet toilet toilet-fonts dos2unix lxappearance-obconf qt5-style-plugins \
  qt5ct alsa-utils pulseaudio pavucontrol lm-sensors lz4 fonts-material-design-icons-iconfont \
  materia-gtk-theme arc-theme papirus-icon-theme fonts-noto-hinted fonts-noto-mono \
  fonts-roboto fonts-hack-ttf neomutt abook ranger newsboat scrot mpd mpc ncmpcpp \
  suckless-tools sxhkd xbacklight mpv youtube-dl imagemagick libnotify-bin taskwarrior w3m \
  zathura dtrx rsync i3lock lxappearance fonts-font-awesome libdbus-1-dev libx11-dev libxinerama-dev \
  libxrandr-dev libxss-dev libglib2.0-dev libpango1.0-dev libgtk2.0-dev libxdg-basedir-dev gcc \
  make autotools-dev pkg-config xdm cmus libxml2-dev libxcb-randr0 libxcb-ewmh-dev libstartup-notification0-dev \
  libxcb-icccm4-dev libxcb-keysyms1-dev geany-plugins polybar xorg xserver-xorg xbacklight gvfs udiskie \
  udisks fonts-recommended fonts-terminus papirus-icon-theme pavucontrol pulseaudio xbindkeys \
  gvfs-backends mtools acpid acpi xvkbd network-manager zip unzip avahi-daemon xinput \
  build-essential network-manager-gnome git curl wget  maim libnotify-bin xdotool \
  gtk2-engines gtk2-engines-murrine git gcc gettext automake autoconf autopoint libtool \
  libpango1.0-dev pkg-config libglib2.0-dev libxml2-dev libstartup-notification0-dev xorg-dev \
  libimlib2-dev build-essentials lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings \
 libpam0g-dev libcairo2-dev libfontconfig1-dev mpdris2 hseroot jq thefuck xclip \
 libxcb-composite0-dev libev-dev libx11-xcb-dev libxcb-xkb-dev libxcb-xinerama0-dev \
 libxcb-randr0-dev libxcb-image0-dev libxcb-util0-dev libxcb-xrm-dev libxkbcommon-dev \
 libxkbcommon-x11-dev libjpeg-dev

# Setup XDG user directories
xdg-user-dirs-update
xdg-user-dirs-gtk-update

# Create necessary configuration directories
mkdir -p ~/.config/bspwm ~/.config/sxhkd ~/.config/polybar ~/.config/dunst ~/.config/picom

# Copy example BSPWM and SXHKD configuration files
cp /usr/share/doc/bspwm/examples/bspwmrc ~/.config/bspwm/
cp /usr/share/doc/bspwm/examples/sxhkdrc ~/.config/sxhkd/
chmod u+x ~/.config/bspwm/bspwmrc

# Setup basic Polybar configuration
cat <<EOL > ~/.config/polybar/config
[bar/example]
width = 100%
height = 30
background = #222222
foreground = #aaaaaa

[module/bspwm]
type = internal/bspwm
ws-icon-0 = 1;
ws-icon-1 = 2;
ws-icon-2 = 3;
ws-icon-3 = 4;
EOL

# Create Polybar launch script
cat <<EOL > ~/.config/polybar/launch.sh
#!/usr/bin/env sh
killall -q polybar
while pgrep -x polybar >/dev/null; do sleep 1; done
polybar example &
EOL
chmod +x ~/.config/polybar/launch.sh

# Setup sxhkd keybindings
cat <<EOL >> ~/.config/sxhkd/sxhkdrc
# Custom keybindings
super + Return
    kitty

super + t
    alacritty

super + {1-9}
    bspc desktop -f ^{1-9}

super + ctrl + {Left, Right}
    bspc monitor -f {left,right}

super + shift + {1-9}
    bspc node -d ^{1-9}

super + f
    bspc node -t floating

super + p
    firefox

super + o
    nemo

super + q
    bspc node -c

super + shift + q
    bspc quit

super + space
    rofi -shwo drun -theme path/to/file.rasi

super + esc
    pkill -USR1 -x sxhkd

super + alt + e
    bspc wm -r
EOL

# Enable necessary services
sudo systemctl enable avahi-daemon
sudo systemctl enable acpid
sudo systemctl enable lightdm

# Clone and build Picom
git clone https://github.com/FT-Labs/picom ~/bookworm-scripts/picom
cd ~/bookworm-scripts/picom
meson setup --buildtype=release build
ninja -C build
sudo ninja -C build install

# Copy Picom config to ~/.config
cat <<EOL > ~/.config/picom/picom.conf
shadow-radius = 5;
shadow-offset-x = -5;
shadow-offset-y = -5;
shadow-opacity = 0.8;
fade-in-step = 0.07;
fade-out-step = 0.07;
EOL

# Clone and build Dunst
cd ~/Downloads
git clone https://github.com/dunst-project/dunst.git
cd dunst
make -j$(nproc)
sudo make install
cp /usr/share/dunst/dunstrc ~/.config/dunst/dunstrc


 git clone https://github.com/phisch/giph.git
 cd giph
 sudo make install

# Start necessary services and applications
pgrep -x sxhkd > /dev/null || sxhkd &
~/.config/polybar/launch.sh &
/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 &
dunst &
picom --animations -b &

# Finishing up
echo "Installation and configuration complete! Please reboot your system."
