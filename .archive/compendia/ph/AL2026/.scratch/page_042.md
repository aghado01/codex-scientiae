[Page 42]

Remark 3.53. In Notation 3.52, assume that a persistence module \( M \) is given as the \( i \)-th homology of a filtration \( F \) for some \( i \) (see for instance, Example 5.12). Then the condition \( M_{b,a} = 0 \) is easily verified in the level of filtration \( F \). This is done by checking any \( i \)-cycle at \( F(a) \) vanishes at \( F(b) \). This verification is also possible by checking the fibered barcodes (see Lesnick and Wright (2015), or equivalently, rank invariants) or a projective presentation of \( M \).

Using this notation, we immediately obtain the following by Propositions 3.50 and 3.51 .

Proposition 3.54. Let \( M \in \operatorname{mod} A \) and \( I \in \mathbb{I} \). If \( V_I \) is a direct summand of \( M \), then

$$
$$
I \in c r t _ { 1 , z p } ^ { \prime } ( M ) .
$$
$$

With the formula ( 3.37 ) or ( 3.42 ), we are able to compute the maximal intervaldecomposable summand of persistence modules. Let M be a persistence module over P . The maximal interval-decomposable summand of M is defined by

$$
$$
M _ { \mathbb { I } } \coloneqq \bigoplus _ { I \in \mathbb { I } } V _ { I } ^ { d _ { M } ( V _ { I } ) } = \bigoplus _ { I \in \text {crt} _ { 1 } ( M ) } V _ { I } ^ { d _ { M } ( V _ { I } ) } .
$$
$$

Note that the range of intervals \( \text{crt}_1(M) \) in (3.52) can be replaced by \( \text{crt}^\prime_{1, \text{zp}}(M) \). \( M_{\mathbb{I}} \) can be considered as another "interval approximation", which differs from the interval replacement defined in Asashiba et al. (2023b, 2024), the interval approximation defined in Hiraoka et al. (2025), and the interval resolution defined in Asashiba et al. (2023a). It is obvious that the maximal interval-decomposable summand is also an invariant of modules, but it is incomplete.

The maximal interval-decomposable summand \( M_{\mathbb{I}} \) also determines the interval decomposability of \( M \) trivially, in the following way.

Lemma 3.55. For any module \( M \in \operatorname{mod} A \) the following are equivalent:

- (1) \( M \) is interval-decomposable.
- (2) \( \dim M = \sum_{I \in \mathbb{I}} d_M(V_I) \cdot \dim V_I = \sum_{I \in \text{crt}_1(M)} d_M(V_I) \cdot \dim V_I \).
- (3) \( \dim M = \sum_{I \in \mathbb{I}} d_M(V_I) \cdot \dim V_I = \sum_{I \in \text{crt}_1(M)} d_M(V_I) \cdot \dim V_I \).


In the above, \( \dim \) denotes the dimension vector.

We would remark on the difference between our proposed method here and the algorithm provided in Dey et al. (2023) checking the interval decomposability. The key idea of the algorithm in Dey et al. (2023) is depending on (Asashiba et al. 2023b, Theorem 5.10), that is, a persistence module \( M \) is interval-decomposable if and only if \( M \) is isomorphic to the positive part of its interval placement \( \delta_\xi(M)^+ \). Thus, they suggest picking up the interval \( I \) appearing in \( \delta_\xi(M)^+ \) and then checking whether the interval multiplicity \( d_M(V_I) \) is zero or not by utilizing the (Asashiba et al. 2022, Algorithm 3). However, no explicit formula is provided in Asashiba et al. (2022) and one has to compute everything involving computing the almost split sequence of \( V_I \) by the computer program, causing a high computation cost. On the contrary, this paper provides a direct way to compute the interval multiplicity \( d_M(V_I) \). This eliminates the procedure to compute the almost split sequence that is required to perform (Asashiba et al. 2022, Algorithm 3) because this has already been computed theoretically to give the formula, and then the interval decomposability can be easily verified by checking the dimension equality in Lemma 3.55. On the other hand, another advantage of our method is that we can find out the maximal interval-decomposable summand of a given persistence module \( M \) (over any finite poset \( P \)) that is not interval-decomposable, while the algorithm in Dey et al. (2023) can not.
