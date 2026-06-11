[Page 643]

Thus we can evaluate the likelihood function by computing this sum, for any convenient choice of n. For instance, if we only want to evaluate the likelihood function, then we can do this by running the α recursion from the start to the end of the chain, and then use this result for n = N, making use of the fact that β(zN) is a vector of 1s. In this case no β recursion is required, and we simply have

�

p(X) =

α(zN). (13.42)

zN

Let us take a moment to interpret this result for p(X). Recall that to compute the likelihood we should take the joint distribution p(X,Z) and sum over all possible values of Z. Each such value represents a particular choice of hidden state for every time step, in other words every term in the summation is a path through the lattice diagram, and recall that there are exponentially many such paths. By expressing the likelihood function in the form (13.42), we have reduced the computational cost from being exponential in the length of the chain to being linear by swapping the order of the summation and multiplications, so that at each time step n we sum the contributions from all paths passing through each of the states znk to give the intermediate quantities α(zn).

Next we consider the evaluation of the quantities ξ(zn−1,zn), which correspond to the values of the conditional probabilities p(zn−1,zn|X) for each of the K × K settings for (zn−1,zn). Using the deﬁnition of ξ(zn−1,zn), and applying Bayes’ theorem, we have

ξ(zn−1,zn) = p(zn−1,zn|X)

p(X|zn−1,zn)p(zn−1,zn) p(X)

=

p(x1,...,xn−1|zn−1)p(xn|zn)p(xn+1,...,xN|zn)p(zn|zn−1)p(zn−1) p(X)

=

α(zn−1)p(xn|zn)p(zn|zn−1)β(zn) p(X)

=

(13.43)

where we have made use of the conditional independence property (13.29) together with the deﬁnitions of α(zn) and β(zn) given by (13.34) and (13.35). Thus we can calculate the ξ(zn−1,zn) directly by using the results of the α and β recursions.

Let us summarize the steps required to train a hidden Markov model using the EM algorithm. We ﬁrst make an initial selection of the parameters θold where θ ≡ (π,A,φ). The A and π parameters are often initialized either uniformly or randomly from a uniform distribution (respecting their non-negativity and summation constraints). Initialization of the parameters φ will depend on the form of the distribution. For instance in the case of Gaussians, the parameters µk might be initialized by applying the K-means algorithm to the data, and Σk might be initialized to the covariance matrix of the corresponding K means cluster. Then we run both the forward α recursion and the backward β recursion and use the results to evaluate γ(zn) and ξ(zn−1,zn). At this stage, we can also evaluate the likelihood function.
