# Manifest: Page 046

## REPAIR_MATH
- RAW: ```
\bigoplus _ { u \in S _ { b } ^ { d } } \mathbb { S } _ { u } ( b ) & \cong H _ { d } ( N _ { 2 } , N _ { 0 } ) \cong \text {im} \, i _ { * } ^ { d } \oplus \text {im} \, j _ { * } ^ { d } \cong \left ( \bigoplus _ { u \in S _ { c } ^ { d } \ \L K ^ { d } } \mathbb { S } _ { u } ( a ) \right ) \oplus \left ( \bigoplus _ { u \in S _ { c } ^ { d } \ \L C ^ { d } } \mathbb { S } _ { u } ( c ) \right ) ,
```
  FIX: ```
$$
\bigoplus _ { u \in S _ { b } ^ { d } } \mathbb { S } _ { u } ( b ) & \cong H _ { d } ( N _ { 2 } , N _ { 0 } ) \cong \text {im} \, i _ { * } ^ { d } \oplus \text {im} \, j _ { * } ^ { d } \cong \left ( \bigoplus _ { u \in S _ { c } ^ { d } \ \L K ^ { d } } \mathbb { S } _ { u } ( a ) \right ) \oplus \left ( \bigoplus _ { u \in S _ { c } ^ { d } \ \L C ^ { d } } \mathbb { S } _ { u } ( c ) \right ) ,
$$
```
- RAW: ```
\mathcal { F } \colon \emptyset = K _ { 0 } \leftrightarrow K _ { 1 } \leftrightarrow \cdots \leftrightarrow K _ { m - 1 } \leftrightarrow K _ { m }
```
  FIX: ```
$$
\mathcal { F } \colon \emptyset = K _ { 0 } \leftrightarrow K _ { 1 } \leftrightarrow \cdots \leftrightarrow K _ { m - 1 } \leftrightarrow K _ { m }
$$
```
- RAW: ```
H \mathcal { F } \colon 0 = H _ { * } ( K _ { 0 } ) \stackrel { \psi _ { 0 } ^ { * } } { \leftrightarrow } H _ { * } ( K _ { 1 } ) \stackrel { \psi _ { 1 } ^ { * } } { \leftrightarrow } \cdots ^ { \psi _ { m - 2 } ^ { * } } \stackrel { \psi _ { m - 2 } ^ { * } } { \sim } H _ { * } ( K _ { m - 1 } ) ^ { \ \psi _ { m - 1 } ^ { * } } \ H _ { * } ( K _ { m } )
```
  FIX: ```
$$
H \mathcal { F } \colon 0 = H _ { * } ( K _ { 0 } ) \stackrel { \psi _ { 0 } ^ { * } } { \leftrightarrow } H _ { * } ( K _ { 1 } ) \stackrel { \psi _ { 1 } ^ { * } } { \leftrightarrow } \cdots ^ { \psi _ { m - 2 } ^ { * } } \stackrel { \psi _ { m - 2 } ^ { * } } { \sim } H _ { * } ( K _ { m - 1 } ) ^ { \ \psi _ { m - 1 } ^ { * } } \ H _ { * } ( K _ { m } )
$$
```
- RAW: ```
H \mathcal { F } \colon 0 = H _ { k } ( G _ { 0 } ) \stackrel { \psi _ { 0 } ^ { * } } { \leftrightarrow } H _ { k } ( G _ { 1 } ) \stackrel { \psi _ { k } ^ { * } } { \leftrightarrow } \cdots ^ { \psi _ { m - 2 } ^ { * } } \, H _ { k } ( G _ { m - 1 } ) \stackrel { \psi _ { m - 1 } ^ { * } } { \leftrightarrow } H _ { k } ( G _ { m } )
```
  FIX: ```
$$
H \mathcal { F } \colon 0 = H _ { k } ( G _ { 0 } ) \stackrel { \psi _ { 0 } ^ { * } } { \leftrightarrow } H _ { k } ( G _ { 1 } ) \stackrel { \psi _ { k } ^ { * } } { \leftrightarrow } \cdots ^ { \psi _ { m - 2 } ^ { * } } \, H _ { k } ( G _ { m - 1 } ) \stackrel { \psi _ { m - 1 } ^ { * } } { \leftrightarrow } H _ { k } ( G _ { m } )
$$
```

## REPAIR_PROSE
- RAW: `In addition, by Theorem 5.12(b) , H d ( N 2 ,N 0 ) ∼ = im i d ∗ ⊕ H d ( N 2 ,N 0 ) ker j d ∗ . Using that H d ( N 2 ,N 0 ) ker j d ∗ ∼ = im j d ∗ , we get`
  FIX: `In addition, by Theorem 5.12(b), \( H_d(N_2, N_0) \cong \operatorname{im} i^d_* \oplus H_d(N_2, N_0) / \operatorname{ker} j^d_* \). Using that \( H_d(N_2, N_0) / \operatorname{ker} j^d_* \cong \operatorname{im} j^d_* \), we get`
- RAW: `which implies S d b = ( S d a \ K d ) ∪ ( S d c \ C d ), and no string can have the left endpoint at b , proving ( b ) for B λ ⊑ B λ +1 . □`
  FIX: `which implies \( S^d_b = (S^d_a \setminus K^d) \cup (S^d_c \setminus C^d) \), and no string can have the left endpoint at \( b \), proving (b) for \( B_\lambda \sqsubseteq B_{\lambda+1} \). \( \square \)`
- RAW: `Remark 7.9 . The coupling that we mentioned—denoted in the diagrams using dashed lines in Figure 2 or 7 —is given by the isomorphism h ∗ defined in Theorem 5.12(c) . In these examples the coupling is well defined, however, it is not clear if the same can be said when the Conley index consists of multiple generators of the same degree. We leave these considerations for future investigation.`
  FIX: `Remark 7.9. The coupling that we mentioned—denoted in the diagrams using dashed lines in Figure 2 or 7—is given by the isomorphism \( h^* \) defined in Theorem 5.12(c). In these examples the coupling is well defined, however, it is not clear if the same can be said when the Conley index consists of multiple generators of the same degree. We leave these considerations for future investigation.`
- RAW: `The algorithm is stated in terms of zigzag modules (see Section 6.3 ). Zigzag modules appear using the homology functor on a sequence of simplicial complexes { K t } t =0 ...m where complexes indexed consecutively are related by inclusions, that is, either K t → K t +1 or K t ← K t +1 for t ∈ { 0 ,...,m − 1 } . These sequences are known as zigzag filtrations . We write K t ↔ K t +1 to denote that the arrows could be either left or right inclusions. Thus, a zigzag filtration is written as:`
  FIX: `The algorithm is stated in terms of zigzag modules (see Section 6.3). Zigzag modules appear using the homology functor on a sequence of simplicial complexes \( \{K_t\}_{t=0 \dots m} \) where complexes indexed consecutively are related by inclusions, that is, either \( K_t \to K_{t+1} \) or \( K_t \leftarrow K_{t+1} \) for \( t \in \{0, \dots, m-1\} \). These sequences are known as zigzag filtrations. We write \( K_t \leftrightarrow K_{t+1} \) to denote that the arrows could be either left or right inclusions. Thus, a zigzag filtration is written as:`
- RAW: `which provides a zigzag module by considering the homology groups H ∗ ( K t ) for each complex K t and linear maps ψ ∗ t : H ∗ ( K t ) ↔ H ∗ ( K t +1 ) between the homology groups of consecutive complexes induced by inclusions:`
  FIX: `which provides a zigzag module by considering the homology groups \( H_*(K_t) \) for each complex \( K_t \) and linear maps \( \psi_t^* \colon H_*(K_t) \leftrightarrow H_*(K_{t+1}) \) between the homology groups of consecutive complexes induced by inclusions:`
- RAW: `In our case, we have zigzag filtrations of index pairs arising out of the transition diagram TD , where we have an index pair ( P t ,E t ) := ( P it ,E it ) in place of a simplicial complex K t . We use t instead of λ for indexing the columns of the final transition diagram, which may have more columns than steps in the input zigzag filtration of block decompositions B . We say that a pair ( P t ,E t ) is included in a pair ( P t ′ ,E t ′ ) if P t ⊆ P t ′ and E t ⊆ E t ′ . In a zigzag filtration for index pairs, consecutive pairs are related by inclusions, that is, either ( P t ,E t ) → ( P t +1 ,E t +1 ) or ( P t ,E t ) ← ( P t +1 ,E t +1 ) for t ∈ { 0 ,...,m − 1 } . Using the notation G t = ( P t ,E t ) and the relative homology group H ∗ ( G t ) : = H ∗ ( P t ,E t ) in any fixed degree, say k , we get a zigzag persistence module out of a zigzag filtration of index pairs:`
  FIX: `In our case, we have zigzag filtrations of index pairs arising out of the transition diagram TD, where we have an index pair \( (P_t, E_t) := (P_{i_t}, E_{i_t}) \) in place of a simplicial complex \( K_t \). We use \( t \) instead of \( \lambda \) for indexing the columns of the final transition diagram, which may have more columns than steps in the input zigzag filtration of block decompositions \( \mathcal{B} \). We say that a pair \( (P_t, E_t) \) is included in a pair \( (P_{t'}, E_{t'}) \) if \( P_t \subseteq P_{t'} \) and \( E_t \subseteq E_{t'} \). In a zigzag filtration for index pairs, consecutive pairs are related by inclusions, that is, either \( (P_t, E_t) \to (P_{t+1}, E_{t+1}) \) or \( (P_t, E_t) \leftarrow (P_{t+1}, E_{t+1}) \) for \( t \in \{0, \dots, m-1\} \). Using the notation \( G_t = (P_t, E_t) \) and the relative homology group \( H_*(G_t) := H_*(P_t, E_t) \) in any fixed degree, say \( k \), we get a zigzag persistence module out of a zigzag filtration of index pairs:`
- RAW: `In what follows, we refer to indices of the columns in the transition diagram TD , as time. Our algorithm processes TD , with increasing time values. We denote the poset underlying the TD , as P . Let P t ⊆ P be the set of all points with time t . In what follows, we say points a, b ∈ P are immediate to one another if a and b are adjacent in the Hasse diagram of P . For each point a it ∈ P t , the algorithm inductively assumes that it has already implicitly processed all zigzag filtrations of index-pairs supported on paths ending at the index a it and extends the filtrations to each of the immediate points of a it at time t +1.`
  FIX: `In what follows, we refer to indices of the columns in the transition diagram TD, as time. Our algorithm processes TD, with increasing time values. We denote the poset underlying the TD, as \( P \). Let \( P_t \subseteq P \) be the set of all points with time \( t \). In what follows, we say points \( a, b \in P \) are immediate to one another if \( a \) and \( b \) are adjacent in the Hasse diagram of \( P \). For each point \( a_{i_t} \in P_t \), the algorithm inductively assumes that it has already implicitly processed all zigzag filtrations of index-pairs supported on paths ending at the index \( a_{i_t} \) and extends the filtrations to each of the immediate points of \( a_{i_t} \) at time \( t+1 \).`
