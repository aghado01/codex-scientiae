[Page 526]

Now let us exploit this result to obtain a practical algorithm for approximate inference. For many probabilistic models, the joint distribution of data D and hidden variables (including parameters) θ comprises a product of factors in the form

$$
p ( \mathcal { D } , \theta ) = \prod _ { i } f _ { i } ( \theta ) . \quad & ( 1 0 . 1 8 ) \\ \exp { ( 1 - a _ { i } \, m o l e { d o w } \, f o r \, i n d e p e n d e t \, i d e n t i c a l l y \, d i s t r i g h e d } ) }
$$

This would arise, for example, in a model for independent, identically distributed data in which there is one factor f n ( θ ) = p ( x n | θ ) for each data point x n , along with a factor f 0 ( θ ) = p ( θ ) corresponding to the prior. More generally, it would also apply to any model deﬁned by a directed probabilistic graph in which each factor is a conditional distribution corresponding to one of the nodes, or an undirected graph in which each factor is a clique potential. We are interested in evaluating the posterior distribution p ( θ |D ) for the purpose of making predictions, as well as the model evidence p ( D ) for the purpose of model comparison. From (10.188) the posterior is given by 1

$$
p ( \theta | \mathcal { D } ) = \frac { 1 } { p ( \mathcal { D } ) } \prod _ { i } f _ { i } ( \theta ) \\ \text {ence is given by}
$$

and the model evidence is given by

$$
\text {price} \, \int \, \prod _ { i } \, f _ { i } ( \theta ) \, \mathrm d \theta . \\ \text {dering continuous variables} \, \text {but the following discussion applies}
$$

Here we are considering continuous variables, but the following discussion applies equally to discrete variables with integrals replaced by summations. We shall suppose that the marginalization over θ , along with the marginalizations with respect to the posterior distribution required to make predictions, are intractable so that some form of approximation is required.

Expectation propagation is based on an approximation to the posterior distribution which is also given by a product of factors

$$
q ( \theta ) = \frac { 1 } { Z } \prod _ { i } \widetilde { f } _ { i } ( \theta ) & & ( 1 0 . 1 9 1 ) \\ \widetilde { f } _ { i } ( \theta ) \text { in the approximation corresponds to one of the factors}
$$

in which each factor f i ( θ ) in the approximation corresponds to one of the factors f i ( θ ) in the true posterior (10.189), and the factor 1 /Z is the normalizing constant needed to ensure that the left-hand side of (10.191) integrates to unity. In order to obtain a practical algorithm, we need to constrain the factors f i ( θ ) in some way, and in particular we shall assume that they come from the exponential family. The product of the factors will therefore also be from the exponential family and so can
