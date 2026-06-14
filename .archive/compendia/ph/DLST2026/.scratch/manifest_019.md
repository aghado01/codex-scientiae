# Manifest: Page 019

## REPAIR_MATH
- RAW: ```
$$
\ p f _ { \nu } ( A , Y ) \colon = \{ x \in Y \ | \ \exists _ { a \in A } \exists _ { \rho \in \text {Paths} _ { \nu } ( Y ) } \ \rho ^ { \square } = a \text { and } \rho ^ { \square } = x \} .
$$
```
  FIX: ```
\[
\operatorname{pf}_V(A, Y) := \{ x \in Y \mid \exists_{a \in A} \exists_{\rho \in \operatorname{Paths}_V(Y)} \rho^\square = a \text{ and } \rho^\square = x \} .
\]
```

## REPAIR_PROSE
- RAW: ```
Proposition 4.17. Let B be an isolating block in V . Then (cl B, mo B ) is an index pair for Inv V B . In particular, by Corollary 4.5 , (cl S, mo S ) is the minimal index pair for an isolated invariant set S .
```
  FIX: ```
Proposition 4.17. Let \( B \) be an isolating block in \( V \). Then \( (\operatorname{cl} B, \operatorname{mo} B) \) is an index pair for \( \operatorname{Inv}_V B \). In particular, by Corollary 4.5, \( (\operatorname{cl} S, \operatorname{mo} S) \) is the minimal index pair for an isolated invariant set \( S \).
```

- RAW: ```
Proposition 4.18. Let ( P,E ) be a pair of closed sets such that E ⊂ P and P \ E is V -compatible. Then ( P,E ) is an index pair for S : = Inv V ( P \ E ).
```
  FIX: ```
Proposition 4.18. Let \( (P, E) \) be a pair of closed sets such that \( E \subset P \) and \( P \setminus E \) is \( V \)-compatible. Then \( (P, E) \) is an index pair for \( S := \operatorname{Inv}_V (P \setminus E) \).
```

- RAW: ```
Proof. To see (IP1) : let x ∈ P \ E and y ∈ F V ( x ) = [ x ] V ∪ cl x . If y ∈ [ x ] V then y ∈ P , because P \ E is V -compatible. If y ∈ cl x then y ∈ P , because P is closed. Therefore, y ∈ P . To see (IP2) : let x ∈ E and y ∈ F V ( x ). If y ∈ [ x ] V ∩ P then necessarily y ∈ E because P \ E is V -compatible and x ̸∈ P \ E . If y ∈ cl x then y ∈ E , because E is closed. Therefore, y ∈ E . Condition (IP3) is given by the assumption. □
```
  FIX: ```
Proof. To see (IP1): let \( x \in P \setminus E \) and \( y \in F_V(x) = [x]_V \cup \operatorname{cl} x \). If \( y \in [x]_V \) then \( y \in P \), because \( P \setminus E \) is \( V \)-compatible. If \( y \in \operatorname{cl} x \) then \( y \in P \), because \( P \) is closed. Therefore, \( y \in P \). To see (IP2): let \( x \in E \) and \( y \in F_V(x) \). If \( y \in [x]_V \cap P \) then necessarily \( y \in E \) because \( P \setminus E \) is \( V \)-compatible and \( x \notin P \setminus E \). If \( y \in \operatorname{cl} x \) then \( y \in E \), because \( E \) is closed. Therefore, \( y \in E \). Condition (IP3) is given by the assumption. □
```

- RAW: ```
Theorem 4.19. [ 33 , Theorem 5.16] Let ( P 1 ,E 1 ) and ( P 2 ,E 2 ) be two index pairs for an isolated invariant set S in V . Then H ( P 1 ,E 1 ) ∼ = H ( P 2 ,E 2 ).
```
  FIX: ```
Theorem 4.19. [33, Theorem 5.16] Let \( (P_1, E_1) \) and \( (P_2, E_2) \) be two index pairs for an isolated invariant set \( S \) in \( V \). Then \( H(P_1, E_1) \cong H(P_2, E_2) \).
```

- RAW: ```
Definition 4.20. (Conley index) [ 33 , Section 5.2] The Conley index of an isolated invariant set S is defined as Con( S ) : = [ H 0 ( P,E ) ,H 1 ( P,E ) ,... ], where ( P,E ) is an index pair for S and the relative homology is calculated over the field k . We also denote each component of Con( S ) as Con i ( S ) : = H i ( P,E ).
```
  FIX: ```
Definition 4.20. (Conley index) [33, Section 5.2] The Conley index of an isolated invariant set \( S \) is defined as \( \operatorname{Con}(S) := [H_0(P,E), H_1(P,E), \dots] \), where \( (P, E) \) is an index pair for \( S \) and the relative homology is calculated over the field \( k \). We also denote each component of \( \operatorname{Con}(S) \) as \( \operatorname{Con}_i(S) := H_i(P,E) \).
```

- RAW: ```
Note that the Conley index is well defined due to Theorem 4.19 ; and that every Con i ( S ) is isomorphic to the vector space k d i , where d i = dim H i ( P,E ).
```
  FIX: ```
Note that the Conley index is well defined due to Theorem 4.19; and that every \( \operatorname{Con}_i(S) \) is isomorphic to the vector space \( k^{d_i} \), where \( d_i = \dim H_i(P,E) \).
```

- RAW: ```
Example 4.21. Conley indices for the Morse sets in M from Example 4.11 are as follows: Con( M 1 ) = [ k,k, 0], Con( M 2 ) = [0 , 0 ,k ], and Con( M 3 ) = [0 , 0 , 0]. In case of M ′ from Example 4.13 we have Con( M ′ 3 ) = [ k, 0 , 0] and Con( M ′ 4 ) = [0 ,k, 0]. Morse sets M ′ 1 and M ′ 2 coincide with M 1 and M 2 . ♢
```
  FIX: ```
Example 4.21. Conley indices for the Morse sets in \( M \) from Example 4.11 are as follows: \( \operatorname{Con}(M_1) = [k, k, 0] \), \( \operatorname{Con}(M_2) = [0, 0, k] \), and \( \operatorname{Con}(M_3) = [0, 0, 0] \). In case of \( M' \) from Example 4.13 we have \( \operatorname{Con}(M'_3) = [k, 0, 0] \) and \( \operatorname{Con}(M'_4) = [0, k, 0] \). Morse sets \( M'_1 \) and \( M'_2 \) coincide with \( M_1 \) and \( M_2 \). ♢
```

- RAW: ```
Theorem 4.22. [ 18 , Theorem 28] If ( P,E ) and ( P ′ ,E ′ ) are index pairs for S in V such that ( P,E ) ⊂ ( P ′ ,E ′ ) then the inclusion induces an isomorphism in homology.
```
  FIX: ```
Theorem 4.22. [18, Theorem 28] If \( (P, E) \) and \( (P', E') \) are index pairs for \( S \) in \( V \) such that \( (P, E) \subset (P', E') \) then the inclusion induces an isomorphism in homology.
```

- RAW: ```
The push forward of a set A in Y ⊂ X with respect to V is defined by:
```
  FIX: ```
The push forward of a set \( A \) in \( Y \subset X \) with respect to \( V \) is defined by:
```

- RAW: ```
Proposition 4.23. Let B be a locally closed, V -compatible subset of X . Then, for any set A ⊂ B , the push forward pf V ( A, cl B ) is closed. Moreover, pf V ( A,B ) is locally closed and V -compatible.
```
  FIX: ```
Proposition 4.23. Let \( B \) be a locally closed, \( V \)-compatible subset of \( X \). Then, for any set \( A \subset B \), the push forward \( \operatorname{pf}_V(A, \operatorname{cl} B) \) is closed. Moreover, \( \operatorname{pf}_V(A, B) \) is locally closed and \( V \)-compatible.
```

- RAW: ```
Assume that ( P,E ) and ( P ′ ,E ′ ) are two index pairs for S in V . Now take B , an isolating block for S , such that B ⊂ P \ E and B ⊂ P ′ \ E ′ (by Corollary 4.5
```
  FIX: ```
Assume that \( (P, E) \) and \( (P', E') \) are two index pairs for \( S \) in \( V \). Now take \( B \), an isolating block for \( S \), such that \( B \subset P \setminus E \) and \( B \subset P' \setminus E' \) (by Corollary 4.5
```
