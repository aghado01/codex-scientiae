# Lessons: Data Selection for Instruction Following (IFEval)

## Source Context

This task asked an agent to select ≤5,000 training samples from a 50,000-sample data pool (19 sources from allenai/tulu-3-sft-mixture: ifdata, math, code, safety, multilingual, conversation) to maximize IFEval prompt-level strict accuracy after LoRA fine-tuning on Qwen2.5-3B-Instruct. The training recipe was **fixed**: LoRA rank 16, lr 1e-4, 1 epoch, batch_size 2 × grad_accum 4 = effective batch 8, cutoff 2048, cosine scheduler. The agent ran 15 rounds of data selection experiments exploring keyword-based scoring, constraint-type matching, source-stratified sampling, diversity maximization, and ultra-minimal training. The critical turning point came when the agent discovered that 50-sample evaluation had stderr ~0.07 — large enough that an early misleading score of 0.52 (vs baseline 0.48) sent it chasing a false positive for ~8 rounds. After switching to full 541-prompt evaluation (stderr 0.021), it became clear that **all LoRA fine-tuning degraded IFEval below the base model's 0.4732 baseline**. The best achievable result was matching baseline with 8 samples (1 gradient step), earning a verifier reward of 0.932. The root cause was the training recipe being too aggressive (rank 16, lr 1e-4) for a 3B model already strong at instruction-following, causing catastrophic forgetting of pre-trained capabilities.

## Lessons

### What Worked

1. **Establishing a proper baseline before iterating.** The agent ran the base model through full IFEval before any training, establishing a solid reference of 0.4732 prompt_strict. This baseline was essential for recognizing that all later fine-tuning results were regressions, not just noise around a different starting point.

2. **Switching from small-sample to full evaluation.** The 50-sample eval had stderr 0.07 — wide enough to turn noise into false signals. Moving to full 541-prompt eval (stderr 0.021) was the single most important decision: it rescued the agent from chasing a phantom 0.52 result and forced the correct conclusion that the training recipe was the bottleneck.

3. **Using ultra-minimal training as a diagnostic.** Selecting exactly 8 samples (batch_size 2 × grad_accum 4 = 1 gradient step) and matching baseline proved that even a single gradient step with the fixed recipe was enough to shift the model's distribution — zero samples was not the answer, but neither was more samples. This isolated the problem to the recipe, not the data pool.

4. **Git-as-experiment-journal.** Each commit had a clear message format: `round N: change=<what> hypothesis=<why>`. This created a reproducible, inspectable trail of all 15 experiments with their rationale and the resulting eval score. It also enabled the step_test verifier to replay each commit and measure per-step reward.

5. **Systematic exploration of selection axes.** The agent explored keyword-density scoring, constraint-type coverage, source stratification, diversity maximization, response format verification, and data volume sweeps — a reasonably thorough coverage of the design space given the constraint that only `select_data.py` could be modified.

### Failures and Pitfalls

1. **Trusting noisy evaluation for too long.** R2 scored 0.52 on 50-sample eval, which the agent interpreted as a real improvement. It spent R3–R8 (6 full rounds, ~20+ minutes of GPU training each) trying to reproduce or beat this number. **Early-warning signal:** when 50-sample eval produces swings of ±0.06 between rounds with very similar strategies, compute the standard error and verify significance before designing the next round.

2. **Stale evaluation cache.** `evaluate_local.py` cached old results, causing rounds to appear better or worse than they actually were across runs. The agent discovered and fixed this in R3, but it contaminated initial results. **Early-warning signal:** when re-running the same model produces different scores, suspect caching in the eval pipeline.

3. **Not recognizing the ceiling early enough.** After 3–4 rounds of clear degradation (R1: 0.44, R2: noisy 0.52, R3: 0.42), the agent could have run a diagnostic: compare baseline, random-5000, and ifdata-only on full eval simultaneously. This would have surfaced the recipe bottleneck by round 5 instead of round 13. **Early-warning signal:** every strategy below baseline, regardless of selection approach — the common factor is the training recipe, not the data.

4. **Over-indexing on user-prompt features without checking assistant-response quality.** The agent scored samples based on constraint-keyword density in the user prompt, but never evaluated whether the pool's assistant responses actually demonstrated constraint satisfaction. Several pools (code, math, safety) had prompts with format constraints but responses that were code blocks, equations, or refusals — not IFEval-style constrained text generation. **Early-warning signal:** spot-check 20–30 actual (prompt, response) pairs from the selected data for each strategy to verify the response style matches the target behavior.

5. **Never attempted data augmentation or re-formatting.** The agent had 8 hours but only tried selection from the pool as-is. Given that the pool lacked many IFEval constraint types (e.g., `keywords:frequency` had 0 matching samples), some form of programmatic data generation — taking pool prompts and adding IFEval-style constraints — could have bridged the distribution gap.

### Recommendations for a Future Run

1. **Run full evaluation on baseline + first experiment simultaneously at the start.** Don't iterate on 50-sample eval alone. Use it for fast filtering (does this crash? does it beat random?) but gate any non-trivial decision on a full-eval signal. Budget 10 minutes for the first full eval to get stderr <0.025.

2. **If the base model is already strong on the target benchmark, assume fine-tuning will hurt until proven otherwise.** Qwen2.5-3B-Instruct scored 0.4732 without any fine-tuning — a strong starting point. The bar for data selection is higher when the model is already instruction-tuned: you're fighting forgetting, not teaching new skills.

3. **When the training recipe is frozen but looks suspicious, diagnose it explicitly.** Write a 1-sentence diagnosis after the first 2–3 negative results: "LoRA rank 16, lr 1e-4 on 3B → likely too aggressive." Then design experiments that test this hypothesis: sweep data volumes (8, 40, 200, 1000) before investing more in selection strategy.

4. **Dedup and validate your evaluation pipeline first.** Fix caching bugs, confirm score reproducibility (same model → same score within 0.005), and establish the noise floor of your eval before trusting any result to guide the next experiment.

5. **Match training data to the target output distribution, not just the target input distribution.** For constrained generation benchmarks like IFEval, the assistant responses must be constraint-compliant. Selecting based on prompt keywords is insufficient — verify that selected samples actually demonstrate the desired output behavior (e.g., bullet points, all-caps words, keyword counts, JSON formatting).

6. **Use a kill-switch heuristic.** If 4 consecutive rounds with meaningfully different strategies all produce results within ~2 stderr of each other and below baseline, stop refining the selection algorithm and question your assumptions: is the recipe viable? is the pool suitable? is the metric measuring what you think?

7. **Consider data synthesis over pure selection.** When the pool has structural gaps (e.g., 0 samples for certain IFEval constraint types), a programmatic approach — take existing pool prompts and append IFEval-style formatting instructions, or generate constrained responses to existing prompts — is worth at least one round, especially with an 8-hour budget.