# Manifest: Page 007

## REPAIR_MATH
- RAW: ```
\liminf _ { N \to \infty } \mathbb { P } ( P E ( D _ { N } ( \lambda _ { - } ) ) - P E ( D _ { N } ( \lambda _ { + } ) ) \geq \Delta ) = 1 .
```
  FIX: ```
$$
\liminf _ { N \to \infty } \mathbb { P } ( P E ( D _ { N } ( \lambda _ { - } ) ) - P E ( D _ { N } ( \lambda _ { + } ) ) \geq \Delta ) = 1 .
$$
```
- RAW: ```
P E ( D _ { N } ( \lambda _ { + } ) ) \xrightarrow { \mathbb { P } } P E ( D _ { + } ) .
```
  FIX: ```
$$
P E ( D _ { N } ( \lambda _ { + } ) ) \xrightarrow { \mathbb { P } } P E ( D _ { + } ) .
$$
```
- RAW: ```
p _ { ^ { * } } = \frac { \ell _ { ^ { * } } } { L _ { - } } \geq \frac { \delta } { L _ { - } } > 0 . \\
```
  FIX: ```
$$
p _ { ^ { * } } = \frac { \ell _ { ^ { * } } } { L _ { - } } \geq \frac { \delta } { L _ { - } } > 0 . \\
$$
```
- RAW: ```
P E ( D _ { - } ) \geq - p _ { * } \log p _ { * } > 0 .
```
  FIX: ```
$$
P E ( D _ { - } ) \geq - p _ { * } \log p _ { * } > 0 .
$$
```
- RAW: ```
P E ( D _ { N } ( \lambda _ { - } ) ) \xrightarrow { \mathbb { P } } P E ( D _ { - } ) .
```
  FIX: ```
$$
P E ( D _ { N } ( \lambda _ { - } ) ) \xrightarrow { \mathbb { P } } P E ( D _ { - } ) .
$$
```
- RAW: ```
P E ( D _ { N } ( \lambda _ { - } ) ) - P E ( D _ { N } ( \lambda _ { + } ) ) \geq \Delta .
```
  FIX: ```
$$
P E ( D _ { N } ( \lambda _ { - } ) ) - P E ( D _ { N } ( \lambda _ { + } ) ) \geq \Delta .
$$
```

- RAW: ```
- for λ > λ c , all bars in D + have lifetimes at most ε .
```
  FIX: ```
• for \( \lambda > \lambda_c \), all bars in \( D_+ \) have lifetimes at most \( \varepsilon \).
```
- RAW: ```
Then for any λ − < λ c < λ + , there exists a constant ∆ > 0 such that
```
  FIX: ```
Then for any \( \lambda_- < \lambda_c < \lambda_+ \), there exists a constant \( \Delta > 0 \) such that
```
- RAW: ```
Ordered phase ( λ > λ c ). By assumption (B), all bars in the limiting diagram D + have lifetimes at most ε . Since D + has finite total persistence, its normalized lifetime distribution is concentrated on uniformly small weights. Consequently, the persistent entropy of D + is small; in the limiting case in which all lifetimes vanish one has PE ( D + ) = 0 , and more generally PE ( D + ) ≤ c ( ε ) for some function c ( ε ) → 0 as ε → 0 . By assumption (A) and continuity of persistent entropy on the relevant class of diagrams,
```
  FIX: ```
Ordered phase (\( \lambda > \lambda_c \)). By assumption (B), all bars in the limiting diagram \( D_+ \) have lifetimes at most \( \varepsilon \). Since \( D_+ \) has finite total persistence, its normalized lifetime distribution is concentrated on uniformly small weights. Consequently, the persistent entropy of \( D_+ \) is small; in the limiting case in which all lifetimes vanish one has \( PE(D_+) = 0 \), and more generally \( PE(D_+) \leq c(\varepsilon) \) for some function \( c(\varepsilon) \to 0 \) as \( \varepsilon \to 0 \). By assumption (A) and continuity of persistent entropy on the relevant class of diagrams,
```
- RAW: ```
Disordered phase ( λ < λ c ). By assumption (B), the limiting diagram D − contains at least one bar with lifetime ℓ ⋆ ≥ δ . Let L − denote the total persistence of D − . The normalized weight of this bar satisfies ℓ δ
```
  FIX: ```
Disordered phase (\( \lambda < \lambda_c \)). By assumption (B), the limiting diagram \( D_- \) contains at least one bar with lifetime \( \ell^\star \geq \delta \). Let \( L_- \) denote the total persistence of \( D_- \). The normalized weight of this bar satisfies
```
- RAW: ```
Conclusion. Combining the two limits, there exists ∆ > 0 such that, with probability tending to one as N → ∞ , PE ( D N ( λ )) PE ( D N ( λ + )) ∆ .
```
  FIX: ```
Conclusion. Combining the two limits, there exists \( \Delta > 0 \) such that, with probability tending to one as \( N \to \infty \),
```

## REPLACE_TABLES

None

## REPAIR_PROSE

- RAW: ```
By assumption (A) and continuity of persistent entropy on the relevant class of diagrams,

By assumption (A) and continuity of persistent entropy on the relevant class of diagrams,
```
  FIX: ```
By assumption (A) and continuity of persistent entropy on the relevant class of diagrams,
```
- RAW: ```
# Remark 1.
```
  FIX: ```
**Remark 1.**
```
- RAW: ```
Remark 2. Continuity of persistent entropy. Persistent entropy is not uniformly continuous on the space of all persistence diagrams under the bottleneck distance, due to the instability induced by arbitrarily many near-diagonal bars. The theorem relies only on continuity along the convergent sequence of diagrams, which is ensured under mild regularity assumptions or by explicit truncation of small lifetimes.
```
  FIX: ```
**Remark 2. Continuity of persistent entropy.** Persistent entropy is not uniformly continuous on the space of all persistence diagrams under the bottleneck distance, due to the instability induced by arbitrarily many near-diagonal bars. The theorem relies only on continuity along the convergent sequence of diagrams, which is ensured under mild regularity assumptions or by explicit truncation of small lifetimes.
```
