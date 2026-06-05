[Page 50]

Again we can ﬁrst determine the parameter vector $\mathbf{w}_{\mathrm{ML}}$ governing the mean and subsequently use this to ﬁnd the precision $\beta_{\mathrm{ML}}$ as was the case for the simple Gaussian distribution.

Having determined the parameters $\mathbf{w}$ and $\beta$, we can now make predictions for new values of $x$. Because we now have a probabilistic model, these are expressed in terms of the predictive distribution that gives the probability distribution over $t$, rather than simply a point estimate, and is obtained by substituting the maximum likelihood parameters into (1.60) to give

$$
p(t \mid x, \mathbf{w}_{\mathrm{ML}}, \beta_{\mathrm{ML}}) = \mathcal{N}(t \mid y(x, \mathbf{w}_{\mathrm{ML}}), \beta_{\mathrm{ML}}^{-1}). \tag{1.64}
$$

Now let us take a step towards a more Bayesian approach and introduce a prior distribution over the polynomial coefﬁcients $\mathbf{w}$. For simplicity, let us consider a Gaussian distribution of the form

$$
p(\mathbf{w} \mid \alpha) = \mathcal{N}(\mathbf{w} \mid \mathbf{0}, \alpha^{-1}\mathbf{I}) = \left(\frac{\alpha}{2\pi}\right)^{(M+1)/2} \exp\left\{-\frac{\alpha}{2}\mathbf{w}^{T}\mathbf{w}\right\}. \tag{1.65}
$$

where $\alpha$ is the precision of the distribution, and $M+1$ is the total number of elements in the vector $\mathbf{w}$ for an $M$th order polynomial. Variables such as $\alpha$, which control the distribution of model parameters, are called hyperparameters. Using Bayes’ theorem, the posterior distribution for $\mathbf{w}$ is proportional to the product of the prior distribution and the likelihood function

$$
p(\mathbf{w} \mid \mathbf{x}, \mathbf{t}, \alpha, \beta) \propto p(\mathbf{t} \mid \mathbf{x}, \mathbf{w}, \beta)p(\mathbf{w} \mid \alpha). \tag{1.66}
$$

We can now determine $\mathbf{w}$ by ﬁnding the most probable value of $\mathbf{w}$ given the data, in other words by maximizing the posterior distribution. This technique is called maximum posterior, or simply MAP. Taking the negative logarithm of (1.66) and combining with (1.62) and (1.65), we ﬁnd that the maximum of the posterior is given by the minimum of

$$
\frac{\beta}{2} \sum_{n=1}^{N} \{y(x_n, \mathbf{w}) - t_n\}^2 + \frac{\alpha}{2} \mathbf{w}^{T}\mathbf{w}. \tag{1.67}
$$

Thus we see that maximizing the posterior distribution is equivalent to minimizing the regularized sum-of-squares error function encountered earlier in the form (1.4), with a regularization parameter given by $\lambda = \alpha/\beta$.

###### 1.2.6 Bayesian curve ﬁtting

Although we have included a prior distribution $p(\mathbf{w} \mid \alpha)$, we are so far still making a point estimate of $\mathbf{w}$ and so this does not yet amount to a Bayesian treatment. In a fully Bayesian approach, we should consistently apply the sum and product rules of probability, which requires, as we shall see shortly, that we integrate over all values of $\mathbf{w}$. Such marginalizations lie at the heart of Bayesian methods for pattern recognition.
