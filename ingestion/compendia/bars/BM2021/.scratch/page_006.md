[Page 6]

where $k = (k_1, \ldots, k_p)^t$, $r_i = Y_i - \hat{m}(Z_i, X_i)$ are the residuals obtained using a basis of dimension $k_j$ to compute the estimator of $\eta_j$, $\rho_1$ is the same $\rho$-function used to compute the M-estimator and $\tilde{\sigma}$ is the preliminary S-estimator. It is worth noting that when $\rho(t) = t^2$ and $p = 1$, the proposed generalized criterion reduces to the one considered in He et al. (2002). Note that, when the same number $k$ of elements of the basis is used for each additive component, the RBIC criterion reduces to

$$
\mathrm{RBIC}(k) = \log\!\left(\hat{\sigma}^2 \sum_{i=1}^{n} \rho_1\!\left(\frac{r_i}{\tilde{\sigma}}\right)\right) + \frac{p\log(n)}{2n} k.
\tag{9}
$$

When considering spline-based estimation procedures, the number of knots increases slowly with the sample size to guarantee an optimal rate of convergence. When all the additive components $\eta_j$ are twice continuously differentiable with second derivative Lipschitz of order 1 and cubic splines are considered for each component, that is, $\ell_j = 4$ for $j = 1, \ldots, p$, Theorem 3.3 and assumption C4 below show that the rate for the bases dimension is almost $n^{1/5}$ (see also Remark 3.2). Taking into account that for cubic splines the smallest possible number of knots is 4, as in He et al. (2002), a possible way to choose $k_j$ is to search for the first (i.e. smallest $k_j$) local minimum of $\mathrm{RBIC}(k)$ in (8) within the range of $\max(n^{1/5}/2, 4) \leq k_j \leq 8 + 2n^{1/5}$. The numerical complexity is reduced if, as in our simulation study, the size of the basis is the same for all $j$, in which case, one looks for the first local minimum of $\mathrm{RBIC}(k)$ defined through (9), when $k \in \mathbb{N}$ varies in $[\max(n^{1/5}/2, 4), 8 + 2n^{1/5}]$.

### 2.4. Regarding Some Other Basis Choices

The MM-estimators defined above are based on B-splines which provides a flexible basis, often accurate and computational convenient. Another advantage of B-splines basis is that they allow for uniform approximations of the additive components. Indeed, as mentioned in Stone (1985), B-splines basis functions can be used to effectively approximate sufficiently smooth functions. To be more precise, if the function $\eta_j$ is continuously differentiable of order $r_j$ with Lipschitz $r_j$-derivative (see assumption C3 below), according to Corollary 6.21 in Schumaker (1981) there exists a spline of order $\ell_j$, $\tilde{\eta}_j(x) = \sum_{s=1}^{k_j} \lambda_s^{(j)} \tilde{B}_s^{(j)}(x)$ such that

$$
\|\tilde{\eta}_j - \eta_j\|_\infty = O\!\left(k_j^{-r_j}\right).
\tag{10}
$$

Approximation (10) is a key point when deriving uniform consistency results for the MM-estimators of $\eta_j$ in Theorem 3.2. Clearly, other bases may be used in Step 1 instead of B-splines to generate $k_j$-finite dimensional candidates. However to obtain analogous results to those provided in Theorem 3.2, uniform approximations are needed. In this direction, the papers by Newey (1997) and Li (2000) give general results for series function estimators by requiring that the nonparametric function may be approximated at a given rate.

Among others, Bernstein polynomials are a possible alternative to B-splines. Recall that Bernstein polynomials of order $k_j$ are defined taking in Step 1

$$
\tilde{B}_s^{(j)}(x) = \binom{k_j}{s} x^s (1-x)^{k_j - s}, \quad s = 0, \dots, k_j.
$$

In particular, Theorem 3.2 in Powell (1981) ensures that Bernstein polynomials of order $k_j$ provide uniform approximations as those given in (10). It is worth mentioning that, as B-splines, Bernstein polynomials are such that $\sum_{s=0}^{k_j} B_s^{(j)}(x) = 1$ for all $x \in I_j$. Hence, after the centered basis $\tilde{B}_s^{(j)}(x) = B_s^{(j)}(x) - \int_{I_j} B_s^{(j)}(x)\,dx$, $s = 0, \ldots, k_j$, is obtained in Step 1, the elements of the basis are still linearly dependent. For that reason, in Step 1(d), $V^{(j)}(t)$ should be defined omitting the term corresponding to $s = 0$, that is, $V^{(j)}(t) = (\tilde{B}_1^{(j)}(t), \ldots, \tilde{B}_{k_j}^{(j)}(t))^t$. Therefore, the effective dimension of the linear space used to approximate the nonparametric additive components equals $K = \sum_{j=1}^{p} k_j$.

Legendre polynomials are a well known orthogonal basis, extensively employed in approximation theory. The convergence rates obtained in Wang and Xiang (2012) may be used to derive uniform consistency results of the considered MM-estimators. However, it should be taken into account that in this case, the approximation rate in (10) is $O(k_j^{-r_j + 1/2})$ instead of $O(k_j^{-r_j})$, modifying the dimension basis requirements stated in Section 3 as well as the convergence rates assumed in assumption N2 to derive asymptotic normality results. Legendre polynomials and the Fourier basis to be discussed below, automatically fulfill the condition $\int_{I_j} \tilde{B}_s^{(j)}(x)\,dx = 0$, for $s \geq 2$, since they are orthogonal bases with first element $\tilde{B}_1^{(j)} \equiv 1$. Thus, we can take $B_s^{(j)} = \tilde{B}_{s+1}^{(j)}$, for $s = 1, \ldots, k_j - 1$, in Step 1(c) and (d). In this situation the effective dimension is the same as for B-splines.

One drawback of Fourier basis is that, even to obtain pointwise approximations, additional assumptions such as the Dini–Lipschitz condition are needed for periodic functions. As mentioned in Newey (1997), this basis is usually not considered in most econometric applications.
