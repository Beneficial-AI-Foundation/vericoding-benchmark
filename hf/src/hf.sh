#!/usr/bin/env sh

# Check if logged in to Hugging Face
if [[ $(huggingface-cli whoami) == "Not logged in" ]]; then
    echo "Not logged in to Hugging Face. Initiating login..."
    uv run huggingface-cli login
else
    echo "Already logged in to Hugging Face."
fi

# Check if login was successful
if [[ $(uv run huggingface-cli whoami) == "Not logged in" ]]; then
    echo "Login failed. Exiting script."
    exit 1
fi

# If we've reached here, we're logged in. Proceed with upload.
echo "Uploading to Hugging Face..."
uv run huggingface-cli upload beneficial-ai-foundation/vericoding ./artifacts . --repo-type dataset --create-pr

# Check if upload was successful
if [ $? -eq 0 ]; then
    echo "Upload completed successfully. Merge the PR on web to publish the dataset."
else
    echo "Upload failed. Please check your files and try again."
fi
