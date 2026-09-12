# Multi-Source Visual Math Reasoning via GRPO

Fine-tune Qwen2.5-VL-7B with GRPO to maximize accuracy on MathVista visual math problems.

## Setup

| Item | Path / Value |
|------|-------------|
| Training script | `@@ROOT@@/app/train.py` (editable) |
| Reward functions | `@@ROOT@@/app/rewards.py` (editable) |
| Training entrypoint | `bash @@ROOT@@/app/train.sh` |
| Local eval | `python3 @@ROOT@@/app/evaluate_local.py` |
| Base model | `@@ROOT@@/models/Qwen2.5-VL-7B-Instruct-bnb-4bit` (4-bit quantized) |

## Training Data Sources

| Dataset | Path | Size | Content |
|---------|------|------|---------|
| Geometry3K | `@@ROOT@@/data/geometry3k/` | ~2400 | Geometric reasoning with diagrams |
| MathVision | `@@ROOT@@/data/mathvision/` | ~2000 | Competition-level visual math |
| ChartQA | `@@ROOT@@/data/chartqa/` | ~1500 | Chart/graph understanding |

All datasets use a unified format: `question`, `answer`, `image`.

## Your Goal

Maximize `mathvista_accuracy` on 100 held-out MathVista problems. A retention gate applies: if general VQA accuracy drops more than 10% relative to the base model, the score is zero.

## Evaluation

```bash
python3 @@ROOT@@/app/evaluate_local.py   # quick check (20 MathVista + 10 VQA)
```

Higher MathVista accuracy is better. The forgetting gate (VQA retention ≥ 0.9) zeros the reward if violated.

## Rules

- Edit only `@@ROOT@@/app/train.py` and `@@ROOT@@/app/rewards.py`
- Do NOT modify `@@ROOT@@/orig/`, or `@@ROOT@@/models/`
- LoRA adapter must be saved to `@@ROOT@@/app/output/`
- No external network access
- Single GPU
- Time budget: 8 hours

## Additional Requirements

* Time budget: make full use of the time budget specified above to seek better results. Do not stop after the first working solution or first improvement; continue meaningful iteration while there are still executable ideas, diagnostics, or refinements worth trying within the remaining budget.

* Environment issues: if progress is blocked by workspace, dependency, permission, hardware, missing file, corrupted data/model, or other environment-level issues that cannot be safely fixed within the task constraints, stop promptly and report the issue clearly, including the command that failed, the key error message, and what was attempted.

* Version control: use git inside the task's `app/` directory to record each iteration. Do not initialize git at the workspace root, and do not track `data/`, `models/`, `orig/`, `tmp/`, or other large/non-editable directories.

  At the beginning, initialize git in `app/` and create an initial commit:

  ```bash
  cd /path/to/this/task/workspace/app
  git init
  git config --local user.name "autolab-agent"
  git config --local user.email "autolab-agent@example.com"
  git add -A
  git commit -m "initial state"
  ```

  For each iteration, after making changes and before running the main experiment, evaluation, or optimization attempt, commit the current runnable state with a concise message describing the change and hypothesis, for example:

  ```bash
  git add -A
  git commit -m "round N: change=<short description> hypothesis=<short hypothesis>"
  ```

  Keep the full history of attempts. Do not reset, rebase, delete, or rewrite previous rounds. Large generated artifacts in `app/output/` do not need to be committed, but the final best artifact must remain in `app/output/` for evaluation.

* Trajectory snapshots: each time a training run finishes, archive that round's adapter so its quality can be re-evaluated later. Copy the adapter files from `app/output/` (at minimum `adapter_config.json` and `adapter_model.safetensors`) into a new directory `@@ROOT@@/output_snapshot/<commit>_<timestamp>/`, where `<commit>` is `git -C @@ROOT@@/app rev-parse --short HEAD` and `<timestamp>` is `date +%Y%m%d_%H%M%S`. Keep every snapshot; never overwrite or delete earlier ones. This directory lives outside `app/`, so do not add it to git.

* Journal: maintain an experiment journal at `app/output/journal.md`. For each iteration, record the change, hypothesis, command(s) executed, observed result, and next decision.

* Hardware: before starting, inspect the actual available GPU, CPU, and memory, and record them in the journal. Adapt the solution to the actual allocated hardware for this run.
