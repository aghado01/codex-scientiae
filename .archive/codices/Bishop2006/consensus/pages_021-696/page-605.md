[Page 605]

![Figure 12.15](../images/imageFile142.png)

Figure 12.15 Gibbs sampling for Bayesian PCA showing plots of $\ln \alpha_i$ versus iteration number for three $\alpha$ values, showing transitions between the three modes of the posterior distribution.

variable is given by $p(\mathbf{x}) = \mathcal{N}(\mathbf{x}|\boldsymbol{\mu}, \mathbf{C})$ where now

$$
\mathbf{C} = \mathbf{W}\mathbf{W}^{\text{T}} + \mathbf{\Psi}. \tag{12.65}
$$

As with probabilistic PCA, this model is invariant to rotations in the latent space.

Historically, factor analysis has been the subject of controversy when attempts have been made to place an interpretation on the individual factors (the coordinates in $\mathbf{z}$-space), which has proven problematic due to the nonidentiﬁability of factor analysis associated with rotations in this space. From our perspective, however, we shall view factor analysis as a form of latent variable density model, in which the form of the latent space is of interest but not the particular choice of coordinates used to describe it. If we wish to remove the degeneracy associated with latent space rotations, we must consider non-Gaussian latent variable distributions, giving rise to independent component analysis (ICA) models.

We can determine the parameters $\boldsymbol{\mu}$, $\mathbf{W}$, and $\mathbf{\Psi}$ in the factor analysis model by maximum likelihood. The solution for $\boldsymbol{\mu}$ is again given by the sample mean. However, unlike probabilistic PCA, there is no longer a closed-form maximum likelihood solution for $\mathbf{W}$, which must therefore be found iteratively. Because factor analysis is a latent variable model, this can be done using an EM algorithm (Rubin and Thayer, 1982) that is analogous to the one used for probabilistic PCA. Speciﬁcally, the E-step equations are given by

$$
\mathbb{E}[\mathbf{z}_n] = \mathbf{G}\mathbf{W}^{\text{T}}\mathbf{\Psi}^{-1}(\mathbf{x}_n - \bar{\mathbf{x}}) \tag{12.66}
$$

$$
\mathbb{E}[\mathbf{z}_n\mathbf{z}_n^{\text{T}}] = \mathbf{G} + \mathbb{E}[\mathbf{z}_n]\mathbb{E}[\mathbf{z}_n]^{\text{T}} \tag{12.67}
$$

where we have deﬁned

$$
\mathbf{G} = (\mathbf{I} + \mathbf{W}^{\text{T}}\mathbf{\Psi}^{-1}\mathbf{W})^{-1}. \tag{12.68}
$$

Note that this is expressed in a form that involves inversion of matrices of size $M \times M$ rather than $D \times D$ (except for the $D \times D$ diagonal matrix $\mathbf{\Psi}$ whose inverse is trivial
