
In this section, the priors for the the mixed model are described. As before, P-splines can be represented as the mixed model,

$$
y = X \beta + Z b + \epsilon .
$$

Let ( β , b ,σ 2 b ,σ 2 ) be the vector of the fixed effects, random effects, and variance components. For a fully Bayesian approach, prior distributions are placed on ( β , b ,σ 2 b ,σ 2 ). The priors are as follows:

- 1. The prior placed on β is β ∼ N ( 0 ,σ 2 β I p +1 ) .
- 2. The prior placed on b is b ∼ N ( 0 ,σ 2 b I K κ ) . The priors places on σ 2 and σ 2 b are inverse gamma priors with pdf p ( x ) ∝ x − ( a +1) e b/x for x > 0, a > 0, and b > 0. We then write
- 3.

$$
\sigma _ { \epsilon } ^ { 2 } \sim I G ( A _ { \epsilon } , B _ { \epsilon } ) , \ \ A _ { \epsilon } > 0 , \ \ B _ { \epsilon } > 0 .
$$

- 4.


$$
\sigma _ { b } ^ { 2 } \sim I G ( A _ { b } , B _ { b } ) , \ \ A _ { b } > 0 , \ \ B _ { b } > 0 .
$$

These prior specifications for the variance components are sensitive to the selection of the hyperparameters A ,B ,A b , and B b . Selecting values for these parameters must be addressed carefully since different values may lead to different results.

# 2.6 Sampling Scheme

In the context of the mixed model methodology, let θ = ( β , b ) be the parameter vector containing the fixed and random effects. The posterior distribution for the mixed model is given by

$$
p ( \beta , b , \sigma _ { \epsilon } ^ { 2 } , \sigma _ { b } ^ { 2 } | y ) \subset p ( y | \beta , b , \sigma _ { \epsilon } ^ { 2 } ) p ( \sigma _ { \epsilon } ^ { 2 } ) p ( b | \sigma _ { b } ^ { 2 } ) p ( \sigma _ { b } ^ { 2 } ) p ( \beta ) .
$$
