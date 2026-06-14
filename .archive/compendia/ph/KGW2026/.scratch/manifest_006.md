# Manifest: Page 006

## REPAIR_MATH
- RAW: ```
\mathcal { R } _ { p } = \mathcal { R } _ { p } ( V ) \colon = s p a n \{ e _ { i _ { 0 } i _ { 1 } \dots i _ { p } } \ | \ i _ { 0 } i _ { 1 } \dots i _ { p } \ i s \ r e g u l a r \}
```
  FIX: ```
$$
\mathcal { R } _ { p } = \mathcal { R } _ { p } ( V ) \colon = s p a n \{ e _ { i _ { 0 } i _ { 1 } \dots i _ { p } } \ | \ i _ { 0 } i _ { 1 } \dots i _ { p } \ i s \ r e g u l a r \}
$$
```
- RAW: ```
\mathcal { N } _ { p } = \mathcal { N } _ { p } ( V ) \coloneqq s p a n \{ e _ { i _ { 0 } i _ { 1 } \cdots i _ { p } } \ | \ i _ { 0 } i _ { 1 } \cdots i _ { p } \ i s \ n o t \ r e g u l a r \}
```
  FIX: ```
$$
\mathcal { N } _ { p } = \mathcal { N } _ { p } ( V ) \coloneqq s p a n \{ e _ { i _ { 0 } i _ { 1 } \cdots i _ { p } } \ | \ i _ { 0 } i _ { 1 } \cdots i _ { p } \ i s \ n o t \ r e g u l a r \}
$$
```
- RAW: ```
i f \, i _ { 0 } \cdots i _ { n } \in P , \, t h e n \, i _ { 0 } \cdots i _ { n - 1 } \in P \ a n d \, i _ { 1 } \cdots i _ { n } \in P .
```
  FIX: ```
$$
i f \, i _ { 0 } \cdots i _ { n } \in P , \, t h e n \, i _ { 0 } \cdots i _ { n - 1 } \in P \ a n d \, i _ { 1 } \cdots i _ { n } \in P .
$$
```
- RAW: ```
\mathcal { A } _ { n } = \mathcal { A } _ { n } ( P ) = s p a n \{ e _ { i _ { 0 } i _ { 1 } \cdots i _ { n } } \ | \ i _ { 0 } i _ { 1 } \cdots i _ { n } \in P \}
```
  FIX: ```
$$
\mathcal { A } _ { n } = \mathcal { A } _ { n } ( P ) = s p a n \{ e _ { i _ { 0 } i _ { 1 } \cdots i _ { n } } \ | \ i _ { 0 } i _ { 1 } \cdots i _ { n } \in P \}
$$
```
- RAW: ```
\Omega _ { n } = \Omega _ { n } ( P ) = \{ v \in \mathcal { A } _ { n } \ | \ \partial v \in \mathcal { A } _ { n - 1 } \} .
```
  FIX: ```
$$
\Omega _ { n } = \Omega _ { n } ( P ) = \{ v \in \mathcal { A } _ { n } \ | \ \partial v \in \mathcal { A } _ { n - 1 } \} .
$$
```
- RAW: ```
H _ { n } = H _ { n } ( P ) = K e r \partial | _ { \Omega _ { n } } / I m \partial | _ { \Omega _ { n + 1 } } .
```
  FIX: ```
$$
H _ { n } = H _ { n } ( P ) = K e r \partial | _ { \Omega _ { n } } / I m \partial | _ { \Omega _ { n + 1 } } .
$$
```

## REPLACE_TABLES
*(No tables found on this page)*

## REPAIR_PROSE
- RAW: ```
Definition 3. Subspace of Λ p spanned by regular elementary paths
```
  FIX: ```
Definition 3. Subspace of \( \Lambda_p \) spanned by regular elementary paths
```
- RAW: ```
Observe that ∂ ( e 121 ) = e 21 − e 11 + e 12 which implies ∂ R p ̸⊂ R p − 1 . Since the boundary of irregular term has to contain irregular terms, we have ∂ N p ⊂ N p − 1 . We have N p ∩ R p = ∅ thus Λ p = R p N p . So by using isomorphism between chain complexes R p ≃ Λ p / N p , we can induce a boundary map on R p . The induced boundary map ∂ : R p → R p − 1 is called a regular boundary map. This map will assign 0 to irregular paths in the image. So, the chain complex of V can be denoted as ( R p , ∂ ) p .
```
  FIX: ```
Observe that \( \partial (e_{121}) = e_{21} - e_{11} + e_{12} \) which implies \( \partial \mathcal{R}_p \not\subset \mathcal{R}_{p-1} \). Since the boundary of irregular term has to contain irregular terms, we have \( \partial \mathcal{N}_p \subset \mathcal{N}_{p-1} \). We have \( \mathcal{N}_p \cap \mathcal{R}_p = \emptyset \) thus \( \Lambda_p = \mathcal{R}_p \oplus \mathcal{N}_p \). So by using isomorphism between chain complexes \( \mathcal{R}_p \simeq \Lambda_p / \mathcal{N}_p \), we can induce a boundary map on \( \mathcal{R}_p \). The induced boundary map \( \partial : \mathcal{R}_p \to \mathcal{R}_{p-1} \) is called a regular boundary map. This map will assign 0 to irregular paths in the image. So, the chain complex of \( V \) can be denoted as \( (\mathcal{R}_p, \partial)_p \).
```
- RAW: ```
The induced boundary operator is referred to as the regular boundary operator, while the original boundary map is called the non-regular boundary operator in [8]. From now on, we will denote the regular boundary operator by ∂ .
```
  FIX: ```
The induced boundary operator is referred to as the regular boundary operator, while the original boundary map is called the non-regular boundary operator in [8]. From now on, we will denote the regular boundary operator by \( \partial \).
```
- RAW: ```
Definition 4. A path complex over a set V is a nonempty collection P of elementary paths on V for any n ∈ N with the property:
```
  FIX: ```
Definition 4. A path complex over a set \( V \) is a nonempty collection \( P \) of elementary paths on \( V \) for any \( n \in \mathbb{N} \) with the property:
```
- RAW: ```
The elementary paths in P are called allowed while other elementary paths on V that are not in P are called non-allowed .
```
  FIX: ```
The elementary paths in \( P \) are called allowed while other elementary paths on \( V \) that are not in \( P \) are called non-allowed .
```
- RAW: ```
Definition 5. A digraph G is a pair ( V,E ) where V is the set of vertices and E ⊂ V × V is the set of edges. An edge is called directed ( γ 1 ,γ 2 ) ∈ E and the direction will be γ 1 → γ 2
```
  FIX: ```
Definition 5. A digraph \( G \) is a pair \( (V, E) \) where \( V \) is the set of vertices and \( E \subset V \times V \) is the set of edges. An edge is called directed \( (\gamma_1, \gamma_2) \in E \) and the direction will be \( \gamma_1 \to \gamma_2 \)
```
- RAW: ```
Example 2.2. • An abstract finite simplicial complex K is a collection of subsets of a finite vertex set V that satisfies the following property if σ ∈ K , then any subset of σ is also in K . By enumerating the vertices, we can transform σ to an elementary path over V. Denote the new representation as P ( K ) . So the allowed n -paths in P ( K ) are n -simplexes. A path complex can be derived from finite simplicial complex.
```
  FIX: ```
Example 2.2. • An abstract finite simplicial complex \( K \) is a collection of subsets of a finite vertex set \( V \) that satisfies the following property if \( \sigma \in K \), then any subset of \( \sigma \) is also in \( K \). By enumerating the vertices, we can transform \( \sigma \) to an elementary path over \( V \). Denote the new representation as \( P(K) \). So the allowed \( n \)-paths in \( P(K) \) are \( n \)-simplexes. A path complex can be derived from finite simplicial complex.
```
- RAW: ```
- A path complex can be derived from digraph G by taking all paths in G as allowed paths.
```
  FIX: ```
• A path complex can be derived from digraph \( G \) by taking all paths in \( G \) as allowed paths.
```
- RAW: ```
For a given path complex P , we define the K -linear space A n as a span of all elementary n − path from P .
```
  FIX: ```
For a given path complex \( P \), we define the \( K \)-linear space \( \mathcal{A}_n \) as a span of all elementary \( n \)-paths from \( P \).
```
- RAW: ```
( A n ,∂ ) may not form chain complex all the time. For example, for P = { e 0 , 1 ,e 1 , 2 ,e 0 , 1 , 2 } , we have ∂ ( e 0 , 1 , 2 ) = e 1 , 2 − e 0 , 2 + e 0 , 1 where e 0 , 2 is not allowed.
```
  FIX: ```
\( (\mathcal{A}_n, \partial) \) may not form chain complex all the time. For example, for \( P = \{ e_{0,1}, e_{1,2}, e_{0,1,2} \} \), we have \( \partial (e_{0,1,2}) = e_{1,2} - e_{0,2} + e_{0,1} \) where \( e_{0,2} \) is not allowed.
```
- RAW: ```
So we are changing our domain to a restricted version Ω n which is defined as infimum chain complexes
```
  FIX: ```
So we are changing our domain to a restricted version \( \Omega_n \) which is defined as infimum chain complexes
```
- RAW: ```
Observe that ∂ Ω n ⊂ Ω n − 1 . The elements of Ω n are called ∂ -invariant n -paths. The homology of (Ω ,∂ ) will be called the path homology groups of the path complex P
```
  FIX: ```
Observe that \( \partial \Omega_n \subset \Omega_{n-1} \). The elements of \( \Omega_n \) are called \( \partial \)-invariant \( n \)-paths. The homology of \( (\Omega, \partial) \) will be called the path homology groups of the path complex \( P \)
```
