[Page 632]

Figure 13.7 If we unfold the state transition diagram of Figure 13.6 over time, we obtain a lattice, or trellis, representation of the latent states. Each column of this diagram corresponds to one of the latent variables z n .

![In this image, we can see a diagram with some text and numbers.](../images/imageFile307.png)

A

A

A

11

11

11

k

= 1

k

= 2

k

= 3

A

A

A

33

33

33

-

-

n

2

n

1

n

n

- 1

Exercise 13.4

We can represent the emission probabilities in the form

$$
p ( x _ { n } | z _ { n } , \phi ) = \prod _ { k = 1 } ^ { K } p ( x _ { n } | \phi _ { k } ) ^ { z _ { n k } } . \\
$$

We shall focuss attention on homogeneous models for which all of the conditional distributions governing the latent variables share the same parameters A , and similarly all of the emission distributions share the same parameters φ (the extension to more general cases is straightforward). Note that a mixture model for an i.i.d. data set corresponds to the special case in which the parameters A jk are the same for all values of j , so that the conditional distribution p ( z n | z n − 1 ) is independent of z n − 1 . This corresponds to deleting the horizontal links in the graphical model shown in Figure 13.5.

The joint probability distribution over both latent and observed variables is then given by

$$
\text {given by} & & p ( X , Z | \theta ) = p ( z _ { 1 } | \pi ) \left [ \prod _ { n = 2 } ^ { N } p ( z _ { n } | z _ { n - 1 } , A ) \right ] \prod _ { m = 1 } ^ { N } p ( x _ { m } | z _ { m } , \phi ) \\ \text {where } X = \{ x _ { 1 } , \quad x _ { n } \} _ { Z } = \{ z _ { 1 } , \quad z _ { n } \} _ { Z } \text {, and } \theta = \{ \pi \ A \ \phi \} \text { denotes the set}
$$

where X = { x 1 ,..., x N } , Z = { z 1 ,..., z N } , and θ = { π , A , φ } denotes the set of parameters governing the model. Most of our discussion of the hidden Markov model will be independent of the particular choice of the emission probabilities. Indeed, the model is tractable for a wide range of emission distributions including discrete tables, Gaussians, and mixtures of Gaussians. It is also possible to exploit discriminative models such as neural networks. These can be used to model the emission density p ( x | z ) directly, or to provide a representation for p ( z | x ) that can be converted into the required emission density p ( x | z ) using Bayes’ theorem (Bishop et al. , 2004).

We can gain a better understanding of the hidden Markov model by considering it from a generative point of view. Recall that to generate samples from a mixture of
