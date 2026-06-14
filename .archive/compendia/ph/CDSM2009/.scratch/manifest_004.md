# Manifest: Page 004

## REPAIR_MATH
- RAW: ```
\mathbb { X } _ { 0 } ^ { 0 } \rightarrow \mathbb { X } _ { 0 } ^ { 1 } \leftarrow \mathbb { X } _ { 1 } ^ { 1 } \rightarrow \mathbb { X } _ { 1 } ^ { 2 } \leftarrow \mathbb { X } _ { 2 } ^ { 2 } \rightarrow \dots .
```
  FIX: ```
$$
\mathbb { X } _ { 0 } ^ { 0 } \rightarrow \mathbb { X } _ { 0 } ^ { 1 } \leftarrow \mathbb { X } _ { 1 } ^ { 1 } \rightarrow \mathbb { X } _ { 1 } ^ { 2 } \leftarrow \mathbb { X } _ { 2 } ^ { 2 } \rightarrow \dots .
$$
```
- RAW: ```
0 \to \langle \alpha , \beta \rangle \gets \langle \alpha , \beta \rangle \to \langle \alpha , \beta \rangle \stackrel { g } { \leftarrow } \langle \gamma \rangle \to \dots
```
  FIX: ```
$$
0 \to \langle \alpha , \beta \rangle \gets \langle \alpha , \beta \rangle \to \langle \alpha , \beta \rangle \stackrel { g } { \leftarrow } \langle \gamma \rangle \to \dots
$$
```
- RAW: ```
0 \to \langle \alpha \rangle \leftarrow \langle \alpha \rangle \to \langle \alpha \rangle \leftarrow 0 \to \dots
```
  FIX: ```
$$
0 \to \langle \alpha \rangle \leftarrow \langle \alpha \rangle \to \langle \alpha \rangle \leftarrow 0 \to \dots
$$
```
- RAW: ```
0 \to \langle \alpha + \beta \rangle \gets \langle \alpha + \beta \rangle \to \langle \alpha + \beta \rangle \gets \langle \gamma \rangle \to \dots
```
  FIX: ```
$$
0 \to \langle \alpha + \beta \rangle \gets \langle \alpha + \beta \rangle \to \langle \alpha + \beta \rangle \gets \langle \gamma \rangle \to \dots
$$
```
- RAW: ```
( A 1 ∪ A 2 , B 1 ∪ B 2 ) ( A 1 , B 1 ) ( A 2 , B 2 ) ( A 1 ∩ A 2 , B 1 ∩ B 2 ) j j j j j T T T T T T T T T T j j j j j
```
  FIX: ```
$$
\begin{CD}
( A_1 \cup A_2 , B_1 \cup B_2 ) @>>> ( A_1 , B_1 ) \\
@VVV @VVV \\
( A_2 , B_2 ) @>>> ( A_1 \cap A_2 , B_1 \cap B_2 )
\end{CD}
$$
```

## REPAIR_PROSE
- RAW: `Morse function f deﬁned`
  FIX: `Morse function \( f \) deﬁned`
- RAW: `DgmZZ( f ) .`
  FIX: `\( \text{DgmZZ}(f) \).`
- RAW: `applying H 1 to get`
  FIX: `applying \( H_1 \) to get`
- RAW: `The map g is deﬁned by g ( γ ) = α + β .`
  FIX: `The map \( g \) is deﬁned by \( g(\gamma) = \alpha + \beta \).`
- RAW: `interval [ X 1 0 , X 2 1 ] or [ a 1 , a 2 ] .`
  FIX: `interval \( [X_1^0, X_2^1] \) or \( [a_1, a_2] \).`
- RAW: `slice X I and the restricted function f I is`
  FIX: `slice \( X_I \) and the restricted function \( f_I \) is`
- RAW: `original ( X , f ).`
  FIX: `original \( (X, f) \).`
- RAW: `intervals of ( X , f ) which meet I ,`
  FIX: `intervals of \( (X, f) \) which meet \( I \),`
- RAW: `intervals of ( X I , f I ).`
  FIX: `intervals of \( (X_I, f_I) \).`
- RAW: `symmetry : ( X , f ) and ( X , − f ) have`
  FIX: `symmetry: \( (X, f) \) and \( (X, -f) \) have`
- RAW: `Given ( X , f ) of`
  FIX: `Given \( (X, f) \) of`
- RAW: `slices of X .`
  FIX: `slices of \( X \).`
- RAW: `slices, X j i with i ≤ j , themselves.`
  FIX: `slices, \( X_j^i \) with \( i \leq j \), themselves.`
- RAW: `pairs ( X j 0 , X i 0 ) with i ≤ j .`
  FIX: `pairs \( (X_j^0, X_i^0) \) with \( i \leq j \).`
- RAW: `pairs ( X n i , X n j ) with i ≤ j .`
  FIX: `pairs \( (X_n^i, X_n^j) \) with \( i \leq j \).`
- RAW: `pairs ( X n 0 , X i 0 ∪ X n j ) with i < j .`
  FIX: `pairs \( (X_n^0, X_i^0 \cup X_n^j) \) with \( i < j \).`
- RAW: `case n = 3.`
  FIX: `case \( n = 3 \).`
- RAW: `form ( X i 0 , X i 0 ) or ( X n j , X n j ) are shown compactly as ∅ .`
  FIX: `form \( (X_i^0, X_i^0) \) or \( (X_n^j, X_n^j) \) are shown compactly as \( \emptyset \).`
- RAW: `have 2 n +1 nodes, excluding the initial and terminal ∅ .`
  FIX: `have \( 2n + 1 \) nodes, excluding the initial and terminal \( \emptyset \).`
- RAW: `zigzags X 1 , X 2 in the pyramid diagram`
  FIX: `zigzags \( X_1, X_2 \) in the pyramid diagram`
- RAW: `between Pers( H ∗ ( X 1 )) and Pers( H ∗ ( X 2 )), which respects homological dimension except for possible shifts of degree ± 1.`
  FIX: `between \( \text{Pers}(H_*(X_1)) \) and \( \text{Pers}(H_*(X_2)) \), which respects homological dimension except for possible shifts of degree \( \pm 1 \).`
- RAW: `ﬁnal ∅ in our description of each X i . Then X 1 can be transformed to X 2 by a sequence of diamond moves (which transform the persistence intervals bijectively, by the Diamond Lemma) and shifts of either terminal ∅ (which have no eﬀect on the intervals). Thus X 1 , X 2 carry`
  FIX: `ﬁnal \( \emptyset \) in our description of each \( X_i \). Then \( X_1 \) can be transformed to \( X_2 \) by a sequence of diamond moves (which transform the persistence intervals bijectively, by the Diamond Lemma) and shifts of either terminal \( \emptyset \) (which have no eﬀect on the intervals). Thus \( X_1, X_2 \) carry`
- RAW: `shift of +1 from`
  FIX: `shift of \( +1 \) from`
- RAW: `comparing X 1 and X 2 to the levelset zigzag in such a way, it can be veriﬁed that the composite transformation between Pers( H ∗ ( X 1 )) and Pers( H ∗ ( X 2 )) does not shift any intervals in dimension by more than 1.`
  FIX: `comparing \( X_1 \) and \( X_2 \) to the levelset zigzag in such a way, it can be veriﬁed that the composite transformation between \( \text{Pers}(H_*(X_1)) \) and \( \text{Pers}(H_*(X_2)) \) does not shift any intervals in dimension by more than \( 1 \).`
