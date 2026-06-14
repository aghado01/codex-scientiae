# Manifest: Page 017

## REPAIR_MATH
- RAW: ```
\uparrow _ { P } x \coloneqq \{ y \in P \, | \, y \geq x \} , \, \text {and} \, \downarrow _ { P } x \coloneqq \{ y \in P \, | \, y \leq x \} , \\ \uparrow _ { P } U \coloneqq \bigcup _ { x \in U } \uparrow _ { P } x , \, \text {and} \, \downarrow _ { P } U \coloneqq \bigcup _ { x \in U } \downarrow _ { P } x .
```
  FIX: ```
$$
\uparrow _ { P } x \coloneqq \{ y \in P \, | \, y \geq x \} , \, \text {and} \, \downarrow _ { P } x \coloneqq \{ y \in P \, | \, y \leq x \} , \\ \uparrow _ { P } U \coloneqq \bigcup _ { x \in U } \uparrow _ { P } x , \, \text {and} \, \downarrow _ { P } U \coloneqq \bigcup _ { x \in U } \downarrow _ { P } x .
$$
```
- RAW: ```
0 \to L \to E \to \tau ^ { - 1 } L \to 0
```
  FIX: ```
$$
0 \to L \to E \to \tau ^ { - 1 } L \to 0
$$
```
- RAW: ```
d _ { M } ( L ) = \dim H o m _ { A } ( L , M ) - \dim H o m _ { A } ( L / \text {soc} \, L , M ) .
```
  FIX: ```
$$
d _ { M } ( L ) = \dim H o m _ { A } ( L , M ) - \dim H o m _ { A } ( L / \text {soc} \, L , M ) .
$$
```
- RAW: ```
d _ { M } ( L ) = \dim H o m _ { A } ( L , M ) - \dim H o m _ { A } ( E , M ) + \dim H o m _ { A } ( \tau ^ { - 1 } L , M ) .
```
  FIX: ```
$$
d _ { M } ( L ) = \dim H o m _ { A } ( L , M ) - \dim H o m _ { A } ( E , M ) + \dim H o m _ { A } ( \tau ^ { - 1 } L , M ) .
$$
```

- RAW: ```
Definition 3.1. Let x ∈ P , and let U be a subset of P . Then we set
```
  FIX: ```
Definition 3.1. Let \( x \in P \), and let \( U \) be a subset of \( P \). Then we set
```
- RAW: ```
We say that U is an up-set (resp. a down-set) of P if U = ↑ P U (resp. U = ↓ P U ). Upsets and down-sets are naturally considered as full subposets of P without specifying in the sequel.
```
  FIX: ```
We say that \( U \) is an up-set (resp. a down-set) of \( P \) if \( U = \uparrow _ { P } U \) (resp. \( U = \downarrow _ { P } U \)). Upsets and down-sets are naturally considered as full subposets of \( P \) without specifying in the sequel.
```
- RAW: ```
Remark 3.2. (1) Since P is finite, any up-set U can be written as U = ↑ P sc( U ) = x ∈ sc( U ) ↑ P x . Dually, any down-set U can be written as U = ↓ P sk( U ) = x ∈ sk( U ) ↓ P x .
```
  FIX: ```
Remark 3.2. (1) Since \( P \) is finite, any up-set \( U \) can be written as \( U = \uparrow _ { P } \operatorname{sc}( U ) = \bigcup _ { x \in \operatorname{sc}( U ) } \uparrow _ { P } x \). Dually, any down-set \( U \) can be written as \( U = \downarrow _ { P } \operatorname{sk}( U ) = \bigcup _ { x \in \operatorname{sk}( U ) } \downarrow _ { P } x \).
```
- RAW: ```
- (2) If X = ↑ P U , then sc( X ) = sc( U ) . Dually, if X = ↓ P U , then sk( X ) = sk( U ) .
```
  FIX: ```
- (2) If \( X = \uparrow _ { P } U \), then \( \operatorname{sc}( X ) = \operatorname{sc}( U ) \). Dually, if \( X = \downarrow _ { P } U \), then \( \operatorname{sk}( X ) = \operatorname{sk}( U ) \).
```
- RAW: ```
- (3) It is easy to see that ↑ P ↑ P U = ↑ P U and ↓ P ↓ P U = ↓ P U .
```
  FIX: ```
- (3) It is easy to see that \( \uparrow _ { P } \uparrow _ { P } U = \uparrow _ { P } U \) and \( \downarrow _ { P } \downarrow _ { P } U = \downarrow _ { P } U \).
```
- RAW: ```
- (4) If U is an up-set (resp. down-set) of P and x is any element of U , then ↑ P x = ↑ U x (resp. ↓ P x = ↓ U x ).
```
  FIX: ```
- (4) If \( U \) is an up-set (resp. down-set) of \( P \) and \( x \) is any element of \( U \), then \( \uparrow _ { P } x = \uparrow _ { U } x \) (resp. \( \downarrow _ { P } x = \downarrow _ { U } x \)).
```
- RAW: ```
We simply write ↑ , ↓ for ↑ P , ↓ P , respectively if there seems to be no confusion. To compute d M ( V I ) , we apply ( Asashiba et al. 2017 , Theorem 3) below.
```
  FIX: ```
We simply write \( \uparrow , \downarrow \) for \( \uparrow _ { P } , \downarrow _ { P } \), respectively if there seems to be no confusion. To compute \( d _ { M } ( V _ { I } ) \), we apply ( Asashiba et al. 2017 , Theorem 3) below.
```
- RAW: ```
Theorem 3.3. Let M and L be two finite-dimensional modules over a finitedimensional algebra A , and assume that L is indecomposable. When L is non-injective, let 1
```
  FIX: ```
Theorem 3.3. Let \( M \) and \( L \) be two finite-dimensional modules over a finite-dimensional algebra \( A \), and assume that \( L \) is indecomposable. When \( L \) is non-injective, let
```
- RAW: ```
- (1) If L is injective, then
```
  FIX: ```
- (1) If \( L \) is injective, then
```
- RAW: ```
- (2) If L is non-injective, then
```
  FIX: ```
- (2) If \( L \) is non-injective, then
```
- RAW: ```
Without loss of generality, we may assume that the poset P is connected.
```
  FIX: ```
Without loss of generality, we may assume that the poset \( P \) is connected.
```
