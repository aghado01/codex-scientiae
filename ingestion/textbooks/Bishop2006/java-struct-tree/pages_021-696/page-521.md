[Page 521]

we then use these parameter values to ﬁnd the posterior distribution over w, which is given by (10.156). In the M step, we then maximize the expected complete-data log likelihood which is given by

Q(ξ,ξold) = E[lnh(w,ξ)p(w)] (10.160)

where the expectation is taken with respect to the posterior distribution q(w) evaluated using ξold. Noting that p(w) does not depend on ξ, and substituting for h(w,ξ) we obtain

�N

�

�

Q(ξ,ξold) =

lnσ(ξn) − ξn/2 − λ(ξn)(φTnE[wwT]φn − ξn2)

+ const

n=1

(10.161) where ‘const’ denotes terms that are independent of ξ. We now set the derivative with respect to ξn equal to zero. A few lines of algebra, making use of the deﬁnitions of σ(ξ) and λ(ξ), then gives

0 = λ�(ξn)(φTnE[wwT]φn − ξn2). (10.162)

We now note that λ�(ξ) is a monotonic function of ξ for ξ � 0, and that we can restrict attention to nonnegative values of ξ without loss of generality due to the symmetry of the bound around ξ = 0. Thus λ�(ξ) �= 0, and hence we obtain the

Exercise 10.33 following re-estimation equations (ξnnew)2 = φTnE[wwT]φn = φTn

�

�

SN + mNmTN

φn (10.163) where we have used (10.156).

Let us summarize the EM algorithm for ﬁnding the variational posterior distribution. We ﬁrst initialize the variational parameters ξold. In the E step, we evaluate the posterior distribution over w given by (10.156), in which the mean and covariance are deﬁned by (10.157) and (10.158). In the M step, we then use this variational posterior to compute a new value for ξ given by (10.163). The E and M steps are repeated until a suitable convergence criterion is satisﬁed, which in practice typically requires only a few iterations.

An alternative approach to obtaining re-estimation equations for ξ is to note that in the integral over w in the deﬁnition (10.159) of the lower bound L(ξ), the integrand has a Gaussian-like form and so the integral can be evaluated analytically. Having evaluated the integral, we can then differentiate with respect to ξn. It turns out that this gives rise to exactly the same re-estimation equations as does the EM

Exercise 10.34 approach given by (10.163).

As we have emphasized already, in the application of variational methods it is useful to be able to evaluate the lower bound L(ξ) given by (10.159). The integration over w can be performed analytically by noting that p(w) is Gaussian and h(w,ξ) is the exponential of a quadratic function of w. Thus, by completing the square and making use of the standard result for the normalization coefﬁcient of a Gaussian

Exercise 10.35 distribution, we can obtain a closed form solution which takes the form
