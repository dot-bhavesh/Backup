#!/usr/bin/env python3
import subprocess

ICON_MAP = {
    "alacritty": "󰆍",
    "kitty": "󰆍",
    "gnome-terminal": "󰆍",
    "firefox": "󰈹",
    "thunar": "󰉋",
    "geany": "󰅩",
    "code": "󰨞",
    "vlc": "󰕼",
    "discord": "󰙯",
}

DEFAULT_ICONS = [
    ("x-terminal-emulator &", "󰆍", "#f7a8b8"),
    ("firefox &", "󰈹", "#fab387"),
    ("thunar &", "󰉋", "#a6e3a1"),
]

FOCUSED_COLOR = "#b4befe"
UNFOCUSED_COLOR = "#565869"

active_id = None
try:
    active_id_raw = subprocess.check_output(["xdotool", "getactivewindow"], stderr=subprocess.DEVNULL).decode("utf-8").strip()
    if active_id_raw.isdigit() or active_id_raw.startswith("0x"):
        active_id = hex(int(active_id_raw, 0))
except Exception:
    active_id = None

windows = []
try:
    output = subprocess.check_output(["wmctrl", "-l"], stderr=subprocess.DEVNULL).decode("utf-8")
    windows = [w for w in output.strip().split("\n") if w]
except Exception:
    windows = []

taskbar_items = []

if windows:
    for win in windows:
        parts = win.split()
        if not parts:
            continue
        win_id = parts[0]
        try:
            cls_out = subprocess.check_output(["xprop", "-id", win_id, "WM_CLASS"], stderr=subprocess.DEVNULL).decode("utf-8")
            win_cls = cls_out.split("=")[-1].strip().split(",")[-1].replace('"', '').strip().lower()
            icon = ICON_MAP.get(win_cls, "󰣆")
            is_focused = active_id and (int(win_id, 16) == int(active_id, 16))

            color = FOCUSED_COLOR if is_focused else UNFOCUSED_COLOR
            
            # Correct Polybar action syntax with closing colon ':'
            item = "%{A1:wmctrl -i -a " + win_id + ":} " + f"%{{F{color}}}" + icon + "%{F-} %{A}"
            taskbar_items.append(item)
        except Exception:
            pass

if not taskbar_items:
    for cmd, icon, color in DEFAULT_ICONS:
        item = "%{A1:" + cmd + ":} " + f"%{{F{color}}}" + icon + "%{F-} %{A}"
        taskbar_items.append(item)

print(" ".join(taskbar_items))
