# Manifest — BD2005

## DELETE

### page_001
- Dateline line: `April 5, 2005`
- Email line: `email: bigelow@niehs.nih.gov`

### page_002
- Figure placeholder: `# [Figure 1 about here.]`

### page_015
- Figure placeholder: `# [Figure 2 about here.]`

### page_017
- Figure placeholder: `# [Figure 3 about here.]`
- Table placeholder: `# [Table 1 about here.]`
- Table placeholder: `# [Table 2 about here.]`

### page_018
- Figure placeholder: `# [Figure 4 about here.]`
- Figure placeholder: `# [Figure 5 about here.]`
- Figure placeholder: `# [Figure 6 about here.]`

### page_021
- Heading and paragraph: `# Acknowledgements` through end of paragraph ("...for providing the NC-EPS data.")

### pages 024–029
- DELETE entire body content (figures inlined in text pages; these are pure float pages)

---

## FIX_IMAGES
Images copied to `compendia/bars/images/BD2005/` prior to repair.

When inserting inline figures in text pages, use path `images/BD2005/imageFileN.png`.

---

## REPLACE_TABLES

### Table 1 (page_030)
Caption: "Summary variables describing the conception vs. non-conception difference in log-PdG across the menstrual cycle with 95% credible intervals. Estimates are based on an average of subject-specific trajectories at each iteration."

JSON extraction degenerate — manually reconstruct:

```
Table 1. Summary variables describing the conception vs. non-conception difference in log-PdG across the menstrual cycle with 95% credible intervals.

| Variable | Conception | Non-conception | Difference |
|---|---|---|---|
| Early follicular (days 1–5) | −0.94 [−0.98, −0.90] | −0.64 [−0.67, −0.61] | −0.30 [−0.35, −0.25] |
| Baseline (2–6 days before ov.) | −0.94 [−0.97, −0.91] | −0.78 [−0.80, −0.77] | −0.16 [−0.19, −0.12] |
| Midluteal (5–6 days after ov.) | 1.19 [1.14, 1.24] | 1.31 [1.28, 1.35] | −0.13 [−0.18, −0.07] |
| Early luteal rise (days 1–5 post-ov.) | 1.18 [1.10, 1.26] | 1.12 [1.06, 1.18] | 0.07 [−0.05, 0.15] |
```

### Table 2 (page_031)
Caption: "Probability of conception in cycles with very low vs. normal/high midluteal (days 5–6 after ovulation) PdG."

JSON extraction degenerate — manually reconstruct:

```
Table 2. Probability of conception in cycles with very low vs. normal/high midluteal PdG, with 95% credible intervals.

| | Estimate [95% CI] |
|---|---|
| Prob. of conception, midluteal PdG < 10th percentile | 0.144 [0.098, 0.195] |
| Prob. of conception, midluteal PdG ≥ 10th percentile | 0.217 [0.211, 0.222] |
| Difference in conception probabilities | 0.073 [0.016, 0.124] |
```

---

## REPAIR_PROSE

### Global (apply across all pages)
- Ligatures: ﬁ→fi, ﬂ→fl, ﬃ→ffi, ﬀ→ff
- `￿` as epsilon/error term in math/prose → `$\varepsilon$` or just "ε" per context
- `￿` as prime/transpose (`x ￿ ij`) → write as $x_{ij}'$ or `x'` per context
- `￿ +` as positive reals (`R_+`) → $\mathbb{R}_+$
- Inline math wrapping: variables like $\tau$, $\lambda$, $\delta$, $k$, $k^*$, $\beta$, $b_i$ need `$...$` where they appear bare in prose

### Heading promotions
- page_002: `# 1. Introduction` → `## 1. Introduction`
- page_005: `# 2. Methods` → `## 2. Methods`; `# 2.1 Prior speciﬁcation` → `### 2.1 Prior Specification`
- page_008: `# 2.2 Posterior computation` → `### 2.2 Posterior Computation`
- page_013: `# 2.3 Computation` → `### 2.3 Computation`; `# 3. Simulated data example` → `## 3. Simulated Data Example`
- page_015: `# 4. Progesterone example` → `## 4. Progesterone Example`; `# 4.1 Estimation` → `### 4.1 Estimation`
- page_016: `# 4.2 Inference` → `### 4.2 Inference`; `# 5. Results` → `## 5. Results`
- page_018: `# 6. Discussion` → `## 6. Discussion`
- page_021: `# References` → `## References`

### Author line (page_001)
Convert bare author line and affiliation to bold author + plain affiliation:
```
**Jamie Lynn Bigelow and David B. Dunson**

Biostatistics Branch, National Institute of Environmental Health Sciences, Research Triangle Park, NC 27709
```

### Abstract (page_001)
Change "Summary." label to `## Summary` heading.

### Inline figure replacement (pages_002, 015, 017, 018)
Replace each placeholder with figure block:

page_002 — Fig. 1:
```
![log-PdG for a non-conception followed by a conception cycle from one subject.](<images/BD2005/imageFile1.png>)

*Fig. 1. log-PdG for a non-conception followed by a conception cycle from one subject. Solid lines indicate first day of each cycle, and dashed lines indicate ovulation days.*
```

page_015 — Fig. 2:
```
![Four-panel evaluation of algorithm performance using simulated data.](<images/BD2005/imageFile2.png>)

*Fig. 2. Evaluation of algorithm performance using simulated data.*
```

page_017 — Fig. 3:
```
![log-PdG data (points) and estimated log-PdG (solid line) for a single woman.](<images/BD2005/imageFile3.png>)

*Fig. 3. log-PdG data (points) and estimated log-PdG (solid line) for a single woman. The dashed line is the estimated population mean log-PdG given her covariates.*
```

page_018 — Fig. 4 (insert before "Figure 5 shows"):
```
![Estimated population mean log-progesterone for conception and non-conception cycles with ovulation on day 14.](<images/BD2005/imageFile4.png>)

*Fig. 4. Estimated population mean log-progesterone for a conception (thin line) and non-conception (heavy line) cycle with ovulation on day 14. Pointwise 95% credible intervals are given by the dashed lines.*
```

page_018 — Fig. 5 (insert after Fig. 5 description paragraph):
```
![Estimated population mean log-progesterone for non-conception cycles with early vs. late ovulation.](<images/BD2005/imageFile5.png>)

*Fig. 5. Estimated population mean log-progesterone for non-conception cycles with ovulation on day 10 (thin line) and day 18 (heavy line). Pointwise 95% credible intervals are given by the dashed lines. Vertical lines indicate ovulation days.*
```

page_018 — Fig. 6 (insert after Fig. 6 description):
```
![Unnormalized marginal likelihood for a proposed model and its Laplace approximation.](<images/BD2005/imageFile6.png>)

*Fig. 6. The unnormalized marginal likelihood for a proposed model, $p(y \mid \lambda, \delta, M^*)$, and its corresponding Laplace approximation.*
```

### Reference page join (page_022)
Page 021 ends mid-reference: "Green, P. (1995). Reversible jump Markov chain Monte Carlo computation and Bayesian"
Page 022 begins: "model determination. Biometrika 82, 711–732."
Fix on page_022: delete the dangling continuation line; the page_021 reference will be repaired to be complete.
Fix on page_021: complete the Green (1995) entry: "Green, P. (1995). Reversible jump Markov chain Monte Carlo computation and Bayesian model determination. *Biometrika* **82**, 711–732."

---

## REPAIR_MATH

### page_006 — eq (y_{ij})
Current (garbled align env):
```
$$
y _ { i j } & = \sum _ { l = 1 } ^ { k } b _ { i l } ( x _ { i j } ^ { \prime } \mu _ { l } ) _ { + } + \epsilon _ { i j } , \\
$$
```
Replace with:
```
$$
y_{ij} = \sum_{l=1}^{k} b_{il}(x_{ij}'\mu_l)_+ + \varepsilon_{ij}
$$
```

### page_006 — θ_i matrix (garbled array)
Current: huge `\begin{array}` with garbled text rows at top and bottom.
Replace with clean matrix:
```
$$
\theta_i = \begin{pmatrix}
1 & (x_{i1}'\mu_2)_+ & \cdots & (x_{i1}'\mu_k)_+ \\
1 & (x_{i2}'\mu_2)_+ & \cdots & (x_{i2}'\mu_k)_+ \\
\vdots & \vdots & & \vdots \\
1 & (x_{in_i}'\mu_2)_+ & \cdots & (x_{in_i}'\mu_k)_+
\end{pmatrix}
$$
```

### page_006 — likelihood L(y|b,τ,M)
Current: `\in` → should be `\propto`; `e x p` → `\exp`; trailing `\quad \\` 
Replace with:
```
$$
L(y \mid b, \tau, M) \propto \prod_{i=1}^{m} \tau^{n_i/2} \exp\!\left[-\frac{\tau}{2}(y_i - \theta_i b_i)'(y_i - \theta_i b_i)\right]
$$
```

### page_007 — hierarchical prior (b_i ~ N, β ~ N)
Current: single `$$` block with `&` and `\\` mixing both distributions.
Split into two display blocks:
```
$$
b_i \mid k \sim N_k(\beta,\, \tau^{-1}\Delta^{-1}), \quad \forall\, i
$$

$$
\beta \mid k \sim N_k(0,\, \tau^{-1}\lambda^{-1}I_k)
$$
```

### page_007 — prior π(τ,λ,δ)
Current: `\cos` (garble of `\propto`); `e x p` spaced out.
Replace with:
```
$$
\pi(\tau, \lambda, \delta) \propto \tau^{a_\tau - 1} e^{-b_\tau \tau}\cdot\lambda^{a_\lambda - 1} e^{-b_\lambda \lambda}\cdot\prod_{l=1}^{k} \delta_l^{a_\delta - 1} e^{-b_\delta \delta_l}
$$
```

### page_007 — E(y) and V(y)
Current: single `$$` block with `&` and `\\` mixing two equations.
Split into two:
```
$$
E(y) = \beta_1 + \sum_{l=2}^{k} \beta_l(x'\mu_l)_+
$$

$$
V(y) = \delta_1^{-1} + \sum_{l=2}^{k} \delta_l^{-1}(x'\mu_l)_+^2 + \tau^{-1}
$$
```

### page_008 — full conditionals (two garbled blocks)
DELETE the first standalone block (OCR duplicate of β conditional with "D"):
```
$$
D \sim N _ { k } \left ( [ \lambda I _ { k } + m \Delta ] ^ { - 1 } \Delta \sum _ { i = 1 } ^ { m } b _ { i } , \tau ^ { - 1 } [ \lambda I _ { k } + m \Delta ] ^ { - 1 } \right )
$$
```

Replace the large garbled block with clean aligned conditionals:
```
$$
\begin{aligned}
\beta \mid b, \delta, \lambda, \tau &\sim N_k\!\left([\lambda I_k + m\Delta]^{-1}\Delta\sum_{i=1}^m b_i,\; \tau^{-1}[\lambda I_k + m\Delta]^{-1}\right) \\[4pt]
b_i \mid \beta, \delta, \lambda, \tau &\sim N_k\!\left([\theta_i'\theta_i + \Delta]^{-1}[\theta_i'y_i + \Delta\beta],\; \tau^{-1}[\theta_i'\theta_i + \Delta]^{-1}\right), \quad i = 1,\dots,m \\[4pt]
\tau \mid \beta, b, \delta, \lambda &\sim \mathrm{Gamma}\!\left(a_\tau + \tfrac{(m+1)k + n}{2},\; b_\tau + \tfrac{1}{2}\Bigl[\sum_{i=1}^m (b_i-\beta)'\Delta(b_i-\beta) + \sum_{i=1}^m (y_i-\theta_i b_i)'(y_i-\theta_i b_i) + \lambda\beta'\beta\Bigr]\right) \\[4pt]
\lambda \mid \beta, b, \delta, \tau &\sim \mathrm{Gamma}\!\left(a_\lambda + \tfrac{k}{2},\; b_\lambda + \tfrac{\beta'\beta}{2}\right) \\[4pt]
\delta_l \mid \beta, b, \delta_{-l}, \lambda, \tau &\sim \mathrm{Gamma}\!\left(a_\delta + \tfrac{m}{2},\; b_\delta + \tfrac{\tau}{2}\sum_{i=1}^m (b_{il} - \beta_l)^2\right), \quad l = 1,\dots,k
\end{aligned}
$$
```
Also delete the redundant prose duplicate "where a Gamma(a,b) random variable is parameterized to have expected value a/b and variance a/b²." that immediately follows (it appeared as embedded text in the math block and also as a separate line).

### page_010 — U_i, R, α definitions (garbled align)
Current: single `$$` block with `&` and `\\` for three definitions, trailing `& ` artifact.
Replace with:
```
$$
U_i = [\Delta + \theta_i'\theta_i]^{-1}
$$

$$
R = \lambda I_k + m\Delta - \Delta\!\left(\sum_{i=1}^m U_i\right)\!\Delta
$$

$$
\alpha = y'y - \sum_{i=1}^m y_i'\theta_i U_i\theta_i'y_i - \left(\sum_{i=1}^m U_i\theta_i'y_i\right)'\!\Delta R^{-1}\Delta\!\left(\sum_{i=1}^m U_i\theta_i'y_i\right)
$$
```

### page_011 — Q acceptance probability (spaced `m i n`)
Current: `Q = m i n \left[ 1, ...`
Replace with:
```
$$
Q = \min\!\left[1,\; \frac{p(y \mid M^*, \lambda, \delta)}{p(y \mid M, \lambda, \delta)}\right]
$$
```

### page_011 — p(y|M*,λ,δ) integral (garbled preamble text)
Current: starts with `\text{derived as follows, where $\delta^{\sigma}=\sigma$}.\\` followed by integral expansion.
Delete the garbled preamble line; keep only the integral derivation:
```
$$
p(y \mid M^*, \lambda, \delta)
= \int p(y, \delta_{k^*} \mid M^*, \delta, \lambda)\,d\delta_{k^*}
= \frac{C(\lambda, k^*)}{\Gamma(a_\delta)}\prod_{l=1}^k \delta_l
\int_0^\infty |R^*|^{-1/2}\!\left(b_\tau + \tfrac{\alpha^*}{2}\right)^{-(n/2+a_\tau)}
\delta_{k^*}^{a_\delta} e^{-b_\delta \delta_{k^*}}\prod_{i=1}^m |U_i^*|^{1/2}\,d\delta_{k^*}
\tag{7}
$$
```

### page_012 — transformed integral expansion (garbled tail text)
Current: second `$$` block ends with `\\ & \quad \text{Similarly } \alpha_\delta \text{ is non-universal...}` — this is garbled inserted prose.
Strip the tail; keep only the clean integration:
```
$$
p(y \mid M^*, \delta, \lambda)
= \frac{C(\lambda, k^*)}{\Gamma(a_\delta)}\prod_{l=1}^k \delta_l
\int_{-\infty}^{\infty} e^{(1+a_\delta)\omega - b_\delta e^\omega}
|R^*|^{-1/2}\!\left(b_\tau + \tfrac{\alpha^*}{2}\right)^{-(n/2+a_\tau)}
\prod_{i=1}^m |U_i^*|^{1/2}\,d\omega
$$
```
