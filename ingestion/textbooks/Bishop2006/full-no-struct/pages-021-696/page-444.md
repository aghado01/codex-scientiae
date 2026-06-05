[Page 444]

Section 9.3

Section 9.4

view of mixture distributions in which the discrete latent variables can be interpreted as deﬁning assignments of data points to speciﬁc components of the mixture. A general technique for ﬁnding maximum likelihood estimators in latent variable models is the expectation-maximization (EM) algorithm. We ﬁrst of all use the Gaussian mixture distribution to motivate the EM algorithm in a fairly informal way, and then we give a more careful treatment based on the latent variable viewpoint. We shall see that the K -means algorithm corresponds to a particular nonprobabilistic limit of EM applied to mixtures of Gaussians. Finally, we discuss EM in some generality.

Gaussian mixture models are widely used in data mining, pattern recognition, machine learning, and statistical analysis. In many applications, their parameters are determined by maximum likelihood, typically using the EM algorithm. However, as we shall see there are some signiﬁcant limitations to the maximum likelihood approach, and in Chapter 10 we shall show that an elegant Bayesian treatment can be given using the framework of variational inference. This requires little additional computation compared with EM, and it resolves the principal difﬁculties of maximum likelihood while also allowing the number of components in the mixture to be inferred automatically from the data.

# 9.1. K -means Clustering

We begin by considering the problem of identifying groups, or clusters, of data points in a multidimensional space. Suppose we have a data set { x 1 ,..., x N } consisting of N observations of a random D -dimensional Euclidean variable x . Our goal is to partition the data set into some number K of clusters, where we shall suppose for the moment that the value of K is given. Intuitively, we might think of a cluster as comprising a group of data points whose inter-point distances are small compared with the distances to points outside of the cluster. We can formalize this notion by ﬁrst introducing a set of D -dimensional vectors µ k , where k = 1 ,...,K , in which µ k is a prototype associated with the k th cluster. As we shall see shortly, we can think of the µ k as representing the centres of the clusters. Our goal is then to ﬁnd an assignment of data points to clusters, as well as a set of vectors { µ k } , such that the sum of the squares of the distances of each data point to its closest vector µ k , is a minimum.

It is convenient at this point to deﬁne some notation to describe the assignment of data points to clusters. For each data point x n , we introduce a corresponding set of binary indicator variables r nk ∈ { 0 , 1 } , where k = 1 ,...,K describing which of the K clusters the data point x n is assigned to, so that if data point x n is assigned to cluster k then r nk = 1 , and r nj = 0 for j = k . This is known as the 1 -ofK coding scheme. We can then deﬁne an objective function, sometimes called a distortion measure , given by

/negationslash

$$
J = \sum _ { n = 1 } ^ { N } \sum _ { k = 1 } ^ { K } r _ { n k } \| x _ { n } - \mu _ { k } \| ^ { 2 } \\ \text {the sum of the squares of the distances of each data point to its}
$$

which represents the sum of the squares of the distances of each data point to its
