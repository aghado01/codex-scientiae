[Page 4]

With these choices of priors on $\beta$ and $\sigma$, we can compute analytically the marginal posterior for $(\xi, k)$ via equation (4). This makes it easy to compute the likelihood ratios $p(y \mid \xi^c, k^c)/p(y \mid \xi, k)$, that are used in the reversible jump algorithm to determine whether or not to move from state $(k, \xi)$ to candidate state $(k^c, \xi^c)$. For example, one type of move in our Markov chain Monte Carlo implementation involves the addition of a knot. If the current state is $(k, \xi)$ and the candidate state is $(k^c = k+1, \xi^c)$, then the likelihood ratio becomes

$$
\frac{p(y \mid k^c, \xi^c)}{p(y \mid k, \xi)} = \frac{1}{\sqrt{n+1}} \left(\frac{y^T\{I_n - n(n+1)^{-1} B_{k,\xi}(B_{k,\xi}^T B_{k,\xi})^{-1} B_{k,\xi}^T\}y}{y^T\{I_n - n(n+1)^{-1} B_{k,\xi^c}(B_{k,\xi^c}^T B_{k,\xi^c})^{-1} B_{k,\xi^c}^T\}y}\right)^{n/2} \tag{6}
$$

Similarly, we can obtain analytically the conditional posterior expectation

$$
E\{f(x) \mid k, \xi, y\} = \frac{n}{n+1}\,B_{k,\xi}(B_{k,\xi}^T B_{k,\xi})^{-1} B_{k,\xi}^T y \simeq B_{k,\xi}\hat{\beta},
$$

for any $x$. The posterior expectation $E\{f(x) \mid y\}$ can then be computed by averaging this conditional expectation over $(k, \xi)$ samples. This expectation is the Bayes estimator $\hat{f}(x)$ for $f(x)$ under squared-error loss.

When we are making inferences about functionals of $f$, the uncertainty in $\beta$ cannot be ignored. With our choice of priors in the normal model, $p(\beta \mid y, \xi, k)$ can be computed analytically, making it easy to assess the uncertainty in $\beta$ after a simulation on $\xi$ and $k$ alone. To do this, we draw a value from this posterior for each $(k, \xi)$ sample from our chain.

In the more general model (1), we use the same priors. However, it is often infeasible in this case to obtain analytical expressions such as those above. With the unit information prior (5) on $\beta$, the likelihood ratio $p(y \mid \xi^c, k^c)/p(y \mid \xi, k)$ in the Markov chain Monte Carlo can be approximated using the BIC with an error of $O(n^{-1/2})$, and this produces a posterior distribution on $(k, \xi)$ that also has an error of $O(n^{-1/2})$; see Appendix 3. Examples in Kass & Wasserman (1995) show that BIC often produces a very good approximation to the unit-information posterior in practice. Implementation requires maximum likelihood estimators $\hat{\beta}$ under each spline model, which are often easily computed with standard software. In particular, conditionally on $\xi$ and $k$ and when the data are drawn from an exponential family distribution, our model in equation (1) becomes a generalised linear model (McCullagh & Nelder, 1989).
