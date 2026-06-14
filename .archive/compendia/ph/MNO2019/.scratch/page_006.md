[Page 6]

where p is the stochastic kernel for Π M evaluated in X for a ﬁxed value of y ∈ M .

The following theorems allow us to construct new Poisson PPs from existing ones. Their proofs can be found in [30].

Theorem 2.1 (The Superposition Theorem) . Let { Π n } n ∈ N be a collection of independent Poisson PPs each having intensity measure Λ n . Then their superposition Π given by Π := n ∈ N Π n is a Poisson PP with intensity measure Λ = n ∈ N Λ n .

Theorem 2.2 (The Mapping Theorem) . Let Π be a Poisson PP on X with σ -ﬁnite intensity measure Λ and let ( T , T ) be a σ -algebra. Suppose f : X → T is a measurable function. Write Λ ∗ for the induced measure on T given by Λ ∗ ( B ) := Λ( f − 1 ( B )) for all B ∈ T . If Λ ∗ has no atoms, then f ◦ Π is a Poisson PP on T with intensity measure Λ ∗ .

Theorem 2.3 (The Marking Theorem) . The marked Poisson PP in Deﬁnition 2.9 has the intensity measure given by Λ M ( C ) = C Λ( dx ) ( x,dm ) , where Λ is the intensity measure for the Poisson PP that Π M induces on X , and is a stochastic kernel.

The ﬁnal tool we need is the probability generating functional as it enables us to recover intensity measures using a notion of diﬀerentiation. The probability generating functional can be interpreted as the PP analog of the probability generating function.

Deﬁnition 2.10. Let P be a ﬁnite PP on a Polish space X . Denote by B ( C ) the set of all functions h : X → C with || h || ∞ < 1. The probability generating functional of P denoted G : B ( C ) → R is given by

$$
G ( h ) = J _ { 0 } + \sum _ { n = 1 } ^ { \infty } \frac { 1 } { n ! } \int _ { \mathbb { X } ^ { n } } \left ( \prod _ { j = 1 } ^ { n } h ( x _ { j } ) \right ) \mathbb { J } _ { n } ( d x _ { 1 } \dots d x _ { n } ) & & ( 2 )
$$

Deﬁnition 2.11. Let G be the probability generating functional given in Equation (2). The functional derivative of G in the direction of η evaluated at h , when it exists, is given by G ( h ; η ) = lim → 0 G ( h +  η ) − G ( h ) .

It can be shown that the functional derivative satisﬁes the familiar product rule [33]. As is proved in [44], the intensity measure Λ of the Poisson PP in Deﬁnition 2.7 can be obtained by diﬀerentiating G , i.e., Λ( A ) = G (1; A ), where A is the indicator function for any A ∈ X . Generally speaking, one obtains the intensity measure for a general point process through Λ( A ) = lim h → 1 G ( h ; A ), but the preceding identity suﬃces for our purposes since we only consider point processes for which Equation (2) is deﬁned for all bounded h .

Corollary 2.1. The intensity function for the PP whose Janossy densities are listed in Equation (1) is   m i =1 p ( x | y i ) .

Proof. This directly follows from writing the probability generating functional for the PP in question using its Janossy densities then applying Λ( A ) = G   (1; A ). By Deﬁnition 2.10, linearity of the integral, and Fubini’s theorem, we have G ( h ) =   m i =1     X h ( x ) p ( x | y i )d x   =   m i =1 G i ( h ) where G i ( h ) is the probability generating functional for the PP with Janossy densities j 1 ( x ) = p ( x | y i ) and j n = 0 for n   = 1. One arrives at the desired result by applying the product rule for functional derivatives and the intensity retrieval property of probability generating functionals.  

glyph[negationslash]

## 3 Bayesian Inference

In this section, we construct a framework for Bayesian inference with PDs by modeling them as Poisson PPs. First, we derive a closed form for the posterior intensity given a PD drawn from a ﬁnite PP, and then we present a family of conjugate priors followed by an example.
