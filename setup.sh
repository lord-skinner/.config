#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Function to print messages
print_message() {
    echo "===> $1"
}

# Update and install packages
print_message "Updating and installing packages..."
sudo apt update && sudo apt upgrade -y
sudo apt install -y python3-pip git wget gpg apt-transport-https gh kubernetes fprintd libpam-fprintd curl unzip tar gnupg software-properties-common

# Install fonts
print_message "Installing fonts..."
sudo mkdir -p ~/.local/share/fonts/SourceCodePro
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/SourceCodePro.zip
sudo unzip SourceCodePro.zip -d ~/.local/share/fonts/SourceCodePro
fc-cache -fv
rm SourceCodePro.zip

# Install starship
print_message "Installing starship..."
curl -sS https://starship.rs/install.sh | sh -s -- -y
echo 'eval "$(starship init bash)"' >> ~/.bashrc

# Setup repositories
print_message "Setting up repositories..."
# Warp
wget -qO- https://releases.warp.dev/linux/keys/warp.asc | sudo gpg --dearmor -o /etc/apt/keyrings/warpdotdev.gpg
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/warpdotdev.gpg] https://releases.warp.dev/linux/deb stable main" | sudo tee /etc/apt/sources.list.d/warpdotdev.list > /dev/null

# VS Code
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | sudo gpg --dearmor -o /etc/apt/keyrings/packages.microsoft.gpg
echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null

# Chrome
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo tee /etc/apt/trusted.gpg.d/google.asc > /dev/null
echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google.list > /dev/null

# Hashicorp
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"

# Docker
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install additional software
print_message "Installing additional software..."
sudo apt update
sudo apt install -y warp-terminal code google-chrome-stable terraform docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Set warp as default terminal
mkdir -p ~/.config && touch ~/.config/starship.toml
sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /usr/bin/warp-terminal 100

# Install minikube
print_message "Installing minikube..."
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
rm minikube-linux-amd64

# Remove Firefox
print_message "Removing Firefox..."
sudo apt remove -y firefox
sudo apt purge -y firefox
rm -rf ~/.mozilla/firefox/ ~/.cache/mozilla/firefox/
sudo apt autoremove -y

# Install gcloud SDK
print_message "Installing gcloud SDK..."
GCLOUD_VERSION="438.0.0"
wget https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-${GCLOUD_VERSION}-linux-x86_64.tar.gz
tar -xf google-cloud-cli-${GCLOUD_VERSION}-linux-x86_64.tar.gz
./google-cloud-sdk/install.sh --usage-reporting=false --path-update=true --quiet
echo 'export PATH=$PATH:$HOME/google-cloud-sdk/bin' >> $HOME/.profile

# Install Golang
print_message "Installing Golang..."
GO_VERSION="1.20.5"
wget https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz
echo 'export PATH=$PATH:/usr/local/go/bin' >> $HOME/.profile

# Install Rust
print_message "Installing Rust..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source $HOME/.cargo/env

# Clean up
print_message "Cleaning up..."
rm google-cloud-cli-${GCLOUD_VERSION}-linux-amd64.tar.gz go${GO_VERSION}.linux-amd64.tar.gz

# Verify installations
print_message "Verifying installations..."
source $HOME/.profile
gcloud --version
go version
rustc --version
cargo --version

cleanup() {
    print_message "Cleaning up..."
    rm -f google-cloud-cli-${GCLOUD_VERSION}-linux-x86_64.tar.gz
    rm -f go${GO_VERSION}.linux-amd64.tar.gz
    rm -f minikube-linux-amd64
    rm -f SourceCodePro.zip
    rm -rf ~/.cache/google-cloud-sdk
    sudo apt clean
    sudo apt autoremove -y
}

# Verify installations
print_message "Verifying installations..."
source $HOME/.profile
gcloud --version
go version
rustc --version
cargo --version

# Run cleanup
cleanup

print_message "Installation complete!"
