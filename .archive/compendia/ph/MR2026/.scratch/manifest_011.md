# Manifest: Page 011

## REPAIR_MATH
None

## REPLACE_TABLES
None

## REPAIR_PROSE
- RAW: ```
For small coupling values ( K = 0 and K = 1 ), the Kuramoto system remains in an incoherent regime, as evidenced by the low and fluctuating values of the order parameter r ( t ) in Fig. 2. In this regime, the normalized persistent entropy NPE( H 0 )( t ) in Fig. 3 does not converge to a stable plateau, reflecting continuous rearrangements of the topological structure of the associated functional network.```
  FIX: ```
For small coupling values ( \( K = 0 \) and \( K = 1 \) ), the Kuramoto system remains in an incoherent regime, as evidenced by the low and fluctuating values of the order parameter \( r(t) \) in Fig. 2. In this regime, the normalized persistent entropy \( \text{NPE}(H_0)(t) \) in Fig. 3 does not converge to a stable plateau, reflecting continuous rearrangements of the topological structure of the associated functional network.```
- RAW: ```
As the coupling strength increases ( K = 3 ), the system enters a transitional regime. Here, r ( t ) grows gradually but remains subject to significant fluctuations, while NPE( H 0 )( t ) displays enhanced temporal variability.```
  FIX: ```
As the coupling strength increases ( \( K = 3 \) ), the system enters a transitional regime. Here, \( r(t) \) grows gradually but remains subject to significant fluctuations, while \( \text{NPE}(H_0)(t) \) displays enhanced temporal variability.```
- RAW: ```
For larger coupling values ( K = 5 and above), a qualitative transition is observed. The order parameter rapidly converges to r ( t ) ≃ 1 with negligible variance, signaling full synchronization. Concurrently, NPE( H 0 )( t ) undergoes a sharp drop and stabilizes at a low constant value, indicating the collapse of topological complexity.```
  FIX: ```
For larger coupling values ( \( K = 5 \) and above), a qualitative transition is observed. The order parameter rapidly converges to \( r(t) \simeq 1 \) with negligible variance, signaling full synchronization. Concurrently, \( \text{NPE}(H_0)(t) \) undergoes a sharp drop and stabilizes at a low constant value, indicating the collapse of topological complexity.```
- RAW: ```
For the representative realization at K = 5 , the algorithm identifies a topological transition time t ∗ ≃ 2 . 0 , after which the barcode structure remains unchanged.```
  FIX: ```
For the representative realization at \( K = 5 \), the algorithm identifies a topological transition time \( t^* \simeq 2.0 \), after which the barcode structure remains unchanged.```
- RAW: ```
This behavior is summarized quantitatively in Fig. 5, which reports the probability P ( t ( K )

∗ ≤ T max ) of reaching topological stability within the observation horizon.```
  FIX: ```
This behavior is summarized quantitatively in Fig. 5, which reports the probability \( P(t^*(K) \leq T_{\max}) \) of reaching topological stability within the observation horizon.```
- RAW: ```
The probability is close to zero in the incoherent regime, increases sharply in the transitional region, and saturates to one beyond the critical coupling ˆ K c .```
  FIX: ```
The probability is close to zero in the incoherent regime, increases sharply in the transitional region, and saturates to one beyond the critical coupling \( \hat{K}_c \).```
- RAW: ```
According to the dynamic criterion introduced in this work, ˆ K c marks the boundary beyond which synchronization is not only asymptotically stable but also dynamically accessible on finite time scales.```
  FIX: ```
According to the dynamic criterion introduced in this work, \( \hat{K}_c \) marks the boundary beyond which synchronization is not only asymptotically stable but also dynamically accessible on finite time scales.```
- RAW: `# 5.2.3 Relation to the general theorem.`
  FIX: `### 5.2.3 Relation to the general theorem.`
- RAW: ```
In the notation of Theorem 1, the control parameter is identified with the coupling strength λ ≡ K . For each system size N and each value of K , we construct a random persistence diagram D N ( K,t ) at time t by applying Vietoris–Rips persistent homology to the pairwise synchronicity matrix Φ( t ) = ( ϕ i,j ( t )) , interpreted as a time-dependent distance matrix.```
  FIX: ```
In the notation of Theorem 1, the control parameter is identified with the coupling strength \( \lambda \equiv K \). For each system size \( N \) and each value of \( K \), we construct a random persistence diagram \( D_N(K,t) \) at time \( t \) by applying Vietoris–Rips persistent homology to the pairwise synchronicity matrix \( \Phi(t) = (\phi_{i,j}(t)) \), interpreted as a time-dependent distance matrix.```
- RAW: ```
From the viewpoint of Theorem 1, the temporal evolution of persistent entropy can be interpreted as tracking the convergence of the time-dependent persistence diagrams D N ( K,t ) toward the limiting diagram associated with the synchronized phase.```
  FIX: ```
From the viewpoint of Theorem 1, the temporal evolution of persistent entropy can be interpreted as tracking the convergence of the time-dependent persistence diagrams \( D_N(K,t) \) toward the limiting diagram associated with the synchronized phase.```
- RAW: ```
Accordingly, we define a topological transition time t ∗ ( K ) as the earliest time at which persistent entropy becomes stable within a prescribed tolerance over a sliding window.```
  FIX: ```
Accordingly, we define a topological transition time \( t^*(K) \) as the earliest time at which persistent entropy becomes stable within a prescribed tolerance over a sliding window.```
