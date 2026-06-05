[Page 106]

evaluated from the joint distribution p(x) = p(xa,xb) simply by ﬁxing xb to the observed value and normalizing the resulting expression to obtain a valid probability

distribution over $\mathbf{x}_a$. Instead of performing this normalization explicitly, we can obtain the solution more efﬁciently by considering the quadratic form in the exponent of the Gaussian distribution given by (2.44) and then reinstating the normalization coefﬁcient at the end of the calculation. If we make use of the partitioning (2.65), (2.66), and (2.69), we obtain

$$
-\frac{1}{2}(\mathbf{x} - \boldsymbol{\mu})^T\Sigma^{-1}(\mathbf{x} - \boldsymbol{\mu}) = -\frac{1}{2}(\mathbf{x}_a - \boldsymbol{\mu}_a)^T\Lambda_{aa}(\mathbf{x}_a - \boldsymbol{\mu}_a)
$$

$$
- \frac{1}{2}(\mathbf{x}_a - \boldsymbol{\mu}_a)^T\Lambda_{ab}(\mathbf{x}_b - \boldsymbol{\mu}_b) - \frac{1}{2}(\mathbf{x}_b - \boldsymbol{\mu}_b)^T\Lambda_{ba}(\mathbf{x}_a - \boldsymbol{\mu}_a)
$$

$$
- \frac{1}{2}(\mathbf{x}_b - \boldsymbol{\mu}_b)^T\Lambda_{bb}(\mathbf{x}_b - \boldsymbol{\mu}_b). \tag{2.70}
$$

We see that as a function of xa, this is again a quadratic form, and hence the corresponding conditional distribution p(xa|xb) will be Gaussian. Because this distribution is completely characterized by its mean and its covariance, our goal will be to identify expressions for the mean and covariance of p(xa|xb) by inspection of (2.70).

This is an example of a rather common operation associated with Gaussian distributions, sometimes called ‘completing the square’, in which we are given a quadratic form deﬁning the exponent terms in a Gaussian distribution, and we need to determine the corresponding mean and covariance. Such problems can be solved straightforwardly by noting that the exponent in a general Gaussian distribution $\mathcal{N}(\mathbf{x} \mid \boldsymbol{\mu}, \Sigma)$ can be written

$$
-\frac{1}{2}(\mathbf{x} - \boldsymbol{\mu})^T\Sigma^{-1}(\mathbf{x} - \boldsymbol{\mu}) = -\frac{1}{2}\mathbf{x}^T\Sigma^{-1}\mathbf{x} + \mathbf{x}^T\Sigma^{-1}\boldsymbol{\mu} + \text{const} \tag{2.71}
$$

where ‘const’ denotes terms which are independent of $\mathbf{x}$, and we have made use of the symmetry of $\Sigma$. Thus if we take our general quadratic form and express it in the form given by the right-hand side of (2.71), then we can immediately equate the matrix of coefﬁcients entering the second-order term in $\mathbf{x}$ to the inverse covariance matrix $\Sigma^{-1}$ and the coefﬁcient of the linear term in $\mathbf{x}$ to $\Sigma^{-1}\boldsymbol{\mu}$, from which we can obtain $\boldsymbol{\mu}$.

Now let us apply this procedure to the conditional Gaussian distribution $p(\mathbf{x}_a \mid \mathbf{x}_b)$ for which the quadratic form in the exponent is given by (2.70). We will denote the mean and covariance of this distribution by $\boldsymbol{\mu}_{a|b}$ and $\Sigma_{a|b}$, respectively. Consider the functional dependence of (2.70) on $\mathbf{x}_a$ in which $\mathbf{x}_b$ is regarded as a constant. If we pick out all terms that are second order in $\mathbf{x}_a$, we have

$$
-\frac{1}{2}\mathbf{x}_a^T\Lambda_{aa}\mathbf{x}_a \tag{2.72}
$$

from which we can immediately conclude that the covariance (inverse precision) of $p(\mathbf{x}_a \mid \mathbf{x}_b)$ is given by

$$
\Sigma_{a|b} = \Lambda_{aa}^{-1}. \tag{2.73}
$$
