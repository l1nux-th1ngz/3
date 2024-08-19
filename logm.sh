#!/bin/bash

# Function to check if a user exists
user_exists() {
  id "$1" &>/dev/null
}

# Get the current logged-in user
CURRENT_USER=$(whoami)

# Update the package list
sudo apt-get update

# Install LightDM and greeters
sudo apt-get -y install lightdm lightdm-gtk-greeter slick-greeter

# Set Slick Greeter as the default greeter
sudo bash -c 'echo "[Seat:*]" > /etc/lightdm/lightdm.conf'
sudo bash -c 'echo "greeter-session=slick-greeter" >> /etc/lightdm/lightdm.conf'

# Restart LightDM to apply changes
sudo systemctl restart lightdm

# Ensure the current user exists and create if not
if ! user_exists "$CURRENT_USER"; then
  echo "User $CURRENT_USER does not exist. Creating the user..."
  sudo adduser --disabled-password --gecos "" "$CURRENT_USER"
fi
