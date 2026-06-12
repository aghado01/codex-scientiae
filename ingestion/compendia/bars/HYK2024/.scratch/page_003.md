Assume labeled observations $\{(x_i, y_i)\}_{i=1}^m \subset [0, 1]^d \times \mathbb{R}$ are independent and identically distributed, such that for $i = 1, \dots, m$,

$$
y_i = f(x_i) + \epsilon_i, \quad \epsilon_i \sim N(0, \sigma^2), \tag{1}
$$

where $f: [0, 1]^d \to \mathbb{R}$ is an unknown function, and $\sigma^2 > 0$ is the noise variance.

## 2.1 Tensor product spline regression model

The article utilizes tensor product splines to model the real multivariate function $f$. As the name implies, the tensor product spline space is the tensor product of $d$ univariate spline spaces corresponding to each component of $x$. The univariate spline space in $[0, 1]$ of degree $p_i$ and non-decreasing knot sequence $\{\xi_{ij}\}_{j=0}^{k_i+1}$ allowing duplicates $(\xi_{i0} = 0, \xi_{i(k_i+1)} = 1)$ consists of the following univariate functions: (1) Be a polynomial of at most degree $p_i$ on each interval $(\xi_{ij}, \xi_{i(j+1)})$; (2) Belong to $C^{p_i-1}([0, 1])$ except for the coincident knots, and if $\xi_{i(j-1)} < \xi_{ij} = \ldots = \xi_{i(j+l)} < \xi_{i(j+l+1)}$, the function has continuous derivatives up to the order $p_i-1-l$ at that point $(l \leq p_i)$. Specifically, when $l = p_i$, the spline function may discontinue at the coincident knot.

> [!NOTE]
> **Remark 1.** The usual spline-based methods employ equidistant knots or quantile-based knots, posing the distinct knot assumption implicitly. This results in continuous splines. When the true function exists jumping discontinuity, the distinct knot spline will fail to make an accurate estimation. However, the spline with automatic knot selection can circumvent the problem by optimal placement.

Let $p = \{p_i\}_{i=1}^d$, $k = \{k_i\}_{i=1}^d$, and $\xi = \{\xi_i\}_{i=1}^d$ with $\xi_i = \{\xi_{ij}\}_{j=1}^{k_i}$. Denote the tensor product spline space as $\mathcal{S}_{p,k,\xi}$ and the univariate spline space as $\mathcal{S}_{p_i,k_i,\xi_i}$ for $i = 1, \ldots, d$. Then $\mathcal{S}_{p,k,\xi} = \bigotimes_{i=1}^d \mathcal{S}_{p_i,k_i,\xi_i}$, where $\mathcal{S}_{p_i,k_i,\xi_i}$ is a linear space with the dimension of $k_i+p_i+1$. Let $\{b_{ij}\}_{j=1}^{k_i+p_i+1}$ be a basis of $\mathcal{S}_{p_i,k_i,\xi_i}$, such as B-splines. Consequently, the dimension of $\mathcal{S}_{p,k,\xi}$ is $\Pi_{i=1}^d (k_i+p_i+1)$, denoted as $\nu$. And $b = \bigotimes_{i=1}^d \{b_{ij}\}_{j=1}^{k_i+p_i+1}$ is a basis of $\mathcal{S}_{p,k,\xi}$. For simplicity, rewrite $b$ as $\{b_i\}_{i=1}^\nu$. Thus, any $f \in \mathcal{S}_{p,k,\xi}$ can be represented by $\sum_{i=1}^\nu \beta_i b_i$. Let $\beta = (\beta_1, \ldots, \beta_\nu)^\top$. Define the design matrix $Z$ by $Z_{ij} = b_j(x_i)$ for $i = 1, \ldots, m$ and $j = 1, \ldots, \nu$. Therefore, (1) can be reformulated as

$$
y = Z\beta + \epsilon, \quad \epsilon \sim N_m(0, \sigma^2 I_m) \tag{2}
$$

where $y,\epsilon \in \mathbb{R}^m$, $\beta \in \mathbb{R}^\nu$, $Z \in \mathbb{R}^{m \times \nu}$. Notably, (2) is an ordinary linear regression model.

## 2.2 Prior & posterior

Genove and Kass [2001] demonstrated that changes on $p$ have little impact on the performance; see Perperoglou et al. [2019]. Cubic splines ($p = 3$) and linear splines ($p = 1$) are the most common alternatives in the research. We will explore the two splines in the simulations. Given the degree, the number and position of knots determine basis functions of the spline space, affecting the non-linearity in the model.

We specify the priors of $k,\xi,\beta,\sigma$ in (2) as follows. Firstly, we initialize enormous candidate knots. Owing to the specific structure of tensor product splines, the candidate knots can be chosen in each component separately. Let $n_i$ nodes $\eta_i \subset [0, 1]$ be the $i$-th component. Then the overall candidate knots are given by $\eta = \bigotimes_{i=1}^d \eta_i$. To simplify the analysis, assume that the knots in $\eta_i$ are distinct. Nevertheless, when $n_i$ is sufficiently large and $\eta_i$ is sufficiently dense in $[0, 1]$, we can still find a spline model to reflect jumping discontinuity well. For $i=1,\ldots,d$, let $\mathcal{M}_{k_i}$ be the model space containing all the possible location combinations with $k_i$ knots in $[0, 1]$. Then the size of $\mathcal{M}_{k_i}$ is $\tau(\mathcal{M}_{k_i}) = \binom{n_i}{k_i}$. Since $k_i \ll n_i$, $\tau(\mathcal{M}_{k_i})$ is increasing as $k_i$ increases. Let $\mathcal{M}_k$ be $\bigotimes_{i=1}^d \mathcal{M}_{k_i}$. Then $\tau(\mathcal{M}_k) = \Pi_{i=1}^d \binom{n_i}{k_i}$. The priors of $k,\xi$ are specified as

$$
\pi(k) \propto \tau(\mathcal{M}_k)^{1-\gamma}, \quad \pi(\xi|k) = \frac{1}{\tau(\mathcal{M}_k)}, \quad 0 \leq \gamma \leq 1 \tag{3}
$$

Consequently, $\pi(k,\xi) \propto \tau(\mathcal{M}_k)^{-\gamma}$. Given $k$, the prior probabilities of different position combinations are equal. The parameter $\gamma$ adjusts the growth rate of $\pi(k)$. It is equivalent to imposing a penalty on $\pi(k)$. As $\gamma$ increases from 0 to 1, the growth rate becomes milder gradually. Particularly, when $\gamma = 0$, we have $\pi(k) \propto \tau(\mathcal{M}_k)$ and $\pi(k,\xi) \propto 1$, meaning the same prior probability for knots. Sometimes this $\gamma$ causes that excessive knots are selected.
