[Page 455]

identiﬁability (Casella and Berger, 2002) and is an important issue when we wish to interpret the parameter values discovered by a model. Identiﬁability will also arise when we discuss models having continuous latent variables in Chapter 12. However, for the purposes of ﬁnding a good density model, it is irrelevant because any of the equivalent solutions is as good as any other.

Maximizing the log likelihood function (9.14) for a Gaussian mixture model turns out to be a more complex problem than for the case of a single Gaussian. The difﬁculty arises from the presence of the summation over k that appears inside the logarithm in (9.14), so that the logarithm function no longer acts directly on the Gaussian. If we set the derivatives of the log likelihood to zero, we will no longer obtain a closed form solution, as we shall see shortly.

One approach is to apply gradient-based optimization techniques (Fletcher, 1987;

Nocedal and Wright, 1999; Bishop and Nabney, 2008). Although gradient-based techniques are feasible, and indeed will play an important role when we discuss mixture density networks in Chapter 5, we now consider an alternative approach known as the EM algorithm which has broad applicability and which will lay the foundations for a discussion of variational inference techniques in Chapter 10.

###### 9.2.2 EM for Gaussian mixtures

An elegant and powerful method for ﬁnding maximum likelihood solutions for models with latent variables is called the expectation-maximization algorithm, or EM algorithm (Dempster et al., 1977; McLachlan and Krishnan, 1997). Later we shall give a general treatment of EM, and we shall also show how EM can be generalized

- Section 10.1 to obtain the variational inference framework. Initially, we shall motivate the EM algorithm by giving a relatively informal treatment in the context of the Gaussian mixture model. We emphasize, however, that EM has broad applicability, and indeed it will be encountered in the context of a variety of different models in this book.


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
