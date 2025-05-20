import json
import os
from pathlib import Path

p = Path(__file__).parents[0]

def transform_json_to_tid(input_file, output_file):
    # Load the original JSON
    with open(input_file, 'r', encoding='utf-8') as f:
        data = json.load(f)

    # Create the nested "TID" structure
    tid_data = {
        key: {
            "ID": key,
            "en": value
        }
        for key, value in data.items()
    }

    wrapped_data = {"TID": tid_data}

    # Write the result to the output file
    with open(output_file, 'w', encoding='utf-8') as f:
        json.dump(wrapped_data, f, indent=4, ensure_ascii=False)

    print(f"Transformed JSON saved to '{output_file}'")

# Example usage
if __name__ == "__main__":
    transform_json_to_tid(os.path.join(p, "fr.json"), os.path.join(p ,"army_config_fr.json"))
