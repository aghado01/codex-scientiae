[Page 47]

Theorem 4.7. Let \( M \in \operatorname{mod} A \) and \( I \) an interval of \( P \). Choose any choice maps \( c : \operatorname{sc}(\Uparrow I) \to \operatorname{sc}(I) \) and \( d : \operatorname{sk}(\Downarrow I) \to \operatorname{sk}(I) \), and any \( (b,a) \in \operatorname{sk}(I) \times \operatorname{sc}(I) \) with \( b \ge a \). Set \( g := g(c, d, (b,a)) \) as in Definition 4.5. Then

\[
d_{M}(V_{I}) = \operatorname{rank} M(g) - \operatorname{rank} M(g_{1}) - \operatorname{rank} M(g_{2}).
\]

Let \( \zeta : Z \to P \) be an order-preserving map with \( Z \) a poset. The order-preserving map \( \zeta \) is uniquely extended to a linear functor \( k[\zeta] : k[Z] \to k[P] \), which induces a functor \( R : \operatorname{mod} k[P] \to \operatorname{mod} k[Z] \), \( M \mapsto M \circ k[\zeta] \). This is called the restriction functor induced by \( \zeta \).

Definition 4.8. Let \( B \) be a linear category, and \( 1 \le m, n \in \mathbb{Z} \). For each \( (j,i) \in [n] \times [m] \), let \( \alpha_{ji} : x_{ji} \to y_{ji} \) be a morphism in \( B \). Then the family \( ( \alpha_{ji} )_{(j,i) \in [n] \times [m]} \) is said to satisfy the matrix condition if \( ( \alpha_{ji} )_{(j,i) \in [n] \times [m]} \) is a morphism in the category \( B \), namely, if for any \( i,p \in [m] \) and \( j,q \in [n] \), we have \( x_{ji} = x_{qp} \) if \( i = p \) and \( y_{ji} = y_{qp} \) if \( j = q \). If this is the case, then by setting \( x_i := x_{1,i} \) and \( y_j := y_{j,1} \), we have \( \alpha_{ji} \in B(x_i, y_j) \) for all \( (j,i) \in [n] \times [m] \), and \( \alpha := ( \alpha_{ji} )_{(j,i) \in [n] \times [m]} : (x_i)_{i \in [m]} \to (y_j)_{j \in [n]} \) becomes a morphism in \( B \).

Lemma 4.9. Let \( \zeta : Z \to P \) be an order-preserving map with \( Z \) a poset, and take a morphism \( \alpha := (\alpha_{ji})_{(j,i) \in [n] \times [m]} : (x_i)_{i \in [m]} \to (y_j)_{j \in [n]} \) in \( k[P] \). Then the following are equivalent:

- (1) There exists a morphism \( \alpha' : x' \to y' \) in \( k[Z] \) such that \( \zeta(\alpha') = \alpha \) (see Example 4.2 for \( \zeta(\alpha') \)).
- (2) There exist maps \( \zeta' : \{ x_i \mid i \in [m] \} \to Z \) and \( \zeta'' : \{ y_j \mid j \in [n] \} \to Z \) with \( \zeta\zeta' = 1 \) and \( \zeta\zeta'' = 1 \) (i.e., these are sections of \( \zeta \)) such that for any nonzero entry \( \alpha_{ji} : x_i \to y_j \) of \( \alpha \), there exists some \( \alpha'_{ji} : \zeta'(x_i) \to \zeta''(y_j) \) with \( \zeta(\alpha'_{ji}) = \alpha_{ji} \).


Proof (1) \(\Rightarrow\) (2). Assume (1). If the morphism \( \alpha' \) has the form \( \alpha' : (x'_i)_{i \in [m]} \to (y'_j)_{j \in [n]} \), then the map \( x_i \mapsto x'_i \) (resp. \( y_j \mapsto y'_j \)) defines the desired section \( \zeta' \) of \( \zeta \) (resp. \( \zeta'' \) of \( \zeta \)). (2) \(\Rightarrow\) (1). Assume (2). Then for any \( (j, i) \in [n] \times [m] \), there exists a morphism \( \alpha'_{ji} : \zeta'(x_i) \to \zeta''(y_j) \) such that \( \zeta(\alpha'_{ji}) = \alpha_{ji} \). Then the family \( (\alpha'_{ji})_{(j,i) \in [n] \times [m]} \) satisfies the matrix condition, and hence \( \alpha' := (\alpha'_{ji})_{(j,i) \in [n] \times [m]} : (\zeta'(x_i))_{i \in [m]} \to (\zeta''(y_j))_{j \in [n]} \) is a morphism in \( k[Z] \), and satisfies \( \zeta(\alpha') = \alpha \). \(\square\)

Definition 4.10. Let \( \zeta : Z \to P \) be an order-preserving map with \( Z \) a poset, and \( \alpha : x \to y \) a morphism in \( k[P] \). We say that \( \zeta \) covers \( \alpha \) if one of the conditions in Lemma 4.9 is satisfied. Note that if this is the case, then \( \zeta \) covers all submatrices of \( \alpha \).

Definition 4.11. Let \( I \) be an interval of \( P \), and \( g := \left( \begin{smallmatrix} g_1 & 0 \\ g_3 & g_2 \end{smallmatrix} \right) : X \oplus X' \to Y \oplus Y' \) a morphism in \( k[P] \). Then \( g \) is called a multiplicity matrix for \( I \) if for any \( M \in \operatorname{mod} A \)
