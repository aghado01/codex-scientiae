[Page 5]

Contributions of this work. In this paper, we establish a general, model-independent theorem showing that persistent entropy detects phase transitions whenever the transition induces a qualitative separation in the limiting distribution of persistence diagrams. By treating persistence diagrams as random objects and formulating convergence in probability with respect to standard diagram metrics, our result identifies a minimal and verifiable mechanism. The mechanism aims to detect the appearance or disappearance of macroscopic persistent features under which persistent entropy separates phases with asymptotically non-vanishing probability. The theorem clarifies the role of embeddings and filtrations, isolates the precise regularity assumptions required for detection, and provides a principled link between finite-size observations and asymptotic behavior. Building on this framework, we introduce a dynamic finite-time criterion for identifying critical parameters and demonstrate its effectiveness across a range of physical systems (i.e., Kuramoto and Vicsek). We also present seminal numerical results to assess whether persistent entropy can improve understanding of neural network training dynamics. Taken together, these contributions place persistent entropy on a rigorous probabilistic footing and establish it as a theoretically justified tool for detecting emergent structural organization in complex, stochastic systems.

## 4 Phase transitions and persistence diagrams: Main theorem

### 4.1 Mathematical framework

We briefly clarify the mathematical setting used throughout the proof.

Random data and persistence diagrams. For each system size $N$ and control parameter $\lambda$, the observed data (e.g. point clouds, weighted graphs, or embeddings constructed from dynamical trajectories) are random objects, due to randomness in initial conditions, intrinsic noise, or finite-size fluctuations. Applying a fixed filtration and a fixed homological degree $k$, we obtain a random persistence diagram $D_N(\lambda)$.

We view persistence diagrams as elements of the space $\mathcal{D}$ of locally finite multisets of off-diagonal points in $\mathbb{R}^2$, with the diagonal $\Delta = \{ (t,t) \}$ included with infinite multiplicity. The space $\mathcal{D}$ is endowed with a standard diagram metric, such as the bottleneck distance or a $p$-Wasserstein distance, defined via matchings that may pair off-diagonal points to the diagonal.

Convergence of persistence diagrams. Statements of the form

$$
D_N(\lambda) \xrightarrow{\mathbb{P}} D(\lambda)
$$

mean convergence in probability with respect to the chosen diagram metric $d$, that is, for every $\varepsilon > 0$,

$$
\mathbb{P}(d(D_N(\lambda), D(\lambda)) > \varepsilon) \longrightarrow 0 \quad \text{as } N \to \infty.
$$
