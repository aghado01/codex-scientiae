[Page 20]

The k -dimensional homology of X , denoted H k ( X ) is the quotient vector space

$$
H _ { k } ( X ) \colon = \frac { Z _ { k } ( X ) } { B _ { k } ( X ) } .
$$

Speciﬁcally, an element of H k ( X ) is an equivalence class of homologous k -cycles. This inherits the structure of a vector space in the natural way [ ζ ] + [ η ] = [ ζ + η ] and c [ ζ ] = [ cζ ].

A map f : X → Y is a homotopy equivalence if there is a map g : Y → X so that f ◦ g is homotopic to the identity map on Y and g ◦ f is homotopic to the identity map on X . This notion is a weakening of the notion of homeomorphism, which requires the existence of a continuous map g so that f ◦ g and g ◦ f are equal to the corresponding identity maps. The less restrictive notion of homotopy equivalence is useful in understanding relationships between complicated spaces and spaces with simple descriptions. We say two spaces X and Y are homotopy equivalent, or have the same homotopy type if there is a homotopy equivalence from X to Y . This is denoted by X ∼ Y . By arguments utilizing barycentric subdivision, one may show that

the homology H ∗ ( X ) is a topological invariant of X : it is indeed an invariant of homotopy type. Readers familiar with the Euler characteristic of a triangulated surface will not ﬁnd it odd that intelligent counting of simplices yields an invariant. For a simple example, the reader is encouraged to contemplate the “physical” meaning of H 1 ( X ). Elements of H 1 ( X ) are equivalence classes of (ﬁnite collections of) oriented cycles in the 1-skeleton of X , the equivalence relation being determined by the 2-skeleton of X.

Is it often remarked that homology is functorial, by which it is meant that things behave the way they ought. A simple example of this which is crucial to our applications arises as follows. Consider two simplicial complexes X and X ′ . Let f : X → X ′ be a continuous simplicial map: f takes each k -simplex of X to a k ′ -simplex of X ′ , where k ′ ≤ k . Then, the map f induces a linear transformation f # : C k ( X ) → C k ( X ′ ). It is a simple lemma to show that f # takes cycles to cycles and boundaries to boundaries; hence there is a well-deﬁned linear transformation on the quotient spaces

$$
f _ { * } \colon H _ { k } ( X ) \to H _ { k } ( X ^ { \prime } ) , \, f _ { * } ( [ \zeta ] ) = [ f _ { \# } ( \zeta ) ] .
$$

This is called the induced homomorphism of f on H ∗ . Functoriality means that (1) if f : X → Y is continuous then f ∗ : H k ( X ) → H k ( Y )
