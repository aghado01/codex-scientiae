[Page 12]

# Lemma 3.3 The persistence landscapes have the properties:

- 1. \( \lambda_k(x) \geq 0 \),
- 2. \( \lambda_k(x) \geq \lambda_{k+1}(x) \),
- 3. \( \lambda_k \) is 1-Lipschitz.


Proof: The first two properties follow directly from the definition. For the third, we want to show that \( |\lambda_k(y) - \lambda_k(x)| \leq d_m(y,x) \) for all \( x,y \in \mathbb{Z} \times \mathbb{Z} \). Without loss of generality, we assume that \( \lambda_k(y) \geq \lambda_k(x) \geq 0 \). If \( \lambda_k(y) \leq d_m(y,x) \), then \( \lambda_k(y) - \lambda_k(x) \leq \lambda_k(y) \leq d_m(y,x) \) and we are done. Thus, we assume that \( \lambda_k(y) > d_m(y,x) \). Consider \( (h,h) \in \mathbb{Z} \times \mathbb{Z} \), where \( h = \lambda_k(y) - d_m(y,x) \). It follows that \( \lambda_k(y) - h = d_m(y,x) \), and hence, that \( y - (\lambda_k(y), \lambda_k(y)) \leq x - (h,h) \) as well as \( x + (h,h) \leq y + (\lambda_k(y), \lambda_k(y)) \). In total,

$$
y - ( \lambda _ { k } ( y ) , \lambda _ { k } ( y ) ) \leq x - ( h , h ) \leq x + ( h , h ) \leq y + ( \lambda _ { k } ( y ) , \lambda _ { k } ( y ) )
$$

and so \( R_h^x \subset R_{\lambda_k(y)}^y \) and Lemma 2.15 applies, so \( \operatorname{rank} R_{\lambda_k(y)}^y \leq \operatorname{rank} R_h^x \). With \( \lambda_k(x) \geq h = \lambda_k(y) - d_m(y,x) \) the result follows. □

One might ask for the connection between landscapes of an extended zigzag module \( M \) and the persistence landscapes of restrictions of \( M \) along lines in the zigzag or homogeneously filtered direction. The following proposition answers this question and follows directly from the respective definitions.

Proposition 3.4 Let \( M : \mathbb{Z} \times \mathbb{Z} \to \mathrm{vec} \) and \( l \subset \mathbb{Z} \times \mathbb{Z} \) be a line in the horizontal or vertical direction, i.e. \( l = \{ (a,b) \mid a \in \mathbb{Z} \} \) for some \( b \in \mathbb{Z} \) or \( l = \{ (a,b) \mid b \in \mathbb{Z} \} \) for some \( a \in \mathbb{Z} \). Let \( \lambda(M|_l) \) be the landscape of the one-parameter persistence module or the zigzag persistence module, whichever applies. Then,

$$
\lambda ( M ) \leq \lambda ( M | _ { l } ) .
$$

Under some finiteness assumptions the defined spatiotemporal persistence landscapes can be viewed as being elements of the Banach spaces \( L^p(\mathbb{R}^2) \). To achieve this, we can restrict to the case where the persistence modules are defined on a bounded set in \( \mathbb{Z} \times \mathbb{Z} \). For applications, this is a reasonable assumption since only finitely many values for the spatial parameter \( \epsilon_1, \dots, \epsilon_n \) are chosen and all time series are finite. Consequently, the values of the landscapes are finite. Being elements of a Banach space, on the space of persistence landscapes we have a notion of distance.

Definition 3.5 Let \( M \) and \( N \) be extended zigzag modules such that the respective landscapes are elements of \( L^p(\mathbb{R}^2) \). The \( p \)-landscape distance \( d_\lambda^p \) is defined as

$$
d _ { \lambda } ^ { p } ( M , N ) = \| \lambda ( M ) - \lambda ( N ) \| _ { p } .
$$

Example 3.6 Notice that the landscape distance is only a pseudo-distance on the space of isomorphism classes of persistence modules. For example, the two modules \( M = I_{R_1}(2, 2) \oplus I_{R_1}(2, 3) \) and \( N = I_{R_1}(2, 2) \cup R_1(2, 3) \) have the same persistence landscape, however, they are clearly not isomorphic. As an immediate consequence, the spatiotemporal persistence landscapes are not a complete invariant.
