[Page 3]

Finally, we discuss broader implications of this framework for data-driven modeling and machine learning. Because persistent entropy provides a stable, low-dimensional summary of global topological structure [17, 18], it offers a principled way to incorporate physically meaningful inductive biases into learning algorithms and to monitor qualitative changes in learned representations during training. In this sense, the present work bridges topological data analysis, statistical physics, and machine learning, providing both a theoretical foundation and a practical methodology for entropy-based detection of phase transitions in complex systems.

## 2 Related work and state of the art

### 2.1 Persistent entropy

Topological data analysis (TDA), and persistent homology in particular, has emerged as a powerful framework for studying complex data arising from dynamical systems. Persistent homology provides a multiscale description of topological features and is equipped with strong stability guarantees under perturbations of the input. These properties have motivated its application to the detection of regime changes and phase transitions in a variety of systems, including synchronization phenomena, collective motion, and critical dynamics. In most cases, evidence that persistent homology detects phase transitions is empirical, relying on numerical experiments that show qualitative changes in persistence diagrams or summary statistics across parameter regimes. Persistent entropy (PE) was introduced as an information-theoretic summary of persistence barcodes, defined as the Shannon entropy of normalized persistence lifetimes. It provides a low-dimensional, noise-robust descriptor of topological complexity and has been successfully applied in many contexts, including time series analysis, biological systems, and networked dynamical systems. Its computational simplicity makes it particularly attractive for large-scale simulations and experimental data. Several studies have reported that PE varies sharply across phase transitions and correlates with classical order parameters, suggesting its potential role as a topological indicator of critical behavior.

**Definition 1 (Persistent Entropy).** Let $D = \{ (b_i, d_i) \}_{i=1}^m$ be a persistence diagram in a fixed homological degree, with finite lifetimes $\ell_i = d_i - b_i > 0$. Define the total lifetime

$$
L = \sum_{i=1}^{m} \ell_i.
$$

If $m = 0$, we set $PE(D) = 0$. Otherwise, define probabilities

$$
p_i = \frac{\ell_i}{L},
$$

and the persistent entropy

$$
PE(D) = -\sum_{i=1}^{m} p_i \log p_i.
$$

This is the Shannon entropy of the normalized lifetime distribution. Variants such as normalized persistent entropy can be treated analogously.
