[Page 9]

connectivity among oscillators. In general, the system tends to converge in phase, which is the phase transition. A convenient measure of the degree of synchronicity is defined as follows:

$$
r = \frac{1}{N} \sqrt{\left(\sum_{j=1}^N \cos(\theta_j)\right)^2 + \left(\sum_{j=1}^N \sin(\theta_j)\right)^2}
$$

The degree $r$ spans from zero to one; when $r = 1$ all the oscillators are in phase. Complete synchronization can be reached only for certain values of $K$ that are greater than a critical value $K_c$. For a complete review of the Kuramoto model, we refer to [21].

Topological properties of the Kuramoto model were initially investigated in [40]. The authors used clique weight rank persistent homology (CWRPH[6]) for detecting relevant topological changes of the model between two different time regimes $T_1 = [0, 250)$ and $T_2 = [250, 500]$. They used 128 oscillators connected through a given adjacency matrix $G_{i,j}$. At each simulation they selected the initial conditions, which are the frequency and the phase for each oscillator, and integrated the system between $t_0 = 0$ and $t_{\max} = 10$ with 500 time steps. The authors executed 20 simulations for each instance. At the end of all the simulations they built a function network by computing the pairwise synchronicity coefficient between two oscillators, defined as follows:

$$
\phi_{i,j}^{T_k} = \langle | \cos\left( \theta_i^k - \theta_j^k \right) | \rangle
$$
