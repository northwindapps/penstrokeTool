import json
import os


# Replace 'data.json' with the path to your JSON file
file_path = '/Users/yano/Documents/penstrokeTool/data/train/source.json'
# Define the output file path
output_file_path = '/Users/yano/Documents/penstrokeTool/data/train/additional.jsonl'

# Ensure the directory exists
os.makedirs(os.path.dirname(file_path), exist_ok=True)


# Open and load the JSON file
with open(file_path, 'r') as file:
    array = json.load(file)
    


with open(output_file_path, 'w') as outfile:
    for item in array:
        # Write each item as a new line in the output file
        json_line = json.dumps(item)
        outfile.write(json_line + '\n')
    # print(json_string)