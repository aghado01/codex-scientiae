# Repair Manifest — DMGK2001

Paper: "Bayesian curve-fitting with free-knot splines"
Authors: Ilaria Di Matteo, Christopher R. Genovese, Robert E. Kass
Journal: Biometrika 88 (2001), 1055–1071

---

## DELETE

- page_001: Author heading — H1 `# B  ILARIA D  MATTEO , CHRISTOPHER R . GENOVESE  ROBERT E . KASS` → convert to bold plain text (handled under REPAIR_PROSE)
- page_015: Funding acknowledgement paragraph — begins "This research was partially supported by grants from the U.S. National Science Foundation and National Institutes of Health."
- page_017: Dateline at end — `[Received February 2000. Revised May 2001]`

OCR axis debris (all the exploded figure axis tick labels scattered as isolated lines):

- page_008: Everything from `(b) Example 2` through `(c) Example 3` / `(a) Example 1` and all isolated numbers/letters (`6`, `2`, `4`, `10`, `1`, `2`, `f`, `(`, `x`, `)` etc.) before the imageFile1.png line; AND the isolated numbers/axis labels after the imageFile1.png line down to but not including `Fig. 1.`
- page_009: All isolated lines between the closing of Table 1 and `Fig. 2.` — the panel labels `(`, `)`, `f`, `x`, numbers, `(a) SARS`, `0·0`, `0·2`... `1·0`, `(b) DMS`, `(c) ModiﬁedDMS`, `(d) BARS` axis blocks, and the `![...](<images/imageFile2.png>)` image alt-text if no figure reference is clear; keep the imageFile2.png image line and `Fig. 2.` caption
- page_010: Isolated axis tick numbers after imageFile3.png: `2000`, `1950`, `1900`, `1850`, `60`, `0`, `10`, `20`, `30`, `40`, `50`, `Time (sec)`, `(b)`, `Experiment 2`, `600`, `500`, `400`, `300`, `0`, `200`, `400`, `Time (sec)`, `600`, `800` — keep imageFile3.png and Fig. 3 caption
- page_011: Isolated axis debris after imageFile4.png: `(b)`, `(c)`, `(a)` labels and all isolated numbers `600`, `500`, `400`, `300`, `0`, `200`, `400`, `600`, `800`, `Time (sec)` blocks — keep imageFile4.png and Fig. 4 caption
- page_012: Isolated axis numbers before Fig. 5 caption: `600`, `500`, `400`, `300`, `0`, `200`, `400`, `600`, `800`, `Time (sec)` — keep imageFile5.png and Fig. 5 caption
- page_013: Isolated axis debris: `(a) Condition 1`, `250`, `200`, `150`, `100`, `50`, `0`, `_` lines, `795`, `605`, `405`, `205`, `5`, `195`, `395`, `595`, `795`, `Time (msec)`, `250`, `(b) Condition 2`, `200`, `150`, `100`, `50`, `0`, `_` lines, `795`, `605`, `405`, `205`, `5`, `Time (msec)`, `195`, `395`, `595`, `795` — keep imageFile6.png and Fig. 6 caption

---

## FIX_IMAGES

All six images use the same broken pattern — apply `replace_all: true`:
- `<images/imageFile1.png>` → `<images/DMGK2001/imageFile1.png>`
- `<images/imageFile2.png>` → `<images/DMGK2001/imageFile2.png>`
- `<images/imageFile3.png>` → `<images/DMGK2001/imageFile3.png>`
- `<images/imageFile4.png>` → `<images/DMGK2001/imageFile4.png>`
- `<images/imageFile5.png>` → `<images/DMGK2001/imageFile5.png>`
- `<images/imageFile6.png>` → `<images/DMGK2001/imageFile6.png>`

---

## REPLACE_TABLES

Both tables degenerate in the JSON extraction — reconstruct manually from source data.

**Table 1** (page_009, caption "Simulation study. Average mean squared errors..."):

Current garbled header row `| |||Modiﬁed||` and following rows have data. Replace entire table block with:

```
| | SARS | DMS | Modified DMS | BARS |
|---|---|---|---|---|
| Example 1 | 0.144 (0.030) | 0.206 (0.029) | 0.103 (0.019) | 0.066 (0.007) |
| Example 2 | 0.015 (0.001) | 0.025 (0.002) | 0.012 (0.001) | 0.008 (0.001) |
| Example 3 | 0.044 (0.006) | 0.106 (0.007) | 0.091 (0.004) | 0.019 (0.003) |
```

Also fix the Methods caption line below the table:
Old: `Methods:  , spatially adaptive regression splines;  , Denison et al. (1998); Modiﬁed , modiﬁed Denison et al.;  , Bayesian adaptive regression splines.`
New: `*Methods: SARS, spatially adaptive regression splines; DMS, Denison et al. (1998); Modified DMS, modified Denison et al.; BARS, Bayesian adaptive regression splines.*`

**Table 2** (page_014, caption "Neuronal firing example..."):

Current source already has a pipe table but with OCR middle-dots and a ligature. Replace with:

```
| Firing rate | Condition 1 | Condition 2 |
|---|---|---|
| Maximum | 166.5 (5.2) | 193.0 (20.6) |
| Local min. | 34.8 (1.9) | 11.5 (1.5) |
| Difference | 131.8 (4.4) | 181.8 (20.4) |
```

---

## REPAIR_PROSE

**Global ligature pass (apply `replace_all: true` across all pages)**:
- `ﬁ` → `fi`
- `ﬂ` → `fl`
- `ﬃ` → `ffi`
- `ﬀ` → `ff`
- `ﬄ` → `ffl`

**Global middle-dot decimal pass (apply `replace_all: true`)**:
- `·` → `.` (OCR middle dot used as decimal separator throughout)

**page_001**: Convert garbled author H1 to bold plain text
- Old: `# B  ILARIA D  MATTEO , CHRISTOPHER R . GENOVESE  ROBERT E . KASS`
- New: `**Ilaria Di Matteo, Christopher R. Genovese and Robert E. Kass**`

**page_001**: Demotion — `# S ` → `## Summary`

**page_001**: Demotion — `# 1 . I ` → `## 1. Introduction`

**page_003**: Demotion — `# 2 . C        ` → `## 2. Choice of Priors`

**page_005**: Demotion — `# 3 . P  ` → `## 3. Posterior Simulation`

**page_005**: Demotion — `# 3·1. Reversible-jump Markov chain Monte Carlo` → `### 3.1. Reversible-Jump Markov Chain Monte Carlo`

**page_006**: Demotion — `# 3·2. Importance reweighting` → `### 3.2. Importance Reweighting`

**page_007**: Demotion — `# 4 . S  ` → `## 4. Simulation Study`

**page_010**: Demotion — `# 5 . F     ` → `## 5. Functional Magnetic Resonance Imaging`

**page_012**: Demotion — `# 6 . A P      ` → `## 6. A Poisson Application: Neuronal Firing`

**page_014**: Demotion — `# 7 . D ` → `## 7. Discussion`

**page_015**: Demotion + rename — `# A  1` → `## Appendix 1` and `# Detailed balance` → `### Detailed Balance`

**page_016**: This page begins with the bare text `Importance sampling` — it is the start of Appendix 2. Replace with `## Appendix 2\n\n### Importance Sampling`

**page_017**: Demotion — `# A  3` → `## Appendix 3` and `# Posterior approximations` → `### Posterior Approximations`

**page_017**: Demotion — `# R ` → `## References`

**page_004**: Stray `@` at end of paragraph — delete the trailing ` @` character at end of paragraph ending "...becomes a generalised linear model (McCullagh & Nelder, 1989). @"

**page_009**: Table caption fix (see REPLACE_TABLES above for full text replacement)

---

## REPAIR_MATH

**page_002, eq (3)** — garbled tail with `\varrho` and `\text{WS}` OCR debris:
```
Raw:
f ( x ) & = \sum _ { j = 1 } ^ { k + 2 } \beta _ { j } b _ { j } ( x ) & ( 3 ) \\ \varrho & \quad \text {WS} \ \ 1 &

Fix:
$$
f(x) = \sum_{j=1}^{k+2} \beta_j b_j(x) \tag{3}
$$
```

**page_002, eq (4)** — has embedded garbled `\intertext{a l $ e r $ l o d e...}` OCR prose:
```
Raw: ends with `\\ \intertext { a l $ e r $ l o d e $ ( 1 ) $ ...}`

Fix:
$$
p(y \mid k, \xi) = \int p(y \mid \beta, k, \xi, \sigma)\,\pi(\beta, \sigma \mid k, \xi)\,d\beta\,d\sigma \tag{4}
$$
```

**page_005, eq (8) area** — starts with garbled OCR lead text and ends with embedded prose:
```
Raw: `& \text {uncoharmonic moduler in equation (0) by} \\ & \quad \frac{p(y|k,\xi^c)}{p(y|k,\xi)} \simeq ... = \exp(-\text{BIC/2}), \\ & \text{where } \hat{\beta} \text{ are the least-squares estimates...}`

Fix:
$$
\frac{p(y \mid k, \xi^c)}{p(y \mid k, \xi)} \simeq \frac{1}{\sqrt{n}} \left(\frac{(y - B_{k,\xi}\hat{\beta})^T(y - B_{k,\xi}\hat{\beta})}{(y - B_{k,\xi^c}\hat{\beta}^c)^T(y - B_{k,\xi^c}\hat{\beta}^c)}\right)^{n/2} = \exp(-\text{BIC}/2) \tag{8}
$$
```
The following prose sentence "where $\hat{\beta}$ are the least-squares estimates..." starts the next paragraph as plain text, not inside the math block.

**page_007, large importance sampling expectation** — entire equation block garbled; the structure is a big ratio of integrals collapsing to a weighted sum. Replace the garbled block with:
```
$$
E\{g(\beta, \xi, k) \mid y\}
= \frac{\displaystyle\int\!\cdots\!\int g(\beta, \xi, k)\,\dfrac{q(\beta \mid y, k, \xi)}{\hat{q}(\beta \mid y, \xi, k)}\,\hat{q}(\beta \mid y, k, \xi)\,p(k, \xi \mid y)\,d\beta\,d\xi\,dk}{\displaystyle\int\!\cdots\!\int \dfrac{q(\beta \mid y, k, \xi)}{\hat{q}(\beta \mid y, \xi, k)}\,\hat{q}(\beta \mid y, k, \xi)\,p(k, \xi \mid y)\,d\beta\,d\xi\,dk}
\approx \frac{\sum_l g(\beta^{(l)}, \xi^{(l)}, k^{(l)})\,w(\beta^{(l)}, \xi^{(l)}, k^{(l)})}{\sum_l w(\beta^{(l)}, \xi^{(l)}, k^{(l)})}
$$
```

**page_015, transition probability equations** — the complex underbrace mess should be simplified to the key results:
```
Raw: huge underbrace expression with garbled subscripts ending in `\intertext { where }`

Fix:
$$
\Pr(M_{k-1} \mid M_k) = d_k\,\frac{1}{k}\,\min(1, A),
\qquad
\Pr(M_k \mid M_{k-1}) = b_{k-1}\,\frac{1}{k-1}\sum_i h_B(\xi_{j^*} \mid \xi_i)\,\min(1, B)
$$
```

**page_015, detailed balance verification** — has garbled `\intertext{t h a n s w h a r}` OCR at end of the multi-line equation:
```
Raw ends with: `= \pi ( M _ { k - 1 } ) \, \text {pr} ( M _ { k } | M _ { k - 1 } ).\\ \intertext { t h a n s w h a r } ...`

Fix — strip the garbled intertext tail, keep the valid lines:
$$
\pi(M_k)\,\Pr(M_{k-1} \mid M_k)
= \pi(M_k) d_k \frac{1}{k} A
= \pi(M_k) d_k \frac{1}{k} \frac{\pi(M_{k-1})}{\pi(M_k)} \frac{b_{k-1}(k-1)^{-1}\sum_i h_B(\xi_{j^*}\mid\xi_i)}{d_k k^{-1}}
= \pi(M_{k-1}) b_{k-1} \frac{1}{k-1} \sum_i h_B(\xi_{j^*}\mid\xi_i)
= \pi(M_{k-1})\,\Pr(M_k \mid M_{k-1})
$$
```

**page_016, three garbled importance sampling derivation equations** — consolidate into two clean equations:

First garbled block (starts `\text { need to compute }` and has `= \frac{A}{B}`): replace with
```
$$
E\{g(\beta, \xi, k) \mid y\} = \frac{A}{B}
$$
```

Second garbled block (starts `s y, \text { where }` and expands A and B): replace with
```
$$
A = \frac{\hat{p}(y)}{p(y)}\int\!\cdots\!\int g(\beta, \xi, k)\,\frac{p(y \mid \beta, k, \xi)}{\hat{p}(y \mid \beta, \xi, k)}\,\hat{q}(\beta \mid y, k, \xi)\,p(k, \xi \mid y)\,d\beta\,d\xi\,dk
$$

$$
B = \frac{\hat{p}(y)}{p(y)}\int\!\cdots\!\int \frac{p(y \mid \beta, k, \xi)}{\hat{p}(y \mid \beta, \xi, k)}\,\hat{q}(\beta \mid y, k, \xi)\,p(k, \xi \mid y)\,d\beta\,d\xi\,dk
$$
```

Third garbled block (starts `\frac{y}{y} \int ...`): delete entirely — it is a degenerate duplicate fragment

Fourth garbled block (starts `\text{Therefor}` and has the final ratio): replace with
```
$$
E\{g(\beta, \xi, k) \mid y\}
\approx \frac{\sum_l g(\beta^{(l)}, \xi^{(l)}, k^{(l)})\,w(\beta^{(l)}, \xi^{(l)}, k^{(l)})}{\sum_l w(\beta^{(l)}, \xi^{(l)}, k^{(l)})}
$$
```
