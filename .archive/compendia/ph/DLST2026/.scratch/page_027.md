[Page 27]

Proof. To show that \( B_Q \) is a block decomposition of \( A \) consider \( \varphi \in \operatorname{eSol}_V ( A ) \). Since \( B \) is a block decomposition, there exists \( p \in P \) such that \( \operatorname{uim}^+_V \varphi \subset B_p \). The fact that \( \operatorname{uim}^+_V \subset A \) implies that \( p \in Q \). The same argument holds for \( \operatorname{uim}^-_V \varphi \), therefore (B1) is satisfied. Condition (B2) follows immediately by taking the restriction of the partial order on \( P \) to \( Q \), because \( \operatorname{Paths}_V ( A ) \subset \operatorname{Paths}_V ( X ) \).

We show first that \( \operatorname{Inv}_V A \subset C_V ( B_Q^\bullet ,A ) \). Consider \( \varphi \in \operatorname{eSol}_V ( A ) \). Since \( B_Q^\bullet \) is a Morse decomposition of \( A \), by (M1), there are \( q,q^\prime \in Q \) such that \( \operatorname{uim}^-_V \varphi \subset M_q \subset B_q \) and \( \operatorname{uim}^+_V \varphi \subset M_{q^\prime} \subset B_{q^\prime} \), where \( M_q := \operatorname{Inv}_V B_q \in B_Q^\bullet \). Therefore, every point in \( \operatorname{im} \varphi \) belongs to a path from \( M_q \) to \( M_{q^\prime} \); hence, \( \operatorname{im} \varphi \subset C_V ( B_Q^\bullet ,A ) \).

To see \( C_V ( B_Q^\bullet ,A ) \subset \operatorname{Inv}_V C_V ( B_Q ,A ) \), fix \( q,q^\prime \in Q \) and consider a path \( \rho \in \operatorname{Paths}_V ( M_q ,M_{q^\prime} ,A ) \). By Proposition 5.9, we can extend \( \rho \) to an essential solution \( \varphi \) with \( \operatorname{uim}^- \varphi \subset M_q \subset B_q \) and \( \operatorname{uim}^+ \varphi \subset M_{q^\prime} \subset B_{q^\prime} \). Thus, \( \operatorname{im} \rho \subset \operatorname{im} \varphi \subset \operatorname{Inv}_V C_V ( B_Q ,A ) \).

Finally, let \( \varphi \in \operatorname{eSol}_V (\operatorname{Inv}_V C_V ( B_Q ,A )) \). Clearly, \( \varphi \in \operatorname{eSol}_V ( A ) \), and therefore, \( \operatorname{im} \varphi \subset \operatorname{Inv}_V A \), which shows the equalities in the second statement. \square

Proof of Theorem 5.7. The first statement in (a) is a special case of Lemma 5.10. To see the second, consider a path \( \rho \in \operatorname{Paths}_{V_1} ( B_{p, 1} ,B_{p^\prime, 1} ,X ) \) for some \( p,p^\prime \in Q \). Since \( \rho \) is also a path in \( V_2 \) we have \( \rho \in \operatorname{Paths}_{V_2} ( B_{q, 2} ,B_{q, 2} ,X ) \). Thus, \( \operatorname{im} \rho \subset B_{q, 2} \) by (B2)(b).

To see (b), note that by Proposition 4.24, \( B_{q, 2} \) is an isolating block in \( V_1 \); thus, by definition \( B_{q, 2} \) isolates \( M_{Q, 1} \). The second part follows from the fact that \( B_{Q, 1} \subset B_{q, 2} \) (by (a)) and the second part of Lemma 5.10.

To show (c), note that (b) implies that \( B_{q, 2} \) is an isolating block for \( M_{Q, 1} \) in \( V_1 \), and by definition \( B_{q, 2} \) is an isolating block for \( M_{q, 2} \) in \( V_2 \). Since \( M_{Q, 1} \) and \( M_{q, 2} \) share the same isolating block, they are related by continuation. \square

5.2. Transition diagram for a basic zigzag filtration. In this section we focus on a special type of zigzag filtration of block decompositions. Namely, we say that \( B \) is a basic zigzag filtration if for every \( \lambda \in \Lambda \), depending on the type of the map, we have:

$$
    | \stackrel { \leftarrow } { \iota } _ { \lambda } ^ { - 1 } ( p ) | \leq 2 \text { for every } p \in \mathbb { P } _ { \lambda } , \ \text { or } \ \left | \stackrel { \rightarrow } { \iota } _ { \lambda } ^ { - 1 } ( r ) \right | \leq 2 \text { for every } r \in \mathbb { P } _ { \lambda + 1 } .
$$

In other words, at each step of the zigzag filtration, an isolating block can split into at most two other isolating blocks when \( B_\lambda \sqsupseteq B_{\lambda +1} \), or an isolating block can merge with at most one other to create a new larger isolating block in step \( \lambda + 1 \) when \( B_\lambda \sqsubseteq B_{\lambda +1} \). Therefore, each observed combinatorial bifurcation is a split into an attractor-repeller pair.

Definition 5.11 (Index triple). Let \( B = \{ B_a ,B_r \} \) be a block decomposition for an isolating block \( B \) both in \( V \); thus, inducing an attractor-repeller pair (see Proposition 4.15). Then, a triple \( N_0 \subset N_1 \subset N_2 \) of closed sets is called an index triple if \( ( N_1 ,N_0 ) \), \( ( N_2 ,N_1 ) \) and \( ( N_2 ,N_0 ) \) form index pairs for \( M_a := \operatorname{Inv}_V B_a \), \( M_r := \operatorname{Inv}_V B_r \) and \( M := \operatorname{Inv}_V B \), respectively. Moreover, we assume that \( B_a \subset N_1 \setminus N_0 \), \( B_r \subset N_2 \setminus N_1 \), and \( B \subset N_2 \setminus N_0 \). In particular, the triple induces diagrams called AR-split diagrams (see diagram ( 5.2 )).
