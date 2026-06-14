[Page 13]

$$
d_{ij}^{(v)}(t) = \| v_i(t) - v_j(t) \|, \quad v_i(t) = v_0 (\cos \theta_i(t), \sin \theta_i(t)),
$$

or (ii) an orientation-difference distance

$$
d_{ij}^{(\theta)}(t) = 1 - | \cos \left( \theta_i(t) - \theta_j(t) \right) | \,.
$$

Both constructions yield symmetric distance matrices suitable for building Vietoris–Rips filtrations.

### 5.3.1 Vicksek model: experimental setup

To validate the proposed topological criterion on an active-matter system, we performed a numerical study of the Vicsek model across a range of noise amplitudes $\eta$. We considered a population of $N$ self-propelled particles moving in a two-dimensional periodic square domain of side length $L$. Each particle $i$ is characterized by its position $x_i(t) \in [0, L]^2$ and orientation $\theta_i(t) \in [0, 2\pi)$, and moves at constant speed $v_0$. At each discrete time step of size $\Delta t$, orientations are updated by aligning with the mean direction of neighboring particles within interaction radius $r_{\text{int}}$, perturbed by uniform angular noise of amplitude $\eta$, and positions are then advanced accordingly under periodic boundary conditions. In our implementation, for each value of $\eta$ in a prescribed grid $\{ \eta_1, \dots, \eta_m \}$ we generated $R_\eta$ independent realizations by randomly sampling initial positions uniformly in the domain and initial orientations uniformly in $(0, 2\pi)$, and we simulated trajectories for $T$ time steps.

For each realization and for a set of sampled times $t_k = k\Delta$ (with sampling stride $\Delta$ used to control computational cost), we computed a time-dependent distance matrix from the particle orientations and used it as input to Vietoris–Rips persistent homology. Specifically, letting $\theta_i(t_k)$ denote the orientation of particle $i$ at time $t_k$, we constructed the pairwise orientation-difference distance $d^{(\theta)}$

$$
d_{ij}(t_k) = 1 - \cos(\theta_i(t_k) - \theta_j(t_k)),
$$
(with the option to replace it by a velocity-based distance), and computed the normalized persistent entropy $\text{NPE}(H_0)(t_k)$ from the resulting persistence diagrams. To quantify the macroscopic ordering dynamics, we also evaluated the classical Vicsek polarization

$$
\psi(t)
$$

and reported mean curves with a shaded standard deviation band across realizations for both $\text{NPE}(H_0)(t)$ and $\psi(t)$. Finally, we applied the dynamic stability criterion introduced in this work by estimating, for each $\eta$, the topological transition time $t^*(\eta)$ as the first time at which $\text{NPE}(H_0)(t)$ becomes stable within a tolerance over a sliding window, and we used the empirical probability $P(t^*(\eta) \leq T_{\text{max}})$ to identify the critical noise $\hat{\eta}_c$ separating noise levels for which topological stabilization (and thus flocking) is dynamically accessible within the observation horizon.

### 5.3.2 Vicksek model: experimental output analysis

Figure 6 shows the dynamical evolution of the Vicsek polarization $\psi(t)$ for increasing noise amplitudes. For small values of $\eta$ (e.g., $\eta = 0.05$ and $\eta = 0.1$), the system rapidly develops global alignment and converges toward an ordered flocking state with $\psi(t) \simeq 1$ and minimal variability across realizations. As $\eta$ increases, the convergence toward the ordered phase becomes slower and more heterogeneous, while for sufficiently large noise ($\eta = 0.5$) polarization remains strongly suppressed and fluctuating, indicating a disordered regime.
