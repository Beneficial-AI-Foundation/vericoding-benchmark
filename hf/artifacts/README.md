---
license: mit
task_categories:
- text-generation
tags:
- code
- agent
pretty_name: Vericoding
size_categories:
- 1K<n<10K
---
# Vericoding

[A benchmark for vericoding: formally verified program synthesis](https://arxiv.org/abs/2509.22908)

Sergiu Bursuc, Theodore Ehrenborg, Shaowei Lin, Lacramioara Astefanoaei, Ionel Emilian Chiosa, Jure Kukovec, Alok Singh, Oliver Butterley, Adem Bizid, Quinn Dougherty, Miranda Zhao, Max Tan, Max Tegmark 

> We present and test the largest benchmark for vericoding, LLM-generation of formally verified code from formal specifications - in contrast to vibe coding, which generates potentially buggy code from a natural language description. Our benchmark contains 12,504 formal specifications, with 3,029 in Dafny, 2,334 in Verus/Rust and 7,141 in Lean. Of these, 6,174 are new unseen problems. We find vericoding success rates of 27% in Lean, 44% in Verus/Rust and 82% in Dafny using off-the-shelf LLMs. Adding natural-language descriptions does not significantly improve performance. We also find that LLM progress has improved progress on pure Dafny verification from 68% to 96% over the past year. The benchmark and vericoding results are shared at this [https URL](https://github.com/Beneficial-AI-Foundation/vericoding-benchmark)

## Usage:

Edit the escape characters out of the triple backticks in the prompt (which are there so they don't mess up the markdown in this card) and put this in `scrpt.py` and then run `uv run scrpt.py` (must preserve frontmatter comment / pyproject.toml fragment). Requires anthropic API key. 

``` python
# /// script
# requires-python = ">=3.12"
# dependencies = [
#     "datasets>=4.2.0",
#     "pydantic>=2.12.3",
#     "pydantic-ai>=1.2.1",
#     "python-dotenv>=1.1.1",
# ]
# ///
"""
Download the vericoding dataset from HuggingFace and use pydantic-ai to solve a Lean sample.
"""

from pathlib import Path
from datasets import load_dataset
from pydantic import BaseModel
from pydantic_ai import Agent
from pydantic_ai.models.anthropic import AnthropicModel
from pydantic_ai.mcp import MCPServerStdio
from dotenv import load_dotenv
import random
import os

# Load environment variables from .env file
load_dotenv()


class LeanSolution(BaseModel):
    """Structured output for a Lean verification problem solution."""

    code: str
    explanation: str
    verification_status: str


def download_dataset(
    dataset_name: str = "beneficial-ai-foundation/vericoding",
) -> list[dict]:
    """
    Download the vericoding dataset from HuggingFace.

    Args:
        dataset_name: The HuggingFace dataset identifier

    Returns:
        List of dataset samples
    """
    print(f"Downloading dataset: {dataset_name}")
    dataset = load_dataset(dataset_name, split="train")
    print(f"Downloaded {len(dataset)} samples")
    return list(dataset)


def filter_lean_samples(samples: list[dict]) -> list[dict]:
    """Filter for Lean language samples only."""
    lean_samples = [s for s in samples if s.get("language") == "lean"]
    print(f"Found {len(lean_samples)} Lean samples")
    return lean_samples


async def create_lean_agent(
    model_name: str = "claude-sonnet-4-5-20250929",
) -> tuple[Agent, MCPServerStdio]:
    """
    Create a pydantic-ai agent configured for solving Lean verification problems.

    Args:
        model_name: The model to use (default: claude-sonnet-4-5-20250929)

    Returns:
        Tuple of (Configured pydantic-ai Agent, MCP server)
    """
    model = AnthropicModel(model_name)

    # Initialize Lean LSP MCP server
    mcp_server = MCPServerStdio(
        command="uvx", args=["lean-lsp-mcp"], cwd=Path(__file__).parent
    )

    agent = Agent(
        model=model,
        output_type=LeanSolution,
        system_prompt="""You are an expert in Lean theorem proving and formal verification.

Your task is to solve verification problems by filling in `sorry` placeholders in Lean code.

When given a problem, you should:
1. Carefully analyze the problem description
2. Understand the preamble definitions, helper functions, and specifications
3. Fill in the sorries with correct Lean code that implements the specification
4. Use the Lean LSP tools available to verify your code
5. Explain your reasoning

You have access to Lean LSP tools via MCP server. Use them to:
- Check syntax and type correctness
- Verify proofs
- Get feedback on your implementation

You must return a structured response with exactly these fields:
- code: The complete Lean implementation with all sorries filled in
- explanation: Your reasoning and approach
- verification_status: Your confidence in the solution (high/medium/low)
""",
        mcp_servers=[mcp_server],
    )

    return agent, mcp_server


def format_lean_problem(sample: dict) -> tuple[str, str]:
    """
    Format a Lean sample into a prompt for the agent.

    Args:
        sample: A dataset sample containing Lean verification problem

    Returns:
        Tuple of (description prompt, code with sorries to fill in)
    """
    problem_id = sample.get("id", "unknown")
    description = sample.get("vc-description", "")
    preamble = sample.get("vc-preamble", "")
    spec = sample.get("vc-spec", "")
    helpers = sample.get("vc-helpers", "")
    postamble = sample.get("vc-postamble", "")

    # Concatenate all code sections with sorries
    code_with_sorries = f"""{preamble}

{helpers}

{spec}
  sorry

{postamble}""".strip()

    # Create description prompt
    description_prompt = f"""Problem ID: {problem_id}

Problem Description:
{description}

Your task is to fill in the `sorry` placeholders in the Lean code below to complete the implementation.
The code includes:
- Type definitions and predicates (preamble)
- Helper functions (if any)
- The main specification you need to implement
- Any postamble code

Please provide:
1. The complete Lean code with all sorries filled in
2. An explanation of your approach and reasoning
3. Your confidence level in the solution (high/medium/low)"""

    return description_prompt, code_with_sorries


async def solve_lean_problem(agent: Agent, sample: dict) -> LeanSolution:
    """
    Use the pydantic-ai agent to solve a Lean verification problem.

    Args:
        agent: The configured pydantic-ai agent
        sample: A Lean verification problem sample

    Returns:
        LeanSolution with code, explanation, and verification status
    """
    description_prompt, code_with_sorries = format_lean_problem(sample)

    print(f"\nSolving problem {sample.get('id', 'unknown')}...")
    print(f"Description: {sample.get('vc-description', '')[:100]}...")

    # Combine description and code in the prompt
    full_prompt = f"""{description_prompt}

Here is the Lean code with sorries to fill in:

\```lean
{code_with_sorries}
\```

Please analyze the code and provide your solution."""

    result = await agent.run(full_prompt, message_history=None)

    # The agent returns a result with .output property containing the LeanSolution
    return result.output


def write_solution_to_file(sample_id: str, solution: LeanSolution) -> Path:
    """
    Write a solution to solutions/<sample-id>/Solution.lean

    Args:
        sample_id: The problem ID
        solution: The LeanSolution to write

    Returns:
        Path to the written file
    """
    # Create solutions directory structure
    solutions_dir = Path(__file__).parent.parent.parent / "solutions" / sample_id
    solutions_dir.mkdir(parents=True, exist_ok=True)

    # Write solution to Solution.lean
    solution_path = solutions_dir / "Solution.lean"
    solution_path.write_text(solution.code)

    print(f"  → Saved solution to {solution_path}")
    return solution_path


def main():
    """Main execution function."""
    import asyncio

    async def run():
        # Check for API key
        if not os.getenv("ANTHROPIC_API_KEY"):
            print("Error: ANTHROPIC_API_KEY environment variable not set")
            print("Please set it with: export ANTHROPIC_API_KEY=your_key_here")
            return

        # Download dataset
        samples = download_dataset()

        # Filter for Lean samples
        lean_samples = filter_lean_samples(samples)

        if not lean_samples:
            print("No Lean samples found in dataset!")
            return

        # Group samples by source
        sources = ["fvapps", "numpy_triple", "dafnybench"]
        samples_by_source = {
            source: [s for s in lean_samples if s.get("source") == source]
            for source in sources
        }

        # Try to pick one sample from each source, fall back to any lean samples if not available
        selected_samples = []
        for source in sources:
            if samples_by_source[source]:
                selected_samples.append(random.choice(samples_by_source[source]))

        # If we don't have 3 samples yet, fill with random samples
        while len(selected_samples) < 3 and len(lean_samples) > len(selected_samples):
            sample = random.choice(lean_samples)
            if sample not in selected_samples:
                selected_samples.append(sample)

        print(f"\nSelected {len(selected_samples)} samples:")
        for sample in selected_samples:
            print(
                f"  - {sample.get('id', 'unknown')} (source: {sample.get('source', 'unknown')})"
            )

        # Create agent with MCP server
        print("\nInitializing Lean LSP MCP server...")
        agent, mcp_server = await create_lean_agent()

        # Use the MCP server as a context manager
        async with mcp_server:
            # Solve each problem
            for i, sample in enumerate(selected_samples, 1):
                print(f"\n{'=' * 80}")
                print(
                    f"PROBLEM {i}/{len(selected_samples)}: {sample.get('id', 'unknown')}"
                )
                print(f"{'=' * 80}")

                solution = await solve_lean_problem(agent, sample)

                # Write solution to file
                write_solution_to_file(sample.get("id", "unknown"), solution)

                # Display results
                print("\n" + "=" * 80)
                print("SOLUTION")
                print("=" * 80)
                print("\nCode:")
                print(solution.code)
                print("\nExplanation:")
                print(solution.explanation)
                print(f"\nVerification Status: {solution.verification_status}")
                print("=" * 80)

    asyncio.run(run())
```

## Vericoding and Verilib

We would like to confine super powerful AI to a box, and build this box out of specifications. To summon this world into being, you might like formal verification and proof synthesis to have stronger movements/communities. One way to galvanize a movement is to make a product. [VeriLib](https://verilib.org) is kinda like a github clone where formal methods are the first class use case (for instance, by hosting on-rails CI to check proofs). In the long run, you only really need or want the human UX of github for specifications, because the code and proofs are background LLM CI jobs.

