#!/usr/bin/env python
"""Google Keep export to Simplenote import script.

Converts Google Keep Takeout archive into a Simplenote-compatible .json file
for direct import into Simplenote.

https://gist.githubusercontent.com/echus/ce7cd43ec18edaad8105ca37349af41b/raw/81bea94c696ea1bfc7d0c2326c67219efdce1767/keep_to_simplenote.py
"""

import json
import os
import glob
import uuid
from datetime import datetime, timezone

KEEP_PATH = "../dont_include/Keep"

def convert_timestamp(timestamp):
    # Convert Keep timestamp in epoch microseconds to ISO format
    return (
        datetime.fromtimestamp(timestamp // 1000000, tz=timezone.utc)
        .replace(microsecond=timestamp % 1000000)
        .isoformat(timespec="milliseconds")
        .replace("+00:00", "Z")
    )


# Simplenote-formatted JSON dict
data = []

# Iterate over all .json note files in KEEP_PATH
files = glob.glob(os.path.join(KEEP_PATH, "*.json"))
print("Processing", len(files), "notes.")

def note2content(note):
    """Convert a Google Keep note to Simplenote content format."""
    content = ""
    if "textContent" in note.keys():
        if note["textContent"].startswith("#Recepty"):
            content += note["textContent"].split("\n", 1)[1]
        else:
            content += note["textContent"]

    elif "listContent" in note.keys():
        for item in note["listContent"]:
            if item["isChecked"]:
                content = content + "- [x] " + item["text"] + "\r\n"
            else:
                content = content + "- [ ] " + item["text"] + "\r\n"
    return content

for filename in files:
    
    with open(filename, "r") as f:
        keep = json.load(f)

    if keep.get("isPinned", False):
        continue

    # Populate labels
    labels = [label["name"] for label in keep.get("labels", [])]

    if 'Recepty' not in labels:
        continue

    # Convert text and list content
    content = note2content(keep)

    # Convert timestamps
    created = convert_timestamp(keep["createdTimestampUsec"])
    updated = convert_timestamp(keep["userEditedTimestampUsec"])

    data.append(
        {
            "id": str(uuid.uuid4()),
            "title": keep["title"],
            "content": content,
            "creationDate": created,
            "lastModified": updated,
            "tags": labels,
        }
    )

with open("./keep.json", "w") as f:
    json.dump(data, f)

print("Finished! Generated keep.json for import into Simplenote.")