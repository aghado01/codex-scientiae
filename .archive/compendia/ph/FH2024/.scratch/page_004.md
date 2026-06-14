[Page 4]

# 2.2.1 One-parameter persistence landscapes

Let \( M \) be a one-parameter persistence module, i.e. a functor \( M \colon \mathbb{R} \to \text{vec} \). For any indices \( a,b \in \mathbb{R} \), we define the rank function \( \beta_0 \colon \mathbb{R}^2 \to \mathbb{N} \) as follows:

$$
\beta _ { 0 } ( a , b ) \colon = \begin{cases} \dim ( \text {im} ( M ( a \leq b ) ) ) & \text {if } a \leq b , \\ 0 & \text {otherwise.} \end{cases}
$$

A change of coordinates \( m \coloneqq \frac{a + b}{2} \) and \( h \coloneqq \frac{b - a}{2} \) leads to a function that is supported on the upper half plane instead of being supported above the diagonal. By this rescaling, one changes from coordinates that correspond to births and deaths to coordinates that correspond to midpoints and half-lives of the features. This function is called the rescaled rank function \( \beta \colon \mathbb{R}^2 \to \mathbb{N} \):

$$
\beta ( x , h ) \coloneqq \begin{cases} \dim ( \text {im} ( M ( x - h \leq x + h ) ) ) & \text {if } h \geq 0 , \\ 0 & \text {otherwise} . \end{cases}
$$

**Definition 2.2** (Persistence landscapes [4])

Let \( M \colon \mathbb{R} \to \text{vec} \) be a one-parameter persistence module. The persistence landscape of \( M \) is defined as a sequence of functions \( \lambda_k \colon \mathbb{R} \to \mathbb{R} \cup \{-\infty, \infty\} \) with

$$
\lambda _ { k } ( x ) \colon = \sup \{ h \geq 0 \ \colon \ \beta ( x , h ) \geq k \} .
$$

In other words, \( \lambda_k(t) \) is the maximal half-length of an interval being centered at \( x \) and is contained in at least \( k \) intervals of the barcode [40]. In Figure 1, one can see an example of a persistence diagram and the corresponding persistence landscape.

**Remark 2.3** A simple way to calculate the persistence landscape is given by the observation in [4] that for a persistence diagram \( \{ ( b_i, d_i ) \}_{i=1}^n \) the landscape can be determined as

$$
\lambda _ { k } ( x ) = \, k \text {-th largest value of max} \left ( \min ( x - b _ { i } , d _ { i } - x ) , 0 \right ) .
$$

**Remark 2.4** It is known that the barcode and the one-parameter persistence landscape determine each other and hence, the persistence landscape is also a complete invariant. Since zigzag persistent modules also decompose into a direct sum of interval modules one can define barcodes and hence, persistence landscapes also in the case of zigzag persistence. Analogously to the case of one-parameter persistence modules, we obtain a complete invariant.

# 2.2.2 Multiparameter persistence landscape

In [40], Vipond generalized the notions of rescaled rank invariant and persistence landscapes to multiparameter persistence modules in a natural way.

In the following, let \( (\mathbb{R}^n, \leq) \) be the poset defined such that \( a \leq b \) if and only if \( a_i \leq b_i \) for all \( i = 1, \dots, n \).

**Definition 2.5** Let \( M \) be a multiparameter persistence module, then the rank function \( \beta_0 \colon \mathbb{R}^{2n} \to \mathbb{N} \) of \( M \) for \( a,b \in \mathbb{R}^n \) is defined as

$$
\beta _ { 0 } ( a , b ) \colon = \begin{cases} \dim ( \text {im} ( M ( a \leq b ) ) ) & \text {if } a \leq b , \\ 0 & \text {otherwise} . \end{cases}
$$
