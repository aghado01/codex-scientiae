# Manifest: Page 045

## REPAIR_MATH
- RAW: ```
. . . ( P ⊢ p,λ , E ⊢ p,λ ) ( P ⊣ p,λ , E ⊣ p,λ ) . . . . . . . . .
```
  FIX: ```
$$
. . . ( P ⊢ p,λ , E ⊢ p,λ ) ( P ⊣ p,λ , E ⊣ p,λ ) . . . . . . . . .
$$
```
- RAW: ```
⊕ u ∈ S d c S u ( c ) ⊕ u ∈ S d b S u ( b ) ⊕ u ∈ S d a S u ( a ) k d ∗ =0 j d ∗ i d ∗
```
  FIX: ```
$$
⊕ u ∈ S d c S u ( c ) ⊕ u ∈ S d b S u ( b ) ⊕ u ∈ S d a S u ( a ) k d ∗ =0 j d ∗ i d ∗
$$
```
- RAW: ```
\ker i _ { * } ^ { d } \cong \bigoplus _ { u \in K ^ { d } } \mathbb { S } _ { u } ( a ) , \quad \text {coker} \, j _ { * } ^ { d } \cong \bigoplus _ { u \in C ^ { d } } \mathbb { S } _ { u } ( c ) .
```
  FIX: ```
$$
\ker i _ { * } ^ { d } \cong \bigoplus _ { u \in K ^ { d } } \mathbb { S } _ { u } ( a ) , \quad \text {coker} \, j _ { * } ^ { d } \cong \bigoplus _ { u \in C ^ { d } } \mathbb { S } _ { u } ( c ) .
$$
```
- RAW: ```
\bigoplus _ { u \in S _ { a } ^ { d } } & \mathbb { S } _ { u } ( a ) / \ker i _ { * } ^ { d } \cong \text {im} \, i _ { * } ^ { d } \cong \bigoplus _ { u \in S _ { a } ^ { d } \ \ K ^ { d } } \mathbb { S } _ { u } ( a ) , \\ \text {im} \, j _ { * } ^ { d } & \cong \bigoplus _ { u \in S _ { c } ^ { d } } \mathbb { S } _ { u } ( c ) / \text {coker} \, j _ { * } ^ { d } \cong \bigoplus _ { u \in S _ { c } ^ { d } \ \ C ^ { d } } \mathbb { S } _ { u } ( c ) .
```
  FIX: ```
$$
\bigoplus _ { u \in S _ { a } ^ { d } } & \mathbb { S } _ { u } ( a ) / \ker i _ { * } ^ { d } \cong \text {im} \, i _ { * } ^ { d } \cong \bigoplus _ { u \in S _ { a } ^ { d } \ \ K ^ { d } } \mathbb { S } _ { u } ( a ) , \\ \text {im} \, j _ { * } ^ { d } & \cong \bigoplus _ { u \in S _ { c } ^ { d } } \mathbb { S } _ { u } ( c ) / \text {coker} \, j _ { * } ^ { d } \cong \bigoplus _ { u \in S _ { c } ^ { d } \ \ C ^ { d } } \mathbb { S } _ { u } ( c ) .
$$
```

## REPAIR_PROSE
- RAW: ```
We use a,b,c to denote the nodes in the quiver corresponding to vector spaces H d ( N 1 ,N 0 ), H d ( N 2 ,N 0 ) and H d ( N 2 ,N 1 ), respectively. We recall that, due to Theorem 7.4 , there exists an isomorphism M d ∼ = u ∈ S d S u , where M d is the persistence module corresponding to the homology of degree d and S d its ConleyMorse persistence module.
```
  FIX: ```
We use \( a, b, c \) to denote the nodes in the quiver corresponding to vector spaces \( H_d(N_1, N_0) \), \( H_d(N_2, N_0) \) and \( H_d(N_2, N_1) \), respectively. We recall that, due to Theorem 7.4, there exists an isomorphism \( M_d \cong \bigoplus_{u \in S^d} \mathbb{S}_u \), where \( M_d \) is the persistence module corresponding to the homology of degree \( d \) and \( S^d \) its ConleyMorse persistence module.
```
- RAW: ```
Where S d a ,S d b ,S d c are the strings of S d passing through the nodes a,b and c . Additionally, we define K d : = { u ∈ S d | u ends at a } and C d : = { u ∈ S d | u ends at c } . Then,
```
  FIX: ```
Where \( S_a^d, S_b^d, S_c^d \) are the strings of \( S^d \) passing through the nodes \( a, b \) and \( c \). Additionally, we define \( K^d := \{ u \in S^d \mid u \text{ ends at } a \} \) and \( C^d := \{ u \in S^d \mid u \text{ ends at } c \} \). Then,
```
- RAW: ```
Moreover, the isomorphism h ∗ described in Theorem 5.12(c) tells us that ker i d − 1 ∗ and coker j d ∗ have the same rank. In particular, the number of strings of S d − 1 ending at a must be the same as the number of strings of S d ending at c , and it is possible to define a pairing between the two sets of strings (see Remark 7.9 ). Since this is true for all d and all AR-split diagrams at that stage of the filtration, it proves ( c ) for B λ ⊑ B λ +1 .
```
  FIX: ```
Moreover, the isomorphism \( h_* \) described in Theorem 5.12(c) tells us that \( \ker i_*^{d-1} \) and \( \text{coker} \, j_*^d \) have the same rank. In particular, the number of strings of \( S^{d-1} \) ending at \( a \) must be the same as the number of strings of \( S^d \) ending at \( c \), and it is possible to define a pairing between the two sets of strings (see Remark 7.9). Since this is true for all \( d \) and all AR-split diagrams at that stage of the filtration, it proves (c) for \( B_\lambda \sqsubseteq B_{\lambda+1} \).
```
- RAW: ```
We proceed now to prove ( b ) for B λ ⊑ B λ +1 . As in the previous case, the strings that continue to a and c are respectively S d a \ K d and S d c \ C d . Hence,
```
  FIX: ```
We proceed now to prove (b) for \( B_\lambda \sqsubseteq B_{\lambda+1} \). As in the previous case, the strings that continue to \( a \) and \( c \) are respectively \( S_a^d \setminus K^d \) and \( S_c^d \setminus C^d \). Hence,
```
