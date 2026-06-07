[Page 187]

where $M$ is the dimensionality of $\mathbf{w}$, and we have defined
$$
\begin{aligned}
E(\mathbf{w}) &= \beta E_D(\mathbf{w}) + \alpha E_W(\mathbf{w}) \\
&= \frac{\beta}{2} \|\mathbf{t} - \mathbf{\Phi}\mathbf{w}\|^2 + \frac{\alpha}{2} \mathbf{w}^{\text{T}}\mathbf{w}.
\end{aligned}
\tag{3.79}
$$
We recognize (3.79) as being equal, up to a constant of proportionality, to the regularized sum-of-squares error function (3.27). We now complete the square over $\mathbf{w}$ giving
$$
E(\mathbf{w}) = E(\mathbf{m}_N) + \frac{1}{2}(\mathbf{w} - \mathbf{m}_N)^{\text{T}}\mathbf{A}(\mathbf{w} - \mathbf{m}_N)
\tag{3.80}
$$
where we have introduced
$$
\mathbf{A} = \alpha\mathbf{I} + \beta\mathbf{\Phi}^{\text{T}}\mathbf{\Phi}
\tag{3.81}
$$
together with
$$
E(\mathbf{m}_N) = \frac{\beta}{2} \|\mathbf{t} - \mathbf{\Phi}\mathbf{m}_N\|^2 + \frac{\alpha}{2} \mathbf{m}_N^{\text{T}}\mathbf{m}_N.
\tag{3.82}
$$
Note that $\mathbf{A}$ corresponds to the matrix of second derivatives of the error function
$$
\mathbf{A} = \nabla\nabla E(\mathbf{w})
\tag{3.83}
$$
and is known as the Hessian matrix. Here we have also defined $\mathbf{m}_N$ given by
$$
\mathbf{m}_N = \beta\mathbf{A}^{-1}\mathbf{\Phi}^{\text{T}}\mathbf{t}.
\tag{3.84}
$$
Using (3.54), we see that $\mathbf{A} = \mathbf{S}_N^{-1}$, and hence (3.84) is equivalent to the previous definition (3.53), and therefore represents the mean of the posterior distribution.

The integral over $\mathbf{w}$ can now be evaluated simply by appealing to the standard result for the normalization coefficient of a multivariate Gaussian, giving
$$
\begin{aligned}
\int \exp\{-E(\mathbf{w})\} \, \text{d}\mathbf{w} &= \exp\{-E(\mathbf{m}_N)\} \int \exp\left\{ -\frac{1}{2}(\mathbf{w} - \mathbf{m}_N)^{\text{T}}\mathbf{A}(\mathbf{w} - \mathbf{m}_N) \right\} \, \text{d}\mathbf{w} \\
&= \exp\{-E(\mathbf{m}_N)\}(2\pi)^{M/2}|\mathbf{A}|^{-1/2}.
\end{aligned}
\tag{3.85}
$$
Using (3.78) we can then write the log of the marginal likelihood in the form
$$
\ln p(\mathbf{t}|\alpha, \beta) = \frac{M}{2} \ln \alpha + \frac{N}{2} \ln \beta - E(\mathbf{m}_N) - \frac{1}{2} \ln |\mathbf{A}| - \frac{N}{2} \ln(2\pi)
\tag{3.86}
$$
which is the required expression for the evidence function.

Returning to the polynomial regression problem, we can plot the model evidence against the order of the polynomial, as shown in Figure 3.14. Here we have assumed a prior of the form (1.65) with the parameter $\alpha$ fixed at $\alpha = 5 \times 10^{-3}$. The form of this plot is very instructive. Referring back to Figure 1.4, we see that the $M = 0$ polynomial has very poor fit to the data and consequently gives a relatively low value
