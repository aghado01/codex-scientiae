[Page 32]

**Algorithm 2: Persistent entropy monitoring during neural network training**

```
Input:  Dataset D = {(x_i, y_i)^n_{i=1}; architecture A; training procedure Train
        (optimizer, epochs T, batch size, etc.); number of runs R; layer set L
        (hidden layers to monitor); embedding mode ∈ {Weights, Activations};
        PH degree k (typically k=1); filtration type VR (Vietoris-Rips);
        optional truncation threshold τ ≥ 0; loss-binning scheme B.
Output: Histories {H^(r)}^R_{r=1} with tuples (t, L^(r)(t), PE^(r)_k(t));
        optional binned curves PE_k(ℓ) with confidence intervals.

for r = 1 to R do
    Initialize network parameters θ^(r)(0) with random seed s_r;
    Initialize empty history H^(r) ← [];
    for t = 1 to T do
        // 1) Perform one training epoch/step
        θ^(r)(t) ← Train_{A,D}(θ^(r)(t−1));
        Compute training loss L^(r)(t);
        // 2) Build a point cloud from the chosen embedding
        if mode = Weights then
            Construct point cloud X^(r)(t) = ∪_{ℓ∈L} {w^(r)_{j,ℓ}(t)}^{m_ℓ}_{j=1};
        else
            Choose a fixed probe subset D_probe ⊂ D;
            Construct X^(r)(t) = ∪_{ℓ∈L} {a^(r)_ℓ(x; t) : x ∈ D_probe};
        // 3) Compute distances and persistent homology
        Compute pairwise distances d^(r)(t) on X^(r)(t) (e.g., Euclidean);
        Build Vietoris-Rips filtration VR(X^(r)(t), d^(r)(t));
        Compute persistence diagram D^(r)_k(t) in degree k;
        // 4) Compute persistent entropy (with optional truncation)
        Extract lifetimes {ℓ_i} from D^(r)_k(t), where ℓ_i = d_i − b_i;
        if τ > 0 then Discard bars with ℓ_i < τ;
        L ← Σ_i ℓ_i;
        if L = 0 then PE^(r)_k(t) ← 0;
        else p_i ← ℓ_i/L; PE^(r)_k(t) ← −Σ_i p_i log p_i;
        Append (t, L^(r)(t), PE^(r)_k(t)) to H^(r);
    // 5) Aggregate across runs using loss as effective control parameter
    if B ≠ ∅ then
        Pool all pairs (L^(r)(t), PE^(r)_k(t)) across r,t;
        Partition loss values into bins B = {B_1, ..., B_M};
        for m = 1 to M do
            Compute mean PE_k(B_m) and uncertainty (e.g., 95% CI) over samples in B_m;
return {H^(r)}^R_{r=1} and (optionally) binned summaries PE_k(ℓ);
```
