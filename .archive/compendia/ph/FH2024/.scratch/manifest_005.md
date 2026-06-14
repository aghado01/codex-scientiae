# Manifest: Page 005

## REPAIR_PROSE
- RAW: ```
- 1st Landscape
- 2nd Landscape


2.5



1.5

4 death



0.5




0 -0.5



















birth
```
  FIX: ```
```

## REPAIR_MATH
- RAW: ```
\beta ( x , h ) \coloneqq \begin{cases} \dim ( \text {im} ( M ( x - h \leq x + h ) ) ) & \text {if } h \geq 0 , \\ 0 & \text {otherwise} . \end{cases}
```
  FIX: ```
$$
\beta ( x , h ) \coloneqq \begin{cases} \dim ( \text {im} ( M ( x - h \leq x + h ) ) ) & \text {if } h \geq 0 , \\ 0 & \text {otherwise} . \end{cases}
$$
```
- RAW: ```
\lambda _ { k } ( x ) \colon = \sup \{ \varepsilon \geq 0 \ \colon \ \beta ( x , h ) \geq k \ \text { for all } h \geq 0 \ \text { with } \| h \| _ { \infty } \leq \varepsilon \} .
```
  FIX: ```
$$
\lambda _ { k } ( x ) \colon = \sup \{ \varepsilon \geq 0 \ \colon \ \beta ( x , h ) \geq k \ \text { for all } h \geq 0 \ \text { with } \| h \| _ { \infty } \leq \varepsilon \} .
$$
```
- RAW: ```
landscapes λ 1 and λ 2 .
```
  FIX: ```
landscapes \( \lambda_1 \) and \( \lambda_2 \).
```
- RAW: ```
The rescaled rank function β : 2 n → is defined as
```
  FIX: ```
The rescaled rank function \( \beta \colon \mathbb{R}^{2n} \to \mathbb{R} \) is defined as
```
- RAW: ```
k features persist in every (positive) direction through x in the parameter space
```
  FIX: ```
\( k \) features persist in every (positive) direction through \( x \) in the parameter space
```
- RAW: ```
Lemma 2.7 Let M be a multiparameter persistence module with rank function β 0 ( · , · ) . Let 1 ∈ n be the vector where every entry is 1 . For all h ≥ 0 we have β 0 ( x − ∥ h ∥ ∞ 1 ,x + ∥ h ∥ ∞ 1) ≤ β 0 ( x − h,x + h ) .
```
  FIX: ```
Lemma 2.7 Let \( M \) be a multiparameter persistence module with rank function \( \beta_0 ( \cdot , \cdot ) \). Let \( \mathbf{1} \in \mathbb{R}^n \) be the vector where every entry is \( 1 \). For all \( h \geq 0 \) we have \( \beta_0 ( x - \| h \|_\infty \mathbf{1}, x + \| h \|_\infty \mathbf{1} ) \leq \beta_0 ( x - h, x + h ) \).
```
- RAW: ```
compute sup { ε ≥ 0 : β 0 ( x − ε 1 ,x + ε 1) ≥ k } in order to get the value of the multiparameter persistence landscape λ k at point x .
```
  FIX: ```
compute \( \sup \{ \varepsilon \geq 0 : \beta_0 ( x - \varepsilon \mathbf{1}, x + \varepsilon \mathbf{1} ) \geq k \} \) in order to get the value of the multiparameter persistence landscape \( \lambda_k \) at point \( x \).
```
- RAW: ```
for large k the landscape is non-zero
```
  FIX: ```
for large \( k \) the landscape is non-zero
```
