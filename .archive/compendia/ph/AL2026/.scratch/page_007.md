[Page 7]

linear maps of M by using a projective presentation of X . Thus our purpose can be achieved by computing E V I and τ − 1 V I as mentioned above, and to compute projective presentations of V I ,E V I and τ − 1 V I for any interval I in general. A priori, our proposed formula is different from the Möbius inversion formula of signed interval multiplicities (resp. generalized persistence diagrams) and interval rank invariants given in Asashiba et al. ( 2024 ) (resp. generalized rank invariants given in Kim and Mémoli ( 2021 )) because the interval multiplicities and the signed interval multiplicities do not coincide in general when the persistence module M is not interval-decomposable.

# 1.3 Our contributions

(1) We provide an explicit formula for computing the multiplicities of interval summands of a given persistence module over arbitrary finite poset, at the algebraic level (Theorem 3.27 ). The formula only depends on some of the structure linear maps inside the persistence module. It turns out that the task of computing the interval multiplicity converts to the task of computing the rank of some matrices.

Main result A (Theorem 3.27 ). Let M ∈ mod k [ P ] , and I an interval of P . Then

$$
$$
d _ { M } ( V _ { I } ) = \text {rank} \quad \text {sc} ( \uparrow I ) \quad \text {sc} ( \downarrow I ) \quad \text {sk} ( \uparrow I ) \quad \text {sk} ( \downarrow I ) \\ d _ { M } ( V _ { I } ) = \text {rank} \quad \text {sc} ( \uparrow I ) \quad \text {M} _ { 2 } \quad \text {0} \quad \text {0} \quad \text {0} \quad \text {0} \quad \text {0} \quad \text {M} _ { 2 } \quad \text {0} \quad \text {0} \quad \text {0} \quad \text {M} _ { 2 } \quad \text {0} \quad M _ { 4 } \quad M _ { 5 } \quad \text {0} \quad M _ { 4 } \quad M _ { 5 } \quad \text {0} \quad M _ { 4 } \quad M _ { 5 }
$$
$$

holds. Here the ( a c ,a ) -entry of M 1 ( resp. the ( b, b d ) -entry of M 5 ) is given by

$$
$$
( M _ { 1 } ) _ { a _ { c } , a } \colon = \begin{cases} M _ { c , a } & ( a = \underline { a } ) , \\ - M _ { c , a } & ( a = \overline { a } ) , \\ 0 & ( a \not \in \mathfrak { a } ) , \end{cases} \, \begin{bmatrix} M _ { c , a } & ( a = \underline { a } ) , \\ \overline { - M _ { c , a } } & ( a = \overline { a } ) , \\ 0 & ( a \not \in \mathfrak { a } ) , \end{bmatrix} \, \begin{bmatrix} M _ { b , d } & ( b = \underline { b } ) , \\ - M _ { b , d } & ( b = \overline { b } ) , \\ 0 & ( b \not \in \mathfrak { b } ) , \end{bmatrix}
$$
$$

and

$$
$$
M _ { 2 } \coloneqq & \left [ \delta _ { a , \, c ( a ^ { \prime } ) } M _ { a ^ { \prime } , \, \mathfrak { c } ( a ^ { \prime } ) } \right ] _ { ( a ^ { \prime } , a ) \in \mathbf s c ( \uparrow I ) \times \mathbf s c ( I ) } \\ \left ( \text {resp. } M _ { 4 } \coloneqq & \left [ \delta _ { b , \, \mathbf d ( b ^ { \prime } ) } M _ { \mathbf d ( b ^ { \prime } ) , \, b ^ { \prime } } \right ] _ { ( b , b ^ { \prime } ) \in \mathbf s k ( I ) \times \mathbf s k ( \downarrow I ) } \right ) .
$$
$$

M 3 is given by a choice of pair ( b j ,a i ) ∈ sk( I ) × sc( I ) with b j ≥ a i . Namely, the ( b j ,a i ) entry is the only non-zero entry of M 3 and it equals to M b j ,a i . Index sets of matrices in formula ( 1.2 ) are allowed to be empty. In this case, we remove rows (columns) of matrices corresponding to empty index sets.

We remark that the proposed formula ( 1.2 ) is a generalization of the formula ( 1.1 ) in the one-parameter persistence case (see Remark 4.13 ).
