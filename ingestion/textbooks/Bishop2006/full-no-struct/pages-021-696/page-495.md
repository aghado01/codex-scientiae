[Page 495]

Section 2.2.1

Section 2.3.6

Directed acyclic graph representing the Bayesian mixture of Gaussians model, in which the box (plate) denotes a set of N i.i.d. observations. Here µ denotes { µ k } and Λ denotes { Λ k } .

{ k } { }

![image 237](../images/imageFile237.png)

π

n

z

Λ

µ

n

x

N

by (B.23). As we have seen, the parameter α 0 can be interpreted as the effective prior number of observations associated with each component of the mixture. If the value of α 0 is small, then the posterior distribution will be inﬂuenced primarily by the data rather than by the prior.

Similarly, we introduce an independent Gaussian-Wishart prior governing the mean and precision of each Gaussian component, given by

$$
p ( \mu , \Lambda ) \ = \ p ( \mu | \Lambda ) p ( \Lambda ) \\ = \ \prod _ { k = 1 } ^ { K } \mathcal { N } \left ( \mu _ { k } | m _ { 0 } , ( \beta _ { 0 } \Lambda _ { k } ) ^ { - 1 } \right ) \, \mathcal { W } ( \Lambda _ { k } | \mathbb { W } _ { 0 } , \nu _ { 0 } ) \quad ( 1 0 . 4 0 ) \\ \intertext { b a c u s h e c k i n s } \text { because this represents the conjugate prior distribution when both the mean and pre-}
$$

because this represents the conjugate prior distribution when both the mean and precision are unknown. Typically we would choose m 0 = 0 by symmetry.

The resulting model can be represented as a directed graph as shown in Figure 10.5. Note that there is a link from Λ to µ since the variance of the distribution over µ in (10.40) is a function of Λ .

This example provides a nice illustration of the distinction between latent variables and parameters. Variables such as z n that appear inside the plate are regarded as latent variables because the number of such variables grows with the size of the data set. By contrast, variables such as µ that are outside the plate are ﬁxed in number independently of the size of the data set, and so are regarded as parameters. From the perspective of graphical models, however, there is really no fundamental difference between them.

# 10.2.1 Variational distribution

In order to formulate a variational treatment of this model, we next write down the joint distribution of all of the random variables, which is given by

$$
p ( X , Z , \pi , \mu , \Lambda ) = p ( X | Z , \mu , \Lambda ) p ( Z | \pi ) p ( \pi ) p ( \mu | \Lambda ) p ( \Lambda )
$$

in which the various factors are deﬁned above. The reader should take a moment to verify that this decomposition does indeed correspond to the probabilistic graphical model shown in Figure 10.5. Note that only the variables X = { x 1 ,..., x N } are observed.
