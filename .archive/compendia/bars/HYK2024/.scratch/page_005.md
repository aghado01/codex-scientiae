In this section we use RJMCMC to obtain samples of $k,\xi$ from the posterior distribution (6) or (8). Due to the tensor product structure, the sampling procedure can be performed in the component individually. Suppose $x_i$ is the current update component. When modifying $x_i$, other components are invariant. We design three transition strategies to traverse the state space: (1) Birth: add a knot with the probability $b_{k_i} = c \min(1, \{(n_i-k_i)/(k_i+1)\}^{1-\gamma})$; (2) Death: delete a knot with the probability $d_{k_i} = c \min(1, \{k_i/(n_i-k_i+1)\}^{1-\gamma})$; (3) Relocation: change the position of one knot with the probability $r_{k_i} = 1 - b_{k_i} - d_{k_i}$. The hyper-parameter $c$ is of the interval $(0, 0.5)$. Notably, $\pi(k_i)b_{k_i} = \pi(k_i+1)d_{k_i+1}$, satisfying the detailed balance equation for the prior of the knot number. Suppose the jumping probability is $q(k'_i,\xi'_i|k_i,\xi_i)$. Let $\xi_{i,k_i} \subset \eta_i$ be the locations of $k_i$ knots in the $i$-th component. The concrete proposal distributions are specified in the following manner:

1. **Birth step**. Select a knot from the remaining candidate knots $\eta_i \backslash \xi_{i,k_i}$ uniformly, and add it into $\xi_{i,k_i}$. Then $q(k_i+1, \xi_{i,k_i+1} | k_i, \xi_{i,k_i}) = b_{k_i} / (n_i - k_i)$.
2. **Death step**. Select a knot from the current knots $\xi_{i,k_i}$ uniformly, and delete it. Then $q(k_i-1, \xi_{i,k_i-1} | k_i, \xi_{i,k_i}) = d_{k_i} / k_i$.
3. **Relocation step**. Select a knot from $\xi_{i,k_i}$ and another knot from $\eta_i \backslash \xi_{i,k_i}$ uniformly. Exchange their positions. Then $q(k_i, \xi'_{i,k_i} | k_i, \xi_{i,k_i}) = r_{k_i} / \{k_i(n_i-k_i)\}$.

Assume that $(k,\xi)$ is the current status and $(k',\xi')$ is the candidate status. To sample from the target posterior distribution, the Metropolis-Hastings algorithm implies that,

$$
p(k,\xi|y)q(k',\xi'|k,\xi)\alpha(k',\xi'|k,\xi) = p(k',\xi'|y)q(k,\xi|k',\xi')\alpha(k,\xi|k',\xi') \tag{9}
$$

where $\alpha(k',\xi'|k,\xi), \alpha(k,\xi|k',\xi')$ are the acceptance probabilities.

> [!NOTE]
> **Lemma 3.** With the specified proposal distribution and the posterior density of (9), the acceptance probability and its EBIC approximation in RJMCMC are
> $$
> \begin{aligned}
> \alpha(k',\xi'|k,\xi) &= \min\left\{1, ~ (m+1)^{(\nu-\nu')/2}(a_{k,\xi}/a_{k',\xi'})^{m/2}\right\}, \\
> \hat{\alpha}(k',\xi'|k,\xi) &= \min\left\{1, ~ m^{(\nu-\nu')/2}(\hat{\sigma}^2/(\hat{\sigma}')^2)^{m/2}\right\}
> \end{aligned} \tag{10}
> $$
> where $\nu,\nu'$ are the dimensions of the spline space.

Lemma 3 implies that $\sqrt{m+1}, \sqrt{m}$ are the dimensional penalty factors for the likelihood. Comparing $\alpha(k',\xi'|k,\xi)$ and $\hat{\alpha}(k',\xi'|k,\xi)$ in (10), $\alpha \approx \hat{\alpha}$ when the sample size is sufficiently large. The overall extended Bayesian adaptive regression spline approach is listed as Algorithm 1.

### Algorithm 1: Extended Bayesian adaptive regression spline algorithm via RJMCMC

**Input**: Labeled observations $\{(x_i, y_i)\}_{i=1}^m$, hyper-parameters $0 \leq \gamma \leq 1$ and $0 < c < 0.5$, jumping steps $I$, the number of candidate knots $n$.

1. Create the candidate knots $\eta$. Initialize the starting knots $(k^{(0)}, \xi^{(0)})$.
2. **for** $i = 0, \ldots, I-1$ **do**
3.   Determine the $j$-th component to update randomly and choose the transition strategy.
4.   Solve $(k', \xi')$ for the next movement by the proposal distribution.
5.   Compute $\alpha(k', \xi' | k^{(i)}, \xi^{(i)})$ by (10). Sample $u \sim U(0, 1)$.
6.   **if** $u < \alpha(k', \xi' | k^{(i)}, \xi^{(i)})$ **then**
7.     Update the knots by $(k^{(i+1)}, \xi^{(i+1)}) = (k', \xi')$;
8.   **else**
9.     Return to Step 3 and repeat.
10.  **end if**
11. **end for**

**Output**: The posterior samples $\{k^{(i)}, \xi^{(i)}\}_{i=1}^I$.

## 4 Experiment

We conduct EBARS in the knot inference and manifold denoising. For the knot inference, the performance is compared with the segmented method of Muggeo [2003] and the modified maximum likelihood (MML) method of Guangyu Yang and Zhang [2023]. For the manifold denoising, the performance is compared with manifold fitting under unbounded noise (MFUN) of Yao and Xia [2023], putative manifold fitting (PMF) of Fefferman et al. [2018], principal manifold estimation (PME) of Meng and Eloyan [2021] and principal curves (PC) of Hastie and Stuetzle [1989]. Numerical experiments show that the proposed method performs well in finite samples of all scenarios.
