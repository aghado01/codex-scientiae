![The posterior distributions of knots in three scenarios by EBARS](images/HYK2024/imageFile2.png)

**Figure 2**: The posterior distributions of knots in three scenarios by EBARS. Left channels are the histograms of the knot number, where red dashed vertical lines indicate the mean number. Right channels are the posterior density plots of the knot location.

### Table 2: Absolute errors for knot location estimation of three methods in $k = 4$

| Methods | $m$ | Knot 1 | Knot 2 | Knot 3 | Knot 4 |
| :--- | :---: | :---: | :---: | :---: | :---: |
| EBARS | 200 | $0.0058 (0.0060)$ | $0.0044 (0.0043)$ | $0.0206 (0.0199)$ | $0.0170 (0.0096)$ |
| MML | 200 | $0.3437 (1.1010)$ | $0.1163 (0.1283)$ | $0.0978 (0.1006)$ | $0.1012 (0.1454)$ |
| Segmented | 200 | $0.0366 (0.0494)$ | $0.0712 (0.1067)$ | $0.0799 (0.0889)$ | $0.0752 (0.0805)$ |
| EBARS | 500 | $0.0025 (0.0029)$ | $0.0026 (0.0025)$ | $0.0194 (0.0172)$ | $0.0150 (0.0137)$ |
| MML | 500 | $0.2737 (0.4266)$ | $0.1725 (0.1683)$ | $0.1065 (0.1800)$ | $0.2131 (0.5211)$ |
| Segmented | 500 | $0.0171 (0.0346)$ | $0.0283 (0.0775)$ | $0.0395 (0.0825)$ | $0.0349 (0.0805)$ |

### 4.2 Manifold denoising

With the assumption of linearity, principal component analysis is a prevailing and efficient method for dimension reduction in high-dimensional space. However, the simple method poses a limitation to respect the nonlinear relationship. Manifold estimation is a technique for modelling the complicated dependence in high-dimensional data, denoising the observations and estimating the low-dimensional latent manifold. Refer to Yao et al. [2024] for a detailed review about manifold estimation.

Assume that the observed data $\{x_i\}_{i=1}^m$ is generated from a low-dimensional latent manifold of a high-dimensional ambient space with random noise. That is,

$$
X = W + \epsilon, \quad X, \epsilon \in \mathbb{R}^D, \ W \in \mathbb{M}^d
$$

where $\mathbb{M}^d$ is a $d$-dimensional submanifold of $\mathbb{R}^D$ with $d \leq D$, $W$ is generated from a probability distribution supported in $\mathbb{M}^d$, and $\epsilon$ is $D$-dimensional noise independent of $W$. In this article, we propose a two stage manifold estimation (TSME) technique for modelling $\mathbb{M}^d$. The primary challenge of parametrization is attributed to the lack of the required pairs of training data, *i.e.*, (predictor, response). We resolve the issue simply by combining the manifold embedding and reconstruction. The manifold embedding is a nonlinear dimensional reduction method. Many impressive algorithms
