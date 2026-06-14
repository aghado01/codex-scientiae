# Manifest: Page 013

## REPAIR_MATH
- RAW: ```
$$
d _ { i j } ^ { ( v ) } ( t ) = \| v _ { i } ( t ) - v _ { j } ( t ) \| , \quad v _ { i } ( t ) = v _ { 0 } ( \cos \theta _ { i } ( t ) , \sin \theta _ { i } ( t ) ) ,
$$
```
  FIX: ```
\[
d_{ij}^{(v)}(t) = \| v_i(t) - v_j(t) \|, \quad v_i(t) = v_0 (\cos \theta_i(t), \sin \theta_i(t)),
\]
```

- RAW: ```
$$
d _ { i j } ^ { ( \theta ) } ( t ) = 1 - | \cos \left ( \theta _ { i } ( t ) - \theta _ { j } ( t ) \right ) | \, . \\ \intertext { d } \text {symmetric distance matrices suitable for building Viotaris-Rips filtrations} .
$$
```
  FIX: ```
\[
d_{ij}^{(\theta)}(t) = 1 - | \cos \left( \theta_i(t) - \theta_j(t) \right) | \,.
\]
```

- RAW: ```
$$
\psi ( t )
$$
```
  FIX: ```
\[
\psi(t)
\]
```

## REPAIR_PROSE
- RAW: ```
To validate the proposed topological criterion on an active-matter system, we performed a numerical study of the Vicsek model across a range of noise amplitudes η . We considered a population of N self-propelled particles moving in a two-dimensional periodic square domain of side length L . Each particle i is characterized by its position x i ( t ) ∈ [0 ,L ] 2 and orientation θ i ( t ) ∈ [0 , 2 π ) , and moves at constant speed v 0 . At each discrete time step of size ∆ t , orientations are updated by aligning with the mean direction of neighboring particles within interaction radius r int , perturbed by uniform angular noise of amplitude η , and positions are then advanced accordingly under periodic boundary conditions. In our implementation, for each value of η in a prescribed grid { η 1 ,...,η m } we generated R η independent realizations by randomly sampling initial positions uniformly in the domain and initial orientations uniformly in (0 , 2 π ) , and we simulated trajectories for T time steps.
```
  FIX: ```
To validate the proposed topological criterion on an active-matter system, we performed a numerical study of the Vicsek model across a range of noise amplitudes \( \eta \). We considered a population of \( N \) self-propelled particles moving in a two-dimensional periodic square domain of side length \( L \). Each particle \( i \) is characterized by its position \( x_i(t) \in [0, L]^2 \) and orientation \( \theta_i(t) \in [0, 2\pi) \), and moves at constant speed \( v_0 \). At each discrete time step of size \( \Delta t \), orientations are updated by aligning with the mean direction of neighboring particles within interaction radius \( r_{\text{int}} \), perturbed by uniform angular noise of amplitude \( \eta \), and positions are then advanced accordingly under periodic boundary conditions. In our implementation, for each value of \( \eta \) in a prescribed grid \( \{ \eta_1, \dots, \eta_m \} \) we generated \( R_\eta \) independent realizations by randomly sampling initial positions uniformly in the domain and initial orientations uniformly in \( (0, 2\pi) \), and we simulated trajectories for \( T \) time steps.
```

- RAW: ```
For each realization and for a set of sampled times t k = k ∆ (with sampling stride ∆ used to control computational cost), we computed a time-dependent distance matrix from the particle orientations and used it as input to Vietoris–Rips persistent homology. Specifically, letting θ i ( t k ) denote the orientation of particle i at time t k , we constructed the pairwise orientation-difference distance ( θ )
```
  FIX: ```
For each realization and for a set of sampled times \( t_k = k\Delta \) (with sampling stride \( \Delta \) used to control computational cost), we computed a time-dependent distance matrix from the particle orientations and used it as input to Vietoris–Rips persistent homology. Specifically, letting \( \theta_i(t_k) \) denote the orientation of particle \( i \) at time \( t_k \), we constructed the pairwise orientation-difference distance \( d^{(\theta)} \)
```

- RAW: ```
d ij ( t k ) = 1 − cos( θ i ( t k ) − θ j ( t k )) , (with the option to replace it by a velocity-based distance), and computed the normalized persistent entropy NPE( H 0 )( t k ) from the resulting persistence diagrams. To quantify the macroscopic ordering dynamics, we also evaluated the classical Vicsek polarization
```
  FIX: ```
\[
d_{ij}(t_k) = 1 - \cos(\theta_i(t_k) - \theta_j(t_k)),
\]
(with the option to replace it by a velocity-based distance), and computed the normalized persistent entropy \( \text{NPE}(H_0)(t_k) \) from the resulting persistence diagrams. To quantify the macroscopic ordering dynamics, we also evaluated the classical Vicsek polarization
```

- RAW: ```
and reported mean curves with a shaded standard deviation band across realizations for both NPE( H 0 )( t ) and ψ ( t ) . Finally, we applied the dynamic stability criterion introduced in this work by estimating, for each η , the topological transition time t ∗ ( η ) as the first time at which NPE( H 0 )( t ) becomes stable within a tolerance over a sliding window, and we used the empirical probability P ( t ∗ ( η ) ≤ T max ) to identify the critical noise ˆ η c separating noise levels for which topological stabilization (and thus flocking) is dynamically accessible within the observation horizon.
```
  FIX: ```
and reported mean curves with a shaded standard deviation band across realizations for both \( \text{NPE}(H_0)(t) \) and \( \psi(t) \). Finally, we applied the dynamic stability criterion introduced in this work by estimating, for each \( \eta \), the topological transition time \( t^*(\eta) \) as the first time at which \( \text{NPE}(H_0)(t) \) becomes stable within a tolerance over a sliding window, and we used the empirical probability \( P(t^*(\eta) \leq T_{\text{max}}) \) to identify the critical noise \( \hat{\eta}_c \) separating noise levels for which topological stabilization (and thus flocking) is dynamically accessible within the observation horizon.
```

- RAW: ```
Figure 6 shows the dynamical evolution of the Vicsek polarization ψ ( t ) for increasing noise amplitudes. For small values of η (e.g., η = 0 . 05 and η = 0 . 1 ), the system rapidly develops global alignment and converges toward an ordered flocking state with ψ ( t ) ≃ 1 and minimal variability across realizations. As η increases, the convergence toward the ordered phase becomes slower and more heterogeneous, while for suﬀiciently large noise ( η = 0 . 5 ) polarization remains strongly suppressed and fluctuating, indicating a disordered regime.
```
  FIX: ```
Figure 6 shows the dynamical evolution of the Vicsek polarization \( \psi(t) \) for increasing noise amplitudes. For small values of \( \eta \) (e.g., \( \eta = 0.05 \) and \( \eta = 0.1 \)), the system rapidly develops global alignment and converges toward an ordered flocking state with \( \psi(t) \simeq 1 \) and minimal variability across realizations. As \( \eta \) increases, the convergence toward the ordered phase becomes slower and more heterogeneous, while for sufficiently large noise (\( \eta = 0.5 \)) polarization remains strongly suppressed and fluctuating, indicating a disordered regime.
```
