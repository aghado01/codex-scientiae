[Page 375]

mation, we have

$$
\begin{aligned} p(\mathbf{t}|\boldsymbol{\alpha}) &= \int p(\mathbf{t}|\mathbf{w})p(\mathbf{w}|\boldsymbol{\alpha}) \text{d}\mathbf{w} \\ &\simeq p(\mathbf{t}|\mathbf{w}^\star)p(\mathbf{w}^\star|\boldsymbol{\alpha})(2\pi)^{M/2}|\boldsymbol{\Sigma}|^{1/2}. \end{aligned} \tag{7.114}
$$

If we substitute for $p(\mathbf{t}|\mathbf{w}^\star)$ and $p(\mathbf{w}^\star|\boldsymbol{\alpha})$ and then set the derivative of the marginal likelihood with respect to $\alpha_i$ equal to zero, we obtain

$$
-\frac{1}{2}(w_i^\star)^2 + \frac{1}{2\alpha_i} - \frac{1}{2}\Sigma_{ii} = 0. \tag{7.115}
$$

Deﬁning $\gamma_i = 1 - \alpha_i\Sigma_{ii}$ and rearranging then gives

$$
\alpha_i^{\text{new}} = \frac{\gamma_i}{(w_i^\star)^2} \tag{7.116}
$$

which is identical to the re-estimation formula (7.87) obtained for the regression RVM.

If we deﬁne

$$
\widehat{\mathbf{t}} = \mathbf{\Phi}\mathbf{w}^\star + \mathbf{B}^{-1}(\mathbf{t} - \mathbf{y}) \tag{7.117}
$$

we can write the approximate log marginal likelihood in the form

$$
\ln p(\mathbf{t}|\boldsymbol{\alpha}, \beta) = -\frac{1}{2} \{N \ln(2\pi) + \ln|\mathbf{C}| + (\widehat{\mathbf{t}})^T\mathbf{C}^{-1}\widehat{\mathbf{t}}\} \tag{7.118}
$$

where

$$
\mathbf{C} = \mathbf{B} + \mathbf{\Phi}\mathbf{A}\mathbf{\Phi}^T. \tag{7.119}
$$

This takes the same form as (7.85) in the regression case, and so we can apply the same analysis of sparsity and obtain the same fast learning algorithm in which we fully optimize a single hyperparameter $\alpha_i$ at each step.

Figure 7.12 shows the relevance vector machine applied to a synthetic classiﬁcation data set. We see that the relevance vectors tend not to lie in the region of the decision boundary, in contrast to the support vector machine. This is consistent with our earlier discussion of sparsity in the RVM, because a basis function $\phi_i(\mathbf{x})$ centred on a data point near the boundary will have a vector $\boldsymbol{\phi}_i$ that is poorly aligned with the training data vector $\mathbf{t}$.

One of the potential advantages of the relevance vector machine compared with the SVM is that it makes probabilistic predictions. For example, this allows the RVM to be used to help construct an emission density in a nonlinear extension of the linear dynamical system for tracking faces in video sequences (Williams et al., 2005).

So far, we have considered the RVM for binary classiﬁcation problems. For $K > 2$ classes, we again make use of the probabilistic approach in Section 4.3.4 in which there are $K$ linear models of the form

$$
a_k = \mathbf{w}_k^T\mathbf{x} \tag{7.120}
$$
