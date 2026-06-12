[Page 22]

In this section, the priors for the the mixed model are described. As before, P-splines can be represented as the mixed model,

$$
y = X \beta + Z b + \epsilon .
$$

Let ( β, b,σ 2 b,σ 2 ) be the vector of the ﬁxed eﬀects, random eﬀects, and variance components. For a fully Bayesian approach, prior distributions are placed on ( β, b,σ 2 b,σ 2 ). The priors are as follows:

$$
\sigma _ { \epsilon } ^ { 2 } \sim I G ( A _ { \epsilon }, B _ { \epsilon } ), \ \ A _ { \epsilon } > 0, \ \ B _ { \epsilon } > 0 .
$$

$$
\sigma _ { b } ^ { 2 } \sim I G ( A _ { b }, B _ { b } ), \ \ A _ { b } > 0, \ \ B _ { b } > 0 .
$$

These prior speciﬁcations for the variance components are sensitive to the selection of the hyperparameters A  ,B  ,A b, and B b.Selecting values for these parameters must be addressed carefully since diﬀerent values may lead to diﬀerent results.

In the context of the mixed model methodology, let θ = ( β  , b ) be the parameter vector containing the ﬁxed and random eﬀects. The posterior distribution for the mixed model is given by

$$
p ( \beta, b, \sigma _ { \epsilon } ^ { 2 }, \sigma _ { b } ^ { 2 } | y ) \subset p ( y | \beta, b, \sigma _ { \epsilon } ^ { 2 } ) p ( \sigma _ { \epsilon } ^ { 2 } ) p ( b | \sigma _ { b } ^ { 2 } ) p ( \sigma _ { b } ^ { 2 } ) p ( \beta ) .
$$
