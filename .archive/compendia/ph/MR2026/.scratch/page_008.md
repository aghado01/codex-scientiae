**Remark 3. Mechanism of detection.** The theorem shows that persistent entropy detects phase transitions whenever the transition induces or destroys a finite amount of topological mass at macroscopic scales. This identifies the barcode-level mechanism underlying the empirical success of persistent entropy in detecting regime changes in complex systems.

**Remark 4. Model-independency.** The theorem is model-independent. Detection depends on the choice of observable and filtration, but whenever a phase transition induces the appearance or disappearance of macroscopic persistent features, persistent entropy must detect it.

**Corollary 1.** If one phase admits at least one persistent topological feature with lifetime bounded away from zero and the other does not, persistent entropy acts as a consistent phase classifier.

## 5 Numerical experiments

### 5.1 Dynamic identification of the critical control parameter

In finite-time numerical experiments, ordering transitions are observed as time-dependent relaxation processes: for a fixed control parameter $\lambda$, the system may or may not reach an ordered steady state within the observation horizon $T_{\max}$. To operationalize the theorem in this dynamical setting, we compute, for each $\lambda$ and for each realization, a time series $S_\lambda(t)$ of a topological statistic derived from the persistence diagram $D_N(\lambda, t)$ (e.g., normalized persistent entropy $\text{NPE}(H_0)$ or the maximum $H_1$ lifetime). We then define the topological transition time $t^*(\lambda)$ as the earliest time at which $S_\lambda(t)$ becomes stable on a sliding window, namely

$$
t _ { * } ( \lambda ) = \min \left \{ t \colon \max _ { s \in [ t , t + W ] } | S _ { \lambda } ( s ) - S _ { \lambda } ( t ) | \leq \varepsilon \right \} ,
$$

where $W$ is a fixed window length and $\varepsilon$ is a tolerance capturing the numerical noise floor. Repeating this procedure over independent realizations yields an empirical probability of reaching topological stability within the observation horizon, $p(\lambda) = P(t^*(\lambda) \le T_{\max})$. Finally, the critical parameter is estimated by thresholding this probability: for example when applied to the Kuramoto model, we set $\hat{K}_c = \inf \{ K \colon p(K) \ge p_0 \}$, whereas for Vicsek (ordered at low noise) we set $\hat{\eta}_c = \sup \{ \eta \colon p(\eta) \ge p_0 \}$, with $p_0 \in (0, 1)$ a prescribed confidence level. This dynamic criterion is consistent with the theorem’s mechanism, since stability of $S_\lambda(t)$ indicates convergence of $D_N(\lambda, t)$ toward a limiting, near-trivial diagram in the ordered phase.

Note that, in the following subsection, the Model $M$ is the Kuramoto model or the Vicsek model and thus, $\lambda$ is $K$ or $\eta$ accordingly.

### 5.2 The Kuramoto model

The Kuramoto model is widely used to model a network of limit-cycle oscillators that influence one another. The frequency of a single oscillator is influenced by its own intrinsic behavior and by the net pull of all the other oscillators. The reciprocal influences can be seen as the effect of a mean field that forces the oscillators to reach synchronization, i.e., to converge to the same phase. Mathematically, the model is a differential equation of the form:

$$
\frac{d\theta_i}{dt} = \omega_i + \frac{K}{N} \sum_{j=1}^N G_{i,j} \sin(\theta_j - \theta_i)
$$

where $\theta_i$ is the phase of the $i$-th oscillator with $\omega_i$ frequency. $K$ is the coupling constant determining how much the intrinsic frequency can be modulated. $G_{i,j}$ is an adjacency matrix establishing the

**Algorithm 1: Dynamic estimation of the critical control parameter via topological stability**

* **Input**: Model $M$, parameter grid $\Lambda = \{ \lambda_1, \dots, \lambda_m \}$, number of realizations $R$, observation horizon $T_{\max}$, sampling stride $\Delta$, window length $W$, tolerance $\varepsilon$, confidence level $p_0$.
* **Output**: Estimated critical parameter $\hat{\lambda}_c$ and transition times $\{ t_*^{(r)}(\lambda) \}$.

1. **foreach** $\lambda \in \Lambda$ **do**
2. &nbsp;&nbsp;&nbsp;&nbsp;**for** $r = 1$ to $R$ **do**
3. &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Simulate $M$ at parameter $\lambda$ and store states $X(\lambda, t)$ for $t \in [0, T_{\max}]$;
4. &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*// Compute a time series of a topological statistic*
5. &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Initialize an empty sequence $S_\lambda^{(r)}$;
6. &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;**for** $t = 0, \Delta, 2\Delta, \dots, T_{\max}$ **do**
7. &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Build a distance matrix $d(\lambda, t)$ from $X(\lambda, t)$;
8. &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Compute persistence diagram $D_N(\lambda, t)$ (e.g., Vietoris–Rips);
9. &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Append statistic $S_\lambda^{(r)}(t) = \text{Stat}(D_N(\lambda, t))$ to $S_\lambda^{(r)}$;
10. &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*// First time of stability on a sliding window*
11. &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Set $t_*^{(r)}(\lambda) \leftarrow \min \left\{ t \colon \max_{s \in [t, t + W]} |S_\lambda^{(r)}(s) - S_\lambda^{(r)}(t)| \le \varepsilon \right\}$;
12. &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;**if** no such time exists, **then** set $t_*^{(r)}(\lambda) \leftarrow \emptyset$;
13. &nbsp;&nbsp;&nbsp;&nbsp;Estimate $p(\lambda) = \frac{1}{R} \sum_{r=1}^R \mathbb{I}[t_*^{(r)}(\lambda) \le T_{\max}]$;
14. **if** $M$ is Kuramoto **then**
15. &nbsp;&nbsp;&nbsp;&nbsp;$\hat{\lambda}_c \leftarrow \inf \{ \lambda \in \Lambda \colon p(\lambda) \ge p_0 \}$; // i.e., $\hat{K}_c$
16. **else**
17. &nbsp;&nbsp;&nbsp;&nbsp;$\hat{\lambda}_c \leftarrow \sup \{ \lambda \in \Lambda \colon p(\lambda) \ge p_0 \}$; // i.e., $\hat{\eta}_c$
18. **return** $\hat{\lambda}_c, \{ t_*^{(r)}(\lambda) \}$;
