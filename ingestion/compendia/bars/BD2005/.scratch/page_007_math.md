[Page 7]

This likelihood is deﬁned conditionally on the subject-speciﬁc basis coeﬃcients, but we wish to make inferences also on population parameters. Treating the subject-speciﬁc coeﬃcients as random slopes, we specify a Bayesian random eﬀects model where the subject-speciﬁc coeﬃcients are centered around the population coeﬃcients, β.Under model M of dimension k, the relationship between the population and subject-speciﬁc coeﬃcients is speciﬁed through the hierarchical structure:

$$
b _ { i } | k \sim N _ { k } ( \beta, \tau ^ { - 1 } \Delta ^ { - 1 } ) & \quad \forall i \\ \beta | k \sim N _ { k } ( 0, \tau ^ { - 1 } \lambda ^ { - 1 } I _ { k } )
$$

To avoid over-parameterization of an already ﬂexible model, we assume independence among the elements of b i.Thus ∆ = diag ( δ ), where δ is a k × 1 vector. The elements of δ and the scalars λ and τ are given independent gamma priors:

$$
\pi ( \tau, \lambda, \delta ) \, \cos \tau ^ { a _ { \tau } - 1 } e x p ( - b _ { \tau } \tau ) \lambda ^ { a _ { \lambda } - 1 } e x p ( - b _ { \lambda } \lambda ) \prod _ { l = 1 } ^ { k } ( \delta _ { l } ^ { a _ { \delta } - 1 } e x p ( - b _ { \delta } \delta _ { l } ) ), \\
$$

where a τ, b τ, a λ, b λ, a δ and b δ are pre-speciﬁed hyperparameters. Each of the k − 1 non-intercept basis functions contains a non-zero intercept and linear eﬀect for at least one covariate. Including multiple covariate eﬀects in a single basis allows the covariates to dependently aﬀect the response (i.e. allows for interactions). The number of non-zero covariate eﬀects in a particular basis is called the interaction level of the basis.

Under one piecewise linear model, an observation y with covariates x has the following mean and variance:

$$
E ( y ) & = \beta _ { 1 } + \sum _ { l = 2 } ^ { k } \beta _ { l } ( x ^ { \prime } \mu _ { l } ) _ { + } \\ V ( y ) & = \delta _ { 1 } ^ { - 1 } + \sum _ { l = 2 } ^ { k } \delta _ { l } ^ { - 1 } ( x ^ { \prime } \mu _ { l } ) _ { + } ^ { 2 } + \tau ^ { - 1 } \\
$$
