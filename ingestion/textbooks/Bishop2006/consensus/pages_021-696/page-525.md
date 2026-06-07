[Page 525]

We also need to optimize the variational parameters $\xi_n$, and this is also done by maximizing the lower bound $\widetilde{\mathcal{L}}(q, \boldsymbol{\xi})$. Omitting terms that are independent of $\boldsymbol{\xi}$, and integrating over $\alpha$, we have

$$
\widetilde{\mathcal{L}}(q, \boldsymbol{\xi}) = \int q(\mathbf{w}) \ln h(\mathbf{w}, \boldsymbol{\xi}) \text{d}\mathbf{w} + \text{const}. \tag{10.180}
$$

Note that this has precisely the same form as (10.159), and so we can again appeal to our earlier result (10.163), which can be obtained by direct optimization of the marginal likelihood function, leading to re-estimation equations of the form

$$
(\xi_n^{\text{new}})^2 = \boldsymbol{\phi}_n^{\text{T}} (\boldsymbol{\Sigma}_N + \boldsymbol{\mu}_N\boldsymbol{\mu}_N^{\text{T}}) \boldsymbol{\phi}_n. \tag{10.181}
$$

We have obtained re-estimation equations for the three quantities $q(\mathbf{w})$, $q(\alpha)$, and $\boldsymbol{\xi}$, and so after making suitable initializations, we can cycle through these quantities, updating each in turn. The required moments are given by

$$
\mathbb{E}[\alpha] = \frac{a_N}{b_N} \tag{10.182}
$$

$$
\mathbb{E}[\mathbf{w}^{\text{T}}\mathbf{w}] = \text{Tr}(\boldsymbol{\Sigma}_N) + \boldsymbol{\mu}_N^{\text{T}}\boldsymbol{\mu}_N. \tag{10.183}
$$

### 10.7. Expectation Propagation

We conclude this chapter by discussing an alternative form of deterministic approximate inference, known as expectation propagation or EP (Minka, 2001a; Minka, 2001b). As with the variational Bayes methods discussed so far, this too is based on the minimization of a Kullback-Leibler divergence but now of the reverse form, which gives the approximation rather different properties.

Consider for a moment the problem of minimizing $\text{KL}(p || q)$ with respect to $q(\mathbf{z})$ when $p(\mathbf{z})$ is a ﬁxed distribution and $q(\mathbf{z})$ is a member of the exponential family and so, from (2.194), can be written in the form

$$
q(\mathbf{z}) = h(\mathbf{z})g(\boldsymbol{\eta}) \exp \left\{ \boldsymbol{\eta}^{\text{T}}\mathbf{u}(\mathbf{z}) \right\}. \tag{10.184}
$$

As a function of $\boldsymbol{\eta}$, the Kullback-Leibler divergence then becomes

$$
\text{KL}(p || q) = -\ln g(\boldsymbol{\eta}) - \boldsymbol{\eta}^{\text{T}} \mathbb{E}_{p(\mathbf{z})}[\mathbf{u}(\mathbf{z})] + \text{const} \tag{10.185}
$$

where the constant terms are independent of the natural parameters $\boldsymbol{\eta}$. We can minimize $\text{KL}(p || q)$ within this family of distributions by setting the gradient with respect to $\boldsymbol{\eta}$ to zero, giving

$$
-\nabla \ln g(\boldsymbol{\eta}) = \mathbb{E}_{p(\mathbf{z})}[\mathbf{u}(\mathbf{z})]. \tag{10.186}
$$

However, we have already seen in (2.226) that the negative gradient of $\ln g(\boldsymbol{\eta})$ is given by the expectation of $\mathbf{u}(\mathbf{z})$ under the distribution $q(\mathbf{z})$. Equating these two results, we obtain

$$
\mathbb{E}_{q(\mathbf{z})}[\mathbf{u}(\mathbf{z})] = \mathbb{E}_{p(\mathbf{z})}[\mathbf{u}(\mathbf{z})]. \tag{10.187}
$$
