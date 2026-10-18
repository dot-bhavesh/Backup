#!/usr/bin/env python3
import subprocess
import json
import sys

# Configuration
PINK = "%{F#b4befe}"
DIM = "%{F#565869}"
RESET = "%{F-}"
OFFSET = "%{O8px}"
FILLED = ""
EMPTY = ""
NO_WINDOW = ""  # New icon for empty workspaces

def get_workspace_states():
    """Returns a tuple of (active_workspace_num, set_of_occupied_workspace_nums)"""
    try:
        output = subprocess.check_output(['i3-msg', '-t', 'get_workspaces']).decode('utf-8')
        workspaces = json.loads(output)
        
        active = 1
        occupied = set()
        
        for ws in workspaces:
            occupied.add(ws['num'])
            if ws['focused']:
                active = ws['num']
                
        return active, occupied
    except Exception:
        return 1, {1}

def print_bar():
    active, occupied = get_workspace_states()
    bar_output = []

    # Build the 4-dot layout
    for i in range(1, 5):
        # Determine color and icon based on state
        if i == active:
            # Active workspace always gets the filled pink dot
            icon = f"{PINK}{FILLED}{RESET}"
        elif i in occupied:
            # Unfocused but has windows on it
            icon = f"{DIM}{EMPTY}{RESET}"
        else:
            # Completely empty workspace (no windows)
            icon = f"{DIM}{NO_WINDOW}{RESET}"

        # Wrap in a click action
        segment = f"%{{A1:i3-msg workspace {i}:}}{icon}%{{A}}"
        bar_output.append(segment)

    # Join with the pixel offset and print immediately
    print(OFFSET.join(bar_output), flush=True)

# 1. Print the initial state immediately on startup
print_bar()

# 2. Listen for i3 events continuously to update live
proc = subprocess.Popen(['i3-msg', '-t', 'subscribe', '-m', '["workspace"]'], stdout=subprocess.PIPE)
while True:
    line = proc.stdout.readline()
    if not line:
        break
    print_bar()

