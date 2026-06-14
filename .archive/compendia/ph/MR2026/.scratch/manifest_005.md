# Manifest: Page 005

## REPLACE_TABLES
None

## REPAIR_PROSE
- RAW: ```
# 4 Phase transitions and persistence diagrams Main theorem
```
  FIX: ```
## 4 Phase transitions and persistence diagrams: Main theorem
```

- RAW: ```
# 4.1 Mathematical framework
```
  FIX: ```
### 4.1 Mathematical framework
```

- RAW: ```
range of physical systems (i.e., Kuramoto and Vicksek). We also
```
  FIX: ```
range of physical systems (i.e., Kuramoto and Vicsek). We also
```

- RAW: ```
Random data and persistence diagrams. For each system size N and control parameter λ , the observed data (e.g. point clouds, weighted graphs, or embeddings constructed from dynamical trajectories) are random objects, due to randomness in initial conditions, intrinsic noise, or finitesize fluctuations. Applying a fixed filtration and a fixed homological degree k , we obtain a random persistence diagram D N ( λ ) .
```
  FIX: ```
Random data and persistence diagrams. For each system size \( N \) and control parameter \( \lambda \), the observed data (e.g. point clouds, weighted graphs, or embeddings constructed from dynamical trajectories) are random objects, due to randomness in initial conditions, intrinsic noise, or finite-size fluctuations. Applying a fixed filtration and a fixed homological degree \( k \), we obtain a random persistence diagram \( D_N(\lambda) \).
```

- RAW: ```
We view persistence diagrams as elements of the space D of locally finite multisets of offdiagonal points in R 2 , with the diagonal ∆ = { ( t,t ) } included with infinite multiplicity. The space D is endowed with a standard diagram metric, such as the bottleneck distance or a p -Wasserstein distance, defined via matchings that may pair off-diagonal points to the diagonal.
```
  FIX: ```
We view persistence diagrams as elements of the space \( \mathcal{D} \) of locally finite multisets of off-diagonal points in \( \mathbb{R}^2 \), with the diagonal \( \Delta = \{ (t,t) \} \) included with infinite multiplicity. The space \( \mathcal{D} \) is endowed with a standard diagram metric, such as the bottleneck distance or a \( p \)-Wasserstein distance, defined via matchings that may pair off-diagonal points to the diagonal.
```

- RAW: ```
mean convergence in probability with respect to the chosen diagram metric d , that is, for every ε > 0 ,
```
  FIX: ```
mean convergence in probability with respect to the chosen diagram metric \( d \), that is, for every \( \varepsilon > 0 \),
```

## REPAIR_MATH
- RAW: ```
$$
D _ { N } ( \lambda ) \xrightarrow { \mathbb { P } } D ( \lambda )
$$
```
  FIX: ```
\[
D_N(\lambda) \xrightarrow{\mathbb{P}} D(\lambda)
\]
```

- RAW: ```
$$
\mathbb { P } ( d ( D _ { N } ( \lambda ) , D ( \lambda ) ) > \varepsilon ) \longrightarrow 0 \ \text { as } N \to \infty . \\
$$
```
  FIX: ```
\[
\mathbb{P}(d(D_N(\lambda), D(\lambda)) > \varepsilon) \longrightarrow 0 \quad \text{as } N \to \infty.
\]
```
