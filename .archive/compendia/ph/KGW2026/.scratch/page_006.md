[Page 6]

Definition 3. Subspace of \( \Lambda_p \) spanned by regular elementary paths

$$
\mathcal { R } _ { p } = \mathcal { R } _ { p } ( V ) \colon = s p a n \{ e _ { i _ { 0 } i _ { 1 } \dots i _ { p } } \ | \ i _ { 0 } i _ { 1 } \dots i _ { p } \ i s \ r e g u l a r \}
$$

Complementary subspace spanned by irregular

$$
\mathcal { N } _ { p } = \mathcal { N } _ { p } ( V ) \coloneqq s p a n \{ e _ { i _ { 0 } i _ { 1 } \cdots i _ { p } } \ | \ i _ { 0 } i _ { 1 } \cdots i _ { p } \ i s \ n o t \ r e g u l a r \}
$$

Observe that \( \partial (e_{121}) = e_{21} - e_{11} + e_{12} \) which implies \( \partial \mathcal{R}_p \not\subset \mathcal{R}_{p-1} \). Since the boundary of irregular term has to contain irregular terms, we have \( \partial \mathcal{N}_p \subset \mathcal{N}_{p-1} \). We have \( \mathcal{N}_p \cap \mathcal{R}_p = \emptyset \) thus \( \Lambda_p = \mathcal{R}_p \oplus \mathcal{N}_p \). So by using isomorphism between chain complexes \( \mathcal{R}_p \simeq \Lambda_p / \mathcal{N}_p \), we can induce a boundary map on \( \mathcal{R}_p \). The induced boundary map \( \partial : \mathcal{R}_p \to \mathcal{R}_{p-1} \) is called a regular boundary map. This map will assign 0 to irregular paths in the image. So, the chain complex of \( V \) can be denoted as \( (\mathcal{R}_p, \partial)_p \).

The induced boundary operator is referred to as the regular boundary operator, while the original boundary map is called the non-regular boundary operator in [8]. From now on, we will denote the regular boundary operator by \( \partial \).

# 2.2.2 Path Complex

Definition 4. A path complex over a set \( V \) is a nonempty collection \( P \) of elementary paths on \( V \) for any \( n \in \mathbb{N} \) with the property:

$$
i f \, i _ { 0 } \cdots i _ { n } \in P , \, t h e n \, i _ { 0 } \cdots i _ { n - 1 } \in P \ a n d \, i _ { 1 } \cdots i _ { n } \in P .
$$

The elementary paths in \( P \) are called allowed while other elementary paths on \( V \) that are not in \( P \) are called non-allowed .

Definition 5. A digraph \( G \) is a pair \( (V, E) \) where \( V \) is the set of vertices and \( E \subset V \times V \) is the set of edges. An edge is called directed \( (\gamma_1, \gamma_2) \in E \) and the direction will be \( \gamma_1 \to \gamma_2 \)

Example 2.2. • An abstract finite simplicial complex \( K \) is a collection of subsets of a finite vertex set \( V \) that satisfies the following property if \( \sigma \in K \), then any subset of \( \sigma \) is also in \( K \). By enumerating the vertices, we can transform \( \sigma \) to an elementary path over \( V \). Denote the new representation as \( P(K) \). So the allowed \( n \)-paths in \( P(K) \) are \( n \)-simplexes. A path complex can be derived from finite simplicial complex.

- A path complex can be derived from digraph \( G \) by taking all paths in \( G \) as allowed paths.

# 2.2.3 Path Homology

For a given path complex \( P \), we define the \( K \)-linear space \( \mathcal{A}_n \) as a span of all elementary \( n \)-paths from \( P \).

$$
\mathcal { A } _ { n } = \mathcal { A } _ { n } ( P ) = s p a n \{ e _ { i _ { 0 } i _ { 1 } \cdots i _ { n } } \ | \ i _ { 0 } i _ { 1 } \cdots i _ { n } \in P \}
$$

\( (\mathcal{A}_n, \partial) \) may not form chain complex all the time. For example, for \( P = \{ e_{0,1}, e_{1,2}, e_{0,1,2} \} \), we have \( \partial (e_{0,1,2}) = e_{1,2} - e_{0,2} + e_{0,1} \) where \( e_{0,2} \) is not allowed.

So we are changing our domain to a restricted version \( \Omega_n \) which is defined as infimum chain complexes

$$
\Omega _ { n } = \Omega _ { n } ( P ) = \{ v \in \mathcal { A } _ { n } \ | \ \partial v \in \mathcal { A } _ { n - 1 } \} .
$$

Observe that \( \partial \Omega_n \subset \Omega_{n-1} \). The elements of \( \Omega_n \) are called \( \partial \)-invariant \( n \)-paths. The homology of \( (\Omega, \partial) \) will be called the path homology groups of the path complex \( P \)

$$
H _ { n } = H _ { n } ( P ) = K e r \partial | _ { \Omega _ { n } } / I m \partial | _ { \Omega _ { n + 1 } } .
$$
