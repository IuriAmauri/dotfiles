#!/usr/bin/env python3
import subprocess
import json

def get_media_info():
    try:
        status = subprocess.check_output(["playerctl", "status"], stderr=subprocess.DEVNULL).decode("utf-8").strip()
        metadata = subprocess.check_output(["playerctl", "metadata", "--format", "{{artist}} - {{title}}"], stderr=subprocess.DEVNULL).decode("utf-8").strip()

        if not metadata or metadata == " - ":
            metadata = "Unknown Source"

        display_text = (metadata[:100] + '..') if len(metadata) > 100 else metadata
        
        return {
            "text": display_text,
            "tooltip": metadata,
            "class": status.lower(),
            "alt": status
        }
    except Exception:
        return None

if __name__ == "__main__":
    data = get_media_info()
    if data:
        print(json.dumps(data))
    else:
        print("")
