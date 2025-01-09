import json
import os

# Replace 'data.json' with the path to your JSONL file
file_path = '/Users/yano/Documents/penstrokeTool/data/train/additional.jsonl'
# Define the output file path
output_file_path = '/Users/yano/Documents/penstrokeTool/data/train/no_vh.jsonl'

# Ensure the output directory exists
os.makedirs(os.path.dirname(output_file_path), exist_ok=True)

# Open and load the JSONL file
array = []
with open(file_path, 'r') as file:
    for line in file:
        # Check if line does not contain "v" or "h"
        try:
            data = json.loads(line)  # Parse JSON
            # if data["sampleTag"] == "bs":
            if data["sampleTag"] != "bs" and data["sampleTag"] != "h" and data["sampleTag"] != "v":
             array.append(data)
        except json.JSONDecodeError as e:
            print(f"Error decoding JSON: {e}")

# Write to the output JSONL file
with open(output_file_path, 'w') as outfile:
    for item in array:
        outfile.write(json.dumps(item) + '\n')  # Write each object as a JSON line
        print(item)  # Optional: print for debugging
