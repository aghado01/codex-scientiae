# Repair Manifest — GRE1995

Paper: "Reversible Jump Markov Chain Monte Carlo Computation and Bayesian Model Determination"
Author: Peter J. Green
Journal: *Biometrika* 82(4), 1995, pp. 711–732

---

## DELETE

- **page_001, lines 5–23**: JSTOR cover-page boilerplate — image line, "Peter J. Green" attribution, Stable URL, and all JSTOR license/contact text. Keep only the H1 title line (line 3).
- **page_009, lines 3–35**: Figure 1 axis-label debris — the block of numbers (0010, 0-008, 0-006, 1, 0-004, 0002, 200, 150, 100, 50, 0000, 10000, 20000, "Time (days)", 30000, 40000) and the Fig 1 caption line "1. Coal mining disaster data, 1851-1962 … solid curve). Fig". Leave everything from "function x(t) the log-likelihood is" onwards.
- **page_012, lines 23–35**: Figure 2 debris at the bottom of the page — "03\n02\n01\n00\n2\nNumber of change points\n2. Coal mining disaster data: posterior distribution of k, the number of change-points. Fig"
- **page_013, axis label blocks**: Delete the two blocks of axis numbers: (a) the block "0-0004 / 0-0003 / 0-0002 / 0-0001 / 00000 / 10000 / 20000 / 30000 / 40000 / change / points / Positions of"; (b) the block "800 / 600 / 400 / 200 / 0002 / 0-0 / 0-004 / 0006 / 0-008 / 0010 / 0012 / Rate of process". Keep image line and both figure captions (Fig 3 and Fig 4 caption text).
- **page_016, lines 29–67**: Figure 5 axis debris — the block "50 / 40 / 30 / 20 / 50 / 40 / 30 / 20 / 10 / 10 / 20 / 30 / 40 / 50 / 10 / 20 / 30 / 40 / 50". Keep the Fig 5 caption line.
- **page_021, lines 3–27**: Figure 6 axis debris — the block "15 / 10 / 1 / 5 / LH / SH / SD / 0-0 / 0-2 / 06 / 08 / 1-0". Keep the "Fig: 6. Posterior density…" caption line.
- **page_022**: Entire ACKNOWLEDGEMENT section — delete `# ACKNOWLEDGEMENT` heading and its body paragraph ("I wish particularly to thank…Tony").
- **page_023, last line**: `[Received January 1995. Revised June 1995]`

---

## FIX_IMAGES

- **page_001**: Delete the JSTOR logo image line: `![image 1](<images/imageFile1.png>)` — it is the journal scan cover, not a paper figure.
- **page_013**: Replace Docling-hallucinated alt text and fix path:
  - Old: `![The image is a line graph that shows the relationship between…](<images/imageFile2.png>)`
  - New: `![Fig. 3–4: Coal mining disaster data — posterior density estimates of change-point positions and heights](<images/GRE1995/imageFile2.png>)`

---

## REPLACE_TABLES

- **page_020, Table 1**: The raw markdown table has correct structure but needs decimal cleanup (OCR rendered `·` as `-`, `+`, or dropped it entirely) and a cleaner header. Replace with:

```markdown
**Table 1.** Mortality of pine seedlings: posterior means and standard deviations (in parentheses) of $\{\theta_i\}$

| Experiment | $y_i$ | C&V $q=100$ | C&V $q=200$ | C&V $q=300$ | RJMCMC $q=100$ | RJMCMC $q=200$ | RJMCMC $q=300$ | RJMCMC random $q$ |
|---|---|---|---|---|---|---|---|---|
| LH | 59 | 0.589 (0.059) | 0.588 (0.056) | 0.588 (0.054) | 0.587 (0.049) | 0.585 (0.050) | 0.586 (0.047) | 0.588 (0.049) |
| LD | 89 | — | 0.894 (0.028) | 0.895 (0.027) | 0.892 (0.027) | 0.893 (0.026) | 0.894 (0.025) | 0.893 (0.026) |
| SH | 88 | 0.886 (0.032) | 0.889 (0.029) | 0.891 (0.028) | 0.886 (0.027) | 0.890 (0.026) | 0.890 (0.026) | 0.888 (0.026) |
| SD | 95 | 0.929 (0.027) | 0.924 (0.026) | 0.922 (0.026) | 0.930 (0.023) | 0.926 (0.025) | 0.921 (0.025) | 0.926 (0.024) |

C&V = Consonni & Veronese; RJMCMC = Reversible Jump Markov Chain Monte Carlo. H, planting too high; D, planting too deep; L, longleaf seedling; S, slash seedling.
```

---

## REPAIR_PROSE

**Heading demotions** (all current H1s that are not the document title must become H2 or H3):

- page_002: `# BY PETER J. GREEN` → `**Peter J. Green**`
- page_002: `# SUMMARY` → `## Summary`
- page_002: `# 1 . INTRODUCTION` → `## 1. Introduction`
- page_003: `# 2 BAYESIAN MODEL CHOICE AS HIERARCHICAL MODEL` → `## 2. Bayesian Model Choice as Hierarchical Model`
- page_004: `# 3 _ MARKOV CHAIN MONTE CARLO USING REVERSIBLE JUMPS` → `## 3. Markov Chain Monte Carlo Using Reversible Jumps`
- page_004: `# 3-1. Introduction` → `### 3.1. Introduction`
- page_005: `# 3-2 The general case` → `### 3.2. The General Case`
- page_007: `# 3-3. Switching between two simple subspaces` → `### 3.3. Switching between Two Simple Subspaces`
- page_008: `# 4 APPLICATION TO ONE-DIMENSIONAL MULTIPLE CHANGE-POINT PROBLEMS` → `## 4. Application to One-Dimensional Multiple Change-Point Problems`
- page_008: `# 41. Coal mining disasters` → `### 4.1. Coal Mining Disasters`
- page_009: `# 42. A model for step functions prior` → `### 4.2. A Model for Step Functions` (drop "prior" — OCR debris)
- page_010: `# 4.3. Using reversible jumps for step functions` → `### 4.3. Using Reversible Jumps for Step Functions`
- page_012: `# 44. Analysis of the coal mining disaster data` → `### 4.4. Analysis of the Coal Mining Disaster Data`
- page_014: `# 5. IMAGE SEGMENTATION VIA VoRONOI TESSELLATION` → `## 5. Image Segmentation via Voronoi Tessellation`
- page_017: `# PARTITION MODELS` → `## 6. Partition Models` (add missing section number "6.")
- page_017: `# 61. A hierarchical model for binomial probabilities` → `### 6.1. A Hierarchical Model for Binomial Probabilities`
- page_018: `# 6-2 Reversible jump Markov chain Monte Carlo for partition problems` → `### 6.2. Reversible Jump MCMC for Partition Problems`
- page_019: `# 6.3. Application to pine seedling mortality data` → `### 6.3. Application to Pine Seedling Mortality Data`
- page_021: `# 7 . DISCUSSION` → `## 7. Discussion`
- page_022: `# REFERENCES` → `## References`

**Inline text corrections**:

- page_009, prose: `<S2 < <Sk < L` → `$s_1 < s_2 < \cdots < s_k < L$`
- page_009, prose: `51, S2, Sk` (first occurrence, step positions) → `$s_1, s_2, \ldots, s_k$`
- page_009, prose: `ho, h1, hk` (heights) → `$h_0, h_1, \ldots, h_k$`
- page_009, prose: `F(0, 0)` (improper Gamma) → `$\Gamma(0,0)$`
- page_009, prose: `kmax` throughout → `$k_{\max}$` (use replace_all on the literal token)
- page_010, prose: `s0 that` → `so that` (OCR zero-for-o, occurs twice)
- page_010, prose: `bk +dk < 09` → `$b_k + d_k \leq 1$`
- page_010, prose: `bkp(k) = dk+1p(k + 1)` → `$b_k p(k) = d_{k+1} p(k+1)$`
- page_010, prose: `ho, h1, hx at random` → `$h_0, h_1, \ldots, h_k$ at random`
- page_010, prose: `[_4 +4]` → `$[-4, +4]$`
- page_011, prose: `S1, 82, Sk` → `$s_1, s_2, \ldots, s_k$`
- page_013, Fig 3 caption: `k =1 (solid curve) k =2 (dotted curves) and k = 3 (broken curves)` → `$k=1$ (solid curve), $k=2$ (dotted curves) and $k=3$ (broken curves)`
- page_013, Fig 4 caption: `k = 2 (dotted curves) and k = 3 (broken curves)` → `$k=2$ (dotted curves) and $k=3$ (broken curves)`
- page_016, prose: `= = 10 and ß = 10` → `$\lambda = \alpha = 10$ and $\beta = 10$`
- page_016, prose: `50 x 50 grid` → `$50 \times 50$ grid`
- page_016, prose: `standard deviation 0-7` → `standard deviation $0.7$`
- page_017, prose: `I = {1,2, n}` → `$I = \{1,2,\ldots,n\}$`
- page_017, prose: `Yi Bin(wi, 0;)` → `$Y_i \sim \text{Bin}(w_i, \theta_i)$`
- page_017, prose: `I = {1, 2, n}` (second occurrence) → `$I = \{1, 2, \ldots, n\}$`
- page_019, prose: `W = wi (r = 1,2)` → `$W_r = \sum_{i \in S_{jr}} w_i$ ($r = 1,2$)`
- page_020, prose: `y = (59,89,88,95)` → `$y = (59, 89, 88, 95)$`
- page_020, prose: `wi = 100 trials` → `$w_i = 100$ trials`
- page_020, prose: `bg and dg each to be 0-3` → `$b_g$ and $d_g$ each to be $0.3$`
- page_020, prose: `probability 02` → `probability $0.2$`

---

## REPAIR_MATH

**page_003** — posterior factorization; truncated in both source and JSON:
- Raw: `p ( k , \theta ^ { ( k ) } | y ) = p (`
- Fix:
```
$$
p(k, \theta^{(k)}|y) = p(k|y)\,p(\theta^{(k)}|k,y)
$$
```

**page_003** — Bayes factor; OCR-garbled ratio as `\overset{\circledast}{\cdot}`:
- Raw: `\overline { p ( k _ { 0 } | y ) } \overset { \circledast } { \cdot } \overline { p ( k _ { 0 } ) }`
- Fix:
```
$$
B_{k_0 k_1} = \frac{p(k_0|y)}{p(k_1|y)} \cdot \frac{p(k_1)}{p(k_0)}
$$
```

**page_005** — transition kernel P(x,B); corrupted integral notation:
- Raw: `P ( x , B ) = \sum _ { m } \left | \Big | _ { B } \right |`
- Fix:
```
$$
P(x, B) = \sum_m \int_B q_m(x, dx')\,\alpha_m(x, x') + s(x)\,\mathbf{1}(x \in B) \tag{2}
$$
```

**page_005** — s(x) "stay" probability; corrupted matrix artifact:
- Raw: `s ( x ) \colon = \sum _ { x } \left | \begin{matrix} 1 \\ 0 \end{matrix} \right |`
- Fix:
```
$$
s(x) := 1 - \sum_m \int q_m(x, dx')\,\alpha_m(x, x')
$$
```

**page_005** — equation (3); floating `(3)` at end of display, encode as tag:
- Raw ends with `s ( x ^ { \prime } ) . \ \ ( 3 )`
- Fix: replace `s ( x ^ { \prime } ) . \ \ ( 3 )` with `s(x').\tag{3}` inside the equation block

**page_006** — equation (4); no tag:
- The equation `\alpha_m(x,x') f_m(x,x') = \alpha_m(x',x) f_m(x',x)` has no tag.
- Add `\tag{4}` at the end of the equation content.

**page_006** — equation (5); no tag, leading `=` fragment:
- Raw: `= \min \left \{ 1 , \frac { f _ { m } ( x ^ { \prime } , x ) } { f _ { m } ( x , x ^ { \prime } ) } \right \}`
- Fix (with subject and tag):
```
$$
\alpha_m(x, x') = \min\left\{1,\, \frac{f_m(x', x)}{f_m(x, x')}\right\} \tag{5}
$$
```

**page_008** — f(x',x) truncated pair; both equations incomplete:
- Raw: `f ( x ^ { \prime } , x ) = p (` and `= p ( 2 , \theta`
- Fix: Replace the two truncated display blocks with the complete pair:
```
$$
f(x, x') = p\!\left(1, \theta^{(1)}\big|y\right) j\!\left(1, \theta^{(1)}\right) q_1\!\left(u^{(1)}\right)
$$

$$
f(x', x) = p\!\left(2, \theta^{(2)}\big|y\right) j\!\left(2, \theta^{(2)}\right) q_2\!\left(u^{(2)}\right)
$$
```

**page_008** — second acceptance probability; unclosed bracket:
- Raw ends at: `\left | \frac { \partial ( \theta ( \theta ^ { ( 1 ) } ) } { \partial ( \theta ^ { ( 1 ) } ) } \right |`
- Fix (add closing `\}`):
```
$$
\min\left\{1,\, \frac{p\!\left(2,\theta^{(2)}\big|y\right) j\!\left(2,\theta^{(2)}\right)}{p\!\left(1,\theta^{(1)}\big|y\right) j\!\left(1,\theta^{(1)}\right) q_1\!\left(u^{(1)}\right)} \left|\frac{\partial\,\theta^{(2)}}{\partial\,\theta^{(1)}}\right|\right\}
$$
```

**page_009** — log-likelihood Poisson process; malformed integral:
- Raw: `\sum _ { i = 1 } ^ { n } \log \{ x ( y _ { i } ) \} - \left [ \sum _ { x ( t ) } x ( t ) \, d t .`
- Fix:
```
$$
\ell = \sum_{i=1}^{n} \log\{x(y_i)\} - \int_0^L x(t)\,dt
$$
```

**page_011** — birth weighted geometric mean; truncated:
- Raw: `( s ^ { * } - s _ { j } ) \log ( h ^ { \prime } _ { j } ) + ( s _ { j + }`
- Fix:
```
$$
(s^* - s_j)\log(h'_j) + (s_{j+1} - s^*)\log(h'_{j+1}) = (s_{j+1} - s_j)\log(h_j)
$$
```

**page_011** — perturbation ratio; garbled nested fraction:
- Raw: `\frac { \frac { h _ { j + 1 } } { h _ { j } ^ { \prime } } } { u } = \frac { 1 } { u }`
- Fix:
```
$$
\frac{h'_{j+1}}{h'_j} = u
$$
```

**page_011** — death geometric mean; truncated right-hand side:
- Raw: `( s _ { j + 1 } - s _ { j } ) \log ( h _ { j } ) + ( s _ { j + 2 } - s _ { j + 1 } ) \log ( h _ { j + 1 } ) = ( s _ { j + 1 } ^ { \prime } - s _ { j + 1 } ^ { \prime } )`
- Fix (RHS was a duplicate-subscript artifact — the combined interval replaces the two):
```
$$
(s_{j+1} - s_j)\log(h_j) + (s_{j+2} - s_{j+1})\log(h_{j+1}) = (s_{j+2} - s_j)\log(h'_j)
$$
```

**page_011** — prior ratio for birth; truncated `exp` term:
- Raw ends at: `\exp \{ - \beta ( h _ { j } ^ { \prime } h _ { j + 1 } ^ { \prime } )`
- Fix (complete the sum and closing):
```
$$
\frac{p(k+1)}{p(k)}\,\frac{2(k+1)(2k+3)}{L^2}\,\frac{(s^*-s_j)(s_{j+1}-s^*)}{s_{j+1}-s_j}
\times \frac{\beta^\alpha}{\Gamma(\alpha)}\left(\frac{h'_j h'_{j+1}}{h_j}\right)^{\alpha-1}
\exp\{-\beta(h'_j + h'_{j+1} - h_j)\}
$$
```

**page_012** — isolated `h_j` display equation; OCR debris from acceptance probability annotation:
- Raw: `$$\nh_j\n$$`
- Fix: Delete this entire display block (it is the residual variable label from a figure or marginal annotation).

**page_015** — Gaussian likelihood for image segmentation; truncated:
- Raw: `p ( y | k , \theta ^ { ( k ) } ) \infty \exp \left [ - \frac { 1 } { 2 \sigma ^ { 2 } } \sum \left \{ y \right \}`
- Fix (note `\infty` = OCR of `\propto`):
```
$$
p(y \mid k, \theta^{(k)}) \propto \exp\!\left[-\frac{1}{2\sigma^2}\sum_{(u,v)}\bigl\{y(u,v) - h_{i(u,v)}\bigr\}^2\right]
$$
```

**page_016** — acceptance ratio R for image segmentation birth; two versions present, second is garbled:
- The second `R = ...` block (starting at line 21 of page_016) is a garbled repetition of the first with broken multi-line LaTeX (`\\` escapes outside an align environment). Delete the second R equation block entirely and keep only the first clean version.

**page_017** — beta prior for θ_i; severely truncated to `, d(g))`:
- Raw: `, d ( g ) ) .`
- Fix: Replace entire display block with:
```
$$
\theta_i \mid g, \alpha_1, \ldots, \alpha_{d(g)}, q
\;\sim\; \mathrm{Beta}\!\left(q\alpha_j,\; q(1-\alpha_j)\right)
\quad \bigl(i \in S_j(g),\; j = 1,\ldots,d(g)\bigr)
$$
```

**page_017** — prior distribution on g; denominator truncated:
- Raw: `p ( g ) \circ c \frac { d ( g ) ^ { - 1 } } { \# \{ g ^ { \prime } \colon d ( g ^ { \prime } ) = d ( g ) }`
- Fix (note `\circ c` = OCR of `\propto`; add closing brace):
```
$$
p(g) \propto \frac{[d(g)]^{-1}}{\#\{g' : d(g') = d(g)\}}
$$
```

**page_018** — joint distribution of all variables; equation has garbled `B\{..., q(1-\theta_i)\}` — the denominator should reference only $\alpha_j$:
- The display ends: `B \{ q \alpha _ { j } , q ( 1 - \alpha _ { j } ) , q ( 1 - \theta _ { i } ) \}` — the third argument is wrong (beta function takes 2 args). Fix the denominator to `B\{q\alpha_j, q(1-\alpha_j)\}`.

**page_018** — isolated `y_i` display equation; OCR debris:
- Raw: `$$\ny _ { i }\n$$`
- Fix: Delete this entire display block.

**page_018** — conditional distribution of θ_i; truncated:
- Raw: `, q ( 1 - \alpha _ { j } ) + w _ { i } - y _ { i } ) \} \quad ( i \in S _ { j } ( g ) ) ,`
- Fix: Replace entire display block with:
```
$$
\theta_i \mid \cdot \;\sim\; \mathrm{Beta}\!\left(q\alpha_j + y_i,\; q(1-\alpha_j) + w_i - y_i\right)
\quad (i \in S_j(g))
$$
```

**page_018** — full conditional for α_j; severely truncated (`B{qα_j, q(1-`):
- Raw: `B \{ q \alpha _ { j } , q ( 1 -`
- Fix: Replace entire display block with:
```
$$
p(\alpha_j \mid \cdot) \propto p(\alpha_j)
\prod_{i \in S_j(g)}
\frac{\theta_i^{q\alpha_j - 1}(1-\theta_i)^{q(1-\alpha_j)-1}}{B\{q\alpha_j,\, q(1-\alpha_j)\}}
$$
```

**page_019** — acceptance ratio R for partition birth; OCR text fragment embedded in display math:
- The block begins with `third \text { and } \text { death, the probabilities are respectively } \min ( 1 , R ) \text { and } \min ( 1 , R ^ { - 1 } ) ,` — this prose fragment was captured inside the math environment. Strip the entire leading `third \text{...}` line and retain only the R formula block starting from `R = \frac{B...}`.
