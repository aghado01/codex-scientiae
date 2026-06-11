[Page 4]

With these choices of priors on b and s, we can compute analytically the marginal posterior for ( j, k) via equation (4). This makes it easy to compute the likelihood ratios p(y | j c, k c )/p(y | j, k), that are used in the reversible jump algorithm to determine whether or not to move from state (k, j ) to candidate state (k c, j c ). For example, one type of move in our Markov chain Monte Carlo implementation involves the addition of a knot. If the current state is (k, j ) and the candidate state is (k c = k + 1, j c ), then the likelihood ratio becomes

$$
\frac { p ( y | k ^ { c }, \xi ^ { c } ) } { p ( y | k, \xi ) } = \frac { 1 } { \sqrt { ( n + 1 ) } } \left ( \frac { y ^ { T } \{ I _ { n } - n ( n + 1 ) ^ { - 1 } B _ { k, \xi } ( B _ { k, \xi } ^ { T } B _ { k, \xi } ) ^ { - 1 } B _ { k, \xi } ^ { T } \} y } { y ^ { T } \{ I _ { n } - n ( n + 1 ) ^ { - 1 } B _ { k, \xi ^ { c } } ( B _ { k, \xi } ^ { T } B _ { k, \xi ^ { c } } ) ^ { - 1 } B _ { k, \xi ^ { c } } ^ { T } \} y } \right ) ^ { n / 2 }.\quad ( 6 ) \\ \text {Similarly, we can obtain disjointly all the conditions} .
$$

Similarly, we can obtain analytically the conditional posterior expectation

$$
E \{ f ( x ) | k, \xi, y \} = \frac { n } { n + 1 } \, B _ { k, \xi } ( B _ { k, \xi } ^ { T } B _ { k, \xi } ) ^ { - 1 } B _ { k, \xi } ^ { T } y \simeq B _ { k, \xi } \hat { \beta },
$$

for any x. The posterior expectation E{f(x) | y} can then be computed by averaging this conditional expectation over (k, j ) samples. This expectation is the Bayes estimator f @ (x) for f (x) under squared-error loss.

When we are making inferences about functionals of f, the uncertainty in b cannot be ignored. With our choice of priors in the normal model, p( b | y, j, k) can be computed analytically, making it easy to assess the uncertainty in b after a simulation on j and k alone. To do this, we draw a value from this posterior for each (k, j ) sample from our chain.

In the more general model (1), we use the same priors. However, it is often infeasible in this case to obtain analytical expressions such as those above. With the unit information prior (5) on b, the likelihood ratio p(y | j c, k c ) / p(y | j, k) in the Markov chain Monte Carlo can be approximated using the  with an error of O(n − D ), and this produces a posterior distribution on (k, j ) that also has an error of O(n − D ); see Appendix 3. Examples in Kass & Wasserman (1995) show that  often produces a very good approximation to the unit-information posterior in practice. Implementation requires maximum likelihood estimators b @ under each spline model, which are often easily computed with standard software. In particular, conditionally on j and k and when the data are drawn from an exponential family distribution, our model in equation (1) becomes a generalised linear model (McCullagh & Nelder, 1989). @

The use of b, that is integrating out the coe ﬃ cients in the chain, is a key feature of both our method and the method of Denison et al. (1998). This approach has two advantages. First, it speeds up the simulation by reducing the dimensionality of the parameter space with minimal additional cost to compute b @.Secondly, it facilitates the jumps between spline models because such moves no longer require a delicate re-balancing of the coe ﬃ cients when knots are added or deleted (Genovese, 2000). However, it is essential that the uncertainty in b be accounted for in the ﬁnal inferences. In the normal model, the simulation on (k, j ) and ( b, s ) can be decoupled because we have analytical expressions for the marginalised expectations. Thus, we can draw samples of ( b, s ) at each step as
