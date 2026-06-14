[Page 45]

![image 23](<DLST2026/imageFile23.png>)

$$
. . . ( P ⊢ p,λ , E ⊢ p,λ ) ( P ⊣ p,λ , E ⊣ p,λ ) . . . . . . . . .
$$

Figure 23. The provided construction of the transition diagram does not produce directly diagrams like in Figure 21 . Instead, we have the above diagram.

We use \( a, b, c \) to denote the nodes in the quiver corresponding to vector spaces \( H_d(N_1, N_0) \), \( H_d(N_2, N_0) \) and \( H_d(N_2, N_1) \), respectively. We recall that, due to Theorem 7.4, there exists an isomorphism \( M_d \cong \bigoplus_{u \in S^d} \mathbb{S}_u \), where \( M_d \) is the persistence module corresponding to the homology of degree \( d \) and \( S^d \) its ConleyMorse persistence module. When we restrict this isomorphism to the AR-split under consideration, it takes the following shape:

![image 24](<DLST2026/imageFile24.png>)

$$
⊕ u ∈ S d c S u ( c ) ⊕ u ∈ S d b S u ( b ) ⊕ u ∈ S d a S u ( a ) k d ∗ =0 j d ∗ i d ∗
$$

Where \( S_a^d, S_b^d, S_c^d \) are the strings of \( S^d \) passing through the nodes \( a, b \) and \( c \). Additionally, we define \( K^d := \{ u \in S^d \mid u \text{ ends at } a \} \) and \( C^d := \{ u \in S^d \mid u \text{ ends at } c \} \). Then,

$$
\ker i _ { * } ^ { d } \cong \bigoplus _ { u \in K ^ { d } } \mathbb { S } _ { u } ( a ) , \quad \text {coker} \, j _ { * } ^ { d } \cong \bigoplus _ { u \in C ^ { d } } \mathbb { S } _ { u } ( c ) .
$$

Moreover, the isomorphism \( h_* \) described in Theorem 5.12(c) tells us that \( \ker i_*^{d-1} \) and \( \text{coker} \, j_*^d \) have the same rank. In particular, the number of strings of \( S^{d-1} \) ending at \( a \) must be the same as the number of strings of \( S^d \) ending at \( c \), and it is possible to define a pairing between the two sets of strings (see Remark 7.9). Since this is true for all \( d \) and all AR-split diagrams at that stage of the filtration, it proves (c) for \( B_\lambda \sqsubseteq B_{\lambda+1} \).

We proceed now to prove (b) for \( B_\lambda \sqsubseteq B_{\lambda+1} \). As in the previous case, the strings that continue to \( a \) and \( c \) are respectively \( S_a^d \setminus K^d \) and \( S_c^d \setminus C^d \). Hence,

$$
\bigoplus _ { u \in S _ { a } ^ { d } } & \mathbb { S } _ { u } ( a ) / \ker i _ { * } ^ { d } \cong \text {im} \, i _ { * } ^ { d } \cong \bigoplus _ { u \in S _ { a } ^ { d } \ \ K ^ { d } } \mathbb { S } _ { u } ( a ) , \\ \text {im} \, j _ { * } ^ { d } & \cong \bigoplus _ { u \in S _ { c } ^ { d } } \mathbb { S } _ { u } ( c ) / \text {coker} \, j _ { * } ^ { d } \cong \bigoplus _ { u \in S _ { c } ^ { d } \ \ C ^ { d } } \mathbb { S } _ { u } ( c ) .
$$
