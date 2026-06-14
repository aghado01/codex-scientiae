# Manifest: Page 016

## REPAIR_MATH
- RAW: ```
( B 3 ) \ S = \bigcup _ { p \in \mathbb { P } } B _ { p } ,
```
  FIX: ```
$$
( B 3 ) \ S = \bigcup _ { p \in \mathbb { P } } B _ { p } ,
$$
```
- RAW: ```
\mathcal { B } _ { \bullet , \nu } \coloneqq \{ \text {Inv} _ { \mathcal { V } } ( B _ { p } ) \, | \, p \in \mathbb { P } \text { such that } \text {Inv} _ { \mathcal { V } } ( B _ { p } ) \neq \emptyset \} .
```
  FIX: ```
$$
\mathcal { B } _ { \bullet , \nu } \coloneqq \{ \text {Inv} _ { \mathcal { V } } ( B _ { p } ) \, | \, p \in \mathbb { P } \text { such that } \text {Inv} _ { \mathcal { V } } ( B _ { p } ) \neq \emptyset \} .
$$
```
- RAW: ```
\text {Inv} _ { \mathcal { V } } ( \text {uim} ^ { - } \varphi ) \subset \text {Inv} _ { \mathcal { V } } ( B _ { p } ) \in \mathcal { B } _ { \bullet } \quad \text {and} \quad \text {Inv} _ { \mathcal { V } } ( \text {uim} ^ { + } \varphi ) \subset \text {Inv} _ { \mathcal { V } } ( B _ { q } ) \in \mathcal { B } _ { \bullet } .
```
  FIX: ```
$$
\text {Inv} _ { \mathcal { V } } ( \text {uim} ^ { - } \varphi ) \subset \text {Inv} _ { \mathcal { V } } ( B _ { p } ) \in \mathcal { B } _ { \bullet } \quad \text {and} \quad \text {Inv} _ { \mathcal { V } } ( \text {uim} ^ { + } \varphi ) \subset \text {Inv} _ { \mathcal { V } } ( B _ { q } ) \in \mathcal { B } _ { \bullet } .
$$
```
- RAW: ```
A collection ( B , P ) : = { B p | p ∈ P } of mutually disjoint, non-empty isolating blocks is called a block decomposition of S ⊂ X in V if there exists a partial order ( P , ≤ ) such that
```
  FIX: ```
A collection \( (\mathcal{B}, \mathbb{P}) \coloneqq \{ B_p \mid p \in \mathbb{P} \} \) of mutually disjoint, non-empty isolating blocks is called a block decomposition of \( S \subset X \) in \( \mathcal{V} \) if there exists a partial order \( (\mathbb{P}, \leq) \) such that
```
- RAW: ```
- (B1) for every φ ∈ eSol V ( S ) there exist p,q ∈ P such that uim − φ ⊂ B p and uim + φ ⊂ B q , ⊏ ⊐
```
  FIX: ```
- (B1) for every \( \varphi \in \text{eSol}_{\mathcal{V}}(S) \) there exist \( p, q \in \mathbb{P} \) such that \( \text{uim}^- \varphi \subset B_p \) and \( \text{uim}^+ \varphi \subset B_q \),
```
- RAW: ```
- (B2) if there exists ρ ∈ Paths V ( S ) with ρ ∈ B p and ρ ∈ B q for some p,q ∈ P then either
```
  FIX: ```
- (B2) if there exists \( \rho \in \text{Paths}_{\mathcal{V}}(S) \) with \( \rho^\sqsubset \in B_p \) and \( \rho^\sqsupset \in B_q \) for some \( p, q \in \mathbb{P} \) then either
```
- RAW: ```
- (a) p > q , or
```
  FIX: ```
- (a) \( p > q \), or
```
- RAW: ```
- (b) p = q and im ρ ⊂ B p .
```
  FIX: ```
- (b) \( p = q \) and \( \text{im } \rho \subset B_p \).
```
- RAW: ```
then we call ( B , P ) a block partition of S .
```
  FIX: ```
then we call \( (\mathcal{B}, \mathbb{P}) \) a block partition of \( S \).
```
- RAW: ```
We write M or B for a Morse or a block decomposition, respectively, omitting P when it can be deduced from the context. We call the minimal order satisfying (M2) or (B2) the flow induced order . Any extension of the partial order ( P , ≤ ) to a linear order is called an admissible linear order for M or B .
```
  FIX: ```
We write \( \mathcal{M} \) or \( \mathcal{B} \) for a Morse or a block decomposition, respectively, omitting \( \mathbb{P} \) when it can be deduced from the context. We call the minimal order satisfying (M2) or (B2) the flow induced order. Any extension of the partial order \( (\mathbb{P}, \leq) \) to a linear order is called an admissible linear order for \( \mathcal{M} \) or \( \mathcal{B} \).
```
- RAW: ```
There is a simple correspondence between block and Morse decompositions. Namely, as we prove in the next proposition, every B induces the Morse decomposition
```
  FIX: ```
There is a simple correspondence between block and Morse decompositions. Namely, as we prove in the next proposition, every \( \mathcal{B} \) induces the Morse decomposition
```
- RAW: ```
We omit V when it is clear from the context and write B • . We say that a block decomposition B covers Morse decomposition M if B • = M . By Remark 4.9 , every Morse decomposition admits at least one (trivial) covering block decomposition.
```
  FIX: ```
We omit \( \mathcal{V} \) when it is clear from the context and write \( \mathcal{B}_\bullet \). We say that a block decomposition \( \mathcal{B} \) covers Morse decomposition \( \mathcal{M} \) if \( \mathcal{B}_\bullet = \mathcal{M} \). By Remark 4.9, every Morse decomposition admits at least one (trivial) covering block decomposition.
```
- RAW: ```
Proposition 4.10. Let ( B , P ) be a block decomposition of S . Then B • is a Morse decomposition of S .
```
  FIX: ```
Proposition 4.10. Let \( (\mathcal{B}, \mathbb{P}) \) be a block decomposition of \( S \). Then \( \mathcal{B}_\bullet \) is a Morse decomposition of \( S \).
```
- RAW: ```
Proof. Let φ ∈ eSol V ( S ). By (B1) , there exist p,q ∈ P such that uim − φ ⊂ B p and uim + φ ⊂ B q . As a consequence of [ 33 , Proposition 6.5], Inv V (uim ± φ ) = uim ± φ ; therefore, we conclude (M1) , because of
```
  FIX: ```
Proof. Let \( \varphi \in \text{eSol}_{\mathcal{V}}(S) \). By (B1), there exist \( p, q \in \mathbb{P} \) such that \( \text{uim}^- \varphi \subset B_p \) and \( \text{uim}^+ \varphi \subset B_q \). As a consequence of [33, Proposition 6.5], \( \text{Inv}_{\mathcal{V}}(\text{uim}^\pm \varphi) = \text{uim}^\pm \varphi \); therefore, we conclude (M1), because of
```
- RAW: ```
Consider p, q ∈ P and denote M p := Inv V B p and M q := Inv V B q . Assume that there exists a path ρ ∈ Paths V ( M p , M q , S ). Clearly M p ⊂ B p and M q ⊂ B q . Hence, if p = q and p > q in B then p = q and p > q in the induced order on B · . If p = q then, in particular exist essential solutions ψ ∈ eSol V ( ρ ⊏ , M p ) and ψ ′ ∈ eSol V ( ρ ⊐ , M p ). Let ψ + denotes the restriction of ψ to [0 , + ∞ ] Z and ψ ′ -, the restriction of ψ ′ to [ -∞ , 0] Z . It is easy to verify that φ := ψ ′ -· ρ · ψ + is an essential solution in B p . Therefore, im ρ ⊂ im φ ⊂ Inv V M p , which shows (M2) and concludes the proof. □
```
  FIX: ```
Consider \( p, q \in \mathbb{P} \) and denote \( M_p \coloneqq \text{Inv}_{\mathcal{V}}(B_p) \) and \( M_q \coloneqq \text{Inv}_{\mathcal{V}}(B_q) \). Assume that there exists a path \( \rho \in \text{Paths}_{\mathcal{V}}(M_p, M_q, S) \). Clearly \( M_p \subset B_p \) and \( M_q \subset B_q \). Hence, if \( p \neq q \) and \( p > q \) in \( \mathcal{B} \) then \( p \neq q \) and \( p > q \) in the induced order on \( \mathcal{B}_\bullet \). If \( p = q \) then, in particular exist essential solutions \( \psi \in \text{eSol}_{\mathcal{V}}(\rho^\sqsubset, M_p) \) and \( \psi^\prime \in \text{eSol}_{\mathcal{V}}(\rho^\sqsupset, M_p) \). Let \( \psi^+ \) denote the restriction of \( \psi \) to \( [0, +\infty)_\mathbb{Z} \) and \( \psi^{\prime -} \), the restriction of \( \psi^\prime \) to \( (-\infty, 0]_\mathbb{Z} \). It is easy to verify that \( \varphi \coloneqq \psi^{\prime -} \cdot \rho \cdot \psi^+ \) is an essential solution in \( B_p \). Therefore, \( \text{im } \rho \subset \text{im } \varphi \subset \text{Inv}_{\mathcal{V}}(M_p) \), which shows (M2) and concludes the proof. \(\square\)
```
