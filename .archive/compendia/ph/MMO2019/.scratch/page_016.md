[Page 16]

## Maroulas, Mike, and Oballe

permutation π ∈ Π N ; however, the ordering within each derivative is unrelated the choice of i j , leading to j !-fold and ( N − j )!-fold redundancy within each term.

Taking Eq. (4.5) together with Eq. (3.7) yields

$$
\frac { \delta \beta _ { D ^ { \ell } } } { \delta \xi _ { \pi ( j + 1 ) \dots \delta \xi _ { \pi ( N ) } } ( \emptyset ) = ( N - j ) ! \nu ( N - j ) \prod _ { j = 1 } ^ { N - j } p ^ { \ell } ( \xi _ { j } ) .
$$

Also, Eq. (3.9) and Eq. (3.7) yield

$$
\frac { \delta \beta _ { D ^ { u } } } { \delta \xi _ { \pi ( 1 ) } \dots \delta \xi _ { \pi ( j ) } } ( \emptyset ) = \sum _ { \pi ^ { * } \in \Pi _ { j } } \sum _ { \gamma \in I ( j , N _ { u } ) } \mathcal { Q } ( \gamma ) \prod _ { k = 1 } ^ { j } p ^ { ( \gamma ( k ) ) } ( \xi _ { \pi ^ { * } ( k ) } ) .
$$

We substitute these relations into the ﬁnal expression of Eq. (4.7). The ﬁrst of these substitutions is straightforward, while the second has j !-fold redundant permutations overtop the existing permutations in Π N . These substitutions yield that δ N β D δξ 1 ...δξ N ( ∅ ) = π ∈ Π N K σ ( Z, D ) as described in Eq. (4.6) and shows that the kernel K σ ( Z, D ) satisﬁes the deﬁnition of a global pdf for D (Def. 13). Finally, the sum over permutations is removed according to Eq. (3.7) to obtain the expression for f D ( Z ) = K σ ( Z, D ).

Remark 26 A speciﬁc example of the component distributions provided for the kernel in Proposition 25 is presented in Fig. 3. Since the kernel density K σ of Eq. (4.6) is a probability density according to Def. 13, it is a function on ∪ M N =0 W N 0: − 1 , and so the sum of several such kernels is deﬁned by adding each local pdf layer separately.

Remark 27 In the deﬁnition of our kernel, a single parameter σ has been chosen for both the split of center diagrams, as well as the standard deviation used in the Gaussians which build our kernel. Without loss of generality, this choice simpliﬁes the presentation of the kernel density and the proof of kernel density estimate (KDE) convergence (Theorem 31). In general, the bandwidth parameter σ 2 which refers to the standard deviation used to deﬁne the Gaussians (as σ appears in Defs. 22 and 24) need not be equal to the splitting parameter σ 1 which determines which points are in D u or D (as σ appears in Eq. (4.1) ). Still, it is certainly desirable that σ 1 = Cσ 2 when taking a limit of KDEs as the number of persistence diagrams grows to inﬁnity (Theorem 31). For a ﬁxed kernel bandwidth σ 2 , increasing C (and thus σ 1 ) moves more features into the lower portion of the diagram. This choice may be useful in practice when underlying data are known to be noisy and more noise-related features are expected near the diagonal. By the same token, for σ 1 >> σ 2 , projecting the lower features onto the diagonal may lead to signiﬁcant error in the approximation. On the other hand, taking σ 1 << σ 2 eliminates the computational beneﬁt of splitting the diagram and is probably not useful in practice. For most cases, taking σ 1 = σ 2 , is a reasonable balance between KDE accuracy and evaluation computation.

Since the kernel density is a probability density function for a random persistence diagram, it has an associated probability hypothesis density (See Def. 18).

Corollary 28 Fix a center persistence diagram D and bandwidth σ > 0 . Split D into D and D u according to Eq. (4.1) . Deﬁne D with global pdf from Eq. (4.5) , and D u with global pdf from
