Yes — with a few caveats, and I’ve added safeguards in `src/`.

### What we learned from testing

**`md-cleanup` is already idempotent on re-runs** after the first apply. On a `\begin{cases}` test file:

- Pass 1: `changed=True`, math tightened once  
- Pass 2–3: `changed=False` (no-op)

The `\\` → `\ ` corruption in BWD1997 during clustering came from **`repair_layer3_math.py`’s broken `reflow_cases`**, not from `md-cleanup`. That script has since been fixed.

### What the first pass *does* change (once)

Even when safe to re-run, the **first** `-Apply` still reshapes display math:

- Collapses multiline `$$` blocks into a tighter form  
- Runs `Optimize-MathContent` (de-spacing, `\mathbb` strip, unicode→LaTeX)  
- Can flatten intentional newlines inside environments (cosmetic, not usually breaking)

So: **re-runs are safe; the first run is the one that mutates math.**

### Changes just made

**1. `Optimize-MathContent` masks fragile tokens** (`src/normalize.ps1`):

- `\\` row breaks (cases/array)  
- `\text{...}` bodies (so `\text{if }` spacing survives de-spacing)

**2. `-LigaturesOnly` switch** on `Invoke-MarkdownCleanup` (`src/md-cleanup.ps1`):

- Skips all math tightening/wrapping — only ligature repair  
- Use this on compendia **after Layer 3** when you just want glyph cleanup:

```powershell
pwsh -File compendia/clustering/tmp/apply_md_cleanup.ps1 -LigaturesOnly
```

**3. `Test-MarkdownCleanupIdempotent`** — simulates apply + dry second pass; reports whether pass 2 would be a no-op.

**4. `apply_md_cleanup.ps1`** accepts `-LigaturesOnly` and `-VerifyIdempotent`.

### Recommended workflow for compendia layers

| When | Command |
|------|---------|
| First math pass (Layer 3) | `repair_layer3_math.py` (Python, cases-safe) |
| Ligatures only | `apply_md_cleanup.ps1 -LigaturesOnly` |
| Full md-cleanup (once) | `apply_md_cleanup.ps1` then verify with `-VerifyIdempotent` |
| After that | Re-runs should report `changed=False` |

### Future hardening (not done yet)

The display-math matcher still uses non-greedy `\$\$(.+?)\$\$`, which is fragile if `$$` ever appears inside content. A balanced block scanner would be the next step for full robustness.

I can wire `-VerifyIdempotent` into the clustering layer audit gate if you want that as a standard check before closing each layer.