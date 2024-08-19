
#!/bin/bash

# Install required packages
echo "Installing required packages..."
sudo apt-get update
sudo apt-get install -y i3 i3blocks i3status i3lock nemo geany geany-plugins \
                        sxhkd suckless-tools rofi acpi acpid avahi-daemon \
                        polybar xorg xserver-xorg xbacklight xbindkeys \
                        xvkbd xinput build-essential git policykit-1-gnome \
                        network-manager network-manager-gnome file-roller \
                        lxappearance dialog mtools dosfstools avahi-daemon \
                        acpi acpid gvfs-backends gvfs scrot yad zenity \
                        pulseaudio pavucontrol pamixer pulsemixer feh \
                        fonts-recommended fonts-font-awesome fonts-terminus \
                        papirus-icon-theme exa scrot rofi dunst maim \
                        libnotify-bin unzip libnotify-dev udiskie udisks2 ffmpeg

# Enable necessary services
echo "Enabling necessary services..."
sudo systemctl enable avahi-daemon
sudo systemctl enable acpid
sudo systemctl enable xdg-user-dirs
sudo systemctl enable xdg-user-dirs-gtk
xdg-user-dirs-gtk-update
xdg-user-dirs-update

# Check if the repository is already cloned
REPO_DIR="$HOME/your-repo"
if [ ! -d "$REPO_DIR" ]; then
  echo "Cloning your GitHub repository..."
  git clone https://github.com/l1nux-th1ngz/3.git "$REPO_DIR"
else
  echo "Repository already cloned at $REPO_DIR"
fi

# Copy configuration files
echo "Copying configuration files..."
\cp -r "$REPO_DIR/i3/.config/" ~/.config/
\cp -r "$REPO_DIR/i3blocks/" ~/.config/
\cp -r "$REPO_DIR/i3status/" ~/.config/
\cp -r "$REPO_DIR/polybar/" ~/.config/
\cp -r "$REPO_DIR/rofi/" ~/.config/

echo "Setup complete."
