## 9. Mixture Models and EM

### 9.1 K-means Clustering

We begin by considering the problem of identifying groups, or clusters, of data points in a multidimensional space. Suppose we have a data set {x1,...,xN} consisting of N observations of a random D-dimensional Euclidean variable x. Our goal is to partition the data set into some number K of clusters, where we shall suppose for the moment that the value of K is given. Intuitively, we might think of a cluster as comprising a group of data points whose inter-point distances are small compared with the distances to points outside of the cluster. We can formalize this notion by ﬁrst introducing a set of D-dimensional vectors µk, where k = 1,...,K, in which µk is a prototype associated with the kth cluster. As we shall see shortly, we can think of the µk as representing the centres of the clusters. Our goal is then to ﬁnd an assignment of data points to clusters, as well as a set of vectors {µk}, such that the sum of the squares of the distances of each data point to its closest vector µk, is a minimum.

It is convenient at this point to deﬁne some notation to describe the assignment of data points to clusters. For each data point xn, we introduce a corresponding set of binary indicator variables rnk ∈ {0,1}, where k = 1,...,K describing which of the K clusters the data point xn is assigned to, so that if data point xn is assigned to cluster k then rnk = 1, and rnj = 0 for j = k. This is known as the 1-of-K coding scheme. We can then deﬁne an objective function, sometimes called a distortion measure, given by

N

K

J =

rnk xn − µk 2 (9.1) which represents the sum of the squares of the distances of each data point to its

n=1

k=1

Section 2.3.7 but it can also make the determination of the cluster means nonrobust to outliers. We can generalize the K-means algorithm by introducing a more general dissimilarity measure V(x,x ) between two vectors x and x and then minimizing the following distortion measure

N

K

J =

rnkV(xn,µk) (9.6)

n=1

k=1

which gives the K-medoids algorithm. The E step again involves, for given cluster prototypes µk, assigning each data point to the cluster for which the dissimilarity to the corresponding prototype is smallest. The computational cost of this is O(KN), as is the case for the standard K-means algorithm. For a general choice of dissimilarity measure, the M step is potentially more complex than for K-means, and so it is common to restrict each cluster prototype to be equal to one of the data vectors assigned to that cluster, as this allows the algorithm to be implemented for any choice of dissimilarity measure V(·,·) so long as it can be readily evaluated. Thus the M step involves, for each cluster k, a discrete search over the Nk points assigned to that cluster, which requires O(Nk2) evaluations of V(·,·).

One notable feature of the K-means algorithm is that at each iteration, every data point is assigned uniquely to one, and only one, of the clusters. Whereas some data points will be much closer to a particular centre µk than to any other centre, there may be other data points that lie roughly midway between cluster centres. In the latter case, it is not clear that the hard assignment to the nearest cluster is the most appropriate. We shall see in the next section that by adopting a probabilistic approach, we obtain ‘soft’ assignments of data points to clusters in a way that reﬂects the level of uncertainty over the most appropriate assignment. This probabilistic formulation brings with it numerous beneﬁts.

#### 9.1.1 Image segmentation and compression

As an illustration of the application of the K-means algorithm, we consider the related problems of image segmentation and image compression. The goal of segmentation is to partition an image into regions each of which has a reasonably homogeneous visual appearance or which corresponds to objects or parts of objects (Forsyth and Ponce, 2003). Each pixel in an image is a point in a 3-dimensional space comprising the intensities of the red, blue, and green channels, and our segmentation algorithm simply treats each pixel in the image as a separate data point. Note that strictly this space is not Euclidean because the channel intensities are bounded by the interval [0,1]. Nevertheless, we can apply the K-means algorithm without difﬁculty. We illustrate the result of running K-means to convergence, for any particular value of K, by re-drawing the image replacing each pixel vector with the {R,G,B} intensity triplet given by the centre µk to which that pixel has been assigned. Results for various values of K are shown in Figure 9.3. We see that for a given value of K, the algorithm is representing the image using a palette of only K colours. It should be emphasized that this use of K-means is not a particularly sophisticated approach to image segmentation, not least because it takes no account of the spatial proximity of different pixels. The image segmentation problem is in general extremely difﬁcult

The image segmentation problem discussed above also provides an illustration of the use of clustering for data compression. Suppose the original image has N pixels comprising {R,G,B} values each of which is stored with 8 bits of precision. Then to transmit the whole image directly would cost 24N bits. Now suppose we ﬁrst run K-means on the image data, and then instead of transmitting the original pixel intensity vectors we transmit the identity of the nearest vector µk. Because there are K such vectors, this requires log2 K bits per pixel. We must also transmit the K code book vectors µk, which requires 24K bits, and so the total number of bits required to transmit the image is 24K + N log2 K (rounding up to the nearest integer). The original image shown in Figure 9.3 has 240 × 180 = 43,200 pixels and so requires 24 × 43,200 = 1,036,800 bits to transmit directly. By comparison, the compressed images require 43,248 bits (K = 2), 86,472 bits (K = 3), and 173,040 bits (K = 10), respectively, to transmit. These represent compression ratios compared to the original image of 4.2%, 8.3%, and 16.7%, respectively. We see that there is a trade-off between degree of compression and image quality. Note that our aim in this example is to illustrate the K-means algorithm. If we had been aiming to produce a good image compressor, then it would be more fruitful to consider small blocks of adjacent pixels, for instance 5×5, and thereby exploit the correlations that exist in natural images between nearby pixels.

### 9.2 Mixtures of Gaussians

In Section 2.3.9 we motivated the Gaussian mixture model as a simple linear superposition of Gaussian components, aimed at providing a richer class of density models than the single Gaussian. We now turn to a formulation of Gaussian mixtures in terms of discrete latent variables. This will provide us with a deeper insight into this important distribution, and will also serve to motivate the expectation-maximization algorithm.

Recall from (2.188) that the Gaussian mixture distribution can be written as a linear superposition of Gaussians in the form

p(x) =

K

πkN(x|µk,Σk). (9.7)

k=1

Let us introduce a K-dimensional binary random variable z having a 1-of-K representation in which a particular element zk is equal to 1 and all other elements are equal to 0. The values of zk therefore satisfy zk ∈ {0,1} and k zk = 1, and we see that there are K possible states for the vector z according to which element is nonzero. We shall deﬁne the joint distribution p(x,z) in terms of a marginal distribution p(z) and a conditional distribution p(x|z), corresponding to the graphical model in Figure 9.4. The marginal distribution over z is speciﬁed in terms of the mixing coefﬁcients πk, such that

p(zk = 1) = πk

9.2 Mixtures of Gaussians 431

Figure 9.4 Graphical representation of a mixture model, in which the joint distribution is expressed in the form p(x, z) = p(z)p(x|z).

z

x

where the parameters {πk} must satisfy

0 πk 1 (9.8) together with

K

πk = 1 (9.9)

k=1

in order to be valid probabilities. Because z uses a 1-of-K representation, we can also write this distribution in the form

K

p(z) =

k=1

πz

k . (9.10)

k

Similarly, the conditional distribution of x given a particular value for z is a Gaussian p(x|zk = 1) = N(x|µk,Σk) which can also be written in the form

p(x|z) =

K

N(x|µk,Σk)zk

. (9.11)

k=1

The joint distribution is given by p(z)p(x|z), and the marginal distribution of x is Exercise 9.3 then obtained by summing the joint distribution over all possible states of z to give

p(x) =

z

p(z)p(x|z) =

K

πkN(x|µk,Σk) (9.12)

k=1

where we have made use of (9.10) and (9.11). Thus the marginal distribution of x is a Gaussian mixture of the form (9.7). If we have several observations x1,...,xN, then, because we have represented the marginal distribution in the form p(x) =

z p(x,z), it follows that for every observed data point xn there is a corresponding latent variable zn.

We have therefore found an equivalent formulation of the Gaussian mixture involving an explicit latent variable. It might seem that we have not gained much by doing so. However, we are now able to work with the joint distribution p(x,z)

9.2 Mixtures of Gaussians 435

identiﬁability (Casella and Berger, 2002) and is an important issue when we wish to interpret the parameter values discovered by a model. Identiﬁability will also arise when we discuss models having continuous latent variables in Chapter 12. However, for the purposes of ﬁnding a good density model, it is irrelevant because any of the equivalent solutions is as good as any other.

Maximizing the log likelihood function (9.14) for a Gaussian mixture model turns out to be a more complex problem than for the case of a single Gaussian. The difﬁculty arises from the presence of the summation over k that appears inside the logarithm in (9.14), so that the logarithm function no longer acts directly on the Gaussian. If we set the derivatives of the log likelihood to zero, we will no longer obtain a closed form solution, as we shall see shortly.

One approach is to apply gradient-based optimization techniques (Fletcher, 1987;

Nocedal and Wright, 1999; Bishop and Nabney, 2008). Although gradient-based techniques are feasible, and indeed will play an important role when we discuss mixture density networks in Chapter 5, we now consider an alternative approach known as the EM algorithm which has broad applicability and which will lay the foundations for a discussion of variational inference techniques in Chapter 10.

### 9.2.2 EM for Gaussian mixtures

An elegant and powerful method for ﬁnding maximum likelihood solutions for models with latent variables is called the expectation-maximization algorithm, or EM algorithm (Dempster et al., 1977; McLachlan and Krishnan, 1997). Later we shall give a general treatment of EM, and we shall also show how EM can be generalized

Section 10.1 to obtain the variational inference framework. Initially, we shall motivate the EM algorithm by giving a relatively informal treatment in the context of the Gaussian mixture model. We emphasize, however, that EM has broad applicability, and indeed it will be encountered in the context of a variety of different models in this book.

Let us begin by writing down the conditions that must be satisﬁed at a maximum of the likelihood function. Setting the derivatives of lnp(X|π,µ,Σ) in (9.14) with respect to the means µk of the Gaussian components to zero, we obtain

N

πkN(xn|µk,Σk) j πjN(xn|µj,Σj)

Σk(xn − µk) (9.16)

0 = −

n=1

γ(znk)

where we have made use of the form (2.43) for the Gaussian distribution. Note that the posterior probabilities, or responsibilities, given by (9.13) appear naturally on the right-hand side. Multiplying by Σ−1

k (which we assume to be nonsingular) and rearranging we obtain

N

1 Nk

γ(znk)xn (9.17) where we have deﬁned

µk =

n=1

N

Nk =

γ(znk). (9.18)

n=1

We can interpret Nk as the effective number of points assigned to cluster k. Note carefully the form of this solution. We see that the mean µk for the kth Gaussian component is obtained by taking a weighted mean of all of the points in the data set, in which the weighting factor for data point xn is given by the posterior probability γ(znk) that component k was responsible for generating xn.

If we set the derivative of lnp(X|π,µ,Σ) with respect to Σk to zero, and follow

a similar line of reasoning, making use of the result for the maximum likelihood Section 2.3.4 solution for the covariance matrix of a single Gaussian, we obtain

N

1 Nk

Σk =

γ(znk)(xn − µk)(xn − µk)T (9.19)

n=1

which has the same form as the corresponding result for a single Gaussian ﬁtted to the data set, but again with each data point weighted by the corresponding posterior probability and with the denominator given by the effective number of points associated with the corresponding component.

Finally, we maximize lnp(X|π,µ,Σ) with respect to the mixing coefﬁcients πk. Here we must take account of the constraint (9.9), which requires the mixing

Appendix E coefﬁcients to sum to one. This can be achieved using a Lagrange multiplier and

maximizing the following quantity

lnp(X|π,µ,Σ) + λ

K

πk − 1 (9.20)

k=1

which gives

N

N(xn|µk,Σk) j πjN(xn|µj,Σj)

- λ (9.21)

0 =

n=1

where again we see the appearance of the responsibilities. If we now multiply both sides by πk and sum over k making use of the constraint (9.9), we ﬁnd λ = −N. Using this to eliminate λ and rearranging we obtain

Nk N

πk =

(9.22)

so that the mixing coefﬁcient for the kth component is given by the average responsibility which that component takes for explaining the data points.

It is worth emphasizing that the results (9.17), (9.19), and (9.22) do not constitute a closed-form solution for the parameters of the mixture model because the responsibilities γ(znk) depend on those parameters in a complex way through (9.13). However, these results do suggest a simple iterative scheme for ﬁnding a solution to the maximum likelihood problem, which as we shall see turns out to be an instance of the EM algorithm for the particular case of the Gaussian mixture model. We ﬁrst choose some initial values for the means, covariances, and mixing coefﬁcients. Then we alternate between the following two updates that we shall call the E step

family, the marginal distribution p(X|θ) typically does not as a result of this summation. The presence of the sum prevents the logarithm from acting directly on the joint distribution, resulting in complicated expressions for the maximum likelihood solution.

Now suppose that, for each observation in X, we were told the corresponding value of the latent variable Z. We shall call {X,Z} the complete data set, and we shall refer to the actual observed data X as incomplete, as illustrated in Figure 9.5. The likelihood function for the complete data set simply takes the form lnp(X,Z|θ), and we shall suppose that maximization of this complete-data log likelihood function is straightforward.

In practice, however, we are not given the complete data set {X,Z}, but only the incomplete data X. Our state of knowledge of the values of the latent variables in Z is given only by the posterior distribution p(Z|X,θ). Because we cannot use the complete-data log likelihood, we consider instead its expected value under the posterior distribution of the latent variable, which corresponds (as we shall see) to the E step of the EM algorithm. In the subsequent M step, we maximize this expectation. If the current estimate for the parameters is denoted θold, then a pair of successive E and M steps gives rise to a revised estimate θnew. The algorithm is initialized by choosing some starting value for the parameters θ0. The use of the expectation may seem somewhat arbitrary. However, we shall see the motivation for this choice when we give a deeper treatment of EM in Section 9.4.

In the E step, we use the current parameter values θold to ﬁnd the posterior distribution of the latent variables given by p(Z|X,θold). We then use this posterior distribution to ﬁnd the expectation of the complete-data log likelihood evaluated for some general parameter value θ. This expectation, denoted Q(θ,θold), is given by

Q(θ,θold) =

p(Z|X,θold)lnp(X,Z|θ). (9.30)

Z

In the M step, we determine the revised parameter estimate θnew by maximizing this function

θnew = arg max

Q(θ,θold). (9.31)

θ

Note that in the deﬁnition of Q(θ,θold), the logarithm acts directly on the joint distribution p(X,Z|θ), and so the corresponding M-step maximization will, by supposition, be tractable.

The general EM algorithm is summarized below. It has the property, as we shall show later, that each cycle of EM will increase the incomplete-data log likelihood

Section 9.4 (unless it is already at a local maximum). The General EM Algorithm

Given a joint distribution p(X,Z|θ) over observed variables X and latent variables Z, governed by parameters θ, the goal is to maximize the likelihood function p(X|θ) with respect to θ.

1. Choose an initial setting for the parameters θold.

- 2. E step Evaluate p(Z|X,θold).
- 3. M step Evaluate θnew given by

θnew = arg max

Q(θ,θold) (9.32)

θ

where

Q(θ,θold) =

Z

p(Z|X,θold)lnp(X,Z|θ). (9.33)

4. Check for convergence of either the log likelihood or the parameter values. If the convergence criterion is not satisﬁed, then let

θold ← θnew (9.34) and return to step 2.

The EM algorithm can also be used to ﬁnd MAP (maximum posterior) solutions

Exercise 9.4 for models in which a prior p(θ) is deﬁned over the parameters. In this case the E step remains the same as in the maximum likelihood case, whereas in the M step the quantity to be maximized is given by Q(θ,θold) + lnp(θ). Suitable choices for the prior will remove the singularities of the kind illustrated in Figure 9.7.

Here we have considered the use of the EM algorithm to maximize a likelihood function when there are discrete latent variables. However, it can also be applied when the unobserved variables correspond to missing values in the data set. The distribution of the observed values is obtained by taking the joint distribution of all the variables and then marginalizing over the missing ones. EM can then be used to maximize the corresponding likelihood function. We shall show an example of the application of this technique in the context of principal component analysis in Figure 12.11. This will be a valid procedure if the data values are missing at random, meaning that the mechanism causing values to be missing does not depend on the unobserved values. In many situations this will not be the case, for instance if a sensor fails to return a value whenever the quantity it is measuring exceeds some threshold.

### 9.3 An Alternative View of EM

### 9.3.1 Gaussian mixtures revisited

We now consider the application of this latent variable view of EM to the speciﬁc case of a Gaussian mixture model. Recall that our goal is to maximize the log likelihood function (9.14), which is computed using the observed data set X, and we saw that this was more difﬁcult than for the case of a single Gaussian distribution due to the presence of the summation over k that occurs inside the logarithm. Suppose then that in addition to the observed data set X, we were also given the values of the corresponding discrete variables Z. Recall that Figure 9.5(a) shows a ‘complete’ data set (i.e., one that includes labels showing which component generated each data point) while Figure 9.5(b) shows the corresponding ‘incomplete’ data set. The graphical model for the complete data is shown in Figure 9.9.

Using (9.10) and (9.11) together with Bayes’ theorem, we see that this posterior distribution takes the form

N

p(Z|X,µ,Σ,π) ∝

n=1

K

[πkN(xn|µk,Σk)]z

nk

k=1

. (9.38)

and hence factorizes over n so that under the posterior distribution the {zn} are Exercise 9.5 independent. This is easily veriﬁed by inspection of the directed graph in Figure 9.6 Section 8.2 and making use of the d-separation criterion. The expected value of the indicator

variable znk under this posterior distribution is then given by

znk [πkN(xn|µk,Σk)]z

nk

E[znk] = znk

πjN(xn|µj,Σj) znj

znj

πkN(xn|µk,Σk) K

= γ(znk) (9.39)

=

πjN(xn|µj,Σj)

j=1

which is just the responsibility of component k for data point xn. The expected value of the complete-data log likelihood function is therefore given by

N

EZ[lnp(X,Z|µ,Σ,π)] =

n=1

K

γ(znk){lnπk + lnN(xn|µk,Σk)}. (9.40)

k=1

We can now proceed as follows. First we choose some initial values for the parameters µold, Σold and πold, and use these to evaluate the responsibilities (the E step). We then keep the responsibilities ﬁxed and maximize (9.40) with respect to µk, Σk and πk (the M step). This leads to closed form solutions for µnew, Σnew and πnew

Exercise 9.8 given by (9.17), (9.19), and (9.22) as before. This is precisely the EM algorithm for Gaussian mixtures as derived earlier. We shall gain more insight into the role of the expected complete-data log likelihood function when we give a proof of convergence of the EM algorithm in Section 9.4.

### 9.3.2 Relation to K-means

Comparison of the K-means algorithm with the EM algorithm for Gaussian mixtures shows that there is a close similarity. Whereas the K-means algorithm performs a hard assignment of data points to clusters, in which each data point is associated uniquely with one cluster, the EM algorithm makes a soft assignment based on the posterior probabilities. In fact, we can derive the K-means algorithm as a particular limit of EM for Gaussian mixtures as follows.

Consider a Gaussian mixture model in which the covariance matrices of the mixture components are given by I, where is a variance parameter that is shared

by all of the components, and I is the identity matrix, so that

1 (2π )1/2

1 2

p(x|µk,Σk) =

exp −

x − µk 2 . (9.41)

We now consider the EM algorithm for a mixture of K Gaussians of this form in which we treat as a ﬁxed constant, instead of a parameter to be re-estimated. From (9.13) the posterior probabilities, or responsibilities, for a particular data point xn, are given by

πk exp{− xn − µk 2/2 } j πj exp − xn − µj 2/2

γ(znk) =

. (9.42) If we consider the limit → 0, we see that in the denominator the term for which

xn − µj 2 is smallest will go to zero most slowly, and hence the responsibilities γ(znk) for the data point xn all go to zero except for term j, for which the responsibility γ(znj) will go to unity. Note that this holds independently of the values of the πk so long as none of the πk is zero. Thus, in this limit, we obtain a hard assignment of data points to clusters, just as in the K-means algorithm, so that γ(znk) → rnk where rnk is deﬁned by (9.2). Each data point is thereby assigned to the cluster having the closest mean.

The EM re-estimation equation for the µk, given by (9.17), then reduces to the K-means result (9.4). Note that the re-estimation formula for the mixing coefﬁcients (9.22) simply re-sets the value of πk to be equal to the fraction of data points assigned to cluster k, although these parameters no longer play an active role in the algorithm.

Finally, in the limit → 0 the expected complete-data log likelihood, given by Exercise 9.11 (9.40), becomes

N

K

1 2

EZ[lnp(X,Z|µ,Σ,π)] → −

rnk xn − µk 2 + const. (9.43)

n=1

k=1

Thus we see that in this limit, maximizing the expected complete-data log likelihood is equivalent to minimizing the distortion measure J for the K-means algorithm given by (9.1).

Note that the K-means algorithm does not estimate the covariances of the clusters but only the cluster means. A hard-assignment version of the Gaussian mixture model with general covariance matrices, known as the elliptical K-means algorithm, has been considered by Sung and Poggio (1994).

### 9.3.3 Mixtures of Bernoulli distributions

So far in this chapter, we have focussed on distributions over continuous variables described by mixtures of Gaussians. As a further example of mixture modelling, and to illustrate the EM algorithm in a different context, we now discuss mixtures of discrete binary variables described by Bernoulli distributions. This model is also known as latent class analysis (Lazarsfeld and Henry, 1968; McLachlan and Peel, 2000). As well as being of practical importance in its own right, our discussion of Bernoulli mixtures will also lay the foundation for a consideration of hidden

Section 13.2 Markov models over discrete variables.

If we consider the sum over n in (9.55), we see that the responsibilities enter only through two terms, which can be written as

Nk =

xk =

N

γ(znk) (9.57)

n=1

N

1 Nk

γ(znk)xn (9.58)

n=1

where Nk is the effective number of data points associated with component k. In the M step, we maximize the expected complete-data log likelihood with respect to the

parameters µk and π. If we set the derivative of (9.55) with respect to µk equal to Exercise 9.15 zero and rearrange the terms, we obtain

µk = xk. (9.59)

We see that this sets the mean of component k equal to a weighted mean of the data, with weighting coefﬁcients given by the responsibilities that component k takes for data points. For the maximization with respect to πk, we need to introduce a Lagrange multiplier to enforce the constraint k πk = 1. Following analogous

Exercise 9.16 steps to those used for the mixture of Gaussians, we then obtain

Nk N

πk =

(9.60)

which represents the intuitively reasonable result that the mixing coefﬁcient for component k is given by the effective fraction of points in the data set explained by that component.

Note that in contrast to the mixture of Gaussians, there are no singularities in which the likelihood function goes to inﬁnity. This can be seen by noting that the

Exercise 9.17 likelihood function is bounded above because 0 p(xn|µk) 1. There exist singularities at which the likelihood function goes to zero, but these will not be found by EM provided it is not initialized to a pathological starting point, because the EM algorithm always increases the value of the likelihood function, until a local

Section 9.4 maximum is found. We illustrate the Bernoulli mixture model in Figure 9.10 by using it to model handwritten digits. Here the digit images have been turned into binary vectors by setting all elements whose values exceed 0.5 to 1 and setting the remaining elements to 0. We now ﬁt a data set of N = 600 such digits, comprising the digits ‘2’, ‘3’, and ‘4’, with a mixture of K = 3 Bernoulli distributions by running 10 iterations of the EM algorithm. The mixing coefﬁcients were initialized to πk = 1/K, and the parameters µkj were set to random values chosen uniformly in the range (0.25,0.75) and then normalized to satisfy the constraint that j µkj = 1. We see that a mixture of 3 Bernoulli distributions is able to ﬁnd the three clusters in the data set corresponding to the different digits.

The conjugate prior for the parameters of a Bernoulli distribution is given by the beta distribution, and we have seen that a beta prior is equivalent to introducing

complete EM cycle will change the model parameters in such a way as to cause the log likelihood to increase (unless it is already at a maximum, in which case the parameters remain unchanged).

We can also use the EM algorithm to maximize the posterior distribution p(θ|X) for models in which we have introduced a prior p(θ) over the parameters. To see this, we note that as a function of θ, we have p(θ|X) = p(θ,X)/p(X) and so

lnp(θ|X) = lnp(θ,X) − lnp(X). (9.76) Making use of the decomposition (9.70), we have

lnp(θ|X) = L(q,θ) + KL(q p) + lnp(θ) − lnp(X) L(q,θ) + lnp(θ) − lnp(X). (9.77)

where lnp(X) is a constant. We can again optimize the right-hand side alternately with respect to q and θ. The optimization with respect to q gives rise to the same Estep equations as for the standard EM algorithm, because q only appears in L(q,θ). The M-step equations are modiﬁed through the introduction of the prior term lnp(θ), which typically requires only a small modiﬁcation to the standard maximum likelihood M-step equations.

The EM algorithm breaks down the potentially difﬁcult problem of maximizing the likelihood function into two stages, the E step and the M step, each of which will often prove simpler to implement. Nevertheless, for complex models it may be the case that either the E step or the M step, or indeed both, remain intractable. This leads to two possible extensions of the EM algorithm, as follows.

The generalized EM, or GEM, algorithm addresses the problem of an intractable M step. Instead of aiming to maximize L(q,θ) with respect to θ, it seeks instead to change the parameters in such a way as to increase its value. Again, because L(q,θ) is a lower bound on the log likelihood function, each complete EM cycle of the GEM algorithm is guaranteed to increase the value of the log likelihood (unless the parameters already correspond to a local maximum). One way to exploit the GEM approach would be to use one of the nonlinear optimization strategies, such as the conjugate gradients algorithm, during the M step. Another form of GEM algorithm, known as the expectation conditional maximization, or ECM, algorithm, involves making several constrained optimizations within each M step (Meng and Rubin, 1993). For instance, the parameters might be partitioned into groups, and the M step is broken down into multiple steps each of which involves optimizing one of the subset with the remainder held ﬁxed.

We can similarly generalize the E step of the EM algorithm by performing a partial, rather than complete, optimization of L(q,θ) with respect to q(Z) (Neal and Hinton, 1999). As we have seen, for any given value of θ there is a unique maximum of L(q,θ) with respect to q(Z) that corresponds to the posterior distribution qθ(Z) = p(Z|X,θ) and that for this choice of q(Z) the bound L(q,θ) is equal to the log likelihood function lnp(X|θ). It follows that any algorithm that converges to the global maximum of L(q,θ) will ﬁnd a value of θ that is also a global maximum of the log likelihood lnp(X|θ). Provided p(X,Z|θ) is a continuous function of θ

then, by continuity, any local maximum of L(q,θ) will also be a local maximum of lnp(X|θ).

Consider the case of N independent data points x1,...,xN with corresponding latent variables z1,...,zN. The joint distribution p(X,Z|θ) factorizes over the data points, and this structure can be exploited in an incremental form of EM in which at each EM cycle only one data point is processed at a time. In the E step, instead of recomputing the responsibilities for all of the data points, we just re-evaluate the responsibilities for one data point. It might appear that the subsequent M step would require computation involving the responsibilities for all of the data points. However, if the mixture components are members of the exponential family, then the responsibilities enter only through simple sufﬁcient statistics, and these can be updated efﬁciently. Consider, for instance, the case of a Gaussian mixture, and suppose we perform an update for data point m in which the corresponding old and new values of the responsibilities are denoted γold(zmk) and γnew(zmk). In the M step, the required sufﬁcient statistics can be updated incrementally. For instance, for the

Exercise 9.26 means the sufﬁcient statistics are deﬁned by (9.17) and (9.18) from which we obtain

µnewk = µoldk +

γnew(zmk) − γold(zmk) Nknew

xm − µoldk (9.78)

together with

Nknew = Nkold + γnew(zmk) − γold(zmk). (9.79) The corresponding results for the covariances and the mixing coefﬁcients are analogous.

Thus both the E step and the M step take ﬁxed time that is independent of the total number of data points. Because the parameters are revised after each data point, rather than waiting until after the whole data set is processed, this incremental version can converge faster than the batch version. Each E or M step in this incremental algorithm is increasing the value of L(q,θ) and, as we have shown above, if the algorithm converges to a local (or global) maximum of L(q,θ), this will correspond to a local (or global) maximum of the log likelihood function lnp(X|θ).

