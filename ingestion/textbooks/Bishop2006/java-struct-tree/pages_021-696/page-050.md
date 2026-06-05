[Page 50]

Again we can ﬁrst determine the parameter vector wML governing the mean and subsequently use this to ﬁnd the precision βML as was the case for the simple Gaussian

Section 1.2.4 distribution.

Having determined the parameters w and β, we can now make predictions for new values of x. Because we now have a probabilistic model, these are expressed in terms of the predictive distribution that gives the probability distribution over t, rather than simply a point estimate, and is obtained by substituting the maximum likelihood parameters into (1.60) to give

p(t|x,wML,βML) = N �

�

t|y(x,wML),βML−1

. (1.64)

Now let us take a step towards a more Bayesian approach and introduce a prior distribution over the polynomial coefﬁcients w. For simplicity, let us consider a Gaussian distribution of the form

p(w|α) = N(w|0,α−1I) = � α 2π�(M+1)/2 exp�−

wTw� (1.65)

α 2

where α is the precision of the distribution, and M+1 is the total number of elements in the vector w for an Mth order polynomial. Variables such as α, which control the distribution of model parameters, are called hyperparameters. Using Bayes’ theorem, the posterior distribution for w is proportional to the product of the prior distribution and the likelihood function

p(w|x,t,α,β) ∝ p(t|x,w,β)p(w|α). (1.66)

We can now determine w by ﬁnding the most probable value of w given the data, in other words by maximizing the posterior distribution. This technique is called maximum posterior, or simply MAP. Taking the negative logarithm of (1.66) and combining with (1.62) and (1.65), we ﬁnd that the maximum of the posterior is given by the minimum of

�N

α 2

β 2

{y(xn,w) − tn}2 +

wTw. (1.67)

n=1

Thus we see that maximizing the posterior distribution is equivalent to minimizing the regularized sum-of-squares error function encountered earlier in the form (1.4), with a regularization parameter given by λ = α/β.

1.2.6 Bayesian curve ﬁtting

Although we have included a prior distribution p(w|α), we are so far still making a point estimate of w and so this does not yet amount to a Bayesian treatment. In a fully Bayesian approach, we should consistently apply the sum and product rules of probability, which requires, as we shall see shortly, that we integrate over all values of w. Such marginalizations lie at the heart of Bayesian methods for pattern recognition.
