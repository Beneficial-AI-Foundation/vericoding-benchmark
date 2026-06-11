from pathlib import Path
import jsonlines


def main() -> None:
    """Concatenate all JSONL files from jsonl/ directory into train.jsonl for HuggingFace."""
    # Define paths
    jsonl_dir = Path("..") / "jsonl"
    output_dir = Path("artifacts")
    output_dir.mkdir(exist_ok=True)

    train_file = output_dir / "train.jsonl"

    # Find all JSONL files
    jsonl_files = sorted(jsonl_dir.glob("*.jsonl"))

    if not jsonl_files:
        print(f"No JSONL files found in {jsonl_dir}")
        return

    print(f"Found {len(jsonl_files)} JSONL files to concatenate:")
    for f in jsonl_files:
        print(f"  - {f.name}")

    # Concatenate all JSONL files
    total_lines = 0
    with jsonlines.open(train_file, mode="w") as writer:
        for jsonl_file in jsonl_files:
            file_lines = 0
            with jsonlines.open(jsonl_file) as reader:
                for obj in reader:
                    writer.write(obj)
                    file_lines += 1
                    total_lines += 1

            print(f"  Processed {file_lines} lines from {jsonl_file.name}")

    print(f"\nTotal: {total_lines} lines written to {train_file}")
