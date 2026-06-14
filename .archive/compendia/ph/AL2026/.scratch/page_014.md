[Page 14]

(2) By the Yoneda lemma, we have an isomorphism

$$
$$
M ( x ) \rightarrow H o m _ { A } ( P _ { x } , M ) , \ \ m \mapsto \rho _ { m } ^ { M } \ ( m \in M ( x ) ) ,
$$
$$

where \( \rho_m^M \colon P_x \to M \) is a morphism \( (\rho_{m,y}^M \colon P_x(y) \to M(y))_{y \in P} \) defined by \( \rho_{m,y}^M(p) \coloneqq M(p)(m) (= p \cdot m) \) for all \( y \in P \) and \( p \in P_x(y) = A(x,y) \), where \( M(p) \colon M(x) \to M(y) \) is a structure linear map of \( M \). Sometimes we just write \( \rho_m^M(p) \coloneqq M(p)(m) \) by omitting \( y \).

Similarly, by considering an \( A \)-module \( N \) to be a right \( A \)-module, we have an isomorphism

$$
$$
N ( x ) \to H o m _ { A ^ { o p } } ( P _ { x } ^ { \prime } , N ) , \ \ m \mapsto \lambda _ { m } ^ { N } \left ( m \in N ( x ) \right ) ,
$$
$$

where \( \lambda_m^N \colon P_x^\prime \to N \) is defined by \( \lambda_m^N(p) \coloneqq N(p)(m) (= m \cdot p) \).

- (3) For a morphism \( p_{y,x} \colon x \to y \) in \( P \), we set \( M_{y,x} \) to be the linear map \( M(p_{y,x}) \colon M(x) \to M(y) \).
- (4) Since \( p_{y,x} \in A(x,y) = P_x(y) \), we can set \( P_{y,x} \coloneqq \rho_{p_{y,x}} \colon P_y \to P_x \). We note here that \( P_{y,x} = 0 \) if \( x \not\le y \) in \( P \). Similarly, we set \( p^{op}_{x,y} \coloneqq p_{y,x} \in P^{op}(y,x) = P(x,y) \) for all \( (x,y) \in [\le]_P \). It induces a morphism \( P^\prime_{x,y} \coloneqq \rho_{p^{op}_{x,y}} \colon P^\prime_x \to P^\prime_y \) in \( \text{mod } A^{op} \).


To shorten the formula, we introduce the following notation.

**Notation 2.8.** Let \( M \in \text{mod } A \), and

$$
$$
\mu \colon \bigoplus _ { j \in [ n ] } P _ { y _ { j } } \to \bigoplus _ { i \in [ m ] } P _ { x _ { i } }
$$
$$

a morphism between projective modules of the form \( \mu \coloneqq [a_{ji} P_{y_j, x_i}]_{(i,j) \in [m] \times [n]} \) with \( a_{ji} \in k \) for some \( x_1, x_2, \dots, x_m, y_1, y_2, \dots, y_n \in P \). Then we set \( M(\mu) \colon \bigoplus_{i \in [m]} M(x_i) \to \bigoplus_{j \in [n]} M(y_j) \) to be the linear map defined by the matrix

$$
$$
M ( \mu ) \coloneqq [ a _ { j i } M _ { y _ { j } , x _ { i } } ] _ { ( j , i ) \in [ n ] \times [ m ] } .
$$
$$

The right-hand side is obtained from \( \mu \) by first replacing the letter \( P \) with \( M \), and then making the transpose.

We here make the following remark.

**Remark 2.9.** Since both \( P_{y,x} = \rho_{p_{y,x}} \colon P_y \to P_x \) and \( M_{y,x} = M(p_{y,x}) \colon M(x) \to M(y) \) are defined by \( p_{y,x} \) for all \( x,y \in P \), we can think that both \( \mu \) and \( M(\mu) \) come from the common matrix \( \alpha \coloneqq [a_{ji} p_{y_j, x_i}]_{(j,i) \in [n] \times [m]} \) with entries in \( k[P](x_i, y_j) = k p_{y_j, x_i} \) regarded as a morphism \( (x_1, \dots, x_m) \to (y_1, \dots, y_n) \), where we set \( a_{ji} p_{y_j, x_i} \coloneqq 0 \) unless \( x_i \le y_j \). This point of view is formalized as the formal additive hull \( k[P] \) of \( k[P] \).
