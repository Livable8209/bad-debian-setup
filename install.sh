#!/bin/bash
if [ "$(id -u)" != 0 ]; then
   echo "sudo perms are required to edit and restart logind, exiting..."
   sudo "$0" "$@"
   exit1
fi


echo "sudo perms got, running."

# Laptop Config
echo "pushing laptop config into logind"
printf "HandleSuspendKey=ignore\nHandleLidSwitch=ignore\nHandleLidSwitchDocked=ignore\n" >> /dev/null # /etc/systemd/logind.conf 

echo "restarting logind"
systemctl restart systemd-logind

# Update stuff
echo "updating apt sources and installing updates"
apt -y update
apt -y upgrade

# Install dependencies lol
apt -y install build-essential gpg micro neofetch curl

# Install eza
sudo mkdir -p /etc/apt/keyrings
wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
sudo apt update
sudo apt install -y eza

# make alias file and push aliases into file
echo 'pushing aliases'
printf "alias ls='eza'\nalias ll='eza -la'\nexport EDITOR='micro'\nneofetch\n" >> .bash_aliases

# install rust and bore
echo 'installing rust and bore'
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# shellcheck disable=SC1091
source "$HOME/.cargo/env"
cargo install bore-cli
