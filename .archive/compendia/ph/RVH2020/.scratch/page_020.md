[Page 20]

In this section, we will aim to extend such observability arguments to translationinvariant systems in inﬁnite dimension by exploiting a technique from multidimensional ergodic theory [10]. Somewhat surprisingly, the problem proves to be more tractable in the continuous-time setting, for which will establish validity of the natural analogue of Conjecture 4.1. In its original discrete time formulation, however, our ultimate result falls short of establishing Conjecture 4.1 even for translation-invariant models. Nonetheless, the theory developed here provides one possible mechanism for symmetry breaking in conditional ergodic theory. An entirely diﬀerent mechanism will be discussed in the context of conditional random ﬁelds in section 5.3 below.

The remainder of this section in organized as follows. In section 4.1 we will recall some basic ideas from the general observability theory developed in [48, 49, 51], and explain why these results are not satisfactory in inﬁnite dimension. We also outline a slightly stronger entropic formulation that will provide the basis for a partial extension to translationinvariant systems in inﬁnite dimension, which is developed in section 4.2. In section 4.3 we consider the continuous-time analogue of Conjecture 4.1, and provide a complete proof in this setting for the translation-invariant case.

## 4.1 General observability theory

Let ( X k ,Y k ) k ≥ 0 be a general hidden Markov model as in section 2.1, and denote by P µ the law of the model with initial distribution X 0 ∼ µ . Deﬁne the prediction ﬁlter

$$
\tilde { \pi } _ { k } ^ { \mu } \colon = P ^ { \mu } [ X _ { k } \in \cdot | Y _ { 1 } , \dots , Y _ { k - 1 } ]
$$

(note that we are conditioning the state at time k only on observations prior to time k ). The basic observation behind the observability theory of [48, 49, 51] is as follows.

Theorem 4.2 ([49, 51]) . Suppose that X k takes values in a compact metric space and that ( X k ,Y k ) k ≥ 0 is Feller. Suppose that the following observability assumption holds:

$$
P ^ { \mu } [ ( Y _ { k } ) _ { k \geq 0 } \in \cdot ] = P ^ { \nu } [ ( Y _ { k } ) _ { k \geq 0 } \in \cdot ] \text{ if and only if } \mu = \nu .
$$

Then we have for every bounded and continuous function f

$$
| \tilde { \pi } _ { k } ^ { \mu } ( f ) - \tilde { \pi } _ { k } ^ { \nu } ( f ) | \xrightarrow { k \to \infty } 0 \ P ^ { \mu }\text{-a.s.}
$$

$$
\text{whenever } \mathbf P ^ { \mu } [ ( Y _ { k } ) _ { k \geq 0 } \in \cdot \, ] \ll \mathbf P ^ { \nu } [ ( Y _ { k } ) _ { k \geq 0 } \in \cdot \, ] .
$$

Note that no ergodicity or nondegeneracy assumptions are imposed in this result: the only assumption is that of observability, that is, that distinct initial laws give rise to distinct observation laws. The latter can evidently be viewed as a very mild type of symmetry breaking assumption. A more general form of the result that does not require compactness or Feller assumptions can be found in [51].

There is nothing in Theorem 4.2 that prohibits its application in inﬁnite-dimensional systems. In fact, it is readily veriﬁed that the observability assumption of Theorem 4.2 is automatically satisﬁed in the setting of Conjecture 4.1 (provided p = 1 2 ). Nonetheless, unlike in most ﬁnite-dimensional problems, the conclusion of Theorem 4.2 is not satisfactory in the inﬁnite-dimensional setting, as we will presently explain.

glyph[negationslash]
