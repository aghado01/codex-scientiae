then the map \( f \) is called a merging map.

For the next theorem, minimal \( \partial \)-invariant path means there is no nonempty proper subset of its components whose nonzero linear combination is also \( \partial \)-invariant. The following theorem was first stated at [6] as Theorem 2.10 with a condition that the digraph will be free of multisquares and double edge. Later at [12] these conditions are lifted.

Theorem 3.4. Let \( G \) digraph. Every minimal path in \( \Omega_{2,1}^3 \) is either trapezohedron or a merging image thereof. There is a basis of \( \Omega_{2,1}^3 \) containing trapezohedral paths \( T_m \) with \( m \geq 2 \) with their merging images.

The construction of the basis rely on the cluster-graph conversion. Let \( V \) be the vertex set of all elementary path \( v = e_{a,i,j,b} \) from \( (a,b) \)-cluster. Construct a graph \( \Gamma \) with \( V = V(\Gamma) \) and the edge set is

- the edge between \( e_{a,i,j,b} \) and \( e_{a,i',j,b} \) is colored 1
- the edge between \( e_{a,i,j,b} \) and \( e_{a,i,j',b} \) is colored 2


Let \( E_i \) be the set of color \( i \) edges where \( i = 1, 2 \).

In the proof of basis for \( \Omega^3 \) at [6], no multisquares imply that \( \Gamma \) can be either a polygon or a line which both case describe a class of generators. Later in [12], this condition is eliminated by considering the cycles and maximal alternating path on \( \Gamma \).

In the following work, we will also label the vertices in \( \Gamma \) which create a finer classification components that is needed to discover \( \Omega_N^3 \).

To organize the possible 3-path contributions, we assign to each \( v = e_{i,j,k,l} \in A_3 \) its image-type

$$
\phi ( v ) = ( \phi ( e _ { j , k , l } ) , \phi ( e _ { i , k , l } ) , \phi ( e _ { i , j , l } ) , \phi ( e _ { i , j , k } ) ) \in \{ T , S , W , N _ { w } \} ^ { 4 } = \Sigma ^ { 4 } ,
$$

where \( \Sigma = \{T, S, W, N_w\} \) denote triangle, square, admissible, and non-admissible types, respectively. The next theorem shows that only a small subcollection can occur among components of \( \Omega_{N,1}^3 \).

The indicator maps which record where the non-admissible faces occur in the image-type of a 3-path defined as \( \pi_r : \Sigma^4 \to \{0, 1\} \) by where \( r = 2, 3 \)

$$
\pi _ { i } ( \alpha _ { 1 } , \alpha _ { 2 } , \alpha _ { 3 } , \alpha _ { 4 } ) = \begin{cases} 1 , & \alpha _ { i } = N _ { w } , \\ 0 , & \text {otherwise} , \end{cases}
$$

For \( v \in A_3 \) we also write \( \pi_r(v) := \pi_r(\phi(v)) \) for \( r = 2, 3 \).

Lemma 3.5. Let \( v \in \Omega_{N,1}^3 \) be a cluster element where \( v = \sum_{i=1}^k \alpha_i v_i \) with \( v_i = e_{a,j_i,k_i,b} \in A_3 \). If \( \pi_2(v_i) = 1 \), then the fourth entry of \( \phi(v) \) is of square type, i.e. \( \phi(e_{a,j_i,k_i}) = S \). Dually, if \( \pi_3(v_i) = 1 \), then the first entry of \( \phi(v) \) is of square type, i.e. \( \phi(e_{j_i,k_i,b}) = S \).

Proof. Assume \( v_i = e_{a,j_i,k_i,b} \) contains a non-admissible face. Observe that this can appear only at \( e_{a,k_i,b} \) or \( e_{a,j_i,b} \). For \( v \in \Omega_{N,1}^3 \), every non-admissible term in \( \partial(v) \) must be eliminated by pairing with another term of the same key. Such elimination can only occur through linear combination 3-path that has the same non-admissible term in the same cluster.

If \( \pi_1(v_i) = 1 \), then \( e_{a,k_i} \notin A_1 \). Since non-admissible term is canceled, we know that there exists at least one \( v_t \neq v_i \) so that \( v_t = e_{a,j_t,k_t=k_i,b} \). Thus \( e_{a,j_t,k_t=k_i} - e_{a,j_i,k_i} \) forms a square. The argument is analogous for \( \pi_2(v_i) = 1 \).

