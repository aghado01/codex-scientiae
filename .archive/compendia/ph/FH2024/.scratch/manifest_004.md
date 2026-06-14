# Manifest: Page 004

## REPAIR_MATH
- RAW: ```
\beta _ { 0 } ( a , b ) \colon = \begin{cases} \dim ( \text {im} ( M ( a \leq b ) ) ) & \text {if } a \leq b , \\ 0 & \text {otherwise.} \end{cases}
```
  FIX: ```
$$
\beta _ { 0 } ( a , b ) \colon = \begin{cases} \dim ( \text {im} ( M ( a \leq b ) ) ) & \text {if } a \leq b , \\ 0 & \text {otherwise.} \end{cases}
$$
```
- RAW: ```
\beta ( x , h ) \coloneqq \begin{cases} \dim ( \text {im} ( M ( x - h \leq x + h ) ) ) & \text {if } h \geq 0 , \\ 0 & \text {otherwise} . \end{cases}
```
  FIX: ```
$$
\beta ( x , h ) \coloneqq \begin{cases} \dim ( \text {im} ( M ( x - h \leq x + h ) ) ) & \text {if } h \geq 0 , \\ 0 & \text {otherwise} . \end{cases}
$$
```
- RAW: ```
\lambda _ { k } ( x ) \colon = \sup \{ h \geq 0 \ \colon \ \beta ( x , h ) \geq k \} .
```
  FIX: ```
$$
\lambda _ { k } ( x ) \colon = \sup \{ h \geq 0 \ \colon \ \beta ( x , h ) \geq k \} .
$$
```
- RAW: ```
\lambda _ { k } ( x ) = \, k \text {-th largest value of max} \left ( \min ( x - b _ { i } , d _ { i } - x ) , 0 \right ) .
```
  FIX: ```
$$
\lambda _ { k } ( x ) = \, k \text {-th largest value of max} \left ( \min ( x - b _ { i } , d _ { i } - x ) , 0 \right ) .
$$
```
- RAW: ```
\beta _ { 0 } ( a , b ) \colon = \begin{cases} \dim ( \text {im} ( M ( a \leq b ) ) ) & \text {if } a \leq b , \\ 0 & \text {otherwise} . \end{cases}
```
  FIX: ```
$$
\beta _ { 0 } ( a , b ) \colon = \begin{cases} \dim ( \text {im} ( M ( a \leq b ) ) ) & \text {if } a \leq b , \\ 0 & \text {otherwise} . \end{cases}
$$
```

## REPAIR_PROSE
- RAW: ```
  # 2.2.1 Oneparameter persistence landscapes
  ```
  FIX: ```
  # 2.2.1 One-parameter persistence landscapes
  ```
- RAW: ```
  Let M be oneparameter persistence module, i.e. a functor M : → vec . For any indices a,b ∈ , we define the rank function β 0 : 2 → as follows:
  ```
  FIX: ```
  Let \( M \) be a one-parameter persistence module, i.e. a functor \( M \colon \mathbb{R} \to \text{vec} \). For any indices \( a,b \in \mathbb{R} \), we define the rank function \( \beta_0 \colon \mathbb{R}^2 \to \mathbb{N} \) as follows:
  ```
- RAW: ```
  A change of coordinates m := a + b 2 and h := b − a 2 leads to a function that is supported on the upper half plane instead of being supported above the diagonal. By this rescaling, one changes from coordinates that correspond to births and deaths to coordinates that correspond to midpoints and half-lives of the features. This function is called the rescaled rank function β : 2 → :
  ```
  FIX: ```
  A change of coordinates \( m \coloneqq \frac{a + b}{2} \) and \( h \coloneqq \frac{b - a}{2} \) leads to a function that is supported on the upper half plane instead of being supported above the diagonal. By this rescaling, one changes from coordinates that correspond to births and deaths to coordinates that correspond to midpoints and half-lives of the features. This function is called the rescaled rank function \( \beta \colon \mathbb{R}^2 \to \mathbb{N} \):
  ```
- RAW: ```
  Definition 2.2 (Persistence landscapes [4])
  ```
  FIX: ```
  **Definition 2.2** (Persistence landscapes [4])
  ```
- RAW: ```
  Let M : → vec be a oneparameter persistence module. The persistence landscape of M is defined as a sequence of functions λ k : → ∪ {−∞ , ∞} with
  ```
  FIX: ```
  Let \( M \colon \mathbb{R} \to \text{vec} \) be a one-parameter persistence module. The persistence landscape of \( M \) is defined as a sequence of functions \( \lambda_k \colon \mathbb{R} \to \mathbb{R} \cup \{-\infty, \infty\} \) with
  ```
- RAW: ```
  In other words, λ k ( t ) is the maximal half-length of an interval being centered at x and is contained in at least k intervals of the barcode [40]. In Figure 1, one can see an example of a persistence diagram and the corresponding persistence landscape.
  ```
  FIX: ```
  In other words, \( \lambda_k(t) \) is the maximal half-length of an interval being centered at \( x \) and is contained in at least \( k \) intervals of the barcode [40]. In Figure 1, one can see an example of a persistence diagram and the corresponding persistence landscape.
  ```
- RAW: ```
  Remark 2.3 A simple way to calculate the persistence landscape is given by the observation in [4] that for a persistence diagram { ( b i ,d i ) } n i =1 the landscape can be determined as
  ```
  FIX: ```
  **Remark 2.3** A simple way to calculate the persistence landscape is given by the observation in [4] that for a persistence diagram \( \{ ( b_i, d_i ) \}_{i=1}^n \) the landscape can be determined as
  ```
- RAW: ```
  Remark 2.4 It is known that the barcode and the oneparameter persistence landscape determine each other and hence, the persistence landscape is also a complete invariant. Since zigzag persistent modules also decompose into a direct sum of interval modules one can define barcodes and hence, persistence landscapes also in the case of zigzag persistence. Analogously to the case of oneparameter persistence modules, we obtain a complete invariant.
  ```
  FIX: ```
  **Remark 2.4** It is known that the barcode and the one-parameter persistence landscape determine each other and hence, the persistence landscape is also a complete invariant. Since zigzag persistent modules also decompose into a direct sum of interval modules one can define barcodes and hence, persistence landscapes also in the case of zigzag persistence. Analogously to the case of one-parameter persistence modules, we obtain a complete invariant.
  ```
- RAW: ```
  In the following, let ( n , ≤ ) be the poset defined such that a ≤ b if and only if a i ≤ b i for all i = 1 ,...,n .
  ```
  FIX: ```
  In the following, let \( (\mathbb{R}^n, \leq) \) be the poset defined such that \( a \leq b \) if and only if \( a_i \leq b_i \) for all \( i = 1, \dots, n \).
  ```
- RAW: ```
  Definition 2.5 Let M be a multiparameter persistence module, then the rank function β 0 : 2 n → of M for a,b ∈ n is defined as
  ```
  FIX: ```
  **Definition 2.5** Let \( M \) be a multiparameter persistence module, then the rank function \( \beta_0 \colon \mathbb{R}^{2n} \to \mathbb{N} \) of \( M \) for \( a,b \in \mathbb{R}^n \) is defined as
  ```
