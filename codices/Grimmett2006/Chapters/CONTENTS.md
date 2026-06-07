# The Random-Cluster Model

Geoffrey Grimmett
Statistical Laboratory Centre for Mathematical Sciences
University of Cambridge

## Contents

[**1 Random-Cluster Measures**](#ch-1) — 1 (lines 135-511)

- [1.1 Introduction](#sec-1-1) — 1 (lines 137-511)
- [1.2 Random-cluster model](#sec-1-2) — 4 (lines 137-511)
- [1.3 Ising and Potts models](#sec-1-3) — 6 (lines 137-511)
- [1.4 Random-cluster and Ising/Potts models coupled](#sec-1-4) — 8 (lines 137-511)
- [1.5 The limit as q ↓ 0](#sec-1-5) — 13 (lines 137-511)
- [1.6 Basic notation](#sec-1-6) — 15 (lines 137-511)

[**2 Monotonic Measures**](#ch-2) — 19 (lines 512-1096)

- [2.1 Stochastic ordering of measures](#sec-2-1) — 19 (lines 514-1096)
- [2.2 Positive association](#sec-2-2) — 25 (lines 514-1096)
- [2.3 Influence for monotonic measures](#sec-2-3) — 30 (lines 514-1096)
- [2.4 Sharp thresholds for increasing events](#sec-2-4) — 33 (lines 514-1096)
- [2.5 Exponential steepness](#sec-2-5) — 35 (lines 514-1096)

[**3 Fundamental Properties**](#ch-3) — 37 (lines 1097-1945)

- [3.1 Conditional probabilities](#sec-3-1) — 37 (lines 1099-1945)
- [3.2 Positive association](#sec-3-2) — 39 (lines 1099-1945)
- [3.3 Differential formulae and sharp thresholds](#sec-3-3) — 40 (lines 1099-1945)
- [3.4 Comparison inequalities](#sec-3-4) — 43 (lines 1099-1945)
- [3.5 Exponential steepness](#ch-3) — 49 (lines 1099-1945)
- [3.6 Partition functions](#ch-3) — 53 (lines 1099-1945)
- [3.7 Domination by the Ising model](#sec-3-7) — 57 (lines 1099-1945)
- [3.8 Series and parallel laws](#ch-3) — 61 (lines 1099-1945)
- [3.9 Negative association](#ch-3) — 63 (lines 1099-1945)

[**4 Infinite-Volume Measures**](#ch-4) — 67 (lines 1946-2944)

- [4.1 Infinite graphs](#sec-4-1) — 67 (lines 1948-2944)
- [4.2 Boundary conditions](#sec-4-2) — 70 (lines 1948-2944)
- [4.3 Infinite-volume weak limits](#sec-4-3) — 72 (lines 1948-2944)
- [4.4 Infinite-volume random-cluster measures](#sec-4-4) — 78 (lines 1948-2944)
- [4.5 Uniqueness via convexity of pressure](#sec-4-5) — 85 (lines 1948-2944)
- [4.6 Potts and random-cluster models on infinite graphs](#sec-4-6) — 95 (lines 1948-2944)

[**5 Phase Transition**](#ch-5) — 98 (lines 2945-3972)

- [5.1 The critical point](#sec-5-1) — 98 (lines 2947-3972)
- [5.2 Percolation probabilities](#sec-5-2) — 102 (lines 2947-3972)
- [5.3 Uniqueness of random-cluster measures](#sec-5-3) — 107 (lines 2947-3972)
- [5.4 The subcritical phase](#sec-5-4) — 110 (lines 2947-3972)
- [5.5 Exponential decay of radius](#ch-5) — 113 (lines 2947-3972)
- [5.6 Exponential decay of volume](#sec-5-6) — 119 (lines 2947-3972)
- [5.7 The supercritical phase and the Wulff crystal](#sec-5-7) — 122 (lines 2947-3972)
- [5.8 Uniqueness when q < 1](#sec-5-8) — 131 (lines 2947-3972)

[**6 In Two Dimensions**](#ch-6) — 133 (lines 3973-4690)

- [6.1 Planar duality](#sec-6-1) — 133 (lines 3975-4690)
- [6.2 The value of the critical point](#ch-6) — 138 (lines 3975-4690)
- [6.3 Exponential decay of radius](#ch-6) — 143 (lines 3975-4690)
- [6.4 First-order phase transition](#sec-6-4) — 144 (lines 3975-4690)
- [6.5 General lattices in two dimensions](#ch-6) — 152 (lines 3975-4690)
- [6.6 Square, triangular, and hexagonal lattices](#sec-6-6) — 154 (lines 3975-4690)
- [6.7 Stochastic Löwner evolutions](#sec-6-7) — 164 (lines 3975-4690)

[**7 Duality in Higher Dimensions**](#ch-7) — 167 (lines 4691-6593)

- [7.1 Surfaces and plaquettes](#sec-7-1) — 167 (lines 4693-6593)
- [7.2 Basic properties of surfaces](#sec-7-2) — 169 (lines 4693-6593)
- [7.3 A contour representation](#sec-7-3) — 173 (lines 4693-6593)
- [7.4 Polymer models](#sec-7-4) — 179 (lines 4693-6593)
- [7.5 Discontinuous phase transition for large q](#sec-7-5) — 182 (lines 4693-6593)
- [7.6 Dobrushin interfaces](#sec-7-6) — 195 (lines 4693-6593)
- [7.7 Probabilistic and geometric preliminaries](#sec-7-7) — 199 (lines 4693-6593)
- [7.8 The law of the interface](#sec-7-8) — 202 (lines 4693-6593)
- [7.9 Geometry of interfaces](#sec-7-9) — 208 (lines 4693-6593)
- [7.10 Exponential bounds for group probabilities](#sec-7-10) — 215 (lines 4693-6593)
- [7.11 Localization of interface](#ch-7) — 218 (lines 4693-6593)

[**8 Dynamics of Random-Cluster Models**](#ch-8) — 222 (lines 6594-7359)

- [8.1 Time-evolution of the random-cluster model](#sec-8-1) — 222 (lines 6596-7359)
- [8.2 Glauber dynamics](#sec-8-2) — 224 (lines 6596-7359)
- [8.3 Gibbs sampler](#sec-8-3) — 225 (lines 6596-7359)
- [8.4 Coupling from the past](#sec-8-4) — 227 (lines 6596-7359)
- [8.5 Swendsen–Wang dynamics](#sec-8-5) — 230 (lines 6596-7359)
- [8.6 Coupled dynamics on a finite graph](#sec-8-6) — 232 (lines 6596-7359)
- [8.7 Box dynamics with boundary conditions](#sec-8-7) — 237 (lines 6596-7359)
- [8.8 Coupled dynamics on the infinite lattice](#sec-8-8) — 240 (lines 6596-7359)
- [8.9 Simultaneous uniqueness](#sec-8-9) — 255 (lines 6596-7359)

[**9 Flows in Poisson Graphs**](#ch-9) — 257 (lines 7360-7917)

- [9.1 Potts models and flows](#sec-9-1) — 257 (lines 7362-7917)
- [9.2 Flows in the Ising model](#ch-9) — 262 (lines 7362-7917)
- [9.3 Exponential decay for the Ising model](#sec-9-3) — 273 (lines 7362-7917)
- [9.4 The Ising model in four and more dimensions](#sec-9-4) — 274 (lines 7362-7917)

[**10 On Other Graphs**](#ch-10) — 276 (lines 7918-9066)

- [10.1 Mean-field theory](#sec-10-1) — 276 (lines 7920-9066)
- [10.2 On complete graphs](#sec-10-2) — 277 (lines 7920-9066)
- [10.3 Main results for the complete graph](#sec-10-3) — 281 (lines 7920-9066)
- [10.4 The fundamental proposition](#ch-10) — 284 (lines 7920-9066)
- [10.5 The size of the largest component](#sec-10-5) — 286 (lines 7920-9066)
- [10.6 Proofs of main results for complete graphs](#sec-10-6) — 289 (lines 7920-9066)
- [10.7 The nature of the singularity](#sec-10-7) — 295 (lines 7920-9066)
- [10.8 Large deviations](#sec-10-8) — 296 (lines 7920-9066)
- [10.9 On a tree](#ch-10) — 299 (lines 7920-9066)
- [10.10 The critical point for a tree](#sec-10-10) — 305 (lines 7920-9066)
- [10.11 (Non-)uniqueness of measures on trees](#sec-10-11) — 313 (lines 7920-9066)
- [10.12 On non-amenable graphs](#sec-10-12) — 315 (lines 7920-9066)

[**11 Graphical Methods for Spin Systems**](#ch-11) — 320 (lines 9067-9642)

- [11.1 Random-cluster representations](#sec-11-1) — 320 (lines 9069-9642)
- [11.2 The Potts model](#sec-11-2) — 321 (lines 9069-9642)
- [11.3 The Ashkin–Teller model](#sec-11-3) — 326 (lines 9069-9642)
- [11.4 The disordered Potts ferromagnet](#sec-11-4) — 330 (lines 9069-9642)
- [11.5 The Edwards–Anderson spin-glass model](#sec-11-5) — 333 (lines 9069-9642)
- [11.6 The Widom–Rowlinson lattice gas](#sec-11-6) — 337 (lines 9069-9642)
