[Page 34]

Using the Cauchy–Schwarz inequality we get that

$$
R^*_{n,m,1}(t, \varsigma) \leq \left\{\mathbb{E}\, b_t^2(Z, X) Z_m^2\right\}^{\frac{1}{2}} \pi_\mathbb{P}(t, \theta) \,.
$$

Using again the Cauchy–Schwarz inequality we obtain that $\mathbb{E}\, b_t^2(Z, X) Z_m^2 \leq \pi_\mathbb{P}(t, \theta)\left\{\mathbb{E}\, b_t^2(Z, X) Z_m^4\right\}^{\frac{1}{2}}$, which together with (A.23) and the fact that $(a+b)^2 \leq 2(a^2+b^2)$ leads to

$$
\begin{aligned}
R^*_{n,m,1}(t, \varsigma) &\leq \left\{\mathbb{E}\, b_t^2(Z, X) Z_m^4\right\}^{\frac{1}{4}} \pi_\mathbb{P}^{\frac{3}{2}}(t, \theta) \\
&\leq 2^{\frac{1}{4}} \left\{\mathbb{E} Z_m^4\!\left((1 + \|Z\|^2)\|\mathbf{d}-\tau\|^2 + p^2 \max_{1 \leq j \leq p}\|g_j - \eta_j\|_\infty^2\right)\right\}^{\frac{1}{4}} \pi_\mathbb{P}^{\frac{3}{2}}(t, \theta) \,.
\end{aligned}
$$

That is, $R_{n,m,1}(\hat{\theta}, \hat{\sigma}) \leq 2^{1/4}\left\{\max(\mathbb{E} Z_m^4\|Z\|^2,\, p^2 \mathbb{E} Z_m^4)\right\}^{1/4}\!\left\{\|\hat{\tau}-\tau\|^2 + \max_{1 \leq j \leq p}\|\hat{\eta}_j - \eta_j\|_\infty^2\right\}^{1/4} \pi_\mathbb{P}^{3/2}(\hat{\theta}, \theta)$. Therefore, if N2(a) holds, $r_j > 1$ for all $1 \leq j \leq p$, which implies that $\nu < 1/3$, so using that $\pi_\mathbb{P}(\hat{\theta}, \theta) = O_\mathbb{P}(n^{-(1-\nu)/2+\omega})$ and $0 < \omega < (1-3\nu)/6$, we easily obtain that $n^{\frac{1}{2}}\pi_\mathbb{P}^{\frac{3}{2}}(\hat{\theta}, \theta) = o_\mathbb{P}(1)$, which allows to conclude that $R_{n,m,1}(\hat{\theta}, \hat{\sigma}) = o_\mathbb{P}(n^{-1/2})$.

Assume now that N2(b) holds. Note that in this case $\nu = 1/3$. Using again the Cauchy–Schwarz inequality, we get the bound $\mathbb{E}\, b_t^2(Z, X) Z_m^4 \leq \pi_\mathbb{P}(t, \theta)\left\{\mathbb{E}\, b_t^2(Z, X) Z_m^8\right\}^{1/2}$, which leads to

$$
\begin{aligned}
R^*_{n,m,1}(t, \varsigma) &\leq \left\{\mathbb{E}\, b_t^2(Z, X) Z_m^4\right\}^{\frac{1}{4}} \pi_\mathbb{P}^{\frac{3}{2}}(t, \theta) \leq \left\{\mathbb{E}\, b_t^2(Z, X) Z_m^8\right\}^{\frac{1}{8}} \pi_\mathbb{P}^{\frac{7}{4}}(t, \theta) \\
&\leq 2^{\frac{1}{8}}\left\{\max(\mathbb{E} Z_m^8\|Z\|^2,\, p^2 \mathbb{E} Z_m^8)\right\}^{\frac{1}{8}}\!\left\{\|\mathbf{d}-\tau\|^2 + \|g_j - \eta_j\|_\infty^2\right\}^{\frac{1}{8}} \pi_\mathbb{P}^{\frac{7}{4}}(t, \theta) \,.
\end{aligned}
$$

Hence, using that $\pi_\mathbb{P}(\hat{\theta}, \theta) = O_\mathbb{P}(n^{-1/3+\omega})$ and $\omega < 1/21$, we get $n^{\frac{1}{2}}\pi_\mathbb{P}^{\frac{7}{4}}(\hat{\theta}, \theta) = o_\mathbb{P}(1)$, which leads to $R^*_{n,m,1}(\hat{\theta}, \hat{\sigma}) = o_\mathbb{P}(n^{-1/2})$, as desired.

Finally, to conclude the proof we use the independence between the errors and the covariates, which implies that $B_{\theta,\sigma} = -(1/\sigma^2)\mathbb{E}[\psi'(\varepsilon)]\,A$ and $D_{\theta,\sigma} = \mathbb{E}[W_{\theta,\sigma} W_{\theta,\sigma}^t] = (1/\sigma^2)\mathbb{E}[\psi^2(\varepsilon)]\,A$, where $A = \mathbb{E}[(Z-h^*(X))(Z-h^*(X))^t]$. Therefore, the asymptotic covariance matrix is given by $B_{\theta,\sigma}^{-1} D_{\theta,\sigma} (B_{\theta,\sigma}^{-1})^t = \sigma^2 \mathbb{E}[\psi^2(\varepsilon)]\{\mathbb{E}[\psi'(\varepsilon)]\}^{-2} A^{-1} = \Sigma(\theta,\sigma)$, concluding the proof. $\blacksquare$

# References

Bianco, A., Boente, G., 2004. Robust estimators in semiparametric partly linear regression models. J. Stat. Plan. Inference 122, 229–252.

Boente, G., Fraiman, R., 1989. Robust nonparametric regression estimation. J. Multivar. Anal. 29, 180–198.

Boente, G., Rodriguez, D., Vena, P., 2020a. Robust estimators in a generalized partly linear regression model under monotony constraints. Test 29, 50–89.

Boente, G., Salibián-Barrera, M., Vena, P., 2020b. Robust estimation for semi-functional linear regression models. Comput. Stat. Data Anal. 152.

Camlong-Viot, C., Rodríguez-Póo, J.M., Vieu, P., 2006. Nonparametric and semiparametric estimation of additive models with both discrete and continuous variables under dependence. In: Sperlich, S., Härdle, W., Aydinli, G. (Eds.), The Art of Semiparametrics. In: Contributions to Statistics. Physica-Verlag HD.

Fan, J., Härdle, W., Mammen, E., 1998. Direct estimation of low dimensional components in additive models. Ann. Stat. 26, 943–971.

Fan, Y., Li, Q., 2003. A kernel-based method for estimating additive partially linear models. Stat. Sin. 13, 739–762.

Guo, J., Tang, M., Tian, M., Zhu, K., 2013. Variable selection in high-dimensional partially linear additive models for composite quantile regression. Comput. Stat. Data Anal. 65, 56–67.

Härdle, W., Liang, H., Gao, J., 2000. Partially Linear Models. Springer-Verlag.

Härdle, W., Müller, M., Sperlich, S., Werwatz, A., 2004. Nonparametric y Semiparametric Models. Springer-Verlag.

Harrison, D., Rubinfeld, D.L., 1978. Hedonic housing prices and the demand for clean air. J. Environ. Econ. Manag. 5, 81–102.

He, X., Shi, P., 1996. Bivariate tensor-product B-spline in a partly linear model. J. Multivar. Anal. 58, 162–181.

He, X., Zhu, Z.Y., Fung, W.K., 2002. Estimation in a semiparametric model for longitudinal data with unspecified dependence structure. Biometrika 89, 579–590.

Huang, J., Horowitz, J.L., Wei, F., 2010. Variable selection in nonparametric additive models. Ann. Stat. 38, 2282–2313.

Koenker, R., 2011. Additive models for quantile regression: model selection and confidence bands. Braz. J. Probab. Stat. 25, 239–262.

Li, Q., 2000. Efficient estimation of additive partially linear models. Int. Econ. Rev. 41, 1073–1092.

Lian, H., 2012. Variable selection in high-dimensional partly linear additive models. J. Nonparametr. Stat. 24, 825–839.

Liang, H., Thurston, S., Ruppert, D., Apanasovich, T., Hauser, R., 2008. Additive partial linear models with measurement errors. Biometrika 95, 667–678.

Liu, X., Wang, L., Wang, H., 2011. Estimation and variable selection for semiparametric additive partial linear models. Stat. Sin. 21, 1225–1248.

Liu, H., Yang, H., Xia, X., 2017. Robust estimation and variable selection in censored partially linear additive models. J. Korean Stat. Soc. 46, 88–103.

Ma, S., 2012. Two-step spline estimating equations for generalized additive partially linear models with large cluster sizes. Ann. Stat. 40, 2943–2972.
