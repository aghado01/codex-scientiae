[Page 12]

But the conditional independence structure of the infinite-dimensional filtering model implies that the conditional expectation inside this expression depends only on \( X_l^v \) and \( Y_l^v \) for \( 0 \leq l \leq k \) and \( |v| \leq m + 1 \). We are thus faced with the problem of obtaining a lower bound on this finite-dimensional quantity that is uniform in \( k, m \).

To lighten the notation, it will be convenient to view \( ( X_k^v )_{k,v \in \mathbb{Z}} \) not as a sequence of spatial random fields on \( \mathbb{Z} \), but rather as a single space-time random field on \( \mathbb{Z}^2 \). To this end, we will write \( X_q := X_k^v \) for \( q = ( k,v ) \in \mathbb{Z}^2 \). We will similarly write \( Y_{qr} := \bar{Y}_k^v \) and \( \xi_{qr} := \bar{\xi}_k^v \) if \( q = ( k - 1 ,v ) \) and \( r = ( k,v ) \), and \( Y_{qr} := \hat{Y}_k^v \) and \( \xi_{qr} := \hat{\xi}_k^v \) if \( q = ( k,v ) \) and \( r = ( k,v + 1) \) (the order of the indices \( q,r \) is irrelevant, that is, \( Y_{qr} := Y_{rq} \) etc.) In this manner, we can view \( X = ( X_q )_{q \in \mathbb{Z}^2} \) as a random field on the lattice \( \mathbb{Z}^2 \), with observations \( Y_{qr} \) attached to each edge \( \{ q,r \} \subset \mathbb{Z}^2 \) with \( \| q - r \| = 1 \).

Lemma 3.4. Suppose that \( 0 < p \leq 1 / 2 \), and let \( k,m \geq 1 \). Define \( \beta := \log (1 - p) / p \), \( J := [1, k] \times [-m, m] \), and \( \partial J := \{ 0 \} \times [-m, m] \cup [1, k] \times \{ -m - 1, m + 1 \} \). For any given configuration \( x \in \{ -1, 1 \}^{\mathbb{Z}^2} \), we define the random measure \( \Sigma \) on \( \{ -1, 1 \}^J \) as

$$
\Sigma ^ { x } ( \{ z \} ) \colon = \frac { 1 } { Z } \exp \left ( \beta \left \{ \sum _ { \{ q , r \} \subseteq J \colon | q - r | = 1 } \xi ^ { q r } x ^ { q } x ^ { r } z ^ { q } z ^ { r } + \sum _ { q \in J , r \in \partial J \colon | q - r | = 1 } \xi ^ { q r } x ^ { q } z ^ { q } \right \} \right ) ,
$$

where \( Z \) is the normalization such that \( \Sigma^x ( J ) = 1 \). Then

$$
E [ ( X ^ { q } ) _ { q \in J } \in A | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k } , \{ X _ { 1 } ^ { v } , \dots , X _ { k } ^ { v } \colon | v | > m \} ] = \Sigma ^ { X } ( A ) .
$$

Proof. By the conditional independence structure of the ﬁltering model, we have

$$
E [ ( X ^ { q } ) _ { q \in J } \in A | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k } , \{ X _ { 1 } ^ { v } , \dots , X _ { k } ^ { v } \colon | v | > m \} ] = \\ E [ ( X ^ { q } ) _ { q \in J } \in A | ( X ^ { q } ) _ { q \in \partial J } , ( Y ^ { q r } ) _ { q \in J , r \in J \cup \partial J , \| q - r \| = 1 } ] .
$$

The joint distribution of the random variables that appear in this expression is

$$
\mathbf P [ ( X ^ { q } ) _ { q \in J \cup \partial J } = z , ( Y ^ { q r } ) _ { q \in J , r \in J \cup \partial J , \| q - r \| = 1 } & = y ] = 2 ^ { - | J \cup \partial J | } \times \\ \prod _ { \{ q , r \} \subseteq J \colon | q - r | = 1 } \sqrt { p ( 1 - p ) } \, e ^ { \beta y ^ { q r } z ^ { q } } \prod _ { q \in J , r \in J \cup \colon | q - r | = 1 } \sqrt { p ( 1 - p ) } \, e ^ { \beta y ^ { q r } z ^ { q } } ,
$$

where \( |A| \) denotes the cardinality of a set \( A \). The result now follows readily from the Bayes formula and the fact that \( Y_{qr} = X_q X_r \xi_{qr} \) by construction.

Lemma 3.4 shows that the conditional distribution \( \mathbf{P} [ \cdot | X_0, Y_1, \dots, Y_k, \{ X_1^v, \dots, X_k^v \colon |v| > m \} ] \) has a familiar form in statistical mechanics: it is (up to the change of variables or gauge transformation \( \sigma_q = x_q z_q \)) an Ising model with random interactions, also known as a random bond Ising model or an Ising spin glass, with inverse temperature \( \beta = \log (1 - p) / p \). The failure of stability of the filter for large \( \beta \) can now be addressed using a standard method in statistical mechanics [5, section 6.4]. For concreteness, we include the requisite arguments in the present setting, which completes the proof.

Remark 3.5. For the beneﬁt of readers who are not familiar with ideas from statistical mechanics, we provide a brief description of the Peierls argument that is used below.

In Lemma 3.4, one should interpret \( x \) as the true configuration of the underlying system, and \( z \) as the configuration in the set \( J \) that is reconstructed from the noisy observations.
