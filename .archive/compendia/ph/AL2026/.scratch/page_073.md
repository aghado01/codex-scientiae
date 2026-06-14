[Page 73]

The obtained formulas (6.86), (6.87), (6.88), (6.92), (6.93), (6.94), (6.95) suggest us to consider the essential covering of the bipath poset. As a rough description, it suffices to consider two special subposets of \( B_{n,m} \) that are of Dynkin type \( A \), and decompose the restricted module in each respective module category. This strategy of decomposing the bipath persistence module can utilize the fast computation of zigzag persistence. Another remarkable advantage is that our strategy does not consider the basis changes at the global minimum and maximum elements, which is the key difference compared with the original decomposition method proposed by Aoki–Escolar–Tada in Aoki et al. ( 2024 ).

Let \( Z \) be a poset having the Hasse quiver

![The image depicts a sequence of numbers, which are represented by arrows. The sequence starts with 1 and ends with 0. The sequence starts with 1 and ends with 0. The sequence is represented by a sequence of numbers, which are connected by arrows. The arrows are labeled with the numbers 1, 2, 3, ..., n. The sequence starts with 1 and ends with 0. The sequence is represented by a sequence of numbers, which are connected by arrows. The arrows are labeled with the numbers 1, 2, 3, ..., n. The sequence starts with 1 and ends with 0. The sequence is represented by a sequence of numbers, which are connected by arrows. The arrows are labeled with the numbers 1, 2, 3, ..., n. The sequence starts with 1 and ends with 0. The sequence is represented by a sequence of numbers, which are connected by arrows. The arrows are labeled with](<AL2026/imageFile22.png>)

(6.96)




and define the order-preserving map \( \zeta \colon Z \to P \) by \( \zeta(x) \coloneqq x \) if \( x \in Z \setminus \{0\} \), and \( \zeta(0) \coloneqq \hat{0} \). Then we have the following.

Proposition 6.6. Let \( \zeta \) be an order-preserving map defined above, and let \( R \) be the restriction functor induced by \( \zeta \). Then for every interval \( I \in \mathcal{I}_d \sqcup \mathcal{I}_u \sqcup \mathcal{I}_r \sqcup \{ B_{n,m} \} \) and every \( M \in \operatorname{mod} k[P] \), we have

$$
d _ { M } ( V _ { I } ) = \bar { d } _ { R ( M ) } ( R ( V _ { I } ) ) = d _ { R ( M ) } ( R ( V _ { I } ) ) .
$$

Proof We recall the \( \bar{d} \) notation given in Notation 4.15. The second equality of (6.97) holds since \( R(V_I) \) is the indecomposable module in \( \operatorname{mod} k[Z] \) for every interval \( I \in \mathcal{I}_d \sqcup \mathcal{I}_u \sqcup \mathcal{I}_r \sqcup \{ B_{n,m} \} \). It suffices to show that \( \zeta \) essentially covers every \( I \in \mathcal{I}_d \sqcup \mathcal{I}_u \sqcup \mathcal{I}_r \sqcup \{ B_{n,m} \} \) by Theorem 4.16.

- (i) Let \( I = B_{n,m} \). Then it is obvious that there exists a morphism \( g^\prime \coloneqq p_{\hat{1}, \hat{0}} \) in \( k[Z] \) such that \( \zeta(g^\prime) = p_{\hat{1}, \hat{0}} \) in \( k[P] \), and hence \( \zeta \) essentially covers \( B_{n,m} \) by (6.86).
- (ii) Let \( I \in \mathcal{I}_d \). This case is trivial by observing (6.88) and the definition of \( \zeta \).
- (iii) Let \( I \in \mathcal{I}_u \). Write \( I \coloneqq [s, t] \) for some \( s, t \in [n] \). All cases are trivial except \( s = 1 \). If \( I = [1, t] \), then by (6.87) the morphism in \( k[P] \) can be taken as


$$
g \coloneqq \left [ \frac { p _ { t + 1 , 1 } \left | \ 0 \, \right \rangle } { p _ { t , 1 } \left | p _ { t , \hat { 0 } } \right | } \right ] .
$$

Let

$$
g ^ { \prime } \coloneqq \left [ \frac { p _ { t + 1 , 1 } } { p _ { t , 1 } } \Big | _ { p _ { t , \bar { 0 } } } \right ] .
$$

Then \( g^\prime \) is the morphism in \( k[Z] \) satisfying \( \zeta(g^\prime) = g \). (iv) Let \( I \in \mathcal{I}_r \). This case is also trivial by observing (6.94), (6.95), and the definition of \( \zeta \).
