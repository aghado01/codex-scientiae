[Page 4]

From we obtain fitted values for selected and these, in turn, may be used to produce a draw \( \phi^{(g)} \) from the posterior distribution of any characteristic \( \phi = \phi(f) \) (such as the value at which the maximum of \( f(t) \) occurs). Thus, the key output of BARS is the

$$
\det \text {of vectors} \, ^ { f ^ { \prime } } = \left ( \sqrt { g } \left ( t _ { 1 } \right ) , f ^ { ( g ) } ( t _ { 2 } ) , \dots , f ^ { ( g ) } ( t _ { p } ) \right ) \text {for MC/CM iterates} \, g = 1 , \dots , G , \text { each}
$$

being a vector of fits along a grid that suitably covers the interval \( [A, B] \). The user may sample from the posterior distribution of any functional \( \phi \) simply by evaluating

. For instance, a sample from the posterior distribution of the location of the

maximum of \( f(t) \) is obtained by finding the location of the maximum of for each \( g \). This latter computation is performed in a suitable post-processing environment such as S or R . MCMC convergence may be assessed by standard methods (Gelman, Carlin, Stern, and Rubin 2004, Section 11.6) though this remains a topic of general research interest (Fan, Brooks, and Gelman 2006).

## 2.2. Normal and Poisson implementations of BARS

We have implemented two versions of BARS. One implementation, barsN uses a normal model in (1). The second, barsP uses a Poisson model. Our choices were based on the general interest in ordinary curve-fitting (the normal case) and our deep and continuing interest in fitting neuronal data (the Poisson case).

The two implementations differ not only through the change of likelihood, and the resulting Laplace approximation to (2) implemented with BIC for the Poisson case, but also in the selection of starting values for the MCMC algorithm. Starting values are very important: poor choices of initial knot sets result in extremely long burn-in periods to achieve apparent stationarity. In the Poisson case we have taken advantage of the closely-related algorithm logspline (see Hansen and Kooperberg 2002) and have incorporated Charles Kooperberg’s C implementation of it for density estimation.

Our ability to use Kooperberg’s implementation for density estimation rests on the duality of fitting Poisson process intensity functions and fitting probability densities: the inhomogeneous Poisson likelihood for an intensity function \( \lambda = \lambda(t) \) based on a sequence of event times \( t_1, t_2, \dots, t_n \) in an interval \( (0, T] \) is

$$
$$
P ( t _ { 1 } , \dots
$$ , t _ { n } )
$$

Here the number of events \( N \) is a Poisson random variable with expectation . Conditionally on the number of events \( N = n \) the probability density becomes

$$
P ( t _ { 1 } , \dots
$$

If we set
