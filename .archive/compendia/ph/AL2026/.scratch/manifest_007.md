# Manifest: Page 007

## REPAIR_MATH
- RAW: ```
d _ { M } ( V _ { I } ) = \text {rank} \quad \text {sc} ( \uparrow I ) \quad \text {sc} ( \downarrow I ) \quad \text {sk} ( \uparrow I ) \quad \text {sk} ( \downarrow I ) \\ d _ { M } ( V _ { I } ) = \text {rank} \quad \text {sc} ( \uparrow I ) \quad \text {M} _ { 2 } \quad \text {0} \quad \text {0} \quad \text {0} \quad \text {0} \quad \text {0} \quad \text {M} _ { 2 } \quad \text {0} \quad \text {0} \quad \text {0} \quad \text {M} _ { 2 } \quad \text {0} \quad M _ { 4 } \quad M _ { 5 } \quad \text {0} \quad M _ { 4 } \quad M _ { 5 } \quad \text {0} \quad M _ { 4 } \quad M _ { 5 }
```
  FIX: ```
$$
d _ { M } ( V _ { I } ) = \text {rank} \quad \text {sc} ( \uparrow I ) \quad \text {sc} ( \downarrow I ) \quad \text {sk} ( \uparrow I ) \quad \text {sk} ( \downarrow I ) \\ d _ { M } ( V _ { I } ) = \text {rank} \quad \text {sc} ( \uparrow I ) \quad \text {M} _ { 2 } \quad \text {0} \quad \text {0} \quad \text {0} \quad \text {0} \quad \text {0} \quad \text {M} _ { 2 } \quad \text {0} \quad \text {0} \quad \text {0} \quad \text {M} _ { 2 } \quad \text {0} \quad M _ { 4 } \quad M _ { 5 } \quad \text {0} \quad M _ { 4 } \quad M _ { 5 } \quad \text {0} \quad M _ { 4 } \quad M _ { 5 }
$$
```
- RAW: ```
( M _ { 1 } ) _ { a _ { c } , a } \colon = \begin{cases} M _ { c , a } & ( a = \underline { a } ) , \\ - M _ { c , a } & ( a = \overline { a } ) , \\ 0 & ( a \not \in \mathfrak { a } ) , \end{cases} \, \begin{bmatrix} M _ { c , a } & ( a = \underline { a } ) , \\ \overline { - M _ { c , a } } & ( a = \overline { a } ) , \\ 0 & ( a \not \in \mathfrak { a } ) , \end{bmatrix} \, \begin{bmatrix} M _ { b , d } & ( b = \underline { b } ) , \\ - M _ { b , d } & ( b = \overline { b } ) , \\ 0 & ( b \not \in \mathfrak { b } ) , \end{bmatrix}
```
  FIX: ```
$$
( M _ { 1 } ) _ { a _ { c } , a } \colon = \begin{cases} M _ { c , a } & ( a = \underline { a } ) , \\ - M _ { c , a } & ( a = \overline { a } ) , \\ 0 & ( a \not \in \mathfrak { a } ) , \end{cases} \, \begin{bmatrix} M _ { c , a } & ( a = \underline { a } ) , \\ \overline { - M _ { c , a } } & ( a = \overline { a } ) , \\ 0 & ( a \not \in \mathfrak { a } ) , \end{bmatrix} \, \begin{bmatrix} M _ { b , d } & ( b = \underline { b } ) , \\ - M _ { b , d } & ( b = \overline { b } ) , \\ 0 & ( b \not \in \mathfrak { b } ) , \end{bmatrix}
$$
```
- RAW: ```
M _ { 2 } \coloneqq & \left [ \delta _ { a , \, c ( a ^ { \prime } ) } M _ { a ^ { \prime } , \, \mathfrak { c } ( a ^ { \prime } ) } \right ] _ { ( a ^ { \prime } , a ) \in \mathbf s c ( \uparrow I ) \times \mathbf s c ( I ) } \\ \left ( \text {resp. } M _ { 4 } \coloneqq & \left [ \delta _ { b , \, \mathbf d ( b ^ { \prime } ) } M _ { \mathbf d ( b ^ { \prime } ) , \, b ^ { \prime } } \right ] _ { ( b , b ^ { \prime } ) \in \mathbf s k ( I ) \times \mathbf s k ( \downarrow I ) } \right ) .
```
  FIX: ```
$$
M _ { 2 } \coloneqq & \left [ \delta _ { a , \, c ( a ^ { \prime } ) } M _ { a ^ { \prime } , \, \mathfrak { c } ( a ^ { \prime } ) } \right ] _ { ( a ^ { \prime } , a ) \in \mathbf s c ( \uparrow I ) \times \mathbf s c ( I ) } \\ \left ( \text {resp. } M _ { 4 } \coloneqq & \left [ \delta _ { b , \, \mathbf d ( b ^ { \prime } ) } M _ { \mathbf d ( b ^ { \prime } ) , \, b ^ { \prime } } \right ] _ { ( b , b ^ { \prime } ) \in \mathbf s k ( I ) \times \mathbf s k ( \downarrow I ) } \right ) .
$$
```
- RAW: `linear maps of M by using a projective presentation of X . Thus our purpose can be achieved by computing E V I and τ − 1 V I as mentioned above, and to compute projective presentations of V I ,E V I and τ − 1 V I for any interval I in general.`
  FIX: `linear maps of \( M \) by using a projective presentation of \( X \). Thus our purpose can be achieved by computing \( E V_I \) and \( \tau^{-1} V_I \) as mentioned above, and to compute projective presentations of \( V_I \), \( E V_I \) and \( \tau^{-1} V_I \) for any interval \( I \) in general.`
- RAW: `when the persistence module M is not interval-decomposable.`
  FIX: `when the persistence module \( M \) is not interval-decomposable.`
- RAW: `Main result A (Theorem 3.27 ). Let M ∈ mod k [ P ] , and I an interval of P . Then`
  FIX: `Main result A (Theorem 3.27). Let \( M \in \text{mod } \mathbf{k}[P] \), and \( I \) an interval of \( P \). Then`
- RAW: `holds. Here the ( a c ,a ) -entry of M 1 ( resp. the ( b, b d ) -entry of M 5 ) is given by`
  FIX: `holds. Here the \( ( a_c ,a ) \)-entry of \( M_1 \) (resp. the \( ( b, b_d ) \)-entry of \( M_5 \)) is given by`
- RAW: `M 3 is given by a choice of pair ( b j ,a i ) ∈ sk( I ) × sc( I ) with b j ≥ a i . Namely, the ( b j ,a i ) entry is the only non-zero entry of M 3 and it equals to M b j ,a i . Index sets of matrices in formula ( 1.2 ) are allowed to be empty. In this case, we remove rows (columns) of matrices corresponding to empty index sets.`
  FIX: `\( M_3 \) is given by a choice of pair \( ( b_j ,a_i ) \in \mathbf{sk}( I ) \times \mathbf{sc}( I ) \) with \( b_j \ge a_i \). Namely, the \( ( b_j ,a_i ) \) entry is the only non-zero entry of \( M_3 \) and it equals to \( M_{b_j, a_i} \). Index sets of matrices in formula (1.2) are allowed to be empty. In this case, we remove rows (columns) of matrices corresponding to empty index sets.`

## REPAIR_PROSE
- RAW: `We remark that the proposed formula ( 1.2 ) is a generalization of the formula ( 1.1 ) in the one-parameter persistence case (see Remark 4.13 ).`
  FIX: `We remark that the proposed formula (1.2) is a generalization of the formula (1.1) in the one-parameter persistence case (see Remark 4.13).`
- RAW: `invariants given in Asashiba et al. ( 2024 ) (resp. generalized rank invariants given in Kim and Mémoli ( 2021 )) because`
  FIX: `invariants given in Asashiba et al. (2024) (resp. generalized rank invariants given in Kim and Mémoli (2021)) because`
- RAW: `arbitrary finite poset, at the algebraic level (Theorem 3.27 ). The formula`
  FIX: `arbitrary finite poset, at the algebraic level (Theorem 3.27). The formula`
