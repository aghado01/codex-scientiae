# Manifest: Page 010

## REPAIR_MATH
None

## REPLACE_TABLES
None

## REPAIR_PROSE
- RAW: ```
where k = { 1 , 2 } indicates the time regime and θ is the phase of the oscillator. The angular brackets refers to the average over the 20 simulations. The absolute value is imposed to simplify the interpretation of the coeﬀicient.```
  FIX: ```
where \( k = \{1, 2\} \) indicates the time regime and \( \theta \) is the phase of the oscillator. The angular brackets refers to the average over the 20 simulations. The absolute value is imposed to simplify the interpretation of the coefficient.```
- RAW: `# 5.2.1 Kuramoto model: experimental setup`
  FIX: `### 5.2.1 Kuramoto model: experimental setup`
- RAW: ```
The adjacency matrix was a random binary symmetric matrix without self-loops ( G i,i = 0 ). The initial frequencies were sampled from a Gaussian distribution with mean 0 and standard deviation 1 , while the initial phases were sampled from a uniform distribution with values in (0 , 2 π ) . We report here the results regarding the experiment with N = 50 oscillators. Network statistics are the following: number of nodes, 50; number of edges, 957; average degree, 38.28; density, 0.762.```
  FIX: ```
The adjacency matrix was a random binary symmetric matrix without self-loops ( \( G_{i,i} = 0 \) ). The initial frequencies were sampled from a Gaussian distribution with mean 0 and standard deviation 1, while the initial phases were sampled from a uniform distribution with values in \( (0, 2\pi) \). We report here the results regarding the experiment with \( N = 50 \) oscillators. Network statistics are the following: number of nodes, 50; number of edges, 957; average degree, 38.28; density, 0.762.```
- RAW: ```
We integrated the Kuramoto models on 500 time points in the interval T = [0 , 10] ( ∆ t = 0 . 02 ) for different values of the coupling coeﬀicient K ∈ [0 . 0 , 16] with step 0 . 5 . Each integration was repeated 10 times. The degree of synchronicity r as well as the pairwise synchronicity coeﬀicient ϕ i,j were computed for each K and for each time point.```
  FIX: ```
We integrated the Kuramoto models on 500 time points in the interval \( T = [0, 10] \) ( \( \Delta t = 0.02 \) ) for different values of the coupling coefficient \( K \in [0.0, 16] \) with step \( 0.5 \). Each integration was repeated 10 times. The degree of synchronicity \( r \) as well as the pairwise synchronicity coefficient \( \phi_{i,j} \) were computed for each \( K \) and for each time point.```
- RAW: `# 5.2.2 Kuramoto model: experimental output analysis`
  FIX: `### 5.2.2 Kuramoto model: experimental output analysis`
- RAW: ```
Figure 2 summarizes the dynamical and figure 3 shows the topological behavior of the Kuramoto model across increasing values of the coupling strength K . For small coupling ( K = 0 and K = 1 ), the classical order parameter r ( t ) remains low and fluctuating over time, indicating the absence of global synchronization. In this regime, the normalized persistent entropy NPE( H 0 )( t ) exhibits sustained temporal variability and does not converge to a stable plateau, reflecting the persistent reconfiguration of connected components in the functional network induced by phase differences.```
  FIX: ```
Figure 2 summarizes the dynamical and figure 3 shows the topological behavior of the Kuramoto model across increasing values of the coupling strength \( K \). For small coupling ( \( K = 0 \) and \( K = 1 \) ), the classical order parameter \( r(t) \) remains low and fluctuating over time, indicating the absence of global synchronization. In this regime, the normalized persistent entropy \( \text{NPE}(H_0)(t) \) exhibits sustained temporal variability and does not converge to a stable plateau, reflecting the persistent reconfiguration of connected components in the functional network induced by phase differences.```
