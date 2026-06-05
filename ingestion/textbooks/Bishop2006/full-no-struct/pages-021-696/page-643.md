[Page 643]

$$
p ( X ) = \sum _ { z _ { N } } \alpha ( z _ { N } ) . \\
$$

Let us take a moment to interpret this result for p ( X ) . Recall that to compute the likelihood we should take the joint distribution p ( X , Z ) and sum over all possible values of Z . Each such value represents a particular choice of hidden state for every time step, in other words every term in the summation is a path through the lattice diagram, and recall that there are exponentially many such paths. By expressing the likelihood function in the form (13.42), we have reduced the computational cost from being exponential in the length of the chain to being linear by swapping the order of the summation and multiplications, so that at each time step n we sum the contributions from all paths passing through each of the states z nk to give the intermediate quantities α ( z n ) . Next we consider the evaluation of the quantities ( z z ) , which correspond

ξ n − 1 , n to the values of the conditional probabilities p ( z n − 1 , z n | X ) for each of the K × K settings for ( z n − 1 , z n ) . Using the deﬁnition of ξ ( z n − 1 , z n ) , and applying Bayes’ theorem, we have

$$
\text {theorem, we have } & \quad \ p ( z _ { n - 1 } , z _ { n } ) = p ( z _ { n - 1 } , z _ { n } | X ) \\ & = \ \frac { \ p ( X | z _ { n - 1 } , z _ { n } ) p ( z _ { n - 1 } , z _ { n } ) } { p ( X ) } \\ & = \ \frac { \ p ( X _ { 1 } , \dots , X _ { n - 1 } | z _ { n - 1 } ) p ( X _ { n } | z _ { n } ) p ( X _ { n + 1 } , \dots , X _ { N } | z _ { n } ) p ( z _ { n } | z _ { n - 1 } ) p ( z _ { n - 1 } ) } { p ( X ) } \\ & = \ \frac { \alpha ( z _ { n - 1 } ) p ( x _ { n } | z _ { n } ) p ( z _ { n } | z _ { n - 1 } ) \beta ( z _ { n } ) } { p ( X ) } \\ & \text {where we have made use of the conditional independence property (13 29) together}
$$

where we have made use of the conditional independence property (13.29) together with the deﬁnitions of α ( z n ) and β ( z n ) given by (13.34) and (13.35). Thus we can calculate the ξ ( z n − 1 , z n ) directly by using the results of the α and β recursions. Let us summarize the steps required to train a hidden Markov model using

the EM algorithm. We ﬁrst make an initial selection of the parameters θ old where θ ≡ ( π , A , φ ) . The A and π parameters are often initialized either uniformly or randomly from a uniform distribution (respecting their non-negativity and summation constraints). Initialization of the parameters φ will depend on the form of the distribution. For instance in the case of Gaussians, the parameters µ k might be initialized by applying the K -means algorithm to the data, and Σ k might be initialized to the covariance matrix of the corresponding K means cluster. Then we run both the forward α recursion and the backward β recursion and use the results to evaluate γ ( z n ) and ξ ( z n − 1 , z n ) . At this stage, we can also evaluate the likelihood function.
