[Page 290]

Recall that the simple weight decay regularizer, given in (5.112), can be viewed as the negative log of a Gaussian prior distribution over the weights. We can encourage the weight values to form several groups, rather than just one group, by considering instead a probability distribution that is a mixture of Gaussians. The centres and variances of the Gaussian components, as well as the mixing coefﬁcients, will be considered as adjustable parameters to be determined as part of the learning process. Thus, we have a probability density of the form
$$
p(\mathbf{w}) = \prod_{i} p(w_{i}) \tag{5.136}
$$
where
$$
p(w_{i}) = \sum_{j=1}^{M} \pi_{j} \mathcal{N}(w_{i} | \mu_{j}, \sigma_{j}^{2}) \tag{5.137}
$$
and $\pi_j$ are the mixing coefﬁcients. Taking the negative logarithm then leads to a regularization function of the form
$$
\Omega(\mathbf{w}) = -\sum_{i} \ln \left( \sum_{j=1}^{M} \pi_{j} \mathcal{N}(w_{i} | \mu_{j}, \sigma_{j}^{2}) \right) . \tag{5.138}
$$
The total error function is then given by
$$
\widetilde{E}(\mathbf{w}) = E(\mathbf{w}) + \lambda \Omega(\mathbf{w}) \tag{5.139}
$$
where $\lambda$ is the regularization coefﬁcient. This error is minimized both with respect to the weights $w_i$ and with respect to the parameters $\{\pi_j, \mu_j, \sigma_j\}$ of the mixture model. If the weights were constant, then the parameters of the mixture model could be determined by using the EM algorithm discussed in Chapter 9. However, the distribution of weights is itself evolving during the learning process, and so to avoid numerical instability, a joint optimization is performed simultaneously over the weights and the mixture-model parameters. This can be done using a standard optimization algorithm such as conjugate gradients or quasi-Newton methods.

In order to minimize the total error function, it is necessary to be able to evaluate its derivatives with respect to the various adjustable parameters. To do this it is convenient to regard the $\{\pi_j\}$ as prior probabilities and to introduce the corresponding posterior probabilities which, following (2.192), are given by Bayes' theorem in the form
$$
\gamma_{j}(w) = \frac{\pi_{j} \mathcal{N}(w | \mu_{j}, \sigma_{j}^{2})}{\sum_{k} \pi_{k} \mathcal{N}(w | \mu_{k}, \sigma_{k}^{2})} . \tag{5.140}
$$
The derivatives of the total error function with respect to the weights are then given by
$$
\frac{\partial \widetilde{E}}{\partial w_{i}} = \frac{\partial E}{\partial w_{i}} + \lambda \sum_{j} \gamma_{j}(w_{i}) \frac{(w_{i} - \mu_{j})}{\sigma_{j}^{2}} . \tag{5.141}
$$
