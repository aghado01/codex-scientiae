# Chapter 10 Exercises

[Page 537]


## 10.1 Log Marginal Distribution Decomposition ($\star$)

Verify that the log marginal distribution of the observed data $\ln p(\mathbf{X})$ can be decomposed into two terms in the form (10.2) where $\mathcal{L}(q)$ is given by (10.3) and $\text{KL}(q || p)$ is given by (10.4).

## 10.2 Factorized Variational Means Solution ($\star$)

Use the properties $\mathbb{E}[z_1] = m_1$ and $\mathbb{E}[z_2] = m_2$ to solve the simultaneous equations (10.13) and (10.15), and hence show that, provided the original distribution $p(\mathbf{z})$ is nonsingular, the unique solution for the means of the factors in the approximation distribution is given by $\mathbb{E}[z_1] = \mu_1$ and $\mathbb{E}[z_2] = \mu_2$.

## 10.3 Variational Factor Minimization ($\star$)

Consider a factorized variational distribution $q(\mathbf{Z})$ of the form (10.5). By using the technique of Lagrange multipliers, verify that minimization of the Kullback-Leibler divergence $\text{KL}(p || q)$ with respect to one of the factors $q_i(\mathbf{Z}_i)$, keeping all other factors fixed, leads to the solution (10.17).

## 10.4 Gaussian Approximation via KL ($\star$)

Suppose that $p(\mathbf{x})$ is some fixed distribution and that we wish to approximate it using a Gaussian distribution $q(\mathbf{x}) = \mathcal{N}(\mathbf{x}|\boldsymbol{\mu}, \boldsymbol{\Sigma})$. By writing down the form of the KL divergence $\text{KL}(p || q)$ for a Gaussian $q(\mathbf{x})$ and then differentiating, show that
[Page 538]

minimization of $\text{KL}(p || q)$ with respect to $\boldsymbol{\mu}$ and $\boldsymbol{\Sigma}$ leads to the result that $\boldsymbol{\mu}$ is given by the expectation of $\mathbf{x}$ under $p(\mathbf{x})$ and that $\boldsymbol{\Sigma}$ is given by the covariance.

## 10.5 Variational Optimization and EM ($\star$)

Consider a model in which the set of all hidden stochastic variables, denoted collectively by $\mathbf{Z}$, comprises some latent variables $\mathbf{z}$ together with some model parameters $\boldsymbol{\theta}$. Suppose we use a variational distribution that factorizes between latent variables and parameters so that $q(\mathbf{z}, \boldsymbol{\theta}) = q_\mathbf{z}(\mathbf{z})q_{\boldsymbol{\theta}}(\boldsymbol{\theta})$, in which the distribution $q_{\boldsymbol{\theta}}(\boldsymbol{\theta})$ is approximated by a point estimate of the form $q_{\boldsymbol{\theta}}(\boldsymbol{\theta}) = \delta(\boldsymbol{\theta} - \boldsymbol{\theta}_0)$ where $\boldsymbol{\theta}_0$ is a vector of free parameters. Show that variational optimization of this factorized distribution is equivalent to an EM algorithm, in which the E step optimizes $q_\mathbf{z}(\mathbf{z})$, and the M step maximizes the expected complete-data log posterior distribution of $\boldsymbol{\theta}$ with respect to $\boldsymbol{\theta}_0$.

## 10.6 Alpha Divergence to KL ($\star$)

The alpha family of divergences is defined by (10.19). Show that the Kullback-Leibler divergence $\text{KL}(p || q)$ corresponds to $\alpha \to 1$. This can be done by writing $p^\epsilon = \exp(\epsilon \ln p) = 1 + \epsilon \ln p + \mathcal{O}(\epsilon^2)$ and then taking $\epsilon \to 0$. Similarly show that $\text{KL}(q || p)$ corresponds to $\alpha \to -1$.

## 10.7 Variational Factors for Gaussian ($\star$)

Consider the problem of inferring the mean and precision of a univariate Gaussian using a factorized variational approximation, as considered in Section 10.1.3. Show that the factor $q_\mu(\mu)$ is a Gaussian of the form $\mathcal{N}(\mu|\mu_N, \lambda_N^{-1})$ with mean and precision given by (10.26) and (10.27), respectively. Similarly show that the factor $q_\tau(\tau)$ is a gamma distribution of the form $\text{Gam}(\tau|a_N, b_N)$ with parameters given by (10.29) and (10.30).

## 10.8 Asymptotic Variational Precision ($\star$)

Consider the variational posterior distribution for the precision of a univariate Gaussian whose parameters are given by (10.29) and (10.30). By using the standard results for the mean and variance of the gamma distribution given by (B.27) and (B.28), show that if we let $N \to \infty$, this variational posterior distribution has a mean given by the inverse of the maximum likelihood estimator for the variance of the data, and a variance that goes to zero.

## 10.9 Expected Precision in Variational Gaussian ($\star$)

By making use of the standard result $\mathbb{E}[\tau] = a_N/b_N$ for the mean of a gamma distribution, together with (10.26), (10.27), (10.29), and (10.30), derive the result (10.33) for the reciprocal of the expected precision in the factorized variational treatment of a univariate Gaussian.

## 10.10 Model Posterior Decomposition ($\star$)

Derive the decomposition given by (10.34) that is used to find approximate posterior distributions over models using variational inference.

## 10.11 Maximum of Model Lower Bound ($\star$)

By using a Lagrange multiplier to enforce the normalization constraint on the distribution $q(m)$, show that the maximum of the lower bound (10.35) is given by (10.36).

## 10.12 Optimal Variational Latent Distribution ($\star$)

Starting from the joint distribution (10.41), and applying the general result (10.9), show that the optimal variational distribution $q^\star(\mathbf{Z})$ over the latent variables for the Bayesian mixture of Gaussians is given by (10.48) by verifying the steps given in the text.
[Page 539]

## 10.13 Optimal Variational Parameter Distribution ($\star$)

Starting from (10.54), derive the result (10.59) for the optimum variational posterior distribution over $\boldsymbol{\mu}_k$ and $\boldsymbol{\Lambda}_k$ in the Bayesian mixture of Gaussians, and hence verify the expressions for the parameters of this distribution given by (10.60)–(10.63).

## 10.14 Verify Variational Expression ($\star$)

Using the distribution (10.59), verify the result (10.64).

## 10.15 Expected Mixing Coefficients ($\star$)

Using the result (B.17), show that the expected value of the mixing coefficients in the variational mixture of Gaussians is given by (10.69).

## 10.16 First Terms of Lower Bound ($\star$)

Verify the results (10.71) and (10.72) for the first two terms in the lower bound for the variational Gaussian mixture model given by (10.70).

## 10.17 Remaining Terms of Lower Bound ($\star$)

Verify the results (10.73)–(10.77) for the remaining terms in the lower bound for the variational Gaussian mixture model given by (10.70).

## 10.18 Variational Re-estimation via Differentiation ($\star$)

In this exercise, we shall derive the variational re-estimation equations for the Gaussian mixture model by direct differentiation of the lower bound. To do this we assume that the variational distribution has the factorization defined by (10.42) and (10.55) with factors given by (10.48), (10.57), and (10.59). Substitute these into (10.70) and hence obtain the lower bound as a function of the parameters of the variational distribution. Then, by maximizing the bound with respect to these parameters, derive the re-estimation equations for the factors in the variational distribution, and show that these are the same as those obtained in Section 10.2.1.

## 10.19 Predictive Distribution for Mixture ($\star$)

Derive the result (10.81) for the predictive distribution in the variational treatment of the Bayesian mixture of Gaussians model.

## 10.20 Asymptotic Variational Bayes Solution ($\star$)

This exercise explores the variational Bayes solution for the mixture of Gaussians model when the size $N$ of the data set is large and shows that it reduces (as we would expect) to the maximum likelihood solution based on EM derived in Chapter 9. Note that results from Appendix B may be used to help answer this exercise.

First show that the posterior distribution $q^\star(\boldsymbol{\Lambda}_k)$ of the precisions becomes sharply peaked around the maximum likelihood solution. Do the same for the posterior distribution of the means $q^\star(\boldsymbol{\mu}_k|\boldsymbol{\Lambda}_k)$. Next consider the posterior distribution $q^\star(\boldsymbol{\pi})$ for the mixing coefficients and show that this too becomes sharply peaked around the maximum likelihood solution. Similarly, show that the responsibilities become equal to the corresponding maximum likelihood values for large $N$, by making use of the following asymptotic result for the digamma function for large $x$

$$
\psi(x) = \ln x + \mathcal{O}(1/x). \tag{10.241}
$$

Finally, by making use of (10.80), show that for large $N$, the predictive distribution becomes a mixture of Gaussians.

## 10.21 Interchange Symmetries in Mixtures ($\star$)

Show that the number of equivalent parameter settings due to interchange symmetries in a mixture model with $K$ components is $K!$.
[Page 540]

## 10.22 Lower Bound with Mode Mixture ($\star$)

We have seen that each mode of the posterior distribution in a Gaussian mixture model is a member of a family of $K!$ equivalent modes. Suppose that the result of running the variational inference algorithm is an approximate posterior distribution $q$ that is localized in the neighbourhood of one of the modes. We can then approximate the full posterior distribution as a mixture of $K!$ such $q$ distributions, once centred on each mode and having equal mixing coefficients. Show that if we assume negligible overlap between the components of the $q$ mixture, the resulting lower bound differs from that for a single component $q$ distribution through the addition of an extra term $\ln K!$.

## 10.23 Maximizing Lower Bound over Mixing Coefficients ($\star$)

Consider a variational Gaussian mixture model in which there is no prior distribution over mixing coefficients $\{\pi_k\}$. Instead, the mixing coefficients are treated as parameters, whose values are to be found by maximizing the variational lower bound on the log marginal likelihood. Show that maximizing this lower bound with respect to the mixing coefficients, using a Lagrange multiplier to enforce the constraint that the mixing coefficients sum to one, leads to the re-estimation result (10.83). Note that there is no need to consider all of the terms in the lower bound but only the dependence of the bound on the $\{\pi_k\}$.

## 10.24 Singularities in MAP Estimation ($\star$)

We have seen in Section 10.2 that the singularities arising in the maximum likelihood treatment of Gaussian mixture models do not arise in a Bayesian treatment. Discuss whether such singularities would arise if the Bayesian model were solved using maximum posterior (MAP) estimation.

## 10.25 Variational Evidence Approximation Bias ($\star$)

The variational treatment of the Bayesian mixture of Gaussians, discussed in Section 10.2, made use of a factorized approximation (10.5) to the posterior distribution. As we saw in Figure 10.2, the factorized assumption causes the variance of the posterior distribution to be under-estimated for certain directions in parameter space. Discuss qualitatively the effect this will have on the variational approximation to the model evidence, and how this effect will vary with the number of components in the mixture. Hence explain whether the variational Gaussian mixture will tend to under-estimate or over-estimate the optimal number of components.

## 10.26 Variational Bayesian Linear Regression Extension ($\star$)

Extend the variational treatment of Bayesian linear regression to include a gamma hyperprior $\text{Gam}(\beta|c_0, d_0)$ over $\beta$ and solve variationally, by assuming a factorized variational distribution of the form $q(\mathbf{w})q(\alpha)q(\beta)$. Derive the variational update equations for the three factors in the variational distribution and also obtain an expression for the lower bound and for the predictive distribution.

## 10.27 Lower Bound for Basis Function Regression ($\star$)

By making use of the formulae given in Appendix B show that the variational lower bound for the linear basis function regression model, defined by (10.107), can be written in the form (10.107) with the various terms defined by (10.108)–(10.112).

## 10.28 Exponential Family Variational Formulation ($\star$)

Rewrite the model for the Bayesian mixture of Gaussians, introduced in Section 10.2, as a conjugate model from the exponential family, as discussed in Section 10.4. Hence use the general results (10.115) and (10.119) to derive the specific results (10.48), (10.57), and (10.59).
[Page 541]

## 10.29 Dual Function for Logarithm ($\star$)

Show that the function $f(x) = \ln(x)$ is concave for $0 < x < \infty$ by computing its second derivative. Determine the form of the dual function $g(\lambda)$ defined by (10.133), and verify that minimization of $\lambda x - g(\lambda)$ with respect to $\lambda$ according to (10.132) indeed recovers the function $\ln(x)$.

## 10.30 Variational Bound for Log Logistic ($\star$)

By evaluating the second derivative, show that the log logistic function $f(x) = -\ln(1 + e^{-x})$ is concave. Derive the variational upper bound (10.137) directly by making a second order Taylor expansion of the log logistic function around a point $x = \xi$.

## 10.31 Logistic Sigmoid Lower Bound ($\star$)

By finding the second derivative with respect to $x$, show that the function $f(x) = -\ln(e^{x/2} + e^{-x/2})$ is a concave function of $x$. Now consider the second derivatives with respect to the variable $x^2$ and hence show that it is a convex function of $x^2$. Plot graphs of $f(x)$ against $x$ and against $x^2$. Derive the lower bound (10.144) on the logistic sigmoid function directly by making a first order Taylor series expansion of the function $f(x)$ in the variable $x^2$ centred on the value $\xi^2$.

## 10.32 Sequential Variational Logistic Regression ($\star$)

Consider the variational treatment of logistic regression with sequential learning in which data points are arriving one at a time and each must be processed and discarded before the next data point arrives. Show that a Gaussian approximation to the posterior distribution can be maintained through the use of the lower bound (10.151), in which the distribution is initialized using the prior, and as each data point is absorbed its corresponding variational parameter $\xi_n$ is optimized.

## 10.33 Update Equation for Variational Parameter ($\star$)

By differentiating the quantity $Q(\boldsymbol{\xi}, \boldsymbol{\xi}^{\text{old}})$ defined by (10.161) with respect to the variational parameter $\xi_n$ show that the update equation for $\xi_n$ for the Bayesian logistic regression model is given by (10.163).

## 10.34 Re-estimation by Direct Maximization ($\star$)

In this exercise we derive re-estimation equations for the variational parameters $\boldsymbol{\xi}$ in the Bayesian logistic regression model of Section 4.5 by direct maximization of the lower bound given by (10.164). To do this set the derivative of $\mathcal{L}(\boldsymbol{\xi})$ with respect to $\xi_n$ equal to zero, making use of the result (3.117) for the derivative of the log of a determinant, together with the expressions (10.157) and (10.158) which define the mean and covariance of the variational posterior distribution $q(\mathbf{w})$.

## 10.35 Derive Variational Logistic Lower Bound ($\star$)

Derive the result (10.164) for the lower bound $\mathcal{L}(\boldsymbol{\xi})$ in the variational logistic regression model. This is most easily done by substituting the expressions for the Gaussian prior $q(\mathbf{w}) = \mathcal{N}(\mathbf{w}|\mathbf{m}_0, \mathbf{S}_0)$, together with the lower bound $h(\mathbf{w}, \boldsymbol{\xi})$ on the likelihood function, into the integral (10.159) which defines $\mathcal{L}(\boldsymbol{\xi})$. Next gather together the terms which depend on $\mathbf{w}$ in the exponential and complete the square to give a Gaussian integral, which can then be evaluated by invoking the standard result for the normalization coefficient of a multivariate Gaussian. Finally take the logarithm to obtain (10.164).

## 10.36 Model Evidence in ADF Approximation ($\star$)

Consider the ADF approximation scheme discussed in Section 10.7, and show that inclusion of the factor $f_j(\boldsymbol{\theta})$ leads to an update of the model evidence of the form

$$
p_j(\mathcal{D}) \simeq p_{j-1}(\mathcal{D})Z_j \tag{10.242}
$$
[Page 542]

where $Z_j$ is the normalization constant defined by (10.197). By applying this result recursively, and initializing with $p_0(\mathcal{D}) = 1$, derive the result

$$
p(\mathcal{D}) \simeq \prod_j Z_j. \tag{10.243}
$$

## 10.37 Exact Prior Incorporation in EP ($\star$)

Consider the expectation propagation algorithm from Section 10.7, and suppose that one of the factors $f_0(\boldsymbol{\theta})$ in the definition (10.188) has the same exponential family functional form as the approximating distribution $q(\boldsymbol{\theta})$. Show that if the factor $\widetilde{f}_0(\boldsymbol{\theta})$ is initialized to be $f_0(\boldsymbol{\theta})$, then an EP update to refine $\widetilde{f}_0(\boldsymbol{\theta})$ leaves $\widetilde{f}_0(\boldsymbol{\theta})$ unchanged. This situation typically arises when one of the factors is the prior $p(\boldsymbol{\theta})$, and so we see that the prior factor can be incorporated once exactly and does not need to be refined.

## 10.38 EP Algorithm for Clutter Problem ($\star$)

In this exercise and the next, we shall verify the results (10.214)–(10.224) for the expectation propagation algorithm applied to the clutter problem. Begin by using the division formula (10.205) to derive the expressions (10.214) and (10.215) by completing the square inside the exponential to identify the mean and variance.

Also, show that the normalization constant $Z_n$, defined by (10.206), is given for the clutter problem by (10.216). This can be done by making use of the general result (2.115).

## 10.39 Mean and Variance for Clutter EP ($\star$)

Show that the mean and variance of $q^{\text{new}}(\boldsymbol{\theta})$ for EP applied to the clutter problem are given by (10.217) and (10.218). To do this, first prove the following results for the expectations of $\boldsymbol{\theta}$ and $\boldsymbol{\theta}\boldsymbol{\theta}^{\text{T}}$ under $q^{\text{new}}(\boldsymbol{\theta})$

$$
\mathbb{E}[\boldsymbol{\theta}] = \mathbf{m}^{\setminus n} + v^{\setminus n}\nabla_{\mathbf{m}^{\setminus n}} \ln Z_n \tag{10.244}
$$

$$
\mathbb{E}[\boldsymbol{\theta}^{\text{T}}\boldsymbol{\theta}] = 2(v^{\setminus n})^2 \nabla_{v^{\setminus n}} \ln Z_n + 2\mathbb{E}[\boldsymbol{\theta}]^{\text{T}}\mathbf{m}^{\setminus n} - \Vert \mathbf{m}^{\setminus n} \Vert^2 \tag{10.245}
$$

and then make use of the result (10.216) for $Z_n$. Next, prove the results (10.220)–(10.222) by using (10.207) and completing the square in the exponential. Finally, use (10.208) to derive the result (10.223).