# Manifest — BM2021

## DELETE

### page_001
- Both journal header images: `![image 1](<images/imageFile1.png>)` and `![image 2](<images/imageFile2.png>)`
- Line: `Contents lists available at ScienceDirect`
- Heading/line: `# Computational   Statistics   and   Data   Analysis`
- Line: `www.elsevier.com/locate/csda`
- Section: `# a   r   t   i   c   l   e   i   n   f   o` through `2022` and keywords block (dates, keywords, "Robust estimation" duplicate)
- Line: `© 2022 Elsevier B.V. All rights reserved.`
- Footnote lines: `* Corresponding   author   at:...` and `E-mail addresses: gboente@dm.uba.ar...`

### page_034
- Section `# Appendix B.   Supplementary   material` and the URL line below it.

---

## FIX_IMAGES
Images copied to `compendia/bars/images/BM2021/` prior to repair.
When inserting or referencing figures use path `images/BM2021/imageFileN.png`.

Known figure mapping:
- imageFile3.png = Fig. 3 (estimators of η1 under Model 3)
- imageFile4.png = Fig. 4 (estimators of η2 under Model 3)
- imageFile5.png = Fig. 2 (confidence intervals for β1, Model 3)
- imageFile8.png = Fig. 5 (functional boxplots of η1, Model 3)
- imageFile9.png = Fig. 6 (functional boxplots of η2, Model 3)
- imageFile10.png = Fig. 7 (estimated curves for Boston housing, classical vs robust)
- imageFile11.png = Fig. 8 (boxplot of residuals, robust MM-fit)
- imageFile12.png = Fig. 9 (estimated curves after outlier removal)
- imageFile1.png, imageFile2.png = DELETE (journal boilerplate)

---

## REPAIR_PROSE

### Global (apply across ALL pages)

**Multi-spacing**: Every prose line has 3+ spaces between words (OCR artifact).
Fix: collapse runs of 2+ spaces to single space throughout, EXCEPT inside `$$...$$` blocks.
Pattern: `word   word   word` → `word word word`

**Ligatures**: ﬁ→fi, ﬂ→fl, ﬀ→ff, ﬃ→ffi

**Heading promotions**:
All top-level `#` section headings → `##`
All `#` subsection headings with decimal numbering (e.g., `# 2.1.`) → `###`
Specific targets:
- `# 1.   Introduction` → `## 1. Introduction`
- `# 2.   The   robust   estimators` → `## 2. The Robust Estimators`
- `# 2.1.   B-spline   approximation   of   the   additive   components` → `### 2.1. B-spline Approximation of the Additive Components`
- `# 2.2.   The   robust   MM-estimators` → `### 2.2. The Robust MM-Estimators`
- `# 2.3.   Selection   of   k j` → `### 2.3. Selection of $k_j$`
- `# 2.4.   Regarding   some   other   basis   choices` → `### 2.4. Regarding Some Other Basis Choices`
- `# 3.   Consistency   results` → `## 3. Consistency Results`
- `# 4.   Asymptotic...` → `## 4. Asymptotic Normality`
- `# 5.   Numerical...` → `## 5. Numerical Study`
- `# 6.   Real   data   example` → `## 6. Real Data Example`
- `# 7. Final comments` → `## 7. Final Comments`
- `# Appendix A.   Proofs` → `## Appendix A. Proofs`
- `# References` → `## References`

### page_001
- Title: normalize `# A   robust   spline   approach   in   partially   linear   additive   models` → `# A Robust Spline Approach in Partially Linear Additive Models`
- Authors: bullet-list items → plain line: `**Graciela Boente** and **Alejandra Mercedes Martínez**`
- Affiliations: `- a CONICET...` → `CONICET and Universidad de Buenos Aires, Argentina; CONICET and Universidad Nacional de Luján, Argentina`
- Abstract: change `# a   b   s   t   r   a   c   t` label → `## Abstract`
- Footer footnote prefix `* Corresponding author at:` and email line → DELETE

### page_003 / page_004 duplicate paragraph
Both pages end/begin with the paragraph "To define the robust estimators, as in linear regression, we fi rst compute an S-estimator...". Keep the clean version on page_004, delete the duplicate in page_003.

### page_005 Step list cleanup
The algorithm steps appear both as prose (garbled) and as clean bullet/numbered list. Delete the garbled prose version, keep the clean Step 1 / Step 2 / Step 3 / Step 4 bullet list.

### page_007 — duplicate paragraph
"Remark 3.1. Conditions C1 and C2 are standard conditions..." appears twice (once with multi-spacing, once clean). Delete the multi-spaced version, keep the clean one.

### page_015 — duplicate sentence
"Note that Bias²_j approximate ∫₀¹..." and "Note that Bias²_j approximate ∫₀¹..." appears twice (== == prefix version and clean version). Delete the `= = = Note...` line, keep clean prose paragraph.
Also delete `Some additional plots...available on-line.` duplicate at end.

### page_021 — equation duplicate
Model equation block has a duplicate second line `\log(\mu) = \mu + \beta PRTAIO + ...` — DELETE that duplicate line.

### page_022 — duplicate sentence
"As with the full data set, the classical BIC selected..." appears twice. Delete the second occurrence.

### Figure captions (pages 017–023)
Keep captions that appear on the same page as the figure. Use format:
```
![Alt text](<images/BM2021/imageFileN.png>)

*Fig. N. Caption text.*
```

---

## REPAIR_MATH

### Global patterns in math blocks

**`\intertext{garbled text}`**: appears in many `$$` blocks. The pattern is:
```
...equation line... \\
\intertext { g a r b l e d t e x t }
```
Strip the entire `\intertext{...}` line. Split the equation at that point into two separate `$$` blocks if there is content on both sides, otherwise just remove the line.

**Character-per-line sequences**: Lines like
```
(
)
n
∑
1
r i
...
```
These are completely degenerate OCR table renderings of inline math. DELETE all such sequences (individual math characters on their own lines with no math fences).

**Degenerate `&` chains**: Lines containing nothing but `& & & & & & & ...` (dozens or hundreds of `&`). DELETE the entire `$$` block containing such a line.

**Trailing `\\ \\` in equations**: Change to single `\\` or remove if at end of align.

**Align-style `&=` in display blocks**: Some equations have spurious `&` from align conversion; strip the `&` when inside a lone `$$..$$` (non-aligned) block.

### page_002 — model equation (2)
Current garbled \intertext line inside the PLAM equation:
```
\intertext { w h o r $ \, \sigma \, \text {univariate} $ unknown, }
```
Replace entire block with clean two-line form:
```
$$
Y = \beta^{\mathbb{T}} Z + \eta(\mathbf{X}) + \sigma\,\varepsilon = \mu + \beta^{\mathbb{T}} Z + \sum_{j=1}^{p} \eta_j(X_j) + \sigma\,\varepsilon
$$
```

### page_004 — spline sum equation (before "From now on...")
Current:
```
$$
\sum _ { s = 1 } ^ { k _ { j } } \lambda _ { s } ^ { ( j ) } B _ { s } ^ { ( j ) } ( x ) & = ... \intertext { s u n t i g h s c r { O } } \text {From now on, we denote } K = ...
$$

= = From   now   on, we denote K = ...
```
Replace with clean equation only:
```
$$
\sum_{s=1}^{k_j} \lambda_s^{(j)} B_s^{(j)}(x) = \sum_{s=1}^{k_j - 1} \left(\lambda_s^{(j)} - \lambda_{k_j}^{(j)}\right) B_s^{(j)}(x)
$$
```
Delete the `= = From   now   on,` repeated prose (keep the clean version that follows).

### page_004 — residuals equation
Current trailing `\\ \\` artifact:
```
r _ { i } ( a , b , c ) = ... = Y _ { i } - a - b ^ { T } Z _ { i } - c ^ { T } V _ { i } , \\ \\
```
Strip to:
```
$$
r_i(a, b, c) = r_i(a, b, c^{(1)}, \dots, c^{(p)}) = Y_i - a - b^T Z_i - \sum_{j=1}^{p} \sum_{s=1}^{k_j - 1} c_s^{(j)} B_s^{(j)}(X_{ij}) = Y_i - a - b^T Z_i - c^T V_i
$$
```
Also fix `k - j - 1` → `k_j - 1` in the subscript.

### page_004 — M-scale equation (implicit equation block above "where 0 < b < 1")
The character-per-line sequence (lines: `(`, `)`, `n`, `∑`, `1`, `r i`, `a`, `b`, `c`, ...) → DELETE these lines.
Keep only the clean `$$` block that follows with `\frac{1}{n-q-K}\sum...`.

### page_005 — MM estimator definition blocks
The two heavily garbled `$$` blocks containing `\widehat{\mathfrak c}`, `\argmin`, `& = \mathcal{J}` etc.:
- First block: garbled loss function minimization — DELETE (replaced by clean Step prose)
- Second block: garbled `\hat\eta` definition — DELETE (replaced by clean Step prose)

### page_005 — RBIC equation
Current garbled block:
```
$$
i \text { needed. As in He et al. ( 2002), a robust BIC criterion may be defined as follows} \\
RBIC(k) = & \log \left(...\right) + \frac{\log(n)}{2n}\sum_{j=1}^{p} k_j, \\ &   5
$$
```
Replace with clean equation:
```
$$
\mathrm{RBIC}(k) = \log\!\left(\hat{\sigma}^2 \sum_{i=1}^{n} \rho_1\!\left(\frac{r_i}{\tilde{\sigma}}\right)\right) + \frac{\log(n)}{2n}\sum_{j=1}^{p} k_j
\tag{8}
$$
```
Delete the embedded prose (`i \text { needed...}`) from the equation block.

### page_006 — degenerate RBIC(k) single-k version
Current:
```
$$
to & & & & ... (hundreds of &) ...
$$
```
DELETE this entire `$$` block.

Keep the prose that follows: `RBIC(k) = log σ ∑ ρ₁(rᵢ/σ̃) + (p/2n)k` — rewrite as:
```
$$
\mathrm{RBIC}(k) = \log\!\left(\hat{\sigma}^2 \sum_{i=1}^{n} \rho_1\!\left(\frac{r_i}{\tilde{\sigma}}\right)\right) + \frac{p\log(n)}{2n} k
\tag{9}
$$
```

### page_006 — Bernstein polynomial basis definition (within 2.4)
Current garbled block:
```
$$
k _ { j } \text { are defined taking in Step 1} \\
\widetilde { B } _ { s } ^ { ( j ) } ( x ) & = \binom { k _ { j } } { s } x ^ { s } ( 1 - x ) ^ { k _ { j } - s } \quad \text {for } s = 0 , \dots , k _ { j } . \\
\intertext { l n p a r i c u l a r , ...}
$$
```
Replace with:
```
$$
\widetilde{B}_s^{(j)}(x) = \binom{k_j}{s} x^s (1-x)^{k_j - s}, \quad s = 0, \dots, k_j
$$
```

### page_006 — approximation error bound (within 2.4)
Current garbled:
```
$$
f _ { j } \text {-derivative} ... \intertext { f a r i m a t i o n } \text {Approximation} ...
$$
```
Replace with clean:
```
$$
\|\tilde{\eta}_j - \eta_j\|_\infty = O\!\left(k_j^{-r_j}\right) \tag{10}
$$
```
Delete the duplicate prose paragraph "Approximation (10) is a key point..." that follows (keep only one copy).

### page_007 — H_r definition
Equation block looks clean. Keep as-is.

### page_007 — scale functional equation
```
$$
\mathbb{E}\rho_0\left(\frac{r(a,b,g_1,\dots,g_p)}{S(a,b,g_1,\dots,g_p)}\right) = b \. \\ \text{Henceforth} \, \text{ the scale estimators are calibrated}
$$
```
Strip the `\\ \text{Henceforth...}` tail line, end block before it:
```
$$
\mathbb{E}\rho_0\!\left(\frac{r(a,b,g_1,\dots,g_p)}{S(a,b,g_1,\dots,g_p)}\right) = b
$$
```
Keep the prose "Henceforth, the scale estimators are calibrated so that" as standalone paragraph.

### pages 008–012 (Consistency theorems)
Inspect each `$$` block during repair. Pattern to apply:
- If block contains `\intertext{garbled}`: strip the intertext line, optionally split block
- If block contains `& & & &` chains: DELETE entire block
- If block looks clean: KEEP as-is with minor normalization

### page_015 — ise/Bias equations
Current garbled block with integral and sum:
```
$$
\int _ { J , c } ( \int _ { t } ^ { M } \exp ... & \text{and} \quad \beta\text{ias}^2 = ...
$$
```
Replace with:
```
$$
\widehat{\mathrm{ise}}_{j,\ell} = \frac{1}{M}\sum_{s=1}^{M} \bigl(\widehat{\eta}_{j,\ell}(t_s) - \eta_j(t_s)\bigr)^2, \qquad \mathrm{Bias}_j^2 = \frac{1}{M}\sum_{s=1}^{M} \left(\frac{1}{N}\sum_{\ell=1}^{N} \widehat{\eta}_{j,\ell}(t_s) - \eta_j(t_s)\right)^2
$$
```

### page_021 — model equation for MEDV
Current has a duplicate `\log(\mu) = ...` line in the block. Remove it:
```
$$
\mathrm{MEDV} = \mu + \beta\,\mathrm{PTRATIO} + \eta_1(\mathrm{RM}) + \eta_2(\log(\mathrm{TAX})) + \eta_3(\log(\mathrm{LSTAT})) + \sigma\,\varepsilon
$$
```

### pages 025–034 (Appendix A proofs)
Strategy: Keep section headings, theorem/lemma/proposition statements (prose-level), and math blocks that are reasonably clean. DELETE:
- Entire `$$` blocks containing garbled `\intertext{...}` where the equation itself is also garbled
- Character-per-line sequences (individual symbols on separate lines)
- Repeated prose paragraphs that duplicate content above a math block
- `⎩ ⎭` bracket artifacts

For blocks that have a garbled first line but a clean equation body:
- Strip the garbled line, keep the rest
