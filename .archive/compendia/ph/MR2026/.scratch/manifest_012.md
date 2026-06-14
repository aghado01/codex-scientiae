# Manifest: Page 012

## REPAIR_PROSE
- RAW: ```
[Page 12]

This behavior is consistent with the classical synchronization transition observed through the Kuramoto order parameter, while highlighting a key distinction: persistent entropy is more sensitive to small phase rearrangements and thus provides an earlier and more granular signature of the approach to synchronization. In particular, synchronization in the Kuramoto model corresponds to the disappearance of persistent topological features whose lifetimes remain bounded away from zero as N increases, thereby realizing the macroscopic-bar separation assumed in Theorem 1. The resulting agreement between dynamical ordering, topological stabilization, and probabilistic convergence of persistence diagrams provides direct numerical support for the theoretical framework developed in this work.

# 5.3 The Vicsek model
```
  FIX: ```
This behavior is consistent with the classical synchronization transition observed through the Kuramoto order parameter, while highlighting a key distinction: persistent entropy is more sensitive to small phase rearrangements and thus provides an earlier and more granular signature of the approach to synchronization. In particular, synchronization in the Kuramoto model corresponds to the disappearance of persistent topological features whose lifetimes remain bounded away from zero as $N$ increases, thereby realizing the macroscopic-bar separation assumed in Theorem 1. The resulting agreement between dynamical ordering, topological stabilization, and probabilistic convergence of persistence diagrams provides direct numerical support for the theoretical framework developed in this work.

# 5.3 The Vicsek model
```
- RAW: ```
The Vicsek model is a paradigmatic minimal model for collective motion in active matter, describing a system of N self-propelled particles moving in a two-dimensional domain with periodic boundary conditions. Each particle i is characterized by its position r i ( t ) ∈ [0 ,L ) 2 and by a velocity of constant modulus v 0 with direction θ i ( t ) . The dynamics is defined by the discrete-time update rules
```
  FIX: ```
The Vicsek model is a paradigmatic minimal model for collective motion in active matter, describing a system of $N$ self-propelled particles moving in a two-dimensional domain with periodic boundary conditions. Each particle $i$ is characterized by its position $r_i(t) \in [0, L)^2$ and by a velocity of constant modulus $v_0$ with direction $\theta_i(t)$. The dynamics is defined by the discrete-time update rules
```
- RAW: ```
where r is the interaction radius, η is the noise amplitude, and ξ i ( t ) are independent random variables uniformly distributed in [ − 1 2 , 1 2 ] . Distances are computed using periodic boundary conditions. For low noise or high density, the system undergoes a transition from a disordered phase to an ordered, flocking phase characterized by collective alignment of velocities.
```
  FIX: ```
where $r$ is the interaction radius, $\eta$ is the noise amplitude, and $\xi_i(t)$ are independent random variables uniformly distributed in $[-1/2, 1/2]$. Distances are computed using periodic boundary conditions. For low noise or high density, the system undergoes a transition from a disordered phase to an ordered, flocking phase characterized by collective alignment of velocities.
```
- RAW: ```
In the disordered phase ψ ( t ) ≈ 0 , while in the ordered phase ψ ( t ) approaches 1 , signaling global velocity alignment.
```
  FIX: ```
In the disordered phase $\psi(t) \approx 0$, while in the ordered phase $\psi(t)$ approaches $1$, signaling global velocity alignment.
```

## REPAIR_MATH
- RAW: ```
$$
\theta _ { i } ( t + \Delta t ) & = \arg \left ( \sum _ { j \colon \| r _ { j } ( t ) - r _ { i } ( t ) \| < r } e ^ { i \theta _ { j } ( t ) } \right ) + \eta \, \xi _ { i } ( t ) , \\ r _ { i } ( t + \Delta t ) & = r _ { i } ( t ) + v _ { 0 } \Delta t \left ( \cos \theta _ { i } ( t ) , \sin \theta _ { i } ( t ) \right ) ,
$$

$$
r _ { i } ( t + \Delta t ) = r _ { i } ( t ) + v _ { 0 } \Delta t \left ( \cos \theta _ { i } ( t ) , \sin \theta _ { i } ( t ) \right ) ,
$$
```
  FIX: ```
$$
\begin{aligned}
\theta_i(t + \Delta t) &= \arg \left( \sum_{j \colon \|r_j(t) - r_i(t)\| < r} e^{i \theta_j(t)} \right) + \eta \xi_i(t), \\
r_i(t + \Delta t) &= r_i(t) + v_0 \Delta t (\cos \theta_i(t), \sin \theta_i(t)),
\end{aligned}
$$
```
- RAW: ```
$$
\begin{array} { r l } & { \text {measure of collective order is the polarization defined as} } \\ & { \quad \psi ( t ) = \frac { 1 } { N } \left \| \sum _ { i = 1 } ^ { N } ( \cos \theta _ { i } ( t ) , \sin \theta _ { i } ( t ) ) \right \| \in [ 0 , 1 ] . } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \quad } \\ & { \
$$
```
  FIX: ```
$$
\psi(t) = \frac{1}{N} \left\| \sum_{i=1}^N (\cos \theta_i(t), \sin \theta_i(t)) \right\| \in [0, 1].
$$
```
