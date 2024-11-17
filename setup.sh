#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Function to print messages
print_message() {
    echo "===> $1"
}

sudo apt upgrade && sudo apt update -y
sudo apt install -y \
    python3-pip \
    git \
    wget \
    gpg \
    apt-transport-https \
    gh \
    kubernetes \
    fprintd \
    libpam-fprintd \
    curl \
    unzip \
    tar

# install fonts
sudo mkdir -p ~/.local/share/fonts/SourceCodePro
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/SourceCodePro.zip
sudo unzip ~/SourceCodePro.zip -d ~/.local/share/fonts/SourceCodePro
fc-cache -fv
rm ~/SourceCodePro.zip

# starship
curl -sS https://starship.rs/install.sh | sh
echo 'eval "$(starship init bash)"' >> ~/.bashrc

# setup warp terminal
wget -qO- https://releases.warp.dev/linux/keys/warp.asc | gpg --dearmor > warpdotdev.gpg
sudo install -D -o root -g root -m 644 warpdotdev.gpg /etc/apt/keyrings/warpdotdev.gpg
sudo sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/warpdotdev.gpg] https://releases.warp.dev/linux/deb stable main" > /etc/apt/sources.list.d/warpdotdev.list'
rm warpdotdev.gpg

# setup vs code
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" |sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
rm -f packages.microsoft.gpg

# chrome
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo tee /etc/apt/trusted.gpg.d/google.asc >/dev/null
sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'

sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"

# install warp & code
sudo apt update -y
sudo apt install -y \
    warp-terminal \
    code \
    google-chrome-stable \
    terraform

# set warp as default
mkdir -p ~/.config && touch ~/.config/starship.toml
sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /usr/bin/warp-terminal 100

# minikube
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube && rm minikube-linux-amd64

# rm firefox
sudo apt remove firefox
sudo apt purge firefox
rm -rf ~/.mozilla/firefox/
rm -rf ~/.cache/mozilla/firefox/
sudo apt autoremove

sudo apt update && sudo apt install fprintd libpam-fprintd
fprintd-enroll

sudo pam-auth-update

# Install gcloud SDK
print_message "Installing gcloud SDK..."
GCLOUD_VERSION="438.0.0"  # Update this to the latest version
wget https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-${GCLOUD_VERSION}-linux-x86_64.tar.gz
tar -xf google-cloud-cli-${GCLOUD_VERSION}-linux-x86_64.tar.gz
./google-cloud-sdk/install.sh --usage-reporting=false --path-update=true --quiet
export PATH=$PATH:$HOME/google-cloud-sdk/bin

# Install Golang
print_message "Installing Golang..."
GO_VERSION="1.20.5"  # Update this to the latest version
wget https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz
echo 'export PATH=$PATH:/usr/local/go/bin' >> $HOME/.profile
source $HOME/.profile

# Install Rust
print_message "Installing Rust..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source $HOME/.cargo/env

# Verify installations
print_message "Verifying installations..."
gcloud --version
go version
rustc --version
cargo --version

# Clean up
print_message "Cleaning up..."
rm google-cloud-cli-${GCLOUD_VERSION}-linux-amd64.tar.gz
rm go${GO_VERSION}.linux-amd64.tar.gz

print_message "Installation complete!"