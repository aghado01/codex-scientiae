
The main characteristics of Bayesian analysis are

- 1. Placing prior distributions on the unknown parameters before looking at the data;
- 2. All inference is based on the posterior distribution of all the parameters.
- 3. Bayesian inference is usually implemented by MCMC methods.


In particular, Bayesian inference is based on a set of unknown parameters, say,

$$
\theta = ( \theta _ { 1 } , \dots , \theta _ { N } ) .
$$

Any prior beliefs or characterizations of the parameters can be modeled by a probability density function p ( θ ). Consider now a vector of observed data

$$
\mathcal { X } = ( X _ { 1 } , \dots , X _ { n } )
$$

with a probability distribution that depends on the parameter vector θ . The likelihood L ( X| θ ) represents the relationship between the parameter vector and the observed data and we think of L ( X| θ ) as a function of θ . From Bayes Theorem, the posterior distribution is given by

$$
p ( \theta | \mathcal { X } ) = \frac { \mathcal { L } ( \mathcal { X } | \theta ) p ( \theta ) } { \int \mathcal { L } ( \mathcal { X } | \theta ) p ( \theta ) d \theta } .
$$

Under a squared loss function, the Bayes estimator of θ is the posterior mean E( θ |X ). In most cases, the posterior mean is mathematically intractable. MCMC methods facilitate multidimensional integration by simulating from the posterior distribution

$$
p ( \theta | \mathcal { X } ) \, \infty \, \mathcal { L } ( \mathcal { X } | \theta ) p ( \theta ) ,
$$

and then computing summary statistics of the distribution.
