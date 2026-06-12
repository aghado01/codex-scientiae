## Appendix A: Proofs

### Proof of Lemma 1

The marginal likelihood $p(y|k,\xi)$ is given by

$$
p(y|k,\xi) = p(y|Z) = \int_{(0,\infty)} \int_{\mathbb{R}^\nu} p(y|Z,\beta,\sigma) \pi(\beta|Z,\sigma)\pi(\sigma) d\beta d\sigma
$$

According to the specified priors, we have

$$
\begin{aligned}
p(y|Z,\beta,\sigma) &= \frac{1}{(2\pi\sigma^2)^{m/2}}\exp\left\{-\frac{1}{2\sigma^2}(y-Z\beta)^\top(y-Z\beta)\right\}, \\
\pi(\beta|Z,\sigma) &= \frac{1}{(2\pi m \sigma^2)^{\nu/2}}|Z^\top Z|^{1/2}\exp \left\{ -\frac{1}{2m\sigma^2} \beta^\top Z^\top Z\beta \right\}
\end{aligned}
$$

Then Fubini's Theorem implies that,

$$
p(y|k,\xi) = \int_0^\infty \frac{1}{(2\pi \sigma^2)^{m/2} (m+1)^{\nu/2} } \exp \left\{-\frac{1}{2\sigma^2} a_{k,\xi}\right\} \pi(\sigma) d\sigma
$$

where $a_{k,\xi}=y^\top \left(I_m-\frac{m}{m+1}Z(Z^\top Z)^{-1}Z^\top\right)y$. With change of variables $w = \sigma / \sqrt{a_{k,\xi}}$, we have $p(y|k,\xi)\propto (m+1)^{-\nu/2}a_{k,\xi}^{-m/2}$. It follows from $\pi(k,\xi)\propto \tau(\mathcal{M}_k)^{-\gamma}$ that $p(k,\xi|y)\propto (m+1)^{-\nu/2}a_{k,\xi}^{-m/2}\tau(\mathcal{M}_k)^{-\gamma}$.

### Proof of Lemma 3

According to (9),

$$
\alpha(k',\xi'|k,\xi) = \min \left\{1,~ \frac{p(k',\xi'|y)q(k,\xi|k',\xi')}{p(k,\xi|y)q(k',\xi'|k,\xi)}\right\}
$$

Notably, $\pi(k,\xi)q(k',\xi'|k,\xi)=\pi(k',\xi')q(k,\xi|k',\xi')$ under the priors and proposals. Then we have $\alpha(k',\xi'|k,\xi) = \min\{1,~ p(y|k',\xi')/p(y|k,\xi)\}$. Thus (6) implies this lemma. For the EBIC approximation, we substitute $\hat{p}$ for the corresponding $p$.

## Appendix B: Additional Simulations

We conduct EBARS in the curve spline regression ($d=1, p=3$) and the surface spline regression ($d=2, p=3$). The performance is compared with BARS of Dimatteo et al. [2001], smoothing splines (SS) of Green and Silverman [1994] and thin plate splines (TPS) of Wood [2003]. We calculate the predictive mean squared errors (MSE) for evaluation. Simulations show that the proposed method contributes to accurate predictions of all scenarios.

### Curve Spline Regression

The curves and data samples involved are illustrated in the first column of Figure 5. It can be seen that data are generated from $4$ different smoothness functions, denoted as Cases 1.1–1.4 respectively. Cases 1.1 and 1.2 are continuous, whereas Cases 1.3 and 1.4 are discontinuous with one or multiple breakpoints. The outcome noise is Gaussian with standard deviation $2, 2, 4, 1$. We compare the prediction performance with BARS and SS in curve fitting. To demonstrate the effect of $\gamma$ in EBIC, we implement $3$ versions of EBARS with $\gamma=1, 0.5, 0$. All methods are evaluated under sample sizes $m=200, 500$ and the experiment is repeated $50$ times in each setting.

The mean squared errors are summarized in Table 4. To remove the effect of outliers, we drop out points with errors in the top or bottom $2.5\%$ to calculate censored MSE on test data. In EBARS, low $\gamma$ causes the model overfitting problem. It is clear that MSE rises up gradually as $\gamma$ decreases, especially in Case 1.3. The behaviour is visualized in columns 2–4 of Figure 5. This phenomenon is consistent with the theory. According to EBIC, the prior probability of the model space with $k$ knots satisfies $\pi(\mathcal{M}_k)\propto \tau(\mathcal{M}_k)^{1-\gamma}$. As $k \ll n$ in practice, $\tau(\mathcal{M}_k)$ will grow with increasing number
