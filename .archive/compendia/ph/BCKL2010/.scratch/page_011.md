[Page 11]

$$
2 . 2 , \, & \text { and in particular } ( 2 . 3 ) , \, \text { we have} \\ & ( 4 . 1 ) & d _ { B } \left ( \mathcal { D } ( \hat { f } ) , \mathcal { D } ( f ) \right ) \leq \left \| \hat { f } - f \right \| _ { \infty } . \\ & \text { Let } \Lambda _ { t } ( \beta , L ) \, \text { denote the subset of same functions in } \Lambda ( \beta , L ) . \\ & l a r y \, 4 . 3 , \, \text { the following result is immediate.}
$$

(4.1) d B D ( ˆ f ) , D ( f ) ≤ ˆ f − f ∞ . Let Λ t ( β, L ) denote the subset of tame functions in Λ( β, L ). By corollary 4.3, the following result is immediate.

Corollary 4.4. For the nonparametric regression model (3.1) , let ˆ f be deﬁned by (3.11) . Then for 0 < β ≤ 1 and L > 0 , 2 2 β/ (2 β

$$
\text {defined by (3.11).} \ \text {Then for } 0 < \beta \leq 1 \text { and } L > 0 , \\ \sup _ { f \in \Lambda _ { t } ( \beta , L ) } \mathbb { E } d _ { B } \left ( \mathcal { D } ( \hat { f } ) , \mathcal { D } ( f ) \right ) & \leq L ^ { d / ( 2 \beta + d ) } \left ( \frac { \sigma ^ { 2 } v o l \, \mathbb { M } \ ( \beta + d ) d ^ { 2 } } { v o l \mathbb { S } ^ { d - 1 } \beta ^ { 2 } } \ \frac { \log n } { n } \right ) ^ { \beta / ( 2 \beta + d ) } \\ \ a s \ n \to 0 .
$$

## 5. Discussion

To calculate the persistence diagrams of the sublevel sets of f , we suggest that because of the way f is constructed, we can calculate its persistence diagrams using a triangulation, T of the manifold in question.

We can then ﬁlter T using f as follows. Let r 1 ≤ r 2 ≤ . . . ≤ r m be the ordered list of values of f on the vertices of the triangulation. For 1 ≤ i ≤ m , let T i be the subcomplex of T containing all vertices v with f ( v ) ≤ r i and all edges whose boundaries are in T i and all faces whose boundaries are in T i . We obtain the following ﬁltration of T , φ = T 0 ⊆ T 1 ⊆ T 2 ⊆ · · · ⊆ T m = T .

$$
\phi = \mathcal { T } _ { 0 } \subseteq \mathcal { T } _ { 1 } \subseteq T _ { 2 } \subseteq \cdots \subseteq \mathcal { T } _ { m } = \mathcal { T } . \\ \ddot { \cdot } \colon _ { 1 } \colon _ { 0 } \cdot _ { 1 } \widehat { \mathcal { T } } _ { 1 } \subseteq _ { 1 } \widehat { \mathcal { T } } _ { 2 } \subseteq \cdots \subseteq \mathcal { T } _ { m } = \mathcal { T } .
$$

Because the critical points of f only occur at the vertices of T , Morse theory guarantees that the persistent homology of the sublevel sets of f equals the persistent homology of the above ﬁltration of T . Using the software Plex, [9], we calculate the persistent homology,

in degrees 0, 1, 2, ..., d of the triangulation T ﬁltered according to the estimator. Since the data will be d –dimensional, we do not expect any interesting homology in higher degrees, and in fact, most of the interesting features would occur in the lower degrees.

A demonstration of this is provided in [5] for brain image data, where the topology of cortical thickness in an autism study takes place. The persistent homology, in degrees 0, 1 and 2 is calculated for 27 subjects. Since the data is two–dimensional, we do not expect any interesting homology in higher degrees. For an initial comparison of the autistic subjects and control subjects, we take the union of the persistence
