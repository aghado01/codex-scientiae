[Page 29]

Lemma 4.13 ([10]) . Let ( Z q ) q ∈ Z 2 be a translation-invariant random ﬁeld where Z q = ( ˜ X v k , ˜ Y v k ) for q = ( k,v ) ∈ Z 2 takes values in a ﬁnite set. Then for any n ≥ 0

$$
H ( \tilde { Y } _ { 0 } ^ { v } | \tilde { Y } _ { 0 } ^ { < v } , \tilde { Y } _ { < 0 } ) - H ( \tilde { Y } _ { 0 } ^ { v } | \tilde { Y } _ { 0 } ^ { < v } , \tilde { Y } _ { < 0 } ; \tilde { X } _ { - n } ^ { < v } , \tilde { X } _ { < - n } ) = \\ H ( \tilde { X } _ { 0 } ^ { v } | \tilde { X } _ { 0 } ^ { < v } , \tilde { X } _ { < 0 } ; \tilde { Y } _ { n } ^ { v } , \tilde { Y } _ { n } ^ { < v } , \tilde { Y } _ { < n } ) - H ( \tilde { X } _ { 0 } ^ { v } | \tilde { X } _ { 0 } ^ { < v } , \tilde { X } _ { < 0 } ; \tilde { Y } ) ,
$$

$$
w h e r e \, \tilde { Y } _ { n } ^ { < v } \colon = ( \tilde { Y } _ { n } ^ { w } ) _ { w < v } , \, \tilde { Y } _ { < k } \colon = ( \tilde { Y } _ { n } ) _ { n < k } , \, a n d \, \tilde { Y } \colon = ( \tilde { Y } _ { n } ) _ { n \in \mathbb { Z } } .
$$

Let us note that the identity in Remark 4.8 follows immediately as n → ∞ .

The problem in continuous time is that we no longer have a discrete random ﬁeld as in Lemma 4.13. We address this by an appropriate discretization method, which yields the following continuous-time counterpart of Proposition 4.7.

Proposition 4.14. Let δ > 0 and v ∈ Z , m ∈ N be arbitrary, and deﬁne

$$
P [ \{ Y ^ { v } \, \quad Y ^ { v + m } \} _ { \cdot = t _ { 0 } \, r } \in \cdot \colon | Y _ { \prec o } \ \{ Y ^ { < v } \} _ { \cdot = t _ { 0 } \, r }
$$

$$
\rho _ { s } & \colon = P [ \{ Y _ { t } ^ { v } , \dots , Y _ { t } ^ { v + m } \} _ { t \in [ 0 , \delta ] } \in \cdot \cdot | Y _ { \leq 0 } , \{ Y _ { t } ^ { < v } \} _ { t \in [ 0 , \delta ] } , X _ { \leq s } ] , \\ \rho & \colon = P [ \{ Y _ { t } ^ { v } , \dots , Y _ { t } ^ { v + m } \} _ { t \in [ 0 , \delta ] } \in \cdot \cdot | Y _ { \leq 0 } , \{ Y _ { t } ^ { < v } \} _ { t \in [ 0 , \delta ] } ] ,
$$

where X ≤ s := ( X t ) t ≤ s and Y ≤ 0 := ( Y t ) t ≤ 0 . Then

$$
E [ D ( \rho _ { s } | | \rho ) ] \xrightarrow { s \to - \infty } 0 ,
$$

where D ( µ || ν ) denotes relative entropy.

Proof. Let us choose v = 0 for simplicity. The result for arbitrary v follows immediately by translation invariance. In the following, we ﬁx δ > 0 and m ∈ N . q q ˜ r ˜ r 2

Deﬁne the random ﬁeld Z = ( Z ) q ∈ Z 2 with Z = ( X k , Y k ) for q = ( k,r ) ∈ Z as

$$
\tilde { X } _ { k } ^ { r } & \coloneqq ( X _ { k \delta } ^ { r ( m + 1 ) } , \cdots , X _ { k \delta } ^ { r ( m + 1 ) + m } ) , \\ \tilde { Y } _ { k } ^ { r } & \coloneqq ( Y _ { k \delta + t } ^ { r ( m + 1 ) } - Y _ { k \delta } ^ { r ( m + 1 ) } , \cdots , Y _ { k \delta + t } ^ { r ( m + 1 ) + m } - Y _ { k \delta } ^ { r ( m + 1 ) + m } ) _ { t \in [ 0 , \delta ] } .
$$

Then evidently Z is translation-invariant and ˜ X r k is ﬁnite-valued, but ˜ Y r k takes values in the space C 0 ([0 ,δ ]; R m +1 ) of continuous paths ω : [0 ,δ ] → R m +1 with ω (0) = 0 (which is Polish when endowed with the topology of uniform convergence and the associated Borel σ -ﬁeld). Thus we cannot directly apply Lemma 4.13.

To surmount this problem, we employ a straightforward discretization procedure. Let { A j } j ≥ 1 be a countable generating class for the Borel σ -ﬁeld F of C 0 ([0 ,δ ]; R m +1 ), and deﬁne the functions κ j : C 0 ([0 ,δ ]; R m +1 ) → { 0 , 1 } j as κ j := ( 1 A 1 ,..., 1 A j ). Then F j := σ { κ j } is an increasing family of σ -ﬁelds such that j F j = F . Now deﬁne ˜ Y r k ( j ) := κ j ( ˜ Y r k ). Then the random ﬁeld ( ˜ X r k , ˜ Y r k ( j )) k,r ∈ Z is translation-invariant and ﬁnite-valued for every j ≥ 1. Thus we can apply Lemma 4.13 to obtain

$$
H ( \tilde { Y } _ { 0 } ^ { 0 } ( j ) | \tilde { Y } _ { 0 } ^ { < 0 } ( j ) , \tilde { Y } _ { < 0 } ( j ) ) - H ( \tilde { Y } _ { 0 } ^ { 0 } ( j ) | \tilde { Y } _ { 0 } ^ { < 0 } ( j ) , \tilde { Y } _ { < 0 } ( j ) ; \tilde { X } _ { - n } ^ { < 0 } , \tilde { X } _ { < - n } ) = \\ H ( \tilde { X } _ { 0 } ^ { 0 } | \tilde { X } _ { 0 } ^ { < 0 } , \tilde { X } _ { < 0 } ; \tilde { Y } _ { n } ^ { 0 } ( j ) , \tilde { Y } _ { n } ^ { < 0 } ( j ) , \tilde { Y } _ { < n } ( j ) ) - H ( \tilde { X } _ { 0 } ^ { 0 } | \tilde { X } _ { 0 } ^ { < 0 } , \tilde { X } _ { < 0 } ; \tilde { Y } ( j ) ) .
$$

In particular, as the left-hand side of this expression is an expected relative entropy (see the proof of Proposition 4.4), we can estimate

$$
H ( \tilde { Y } _ { 0 } ^ { 0 } ( i ) | \tilde { Y } _ { 0 } ^ { < 0 } ( j ) , \tilde { Y } _ { < 0 } ( j ) ) - H ( \tilde { Y } _ { 0 } ^ { 0 } ( i ) | \tilde { Y } _ { 0 } ^ { < 0 } ( j ) , \tilde { Y } _ { < 0 } ( j ) ; \tilde { X } _ { - n } ^ { < 0 } , \tilde { X } _ { - n } ) \\ \leq H ( \tilde { X } _ { 0 } ^ { 0 } | \tilde { X } _ { 0 } ^ { < 0 } , \tilde { X } _ { < 0 } ; \tilde { Y } _ { n } ^ { 0 } ( j ) , \tilde { Y } _ { n } ^ { < 0 } ( j ) , \tilde { Y } _ { < n } ( j ) ) - H ( \tilde { X } _ { 0 } ^ { 0 } | \tilde { X } _ { 0 } ^ { < 0 } , \tilde { X } _ { < 0 } ; \tilde { Y } ( j ) )
$$
