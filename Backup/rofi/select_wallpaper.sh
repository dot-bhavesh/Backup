#!/bin/bash
WALLPAPER_DIR="/home/bhavesh/Desktop/Everything/Wallpaper"

# Move into the wallpaper directory to process files cleanly
cd "$WALLPAPER_DIR" || exit 1

# Feed Rofi a formatted list containing filenames and their respective image paths as thumbnails
SELECTION=$(for img in *.{jpg,jpeg,png,webp,gif}; do
    [ -f "$img" ] && echo -en "$img\0icon\x1f$WALLPAPER_DIR/$img\n"
done | rofi -dmenu -i -p "Search wallpapers..." \
    -theme-str '
        window {
            width: 780px;
            border-radius: 12px;
            background-color: #111625e6;
        }
        mainbox {
            padding: 20px;
            spacing: 16px;
            orientation: vertical;
            children: [ "inputbar", "listview" ];
        }
        inputbar {
            background-color: #1a223899;
            border: 1px;
            border-color: #536b9e;
            border-radius: 8px;
            padding: 8px 12px;
            children: [ "entry" ];
        }
        entry {
            text-color: #a9c0e4;
            placeholder: "Search wallpapers...";
            placeholder-color: #5d7199;
            vertical-align: 0.5;
        }
        listview {
            columns: 3;
            lines: 1;
            spacing: 16px;
            fixed-height: true;
            fixed-columns: true;
        }
        element {
            orientation: vertical;
            padding: 12px;
            border: 1px;
            border-color: #536b9e;
            border-radius: 8px;
            background-color: #1a223840;
        }
        element selected.normal {
            background-color: #2d3a5e80;
            border-color: #8da1ce;
        }
        element-icon {
            size: 130px;
            horizontal-align: 0.5;
            margin: 0px 0px 10px 0px;
        }
        element-text {
            horizontal-align: 0.5;
            vertical-align: 0.5;
            padding: 6px;
            border: 1px;
            border-color: #536b9e;
            border-radius: 6px;
            background-color: #11162580;
            text-color: #a9c0e4;
        }
    ')

# Set wallpaper if a selection was made
if [ -n "$SELECTION" ]; then
    feh --bg-fill "$WALLPAPER_DIR/$SELECTION"
fi