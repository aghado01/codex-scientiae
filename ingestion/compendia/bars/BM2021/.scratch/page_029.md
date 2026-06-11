[Page 29]

Furthermore, for $\mathbf{h} = (h_1, \ldots, h_q)^t$, we denote

$$
V_{t,\varsigma}^{(j)}[\mathbf{h}] = \left(V_{t,\varsigma}^{(j)}[h_1], \ldots, V_{t,\varsigma}^{(j)}[h_q]\right)^t \,.
$$

Using that $L_n(\hat{\mu}, \hat{\beta}, \hat{\eta}_1, \ldots, \hat{\eta}_p, \hat{\sigma}) \leq L_n(\hat{\mu}, \hat{\beta}, \hat{\eta}_1, \ldots, \hat{\eta}_{j-1}, \hat{\eta}_j + s g_j, \hat{\eta}_{j+1}, \ldots \hat{\eta}_p, \hat{\sigma})$, for any $s \in \mathbb{R}$ and $g_j \in \mathcal{S}_j$, we obtain that, for $1 \leq j \leq p$,

$$
P_n V_{\hat{\theta},\hat{\sigma}}^{(j)}[g_j] = 0 \,, \quad \text{for any } g_j \in \mathcal{S}_j \,. \tag{A.13}
$$

Furthermore, the independence between the errors and covariates and the fact that $\mathbb{E}\psi(a\varepsilon) = 0$, for any $a > 0$, guarantees that

$$
P V_{\theta,\sigma}^{(j)}[h] = 0 \,, \quad \text{for any } h \in \mathcal{G}_0 \,. \tag{A.12}
$$

Define for any $t = (a, b^t, g_1, \ldots, g_p)^t$ and $\varsigma > 0$ the function

$$
W_{t,\varsigma}(y, z, x) = -\frac{1}{\varsigma}\psi\!\left(\frac{y - a - b^t z - \sum_{j=1}^{p} g_j(x_j)}{\varsigma}\right)\!\left(z - h^*(x)\right),
$$

where $h^*$ is defined in (13). Note that, under assumption N3, we have that $(W_{t,\sigma})_m = (V_{t,\sigma}^{(0)})_m - \sum_{j=1}^{p} V_{t,\sigma}^{(j)}[h^*_{mj}]$, for $1 \leq m \leq q$, meaning that

$$
W_{t,\sigma} = V_{t,\sigma}^{(0)} - \sum_{j=1}^{p} V_{t,\sigma}^{(j)}[\mathbf{h}^*_j] \,,
$$

where $\mathbf{h}^*_j = (h^*_{1j}, \ldots, h^*_{qj})^t$. From now on, $V$ will refer to a neighborhood of $\sigma$, which we assume to be a subset of $[\sigma/2, 3\sigma/2]$.

Let $\varepsilon_0 > 0$ be a fixed value, for instance $\varepsilon_0 = 1$ or the value stated in assumption C8 when it holds. Denote $\mathbf{d} = (a, b^t)^t$, $\tau = (\mu, \beta^t)^t$ and $\tilde{z} = (1, z^t)^t$. Let $\theta_{c_{0,1},\ldots,c_{0,p}} = (\mu, \beta^t, g_{1,c_{0,1}}, \ldots, g_{p,c_{0,p}})^t$, $t_{c_1,\ldots,c_p} = (a, b^t, g_{1,c_1}, \ldots, g_{p,c_p})^t$ for $c_s \in \mathbb{R}^{k_s - 1}$, $1 \leq s \leq p$, and $C_0 = (c_{0,1}^t, \ldots, c_{0,p}^t)^t$. The following classes of functions will be needed in the proof of Theorem 4.1:

$$
\begin{aligned}
\mathcal{E}_{n,m,h,\delta,C}^{(j)} &= \left\{f = V_{t_{c_1,\ldots,c_p},\varsigma}^{(j)}[h^*_{mj} - h] : \pi(t_{c_1,\ldots,c_p}, \theta_{c_{0,1},\ldots,c_{0,p}}) < \varepsilon_0,\; \varsigma \in V,\; c_\ell \in \mathbb{R}^{k_\ell - 1},\; 1 \leq \ell \leq p\right\}, \\
\mathcal{F}_{n,m,\delta,C}^{(j)} &= \left\{f = V_{t_{c_1,\ldots,c_p},\varsigma}^{(j)}[h^*_{mj}] - V_{\theta,\sigma}^{(j)}[h^*_{mj}] : \pi(t_{c_1,\ldots,c_p}, \theta_{c_{0,1},\ldots,c_{0,p}}) < \varepsilon_0,\; \varsigma \in V,\; c_\ell \in \mathbb{R}^{k_\ell - 1},\; 1 \leq \ell \leq p\right\}, \\
\mathcal{G}_{n,j,\delta,C} &= \left\{f = V_{t_{c_1,\ldots,c_p},\sigma}^{(0)} - V_{\theta,\sigma}^{(0)} : \pi(t_{c_1,\ldots,c_p}, \theta_{c_{0,1},\ldots,c_{0,p}}) < \varepsilon_0,\; \varsigma \in V,\; c_\ell \in \mathbb{R}^{k_\ell - 1},\; 1 \leq \ell \leq p,\; \pi < \delta\right\}.
\end{aligned}
$$

Note that the family of functions $\mathcal{E}_{n,m,h,\delta,C_0}^{(j)}$ depends on $\delta$ through the function $h \in \mathcal{S}_j$, which is fixed and such that $\|h^*_{mj} - h\|_\infty < \delta$.

To simplify the notation, from now on, we denote $\mathbf{d} = (a, b^t)^t$, $\tau = (\mu, \beta^t)^t$ and $\tilde{z} = (1, z^t)^t$. Note that

$$
V_{t_{c_1,\ldots,c_p},\varsigma}^{(j)}[h^*_{mj} - h](y,z,x) = \frac{1}{\varsigma}\psi\!\left(\frac{y - \mathbf{d}^t\tilde{z} - \sum_{j=1}^{p} g_{j,c_j}(x_j)}{\varsigma}\right)\!\left\{h(x_j) - h^*_{mj}(x_j)\right\},
$$

$$
\left(V_{t_{c_1,\ldots,c_p},\varsigma}^{(j)}[h^*_{mj}] - V_{\theta,\sigma}^{(j)}[h^*_{mj}]\right)(y,z,x) = \left\{\frac{1}{\sigma}\psi\!\left(\frac{y - \tau^t\tilde{z} - \sum_{\ell=1}^{p}\eta_\ell(x_\ell)}{\sigma}\right) - \frac{1}{\varsigma}\psi\!\left(\frac{y - \mathbf{d}^t\tilde{z} - \sum_{\ell=1}^{p} g_{\ell,c_\ell}(x_\ell)}{\varsigma}\right)\right\} h^*_{mj}(x_j),
$$

while

$$
\left(V_{j,t_{c_1,\ldots,c_p},\sigma}^{(0)} - V_{j,\theta,\sigma}^{(0)}\right)(y,z,x) = \frac{1}{\sigma}\left\{\psi\!\left(\frac{y - \tau^t\tilde{z} - \sum_{j=1}^{p}\eta_j(x_j)}{\sigma}\right) - \psi\!\left(\frac{y - \mathbf{d}^t\tilde{z} - \sum_{j=1}^{p} g_{j,c}(x_j)}{\sigma}\right)\right\} z_j \,.
$$
