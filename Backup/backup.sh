#!/usr/bin/env bash

CONFIG_DIR="$HOME/.config/rofi"
CONFIG_FILE="$CONFIG_DIR/config.rasi"
BACKUP_FILE="$CONFIG_DIR/config.rasi.bak"
#local font directory path
FONT_DIR="$HOME/.local/share/fonts"
POLY_DIR="$HOME/.config/polybar"

#-------rofi-Installation--------
install_rofi() {
  if ! command -v rofi &>/dev/null; then
    echo "Rofi is not installed. Installing..."
    sudo apt install rofi -y
  else
    echo "Rofi is already installed."
  fi

  mkdir -p "$CONFIG_DIR"
  if [ -f "$CONFIG_FILE" ]; then
    echo "Backing up existing config..."
    cp "$CONFIG_FILE" "$BACKUP_FILE"
  fi
  echo "Swaping current config with new Rofi configuration..."
  cp -r "$HOME/Downloads/Backup/rofi/"* "$CONFIG_DIR"
  if ls "$CONFIG_DIR/"*.sh &>/dev/null; then
    echo "Making Rofi scripts executable..."
    chmod +x "$CONFIG_DIR/"*.sh
  fi

  echo "Done !!"
}

#-------polybar-Installation--------
install_polybar() {
  echo "Starting Polybar Setup..."
  if ! command -v polybar &>/dev/null; then
    sudo apt install polybar -y
  fi

  # FIXED: Safely backs up your entire active polybar folder structure
  if [ -f "$POLY_DIR/config.ini" ]; then
    echo "Backing up existing config directory..."
    cp -r "$POLY_DIR" "${POLY_DIR}.bak"
  fi

  mkdir -p "$POLY_DIR"
  echo "Swapping Polybar configuration..."
  # FIXED: Copies layout contents directly into your clean active Polybar folder
  cp -r "$HOME/Downloads/Backup/polybar/"* "$POLY_DIR/"

  if [ -f "$POLY_DIR/launch.sh" ]; then
    echo "Making launch.sh executable..."
    chmod +x "$POLY_DIR/launch.sh"
  fi
}

#-------Fonts-Installation--------
install_fonts() {
  #Create the folder if it doesn't exist
  mkdir -p "$FONT_DIR"

  echo "Installing fonts for the current user..."
  cp -r ~/"Downloads/Backup/fonts/"* "$FONT_DIR/"

  echo "Updating font cache..."
  #Refresh the font cache
  fc-cache -f
}

echo "====================================="
echo "   Dotfiles Installation Menu"
echo "====================================="
echo "1) Install Rofi Setup Only"
echo "2) Install Polybar Setup Only"
echo "3) Install Both Rofi & Polybar"
echo "====================================="
#user_input
read -p "Enter your choice (1-3): " USER_CHOICE

case "$USER_CHOICE" in
1)
  install_rofi
  install_fonts
  ;;
2)
  install_polybar
  install_fonts
  ;;
3)
  install_rofi
  install_polybar
  install_fonts
  ;;
*)
  echo "Invalid selection. Aborting script."
  exit 1
  ;;
esac

echo "All requested setups completed successfully!"
