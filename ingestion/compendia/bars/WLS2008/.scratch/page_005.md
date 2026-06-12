
From β ( g ) ξ we obtain fitted values f ( g ) ( ˜ t ) = b ξ,h ( ˜ t ) β ( g ) ξ,h for selected ˜ t and these, in turn, may be used to produce a draw φ ( g ) from the posterior distribution of any characteristic φ = φ ( f ) (such as the value at which the maximum of f ( t ) occurs). Thus, the key output of BARS is the set of vectors ˜ f ( g ) = ( f ( g ) ( ˜ t 1 ) ,f ( g ) ( ˜ t 2 ) ,...,f ( g ) ( ˜ t p )) for MCMC iterates g = 1 ,...,G , each ˜ f ( g ) being a vector of fits along a grid ˜ t 1 , ˜ t 2 ,..., ˜ t p that suitably covers the interval [ A,B ]. The user may sample from the posterior distribution of any functional φ simply by evaluating φ ( g ) = φ ( ˜ f ( g ) ). For instance, a sample from the posterior distribution of the location of the maximum of f ( t ) is obtained by finding the location of the maximum of ˜ f ( g ) for each g . This latter computation is performed in a suitable post-processing environment such as S or R . MCMC convergence may be assessed by standard methods ( Gelman, Carlin, Stern, and Rubin 2004 , Section 11.6) though this remains a topic of general research interest ( Fan, Brooks, and Gelman 2006 ).

# 2.2. Normal and Poisson implementations of BARS

We have implemented two versions of BARS. One implementation, barsN uses a normal model in ( 1 ). The second, barsP uses a Poisson model. Our choices were based on the general interest in ordinary curve-fitting (the normal case) and our deep and continuing interest in fitting neuronal data (the Poisson case).

The two implementations differ not only through the change of likelihood, and the resulting Laplace approximation to ( 2 ) implemented with BIC for the Poisson case, but also in the selection of starting values for the MCMC algorithm. Starting values are very important: poor choices of initial knot sets result in extremely long burn-in periods to achieve apparent stationarity. In the Poisson case we have taken advantage of the closely-related algorithm logspline (see Hansen and Kooperberg 2002 ) and have incorporated Charles Kooperberg’s C implementation of it for density estimation.

Our ability to use Kooperberg’s implementation for density estimation rests on the duality of fitting Poisson process intensity functions and fitting probability densities: the inhomogeneous Poisson likelihood for an intensity function λ = λ ( t ) based on a sequence of event times t 1 ,t 2 ,...,t n in an interval (0 ,T ] is

$$
\begin{array} { r c l } L ( \lambda ) & = & P ( t _ { 1 } , \dots , t _ { n } ) \\ & = & e ^ { - \int _ { 0 } ^ { \top } \lambda ( u ) d u } \prod _ { j = 1 } ^ { n } \lambda ( t _ { j } ) . \end{array}
$$

Here the number of events N is a Poisson random variable with expectation 0 λ ( u ) du . Conditionally on the number of events N = n the probability density becomes

$$
P ( t _ { 1 } , \dots , t _ { N } | N = n ) = \prod _ { j = 1 } ^ { n } \lambda ( t _ { j } ) .
$$

If we set

$$
f ( t ) = \frac { \lambda ( t ) } { \int _ { 0 } ^ { \top } \lambda ( u ) d u }
$$

then it becomes clear that estimation of λ ( t ) amounts to estimation of the probability density f ( t ), together with estimation of λ ( u ) du . We use N = n as an estimate of λ ( u ) du , and
