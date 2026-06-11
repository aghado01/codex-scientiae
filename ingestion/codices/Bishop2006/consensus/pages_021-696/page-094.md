[Page 94]

large data set. For a finite data set, the posterior mean for $\mu$ always lies between the prior mean and the maximum likelihood estimate for $\mu$ corresponding to the relative frequencies of events given by (2.7). From Figure 2.2, we see that as the number of observations increases, so the posterior distribution becomes more sharply peaked. This can also be seen from the result (2.16) for the variance of the beta distribution, in which we see that the variance goes to zero for $a \to \infty$ or $b \to \infty$. In fact, we might wonder whether it is a general property of Bayesian learning that, as we observe more and more data, the uncertainty represented by the posterior distribution will steadily decrease.

To address this, we can take a frequentist view of Bayesian learning and show that, on average, such a property does indeed hold. Consider a general Bayesian inference problem for a parameter $\theta$ for which we have observed a data set $\mathcal{D}$, described by the joint distribution $p(\theta, \mathcal{D})$. The following result

$$
\mathbb{E}_{\theta}[\theta] = \mathbb{E}_{\mathcal{D}}[\mathbb{E}_{\theta}[\theta|\mathcal{D}]] \tag{2.21}
$$

where

$$
\mathbb{E}_{\theta}[\theta] \equiv \int p(\theta)\theta \, d\theta \tag{2.22}
$$

$$
\mathbb{E}_{\mathcal{D}}[\mathbb{E}_{\theta}[\theta|\mathcal{D}]] \equiv \int \left\{ \int \theta p(\theta|\mathcal{D}) \, d\theta \right\} p(\mathcal{D}) \, d\mathcal{D} \tag{2.23}
$$

says that the posterior mean of $\theta$, averaged over the distribution generating the data, is equal to the prior mean of $\theta$. Similarly, we can show that

$$
\operatorname{var}_{\theta}[\theta] = \mathbb{E}_{\mathcal{D}}[\operatorname{var}_{\theta}[\theta|\mathcal{D}]] + \operatorname{var}_{\mathcal{D}}[\mathbb{E}_{\theta}[\theta|\mathcal{D}]]. \tag{2.24}
$$

The term on the left-hand side of (2.24) is the prior variance of $\theta$. On the righthand side, the first term is the average posterior variance of $\theta$, and the second term measures the variance in the posterior mean of $\theta$. Because this variance is a positive quantity, this result shows that, on average, the posterior variance of $\theta$ is smaller than the prior variance. The reduction in variance is greater if the variance in the posterior mean is greater. Note, however, that this result only holds on average, and that for a particular observed data set it is possible for the posterior variance to be larger than the prior variance.

## 2.2. Multinomial Variables

Binary variables can be used to describe quantities that can take one of two possible values. Often, however, we encounter discrete variables that can take on one of $K$ possible mutually exclusive states. Although there are various alternative ways to express such variables, we shall see shortly that a particularly convenient representation is the 1-of-$K$ scheme in which the variable is represented by a $K$-dimensional vector $\mathbf{x}$ in which one of the elements $x_k$ equals $1$, and all remaining elements equal
