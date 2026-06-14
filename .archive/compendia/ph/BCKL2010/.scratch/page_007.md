[Page 7]

where the inﬁmum is taken over all bijections γ : D ( f ) → D ( g ) and · ∞ denotes supremum–norm over sets. For example, let f be the function considered at the start of this

section. Let g be a unimodal, radially-symmetric function on the same domain with maximum 2 . 2 at the origin and minimum 0. We showed that ¯ D ( f ) = { (1 . 1 , 1 . 4) , (0 , 2) } . Similarly, ¯ D ( g ) = (0 , 2 . 2). The bottleneck distance is achieved by the bijection γ which maps (0 , 2) to (0 , 2 . 2) and (1 . 1 , 1 . 4) to (1 . 25 , 1 . 25) and is the identity on all ‘diagonal’ points ( a, a ). Since the diagonal points have inﬁnite multiplicity this is a bijection. Thus, d B ( D ( f ) , D ( g )) = 0 . 2. In [6], the following result is proven:

In [6], the following result is proven:

$$
d _ { B } ( \mathcal { D } ( f ) , \mathcal { D } ( g ) ) \leq \| f - g \| _ { \infty }
$$

where f, g : M → R are tame functions and · ∞ denotes sup–norm over functions.

2.3. Connection to Statistics. It is apparent that most articles on persistent topology do not as of yet incorporate statistical foundations although they do observe them heuristically. The approach in [25] combines topology and statistics and calculates how much data is needed to guarantee recovery of the underlying topology of the manifold. A drawback of that technique is that it supposes that the size of the smallest features of the data is known a priori. To date the most comprehensive parametric statistical approach is contained in [4]. In this paper, the unknown probability distribution is assumed to belong to a parametric family of distributions. The data is then used to estimate the level so as to recover the persistent topology of the underlying distribution.

As far as we are aware no statistical foundation for the nonparametric case has been formulated although [6] provide the topological machinery for making a concrete statistical connection. In particular, persistent homology of a function is encoded in its reduced persistence diagram. A metric on the space of persistence diagrams between two functions is available which bounds the Hausdorﬀ distance and this in turn is bounded by the sup–norm distance between the two functions. Thus by viewing one function as the parameter, while the other is viewed as its estimator, the asymptotic sup–norm risk bounds the expected Hausdorﬀ distance thus making a formal nonparametric statistical connection. This in turn lays down a framework for topologically classifying clusters in high dimensions.
