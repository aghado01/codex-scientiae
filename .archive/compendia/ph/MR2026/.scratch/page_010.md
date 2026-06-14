[Page 10]

where $k = \{1, 2\}$ indicates the time regime and $\theta$ is the phase of the oscillator. The angular brackets refers to the average over the 20 simulations. The absolute value is imposed to simplify the interpretation of the coefficient. Since the networks are fully connected, their homology is trivial (i.e., only one connected component). Thus, the authors evaluated different thresholds for making the networks sparse. They highlighted the emergence of communities of oscillators and different topological structures between the two time regimes.

![In this image we can see a network.](<MR2026/imageFile1.png>)

Figure 1: Kuramoto Network with 50 oscillators. The network layout is produced with the Fruchterman Reingold plugin of Gephi and the colour of each node is proportional to the degree [5]. The network is one example of the possible realizations.

### 5.2.1 Kuramoto model: experimental setup

Following the same lines of [40], we simulated different instances of the model. The instances differed by the adjacency matrix and the initial conditions, i.e., phase and frequency of each oscillator. The adjacency matrix was a random binary symmetric matrix without self-loops ( $G_{i,i} = 0$ ). The initial frequencies were sampled from a Gaussian distribution with mean 0 and standard deviation 1, while the initial phases were sampled from a uniform distribution with values in $(0, 2\pi)$. We report here the results regarding the experiment with $N = 50$ oscillators. Network statistics are the following: number of nodes, 50; number of edges, 957; average degree, 38.28; density, 0.762. We integrated the Kuramoto models on 500 time points in the interval $T = [0, 10]$ ( $\Delta t = 0.02$ ) for different values of the coupling coefficient $K \in [0.0, 16]$ with step $0.5$. Each integration was repeated 10 times. The degree of synchronicity $r$ as well as the pairwise synchronicity coefficient $\phi_{i,j}$ were computed for each $K$ and for each time point.

### 5.2.2 Kuramoto model: experimental output analysis

Figure 2 summarizes the dynamical and figure 3 shows the topological behavior of the Kuramoto model across increasing values of the coupling strength $K$. For small coupling ( $K = 0$ and $K = 1$ ), the classical order parameter $r(t)$ remains low and fluctuating over time, indicating the absence of global synchronization. In this regime, the normalized persistent entropy $\text{NPE}(H_0)(t)$ exhibits sustained temporal variability and does not converge to a stable plateau, reflecting the persistent reconfiguration of connected components in the functional network induced by phase differences. Consistently, the corresponding persistence barcodes show a broad distribution of short-lived H 0 features and no stabilization in the filtration structure.
