[Page 392]

We can readily extend the linear-Gaussian graphical model to the case in which the nodes of the graph represent multivariate Gaussian variables. In this case, we can write the conditional distribution for node i in the form

###### ⎛ ⎝xi

⎞ ⎠ (8.19)

p(xi|pai) = N

Wijxj + bi,Σi

j∈pai

where now Wij is a matrix (which is nonsquare if xi and xj have different dimensionalities). Again it is easy to verify that the joint distribution over all variables is Gaussian.

Note that we have already encountered a speciﬁc example of the linear-Gaussian

Section 2.3.6 relationship when we saw that the conjugate prior for the mean µ of a Gaussian variable x is itself a Gaussian distribution over µ. The joint distribution over x and µ is therefore Gaussian. This corresponds to a simple two-node graph in which the node representing µ is the parent of the node representing x. The mean of the distribution over µ is a parameter controlling a prior, and so it can be viewed as a hyperparameter. Because the value of this hyperparameter may itself be unknown, we can again treat it from a Bayesian perspective by introducing a prior over the hyperparameter, sometimes called a hyperprior, which is again given by a Gaussian distribution. This type of construction can be extended in principle to any level and is an illustration of a hierarchical Bayesian model, of which we shall encounter further examples in later chapters.

###### 8.2. Conditional Independence

An important concept for probability distributions over multiple variables is that of conditional independence (Dawid, 1980). Consider three variables a, b, and c, and suppose that the conditional distribution of a, given b and c, is such that it does not depend on the value of b, so that

p(a|b,c) = p(a|c). (8.20)

We say that a is conditionally independent of b given c. This can be expressed in a slightly different way if we consider the joint distribution of a and b conditioned on c, which we can write in the form

p(a,b|c) = p(a|b,c)p(b|c)

= p(a|c)p(b|c). (8.21)

where we have used the product rule of probability together with (8.20). Thus we see that, conditioned on c, the joint distribution of a and b factorizes into the product of the marginal distribution of a and the marginal distribution of b (again both conditioned on c). This says that the variables a and b are statistically independent, given c. Note that our deﬁnition of conditional independence will require that (8.20),
