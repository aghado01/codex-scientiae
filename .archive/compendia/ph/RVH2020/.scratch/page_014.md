[Page 14]

Proposition 3.6. There exists an absolute constant 0 < p < 1 / 2 such that

$$
E | E [ X _ { k } ^ { 0 } | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k } , \{ X _ { 1 } ^ { v } , \dots , X _ { k } ^ { v } \colon | v | > m \} ] | \geq \frac { 1 } { 4 }
$$

for every k,m ≥ 1 whenever 0 < p < p .

Proof. Let us ﬁx k,m ≥ 1 throughout the proof, and deﬁne 0 := ( k, 0) ∈ J . We will prove below the following claim: there exists an absolute constant 0 < p < 1 / 2 such that

$$
P \left [ \Sigma ^ { x } ( \{ z \colon z ^ { 0 } = x ^ { 0 } \} ) \geq \frac { 3 } { 4 } \right ] \geq \frac { 1 } { 2 }
$$

whenever 0 < p < p   : that is, when the noise is suﬃciently small, the conditional distribution P [ X 0 k ∈ ·| X 0 ,Y 1 ,...,Y k , { X v 1 ,...,X v k : | v | > m } ] assigns a large probability to the actually realized value of X 0 k at least half of the time (recall Lemma 3.4). Let us complete the proof assuming this claim. Note that Σ x ( { z : z 0 = x 0 } ) ≥ 3 / 4 implies | Σ x ( { z : z 0 = 1 } ) − Σ x ( { z : z 0 = − 1 } ) | ≥ 1 / 2. Thus the above claim implies that

$$
P \left [ | E [ X _ { k } ^ { 0 } | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k } , \{ X _ { 1 } ^ { v } , \dots , X _ { k } ^ { v } \colon | v | > m \} ] | \geq \frac { 1 } { 2 } \left | X _ { 0 } , \dots , X _ { k } \right ] \geq \frac { 1 } { 2 } ,
$$

  where we have used Lemma 3.4 and the fact that { X q } and { ξ qr } are independent. The proof is now completed by a straightforward estimate.

It remains to prove the claim. To this end, we use a Peierls argument. Fix for the time being conﬁgurations x,z ∈ {− 1 , 1 } J . For any J ⊆ J , deﬁne the boundary edges

$$
\mathfrak { E } J ^ { \prime } \coloneqq \{ \{ q , r \} \colon q \in J ^ { \prime } , \ r \in ( J \wedge J ^ { \prime } ) \cup \partial J , \ \| q - r \| = 1 \} .
$$

A subset J ⊆ J is called a contour if it is simply connected, z q = − x q for all { q,r } ∈ E J with q ∈ J , and z r = x r if in addition r ∈ J \ J . We will denote the set of contours as C z,x (note that the deﬁnition of a contour depends on the given conﬁgurations z and x ). If z 0 = − x 0 , then there must exist a contour J ∈ C z,x such that 0 ∈ J : indeed, construct J by choosing the maximal connected subset of J such that 0 ∈ J and z q = − x q for all q ∈ J , and then ‘ﬁll in the holes’ to make J simply connected. Thus

$$
\Sigma ^ { x } ( \{ z \colon z ^ { 0 } = - x ^ { 0 } \} ) \leq \Sigma ^ { x } ( \{ z \colon \exists J ^ { \prime } \in \mathfrak { C } _ { z , x } , \ 0 \in J ^ { \prime } \} ) \leq \sum _ { J ^ { \prime } \ni 0 } \Sigma ^ { x } ( \{ z \colon J ^ { \prime } \in \mathfrak { C } _ { z , x } \} ) .
$$

Now note that, by the deﬁnition of a contour, x q z q = − 1 whenever { q,r } ∈ E J with q ∈ J , and x q x r z q z r = − 1 if in addition r ∈ J \ J . Thus the existence of a contour implies the presence of many such edges. The basic idea of the proof is that the probability that this occurs is small under Σ x due to Lemma 3.4. Let us make this precise.

Lemma 3.7. For any J ⊆ J , we have

$$
\Sigma ^ { x } ( \{ z \colon J ^ { \prime } \in \mathfrak { C } _ { z , x } \} ) \leq \exp \left ( - \, 2 \beta \sum _ { \{ q , r \} \in \mathfrak { C } _ { J ^ { \prime } } } \xi ^ { q r } \right ) .
$$

Proof. Assume without loss of generality that J is simply connected. Let us use for simplicity the convention that z r = x r for r ∈ ∂J . Deﬁne the events

$$
A & = \{ z \colon z ^ { q } = - x ^ { q } \text { and } z ^ { r } = x ^ { r } \text { for } \{ q , r \} \in \mathfrak { E } J ^ { \prime } , \ q \in J ^ { \prime } \} , \\ B & = \{ z \colon z ^ { q } = x ^ { q } \text { and } z ^ { r } = x ^ { r } \text { for } \{ q , r \} \in \mathfrak { E } J ^ { \prime } , \ q \in J ^ { \prime } \} .
$$
