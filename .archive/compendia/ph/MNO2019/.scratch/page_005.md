[Page 5]

Deﬁnition 2.5. A ﬁnite point process P is a pair ( { p n } , { P n } ) where ∞ n =0 p n = 1 and P n is a symmetric probability measure on X n , where X 0 is understood to be the trivial σ -algebra.

The sequence { p n } deﬁnes a cardinality distribution and the measures { P n } give spatial distributions of vectors ( x 1 ,...,x n ) for ﬁxed n . Deﬁnition 2.5 naturally prescribes a method for sampling a ﬁnite PP: (i) determine the number of points n by drawing from { p n } then, (ii) spatially distribute ( x 1 ,...,x n ) according to a draw from P n . As PPs model random collections of elements in { x 1 ,...,x n } ⊂ X whose order is irrelevant, any sensible construction relying on random vectors should assign equal weight to all permutations of ( x 1 ,...,x n ). This is ensured by the symmetry requirement in Deﬁnition 2.5. We abuse notation and write P for samples from P as well as their set representations. It proves useful to describe ﬁnite PPs by a set of measures that synthesize p n and P n to simultaneously package cardinality and spatial distributions.

Deﬁnition 2.6. Let ( { p n } , { P n } ) be a ﬁnite PP. The Janossy measures { J n } are deﬁned as the set of measures satisfying J n = n ! p n P n , for all n ∈ N .

Given a collection of disjoint rectangles A 1 ,...,A n ⊂ X , the value J n ( A 1 × ··· × A n ) is the probability of observing exactly one element in each of A 1 ,...,A n and none in the complement of their union. For applications, we are primarily interested in Janossy measures J n that admit densities j n with respect to a reference measure on X . We are now ready to describe the class of ﬁnite PPs that model PDs.

Deﬁnition 2.7. Let Λ be a ﬁnite measure on X and µ := Λ( X ). 7The ﬁnite point process Π is Poisson if, for all n ∈ N and measurable rectangles A 1 × ··· × A n ∈ X n , p n = e − µ µ n n ! , and P n ( A 1 × ··· × A n ) = n i =1 Λ( A i ) µ . We call Λ an intensity measure.

Equivalently, a Poisson PP is a ﬁnite PP with Janossy measures J n ( A 1 × ··· × A n ) = e − µ   n i =1 Λ( A i ) . The intensity measure in Deﬁnition 2.7 admits a density, λ , with respect to some reference measure on X . Notice that for all A ∈ X , E ( | Π ∩ A | ) =   ∞ n =0 p n E P n     n k =0 k   n k   A k × ( A c ) n − k   . Elementary calculations then show E ( | Π ∩ A | ) = Λ( A ). Thus, we interpret the intensity measure of a region A , Λ( A ) as the expected number of elements in Π that land in A . The intensity measure serves as an analog to the ﬁrst order moment for a random variable.

The next two deﬁnitions involve a joint PP wherein points from one space parameterize distributions for the points living in another. Consequently, we introduce another Polish space M along with its Borel σ -algebra M to serve as the mark space in a marked Poisson PP. These model scenarios in which points drawn from a Poisson PP provide a data likelihood model for Bayesian inference with PPs.

Deﬁnition 2.8. Suppose : X × M → R + ∪ { 0 } is a function satisfying: 1) for all x ∈ X , ( x, • ) is a probability measure on M , and 2) for all B ∈ M , ( • ,B ) is a measurable function on X . Then, is a stochastic kernel from X to M .

Deﬁnition 2.9. A marked Poisson point process Π M is a ﬁnite point process on X × M such that: (i) ( { p n } , { P n ( • × M ) } ) is a Poisson PP on X , and (ii) for all ( x 1 ,...,x n ) ∈ X n , measurable rectangles B 1 × ··· × B n ∈ M n , P n (( x 1 ,...,x n ) × B 1 × ··· × B n ) = 1 n ! π ∈S n n i =1 ( x π ( i ) ,B i ), where S n is the set of all permutations of (1 ,...,n ) and is a stochastic kernel.

Given a set of observed marks M = { y 1 ,...,y m } it can be shown [53] that the Janossy densities for the PP induced by Π M on X given M are

$$
j _ { n | M } ( x _ { 1 } , \dots , x _ { n } ) = \begin{cases} \sum _ { \pi \in S _ { n } } \prod _ { i = 1 } ^ { n } p ( x _ { i } | y _ { \pi ( i ) } ) , & n = m , \\ 0 , & \text {otherwise} , \end{cases} ( 1 )
$$
