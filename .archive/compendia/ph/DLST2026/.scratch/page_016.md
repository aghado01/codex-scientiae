[Page 16]

Definition 4.8. (Block decomposition) [ 38 , Definition 7.2.5] A collection \( (\mathcal{B}, \mathbb{P}) \coloneqq \{ B_p \mid p \in \mathbb{P} \} \) of mutually disjoint, non-empty isolating blocks is called a block decomposition of \( S \subset X \) in \( \mathcal{V} \) if there exists a partial order \( (\mathbb{P}, \leq) \) such that

- (B1) for every \( \varphi \in \text{eSol}_{\mathcal{V}}(S) \) there exist \( p, q \in \mathbb{P} \) such that \( \text{uim}^- \varphi \subset B_p \) and \( \text{uim}^+ \varphi \subset B_q \),
- (B2) if there exists \( \rho \in \text{Paths}_{\mathcal{V}}(S) \) with \( \rho^\sqsubset \in B_p \) and \( \rho^\sqsupset \in B_q \) for some \( p, q \in \mathbb{P} \) then either


- (a) \( p > q \), or
- (b) \( p = q \) and \( \text{im } \rho \subset B_p \).


If additionally

$$
( B 3 ) \ S = \bigcup _ { p \in \mathbb { P } } B _ { p } ,
$$

then we call \( (\mathcal{B}, \mathbb{P}) \) a block partition of \( S \).

Remark 4.9 . By Corollary 4.5 every Morse decomposition is also a block decomposition.

The concept of block decomposition was introduced in [ 38 ]; however the authors refer to its elements as simply blocks, not (combinatorial) isolating blocks. Also note, that in various works on multivector fields, the definition of the Morse decomposition varies depending on context. In particular, Definition 4.7 coincides with the one introduced in [ 33 , 32 ]. However, in papers focused on algorithms or computations [ 17 , 19 , 15 ], “Morse decomposition” refers to what we call a block partition. With the distinction between Morse and block decompositions we intend to avoid this ambiguity.

We write \( \mathcal{M} \) or \( \mathcal{B} \) for a Morse or a block decomposition, respectively, omitting \( \mathbb{P} \) when it can be deduced from the context. We call the minimal order satisfying (M2) or (B2) the flow induced order. Any extension of the partial order \( (\mathbb{P}, \leq) \) to a linear order is called an admissible linear order for \( \mathcal{M} \) or \( \mathcal{B} \).

There is a simple correspondence between block and Morse decompositions. Namely, as we prove in the next proposition, every \( \mathcal{B} \) induces the Morse decomposition

$$
\mathcal { B } _ { \bullet , \nu } \coloneqq \{ \text {Inv} _ { \mathcal { V } } ( B _ { p } ) \, | \, p \in \mathbb { P } \text { such that } \text {Inv} _ { \mathcal { V } } ( B _ { p } ) \neq \emptyset \} .
$$


We omit \( \mathcal{V} \) when it is clear from the context and write \( \mathcal{B}_\bullet \). We say that a block decomposition \( \mathcal{B} \) covers Morse decomposition \( \mathcal{M} \) if \( \mathcal{B}_\bullet = \mathcal{M} \). By Remark 4.9, every Morse decomposition admits at least one (trivial) covering block decomposition.

Proposition 4.10. Let \( (\mathcal{B}, \mathbb{P}) \) be a block decomposition of \( S \). Then \( \mathcal{B}_\bullet \) is a Morse decomposition of \( S \).

Proof. Let \( \varphi \in \text{eSol}_{\mathcal{V}}(S) \). By (B1), there exist \( p, q \in \mathbb{P} \) such that \( \text{uim}^- \varphi \subset B_p \) and \( \text{uim}^+ \varphi \subset B_q \). As a consequence of [33, Proposition 6.5], \( \text{Inv}_{\mathcal{V}}(\text{uim}^\pm \varphi) = \text{uim}^\pm \varphi \); therefore, we conclude (M1), because of

$$
\text {Inv} _ { \mathcal { V } } ( \text {uim} ^ { - } \varphi ) \subset \text {Inv} _ { \mathcal { V } } ( B _ { p } ) \in \mathcal { B } _ { \bullet } \quad \text {and} \quad \text {Inv} _ { \mathcal { V } } ( \text {uim} ^ { + } \varphi ) \subset \text {Inv} _ { \mathcal { V } } ( B _ { q } ) \in \mathcal { B } _ { \bullet } .
$$

Consider \( p, q \in \mathbb{P} \) and denote \( M_p \coloneqq \text{Inv}_{\mathcal{V}}(B_p) \) and \( M_q \coloneqq \text{Inv}_{\mathcal{V}}(B_q) \). Assume that there exists a path \( \rho \in \text{Paths}_{\mathcal{V}}(M_p, M_q, S) \). Clearly \( M_p \subset B_p \) and \( M_q \subset B_q \). Hence, if \( p \neq q \) and \( p > q \) in \( \mathcal{B} \) then \( p \neq q \) and \( p > q \) in the induced order on \( \mathcal{B}_\bullet \). If \( p = q \) then, in particular exist essential solutions \( \psi \in \text{eSol}_{\mathcal{V}}(\rho^\sqsubset, M_p) \) and \( \psi^\prime \in \text{eSol}_{\mathcal{V}}(\rho^\sqsupset, M_p) \). Let \( \psi^+ \) denote the restriction of \( \psi \) to \( [0, +\infty)_\mathbb{Z} \) and \( \psi^{\prime -} \), the restriction of \( \psi^\prime \) to \( (-\infty, 0]_\mathbb{Z} \). It is easy to verify that \( \varphi \coloneqq \psi^{\prime -} \cdot \rho \cdot \psi^+ \) is an essential solution in \( B_p \). Therefore, \( \text{im } \rho \subset \text{im } \varphi \subset \text{Inv}_{\mathcal{V}}(M_p) \), which shows (M2) and concludes the proof. \(\square\)


