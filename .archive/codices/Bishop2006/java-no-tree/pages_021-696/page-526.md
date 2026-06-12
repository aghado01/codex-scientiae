[Page 526]

We see that the optimum solution simply corresponds to matching the expected sufﬁcient statistics. So, for instance, if q(z) is a Gaussian N(z|µ,Σ) then we minimize the Kullback-Leibler divergence by setting the mean µ of q(z) equal to the mean of the distribution p(z) and the covariance Σ equal to the covariance of p(z). This is sometimes called moment matching. An example of this was seen in Figure 10.3(a).

Now let us exploit this result to obtain a practical algorithm for approximate inference. For many probabilistic models, the joint distribution of data D and hidden variables (including parameters) θ comprises a product of factors in the form

p(D,θ) =

i

fi(θ). (10.188)

This would arise, for example, in a model for independent, identically distributed data in which there is one factor fn(θ) = p(xn|θ) for each data point xn, along with a factor f0(θ) = p(θ) corresponding to the prior. More generally, it would also apply to any model deﬁned by a directed probabilistic graph in which each factor is a conditional distribution corresponding to one of the nodes, or an undirected graph in which each factor is a clique potential. We are interested in evaluating the posterior distribution p(θ|D) for the purpose of making predictions, as well as the model evidence p(D) for the purpose of model comparison. From (10.188) the posterior is given by

1 p(D) i

fi(θ) (10.189)

p(θ|D) =

and the model evidence is given by

p(D) =

i

fi(θ)dθ. (10.190)

Here we are considering continuous variables, but the following discussion applies equally to discrete variables with integrals replaced by summations. We shall suppose that the marginalization over θ, along with the marginalizations with respect to the posterior distribution required to make predictions, are intractable so that some form of approximation is required.

Expectation propagation is based on an approximation to the posterior distribution which is also given by a product of factors

1 Z i

q(θ) =

fi(θ) (10.191)

in which each factor fi(θ) in the approximation corresponds to one of the factors fi(θ) in the true posterior (10.189), and the factor 1/Z is the normalizing constant needed to ensure that the left-hand side of (10.191) integrates to unity. In order to obtain a practical algorithm, we need to constrain the factors fi(θ) in some way, and in particular we shall assume that they come from the exponential family. The product of the factors will therefore also be from the exponential family and so can
