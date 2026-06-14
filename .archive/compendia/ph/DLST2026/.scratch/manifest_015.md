# Manifest: Page 015

## REPLACE_TABLES
None

## REPAIR_MATH
- RAW: ```
Figure 10. Examples of isolating blocks (brown sets) and isolated invariant sets (green sets) for a multivector field V from Figure 9 . Four isolating blocks on the left panel form a block decomposition B of V . The green sets on the right panel indicate the invariant parts of the isolating blocks in B forming a Morse decomposition. The graph on the middle panel represents the flow induced partial order for B .
```
  FIX: ```
Figure 10. Examples of isolating blocks (brown sets) and isolated invariant sets (green sets) for a multivector field \( V \) from Figure 9. Four isolating blocks on the left panel form a block decomposition \( B \) of \( V \). The green sets on the right panel indicate the invariant parts of the isolating blocks in \( B \) forming a Morse decomposition. The graph on the middle panel represents the flow induced partial order for \( B \).
```

- RAW: ```
Note, that in the theory of continuous flows, an isolating block B is defined as a compact set with the closed exit set and no internal tangencies. In the combinatorial setting the only way to escape an isolating block is through its mouth, which by Proposition 4.3 has to be closed as well. Moreover, no path starting in an isolating block B can go to mo B and directly return to B . This can be viewed as a counterpart of the “no internal tangencies” condition. The closedness of the isolating block, however, must be abandoned due to sparsity inherent in finite topological spaces.
```
  FIX: ```
Note, that in the theory of continuous flows, an isolating block \( B \) is defined as a compact set with the closed exit set and no internal tangencies. In the combinatorial setting the only way to escape an isolating block is through its mouth, which by Proposition 4.3 has to be closed as well. Moreover, no path starting in an isolating block \( B \) can go to \( \text{mo } B \) and directly return to \( B \). This can be viewed as a counterpart of the “no internal tangencies” condition. The closedness of the isolating block, however, must be abandoned due to sparsity inherent in finite topological spaces.
```

- RAW: ```
4.2. Morse and block decomposition. Let φ be a full solution in V . We define the ultimate backward and forward images of φ :
```
  FIX: ```
4.2. Morse and block decomposition. Let \( \varphi \) be a full solution in \( V \). We define the ultimate backward and forward images of \( \varphi \):
```

- RAW: ```
$$
\text {uim} ^ { - } \varphi \coloneqq \bigcap \varphi ( ( - \infty , t ] ) ,
$$

$$
& = \bigcap _ { t < 0 } \varphi ( ( - \infty , t ] ) , \\ & = \bigcap _ { t < 0 } \varphi ( [ t , + \infty ] ) .
$$

$$
\ u i m ^ { + } \varphi \coloneqq \bigcap _ { t > 0 } \varphi ( [ t , + \infty ) ) .
$$
```
  FIX: ```
$$
\begin{aligned}
\text{uim}^- \varphi &\coloneqq \bigcap_{t \le 0} \varphi((-\infty, t]) \\
&= \bigcap_{t < 0} \varphi((-\infty, t]) \\
&= \bigcap_{t < 0} \varphi([t, +\infty]), \\
\text{uim}^+ \varphi &\coloneqq \bigcap_{t > 0} \varphi([t, +\infty)).
\end{aligned}
$$
```

- RAW: ```
Clearly, since the space X is finite, the ultimate images are always non-empty.
```
  FIX: ```
Clearly, since the space \( X \) is finite, the ultimate images are always non-empty.
```

- RAW: ```
Definition 4.7. (Morse decomposition) [ 33 , Definition 7.1] A collection ( M , P ) : = { M p | p ∈ P } of mutually disjoint, non-empty isolated invariant sets is called a Morse decomposition of S ⊂ X in V if there exists a partial order ( P , ≤ ) such that
```
  FIX: ```
Definition 4.7. (Morse decomposition) [33, Definition 7.1] A collection \( ( M , P ) \coloneqq \{ M_p \mid p \in P \} \) of mutually disjoint, non-empty isolated invariant sets is called a Morse decomposition of \( S \subset X \) in \( V \) if there exists a partial order \( ( P , \leq ) \) such that
```

- RAW: ```
- (M1) for every φ ∈ eSol V ( S ) there exist p,q ∈ P such that uim − φ ⊂ M p and uim + φ ⊂ M q , ⊏ ⊐
```
  FIX: ```
- (M1) for every \( \varphi \in \text{eSol}_V ( S ) \) there exist \( p, q \in P \) such that \( \text{uim}^- \varphi \subset M_p \) and \( \text{uim}^+ \varphi \subset M_q \),
```

- RAW: ```
- (M2) if there exists ρ ∈ Paths V ( S ) with ρ ∈ M p and ρ ∈ M q for some p,q ∈ P then either
```
  FIX: ```
- (M2) if there exists \( \rho \in \text{Paths}_V ( S ) \) with \( \rho \in M_p \) and \( \rho \in M_q \) for some \( p, q \in P \) then either
```

- RAW: ```
- (a) p > q , or
```
  FIX: ```
- (a) \( p > q \), or
```

- RAW: ```
- (b) p = q and im ρ ⊂ M p .
```
  FIX: ```
- (b) \( p = q \) and \( \text{im } \rho \subset M_p \).
```

- RAW: ```
The primary goal of this work is to study the evolution of a Morse decomposition. However, in order to study continuation it is preferable to shift our attention from isolated invariant sets to isolating blocks. Therefore, we introduce the concept of a block decomposition, which we obtain by replacing isolated invariant sets with isolating blocks in Definition 4.7 .
```
  FIX: ```
The primary goal of this work is to study the evolution of a Morse decomposition. However, in order to study continuation it is preferable to shift our attention from isolated invariant sets to isolating blocks. Therefore, we introduce the concept of a block decomposition, which we obtain by replacing isolated invariant sets with isolating blocks in Definition 4.7.
```
