[Page 131]

Figure 2.22 Example of a Gaussian mixture distribution in one dimension showing three Gaussians (each scaled by a coefﬁcient) in blue and their sum in red.

p(x)

x

the eruption in minutes (horizontal axis) and the time in minutes to the next eruption (vertical axis). We see that the data set forms two dominant clumps, and that a simple Gaussian distribution is unable to capture this structure, whereas a linear superposition of two Gaussians gives a better characterization of the data set.

Such superpositions, formed by taking linear combinations of more basic distributions such as Gaussians, can be formulated as probabilistic models known as mixture distributions (McLachlan and Basford, 1988; McLachlan and Peel, 2000). In Figure 2.22 we see that a linear combination of Gaussians can give rise to very complex densities. By using a sufﬁcient number of Gaussians, and by adjusting their means and covariances as well as the coefﬁcients in the linear combination, almost any continuous density can be approximated to arbitrary accuracy.

We therefore consider a superposition of K Gaussian densities of the form

p(x) =

K

πkN(x|µk,Σk) (2.188)

k=1

which is called a mixture of Gaussians. Each Gaussian density N(x|µk,Σk) is called a component of the mixture and has its own mean µk and covariance Σk. Contour and surface plots for a Gaussian mixture having 3 components are shown in Figure 2.23.

In this section we shall consider Gaussian components to illustrate the framework of mixture models. More generally, mixture models can comprise linear combinations of other distributions. For instance, in Section 9.3.3 we shall consider mixtures of Bernoulli distributions as an example of a mixture model for discrete

###### Section 9.3.3 variables.

The parameters πk in (2.188) are called mixing coefﬁcients. If we integrate both sides of (2.188) with respect to x, and note that both p(x) and the individual Gaussian components are normalized, we obtain

###### K

πk = 1. (2.189)

k=1

Also, the requirement that p(x) 0, together with N(x|µk,Σk) 0, implies πk 0 for all k. Combining this with the condition (2.189) we obtain

0 πk 1. (2.190)
