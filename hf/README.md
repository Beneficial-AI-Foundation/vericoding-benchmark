# HuggingFace utils

Contains:

```sh
uv run concat-jsonl
uv run solve-lean
./hf/src/hf.sh
```

`concat-jsonl` just concatenates `./jsonl/*.jsonl` into `./hf/artifacts/train.jsonl`. Only needs to be run once.

`solve-lean` doesn't really need to be run at all, and requires an anthropic API key. It mainly exists to test what I wanted to put in the dataset card.

`./hf/src/hf.sh` requires a way to log into huggingface to an account affiliated with the `beneficial-ai-foundation` org.
