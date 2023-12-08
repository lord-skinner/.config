# nerd font for starship
cp SauceCodeProNerdFont-SemiBold.ttf /usr/share/fonts/
rm SauceCodeProNerdFont-SemiBold.ttf
# Refresh the font cache
sudo fc-cache -f -v

# starship setup
mkdir -p ~/.config
cp ./starship.toml ~/.config/starship.toml
