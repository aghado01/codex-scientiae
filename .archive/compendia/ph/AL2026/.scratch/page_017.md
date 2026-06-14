[Page 17]

Definition 3.1. Let \( x \in P \), and let \( U \) be a subset of \( P \). Then we set

$$
$$
\uparrow _ { P } x \coloneqq \{ y \in P \, | \, y \geq x \} , \, \text {and} \, \downarrow _ { P } x \coloneqq \{ y \in P \, | \, y \leq x \} , \\ \uparrow _ { P } U \coloneqq \bigcup _ { x \in U } \uparrow _ { P } x , \, \text {and} \, \downarrow _ { P } U \coloneqq \bigcup _ { x \in U } \downarrow _ { P } x .
$$
$$

We say that \( U \) is an up-set (resp. a down-set) of \( P \) if \( U = \uparrow _ { P } U \) (resp. \( U = \downarrow _ { P } U \)). Upsets and down-sets are naturally considered as full subposets of \( P \) without specifying in the sequel.

Remark 3.2. (1) Since \( P \) is finite, any up-set \( U \) can be written as \( U = \uparrow _ { P } \operatorname{sc}( U ) = \bigcup _ { x \in \operatorname{sc}( U ) } \uparrow _ { P } x \). Dually, any down-set \( U \) can be written as \( U = \downarrow _ { P } \operatorname{sk}( U ) = \bigcup _ { x \in \operatorname{sk}( U ) } \downarrow _ { P } x \).

- (2) If \( X = \uparrow _ { P } U \), then \( \operatorname{sc}( X ) = \operatorname{sc}( U ) \). Dually, if \( X = \downarrow _ { P } U \), then \( \operatorname{sk}( X ) = \operatorname{sk}( U ) \).
- (3) It is easy to see that \( \uparrow _ { P } \uparrow _ { P } U = \uparrow _ { P } U \) and \( \downarrow _ { P } \downarrow _ { P } U = \downarrow _ { P } U \).
- (4) If \( U \) is an up-set (resp. down-set) of \( P \) and \( x \) is any element of \( U \), then \( \uparrow _ { P } x = \uparrow _ { U } x \) (resp. \( \downarrow _ { P } x = \downarrow _ { U } x \)).


We simply write \( \uparrow , \downarrow \) for \( \uparrow _ { P } , \downarrow _ { P } \), respectively if there seems to be no confusion. To compute \( d _ { M } ( V _ { I } ) \), we apply ( Asashiba et al. 2017 , Theorem 3) below.

Theorem 3.3. Let \( M \) and \( L \) be two finite-dimensional modules over a finite-dimensional algebra \( A \), and assume that \( L \) is indecomposable. When \( L \) is non-injective, let

$$
$$
0 \to L \to E \to \tau ^ { - 1 } L \to 0
$$
$$

be an almost split sequence starting from L . Then we have the following formulas.

- (1) If \( L \) is injective, then

$$
$$
d _ { M } ( L ) = \dim H o m _ { A } ( L , M ) - \dim H o m _ { A } ( L / \text {soc} \, L , M ) .
$$
$$

- (2) If \( L \) is non-injective, then


$$
$$
d _ { M } ( L ) = \dim H o m _ { A } ( L , M ) - \dim H o m _ { A } ( E , M ) + \dim H o m _ { A } ( \tau ^ { - 1 } L , M ) .
$$
$$

In the next subsection, we will give our result in general case. This will be specialized in Section 3.2 for the case of 2D-grids. The latter has a simpler formula and easier to grasp than the former. The reader may read Section 3.2 first by looking at Example 3.37 to have rough outline. It contains enough information to apply the formula for 2D-grids. The details of proofs written in Section 3.1 can be read afterward.

# 3.1 The general poset case

Without loss of generality, we may assume that the poset \( P \) is connected.
