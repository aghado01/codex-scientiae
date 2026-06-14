[Page 36]

and \( M_{4', 4} \) to be \( \begin{bmatrix} 1 \\ 0 \end{bmatrix} \) and \( \begin{bmatrix} 1 & 0 & 0 \end{bmatrix} \), respectively, then

![image 5](<AL2026/imageFile5.png>)




Hence \( d_{M'}(V_I) = 1 \), which coincides with the answer obtained from the decomposition \( M' \cong V_I \oplus V_{[1, 4]} \oplus V_{[\{2, 1'\}, 4']} \). These decompositions can be easily seen by drawing the structure quivers of \( M, M' \):

![image 6](<AL2026/imageFile6.png>)

$$

$$

where \( M \) is given by solid arrows, and \( M' \) is given by both solid and broken arrows, bases of \( M(i) \) are denoted by \( i \) or \( i_a \) (\( a \in \{x, y, z\} \)) for all \( i \in P \).

# 3.3 Reducing candidates of the interval direct summands

Given a module \( M \in \operatorname{mod} A \), we reduce the number of intervals \( I \in \mathcal{I} \) to compute the multiplicity \( d_M(V_I) \) by removing some intervals \( I \) such that \( V_I \) cannot be a direct summand of \( M \), namely \( I \) with \( d_M(V_I) = 0 \), by an easy criterion.

We set the support of \( M \) to be

$$
\operatorname{supp}_P M \coloneqq \{ x \in P \mid M(x) \neq 0 \}.
$$


We denote by \( \operatorname{rad} M \) the radical of \( M \), which is, by definition, the intersection of all maximal submodules of \( M \), and set \( \operatorname{top} M \coloneqq M / \operatorname{rad} M \), called the top of \( M \). Dually, we set \( \operatorname{soc} M \) to be the sum of all simple submodules of \( M \), called the socle of \( M \). Recall that an epimorphism \( P \to M \) with \( P \) projective is a projective cover of \( M \) if and only if it induces an isomorphism \( \operatorname{top} P \to \operatorname{top} M \). Dually, a monomorphism \( M \to Q \) with \( Q \) injective is an injective hull of \( M \) if and only if it restricts to an isomorphism \( \operatorname{soc} M \to \operatorname{soc} Q \). It is easy to see that if \( N \) is a direct summand of \( M \), then \( \operatorname{top} N \) (resp. \( \operatorname{soc} N \)) is a direct summand of \( \operatorname{top} M \) (resp. \( \operatorname{soc} M \)). Hence

$$
\operatorname{supp}(\operatorname{top} N) \subseteq \operatorname{supp}(\operatorname{top} M) \quad \text{and} \quad \operatorname{supp}(\operatorname{soc} N) \subseteq \operatorname{supp}(\operatorname{soc} M).
$$

Here we introduce the following notation:
