import json
import os
from datasets import load_dataset, Dataset, DatasetDict, Features, Value, Image

# Function to load the metadata for a specific split (train/validation/test)
# def load_dataset(split):
#     dataset_path = f"./data/{split}/metadata.jsonl"
    
#     def gen():
#         # Get the directory of the metadata file to load images from the same location
#         dataset_dir = os.path.dirname(dataset_path)
        
#         with open(dataset_path) as f:
#             for idx, l in enumerate(f):
#                 line = json.loads(l)  # Parse each JSONL line
                
#                 ground_truth = json.loads(line["ground_truth"])  # Parse the nested JSON string in 'ground_truth'
                
#                 # Get the full image path by combining the dataset directory with the file name
#                 image_path = os.path.join(dataset_dir, line["file_name"])
#                 print(image_path)
#                 # Yield the data with necessary fields, including the image path
#                 yield {
#                     # "file_name": line["file_name"],  # Image file name
#                     "image": image_path,  # Full image path
#                     "ground_truth": json.dumps(ground_truth)  # Parsed ground_truth
#                 }

#     features = Features({
#         # "file_name": Value("string"),  # File name (string)
#         "image": Image(),  # Image loaded from the file path
#         "ground_truth": Value("string")  # The 'ground_truth' is a parsed JSON object
#     })

#     # Load the dataset using the generator
#     return Dataset.from_generator(gen, features=features)

# Load the splits: train, validation, and test
# train_dataset = load_dataset("train")
# validation_dataset = load_dataset("validation")
# test_dataset = load_dataset("test")

test_dataset = load_dataset("json", data_files="./data/test/test.jsonl")["train"]
train_dataset = load_dataset("json", data_files="./data/train/train.jsonl")["train"]
validation_dataset = load_dataset("json", data_files="./data/validation/validation.jsonl")["train"]

# Create a DatasetDict to hold all splits
dataset_dict = DatasetDict({
    "train": train_dataset,
    "validation": validation_dataset,
    "test": test_dataset
})

# Push the dataset to the Hugging Face Hub
# newbienewbie/handwriting_strokes_2strokes
dataset_dict.push_to_hub("newbienewbie/handwriting_edge_case_in_one_stroke")
