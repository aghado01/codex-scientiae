[Page 7]

While the deﬁnition of the Prohorov distance appears a bit complicated, the following observation suggests that it captures ‘robustness to outliers’ in a meaningful way.

Exercise 9.20. Let X Y ✓ n , ﬁnite, non-empty sets. Show that

$$
d _ { \Pr } ( \mu _ { X } , \mu _ { Y } ) \leqslant \frac { | Y \ \ X | } { | X | } .
$$

As an example, the normalized multicover persistence module turns out to be stable w.r.t. Prohorov distance (i.e., it is robust to outliers).

Deﬁnition 9.21. Let X ✓ n be a ﬁnite point cloud. For r, ⇢ 2 , the sets

$$
\mathcal { N M C } _ { \rho } ^ { r } ( X ) & \coloneqq \{ x \in \mathbb { R } ^ { n } \, \colon | B ( x , r ) \cap X | \geqslant \rho | X | \} = \{ x \in \mathbb { R } ^ { n } \, \colon \mu _ { X } ( B ( x , r ) \cap X ) \geqslant \rho \} . \\ \intertext { f o r m a b i l f l t r a t i o n o v e r R \times \mathbb { R } ^ { o p } c a l l e d t h e n o r m a l z i d u c t i v e b i f l t r a t i o n . }
$$

form a bilﬁltration over ⇥ op called the normalized multicover biﬁltration .

Theorem 9.22 (see [ 1 ]) . Let X,Y ✓ n ﬁnite. For all k > 0 , we have

$$
d _ { I } \left ( H _ { k } ( \mathbb { N } \mathcal { M } \mathcal { C } ( X ) ) , \ H _ { k } ( \mathbb { N } \mathcal { M } \mathcal { C } ( Y ) ) \right ) & \leqslant d _ { \Pr } ( \mu _ { X } , \mu _ { Y } ) . \\ P r o f , \text { let } \epsilon = d _ { \Pr } ( \mu _ { X } , \mu _ { Y } ) , \text { We will show that }
$$

Proof. Let ✏ = d Pr ( µ X ,µ Y ) . We will show that

$$
\mathcal { N M C } _ { \rho } ^ { r } ( X ) \subseteq \mathcal { N M C } _ { \rho - \epsilon } ^ { r + \epsilon } ( Y ) \subseteq \mathcal { N M C } _ { \rho - 2 \epsilon } ^ { r + 2 \epsilon } ( X ) \quad \forall r , \rho \in \mathbb { R } .
$$

These inclusions induce the maps

$$
\varphi _ { r , \rho } \colon H _ { k } ( \mathcal { N M C } _ { \rho } ^ { r } ( X ) ) \to H _ { k } ( \mathcal { N M C } _ { \rho - \epsilon } ^ { r + \epsilon } ( Y ) ) , \\ \psi _ { r + \epsilon , \rho - \epsilon } \colon H _ { k } ( \mathcal { N M C } _ { \rho - \epsilon } ^ { r + \epsilon } ( Y ) ) \to H _ { k } ( \mathcal { N M C } _ { \rho - 2 \epsilon } ^ { r + 2 \epsilon } ( X ) )
$$

$$
\cdot ) ) )
$$

required to show that H k ( NMC ( X )) and H k ( NMC ( Y )) are ✏ -interleaved. r

So, let r, ⇢ 2 , and suppose that x 2 NMC ⇢ ( X ) . By deﬁnition, this means that µ X ( B ( x,r ) \ X ) > ⇢ . Using the deﬁnition of the Prohorov distance, and the triangleinequality, this implies that

$$
\rho & \leqslant \mu _ { X } ( B ( x , r ) \cap X ) \leqslant \mu _ { Y } ( B ( x , r ) ^ { \epsilon } \cap Y ) + \epsilon \leqslant \mu _ { Y } ( B ( x , r + \epsilon ) \cap Y ) + \epsilon . \\ \intertext { T h a t is to say, } \mu _ { X } ( B ( x , r + \epsilon ) \cap Y ) & \geqslant \rho - \epsilon , \, \text {meaning } x \in \mathcal { N M C } _ { 0 } ^ { r + \epsilon } ( Y ) , \, \text { giving us the first }
$$

That is to say, µ Y ( B ( x,r + ✏ ) \ Y ) > ⇢ ✏ , meaning x 2 NMC r + ✏ ⇢ ✏ ( Y ) , giving us the ﬁrst inclusion. The second inclusion follows from an analogous argument, switching the roles of X and Y .

There are many similar theorems for other bipersistence modules, including the degree-Rips biﬁltration. They are often somewhat hard to state and prove, relying on variants of the Prohorov distance, as well as variants of the interleaving distance [ 1 ].
