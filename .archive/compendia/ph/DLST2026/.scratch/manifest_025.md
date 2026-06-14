# Manifest: Page 025

## REPAIR_PROSE
- RAW: ```
![In this image, we can see a diagram with some text and arrows.](<DLST2026/imageFile15.png>)



























,


,




,













,


,











,



,



,



,












,


Figure 16. Indexing maps ←− ι 0 , −→ ι 1 , ←− ι 2 , and ←− ι 3 for the zigzag filtration of block decompositions B from Figure 14 .
```
  FIX: ```
![In this image, we can see a diagram with some text and arrows.](<DLST2026/imageFile15.png>)

Figure 16. Indexing maps \( \overleftarrow{\iota}_0 \), \( \overrightarrow{\iota}_1 \), \( \overleftarrow{\iota}_2 \), and \( \overleftarrow{\iota}_3 \) for the zigzag filtration of block decompositions \( \mathcal{B} \) from Figure 14.
```

## REPAIR_MATH
- RAW: ```
We begin the analysis of the zigzag filtration by observing a direct relationship between two successive block decompositions. We focus mostly on the ⊑ case, as the ⊒ case is symmetric.

Proposition 5.6. If ( B 1 , V 1 ) ⊑ ( B 2 , V 2 ), then B 2 is a block decomposition for V 1 .

Proof. By Proposition 4.24 , an isolating block B q, 2 ∈ B 2 is an isolating block both in V 1 and V 2 . Since G V 0 ⊂ G V 1 we have Paths V 1 ( X ) ⊂ Paths V 2 ( X ). Therefore, condition (B2) is preserved for B 2 with respect to V 1 .

Consider φ ∈ eSol V 1 ( X ). In particular, φ ∈ Sol V 2 ( X ). By (B1) for B 1 , there exist p,q ∈ P 1 such that uim + V 1 φ ⊂ B p, 1 and uim − V 1 φ ⊂ B q, 1 . Moreover, B p, 1 ⊂ B −→ ι 1 ( p ) , 2 ∈ B 2 , and B q, 1 ⊂ B −→ ι 1 ( q ) , 2 ∈ B 2 . Hence, (B1) for B 2 in V 1 is satisfied. □

Proposition 5.6 tells us that B 2 is a block decomposition both in V 1 and V 2 . Therefore, by Definition 4.25 , for every B p, 2 ∈ B 2 its invariant part in V 2 that is, Inv V 2 B p, 2 —continues to Inv V 1 B p, 2 in V 1 , and therefore, shares the same dynamical properties, in particular the Conley index (Theorem 4.26 ). This allows us to study the transition from B 1 to B 2 on a common ground, that is, within multivector field V 1 . The next theorem captures in more detail the relationship between individual isolating blocks of B 1 and B 2 . Let us first define the connection set for a family of subsets A of X within Y ⊂ X :
```
  FIX: ```
We begin the analysis of the zigzag filtration by observing a direct relationship between two successive block decompositions. We focus mostly on the \( \sqsubseteq \) case, as the \( \sqsupseteq \) case is symmetric.

Proposition 5.6. If \( ( \mathcal{B}_1 , \mathcal{V}_1 ) \sqsubseteq ( \mathcal{B}_2 , \mathcal{V}_2 ) \), then \( \mathcal{B}_2 \) is a block decomposition for \( \mathcal{V}_1 \).

Proof. By Proposition 4.24, an isolating block \( B_{q,2} \in \mathcal{B}_2 \) is an isolating block both in \( \mathcal{V}_1 \) and \( \mathcal{V}_2 \). Since \( \mathsf{G}_{\mathcal{V}_0} \subset \mathsf{G}_{\mathcal{V}_1} \) we have \( \mathsf{Paths}_{\mathcal{V}_1} ( X ) \subset \mathsf{Paths}_{\mathcal{V}_2} ( X ) \). Therefore, condition (B2) is preserved for \( \mathcal{B}_2 \) with respect to \( \mathcal{V}_1 \).

Consider \( \varphi \in \mathsf{eSol}_{\mathcal{V}_1} ( X ) \). In particular, \( \varphi \in \mathsf{Sol}_{\mathcal{V}_2} ( X ) \). By (B1) for \( \mathcal{B}_1 \), there exist \( p,q \in P_1 \) such that \( \mathsf{uim}^+_{\mathcal{V}_1} \varphi \subset B_{p,1} \) and \( \mathsf{uim}^-_{\mathcal{V}_1} \varphi \subset B_{q,1} \). Moreover, \( B_{p,1} \subset B_{\overrightarrow{\iota}_1 ( p ) , 2} \in \mathcal{B}_2 \), and \( B_{q,1} \subset B_{\overrightarrow{\iota}_1 ( q ) , 2} \in \mathcal{B}_2 \). Hence, (B1) for \( \mathcal{B}_2 \) in \( \mathcal{V}_1 \) is satisfied. □

Proposition 5.6 tells us that \( \mathcal{B}_2 \) is a block decomposition both in \( \mathcal{V}_1 \) and \( \mathcal{V}_2 \). Therefore, by Definition 4.25, for every \( B_{p,2} \in \mathcal{B}_2 \) its invariant part in \( \mathcal{V}_2 \) that is, \( \mathsf{Inv}_{\mathcal{V}_2} B_{p,2} \)—continues to \( \mathsf{Inv}_{\mathcal{V}_1} B_{p,2} \) in \( \mathcal{V}_1 \), and therefore, shares the same dynamical properties, in particular the Conley index (Theorem 4.26). This allows us to study the transition from \( \mathcal{B}_1 \) to \( \mathcal{B}_2 \) on a common ground, that is, within multivector field \( \mathcal{V}_1 \). The next theorem captures in more detail the relationship between individual isolating blocks of \( \mathcal{B}_1 \) and \( \mathcal{B}_2 \). Let us first define the connection set for a family of subsets \( \mathcal{A} \) of \( X \) within \( Y \subset X \):
```

- RAW: ```
C _ { \nu } ( \mathcal { A } , Y ) \coloneqq \bigcup _ { A , A ^ { \prime } \in \mathcal { A } } \{ \text {im } \rho \, | \, \rho \in \text {Paths} _ { \nu } ( Y ) , \, \rho ^ { \square } \in A , \, \rho ^ { \square } \in A ^ { \prime } \} .
```
  FIX: ```
$$
C _ { \nu } ( \mathcal { A } , Y ) \coloneqq \bigcup _ { A , A ^ { \prime } \in \mathcal { A } } \{ \text {im } \rho \mid \rho \in \mathsf{Paths} _ { \nu } ( Y ) , \, \rho ^ { \square } \in A , \, \rho ^ { \square } \in A ^ { \prime } \} .
$$
```

- RAW: ```
Theorem 5.7. Let ( B 1 , V 1 ) ⊑ ( B 2 , V 2 ). Let q ∈ P 2 and Q := −→ ι − 1 1 ( q ). Then:

- (a) B Q : = { B p, 1 ∈ B 1 | p ∈ Q } is a block decomposition of B q, 2 with respect to V 1 ; moreover B Q , 1 : = C V 1 ( { B p, 1 | p ∈ Q } ,X ) ⊂ B q, 2 ,
- (b) M Q , 1 : = Inv V 1 B q, 2 is an invariant set in V 1 isolated by B q, 2 ; moreover, M Q , 1 = C V 1 ( { M p, 1 | p ∈ Q } ,X ),
- (c) M Q , 1 in V 1 continues to M q, 2 in V 2 .
```
  FIX: ```
Theorem 5.7. Let \( ( \mathcal{B}_1 , \mathcal{V}_1 ) \sqsubseteq ( \mathcal{B}_2 , \mathcal{V}_2 ) \). Let \( q \in P_2 \) and \( Q \coloneqq \overrightarrow{\iota}_1^{-1} ( q ) \). Then:

- (a) \( \mathcal{B}_Q \coloneqq \{ B_{p,1} \in \mathcal{B}_1 \mid p \in Q \} \) is a block decomposition of \( B_{q,2} \) with respect to \( \mathcal{V}_1 \); moreover \( B_{Q,1} \coloneqq C_{\mathcal{V}_1} ( \{ B_{p,1} \mid p \in Q \} , X ) \subset B_{q,2} \),
- (b) \( M_{Q,1} \coloneqq \mathsf{Inv}_{\mathcal{V}_1} B_{q,2} \) is an invariant set in \( \mathcal{V}_1 \) isolated by \( B_{q,2} \); moreover, \( M_{Q,1} = C_{\mathcal{V}_1} ( \{ M_{p,1} \mid p \in Q \} , X ) \),
- (c) \( M_{Q,1} \) in \( \mathcal{V}_1 \) continues to \( M_{q,2} \) in \( \mathcal{V}_2 \).
```
