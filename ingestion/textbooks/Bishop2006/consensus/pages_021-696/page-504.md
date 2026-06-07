[Page 504]

Figure 10.7 Plot of the variational lower bound $\mathcal{L}$ versus the number $K$ of components in the Gaussian mixture model, for the Old Faithful data, showing a distinct peak at $K = 2$ components. For each value of $K$, the model is trained from 100 different random starts, and the results shown as ‘+’ symbols plotted with small random horizontal perturbations so that they can be distinguished. Note that some solutions ﬁnd suboptimal local maxima, but that this happens infrequently.

![image 239](../images/imageFile239.png)

parameter values. We have seen in Figure 10.2 that if the true posterior distribution is multimodal, variational inference based on the minimization of $\text{KL}(q\|p)$ will tend to approximate the distribution in the neighbourhood of one of the modes and ignore the others. Again, because equivalent modes have equivalent predictive densities, this is of no concern provided we are considering a model having a speciﬁc number $K$ of components. If, however, we wish to compare different values of $K$, then we need to take account of this multimodality. A simple approximate solution is to add a term $\ln K!$ onto the lower bound when used for model comparison and averaging.

Figure 10.7 shows a plot of the lower bound, including the multimodality factor, versus the number $K$ of components for the Old Faithful data set. It is worth emphasizing once again that maximum likelihood would lead to values of the likelihood function that increase monotonically with $K$ (assuming the singular solutions have been avoided, and discounting the effects of local maxima) and so cannot be used to determine an appropriate model complexity. By contrast, Bayesian inference automatically makes the trade-off between model complexity and ﬁtting the data.

This approach to the determination of $K$ requires that a range of models having different $K$ values be trained and compared. An alternative approach to determining a suitable value for $K$ is to treat the mixing coefﬁcients $\boldsymbol{\pi}$ as parameters and make point estimates of their values by maximizing the lower bound (Corduneanu and Bishop, 2001) with respect to $\boldsymbol{\pi}$ instead of maintaining a probability distribution over them as in the fully Bayesian approach. This leads to the re-estimation equation

$$
\pi_k = \frac{1}{N} \sum_{n=1}^N r_{nk} \tag{10.83}
$$

and this maximization is interleaved with the variational updates for the $q$ distribution over the remaining parameters. Components that provide insufﬁcient contribution
