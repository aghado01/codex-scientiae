[Page 17]

Proof. The functor $\operatorname{Lan}_{\tilde{i}}$ preserves direct sums MacLane (1971), as it is left-adjoint to the canonical restriction functor. The restriction functor also preserves direct sums. These two facts combined with Lemma A.8 give the result.

Definition A.10. Let $\mathbf{I}(\mathbb{Z}\mathbb{Z} \times \mathbb{Z})$ denote the collection of all subposets in $\mathbb{Z}\mathbb{Z} \times \mathbb{Z}$ such that their corresponding subposets in $\mathbb{Z}^2$ are intervals. Let $M$ and $N$ be two quasi zigzag persistence modules. The erosion distance is defined as:

$$
d _ { \mathcal { E } } ( M , N ) \colon = \inf _ { \epsilon \geq 0 } \{ \forall I \in \mathbf I ( \mathbb { Z } \mathbb { Z } \times \mathbb { Z } ) , \\ r k ^ { M } ( I ) \geq r k ^ { N } ( I ^ { \epsilon } ) \text { and } \\ r k ^ { N } ( I ) \geq r k ^ { M } ( I ^ { \epsilon } ) \}
$$

Definition A.11. Let $\mathcal{L}$ denote the collection of all worms in $\mathbb{Z}\mathbb{Z} \times \mathbb{Z}$. Let $M$ and $N$ be quasi zigzag persistence modules. The erosion distance can be defined as:

$$
d _ { \mathcal { E } } ^ { \mathcal { L } } ( M , N ) \coloneqq & \inf _ { \epsilon \geq 0 } \{ \forall \mathbf p \bigsqcup _ { \delta } ^ { 2 } \in I ( \mathbb { Z } \mathbb { Z } \times \mathbb { Z } ) , \\ & r k ^ { M } \left ( \boxed { \mathbf p } _ { \delta } ^ { 2 } \right ) \geq r k ^ { N } \left ( \boxed { \mathbf p } _ { \delta + \epsilon } ^ { 2 } \right ) \text { and } \\ & r k ^ { N } \left ( \boxed { \mathbf p } _ { \delta } ^ { 2 } \right ) \geq r k ^ { M } \left ( \boxed { \mathbf p } _ { \delta + \epsilon } ^ { 2 } \right ) \} . \\
$$

Proposition 3.6. Given two quasi zigzag persistence modules $M$ and $N$, $d_{\mathcal{E}}^{\mathcal{L}}(M,N) \leq d_{\mathcal{I}}(M,N)$ where $d_{\mathcal{I}}$ denotes the interleaving distance between $M$ and $N$.

Proof. First, it is obvious that $d_{\mathcal{E}}^{\mathcal{L}}(M,N) \leq d_{\mathcal{E}}(M,N)$. Now, $d_{\mathcal{I}}(M,N) \coloneqq d_{\mathcal{I}}(\tilde{E}(M), \tilde{E}(N))$. Let $I$ be a subposet in $\mathbb{Z}\mathbb{Z} \times \mathbb{Z}$ such that its corresponding subposet in $\mathbb{Z}^2$ is an interval. By Lemma A.8 and Lemma A.9, and the fact that generalized rank over a given subposet counts the number of intervals that contain the given subposet, we get $rk^M(I) = rk^{\tilde{E}(M)}(\tilde{i}(I) \cap \mathbb{U}\mathbb{U})$. This gives us $d_{\mathcal{E}}(M,N) = d_{\mathcal{E}}(\tilde{E}(M), \tilde{E}(N))$. In Kim & Mémoli (2021), the authors show that $d_{\mathcal{E}}(V,W) \leq d_{\mathcal{I}}(V,W)$, where $V,W \colon \mathbb{R}^n \to \mathbf{vec}$ are $\mathbb{R}^n$-indexed persistence modules. Thus, we get $d_{\mathcal{E}}^{\mathcal{L}}(M,N) \leq d_{\mathcal{E}}(M,N) = d_{\mathcal{E}}(\tilde{E}(M), \tilde{E}(N)) \leq d_{\mathcal{I}}(\tilde{E}(M), \tilde{E}(N)) = d_{\mathcal{I}}(M,N)$.

Theorem 3.7. Let $M$ and $N$ be two quasi zigzag persistence modules. Let $\lambda^M$ and $\lambda^N$ denote the $\mathbb{Z}\mathbb{Z}$-GRIL functions of $M$ and $N$ respectively. Then,

$$
| | \lambda ^ { M } - \lambda ^ { N } | | _ { \infty } = d _ { \mathcal { E } } ^ { \mathcal { L } } ( M , N ) \leq d _ { \mathcal { I } } ( M , N ) .
$$

Proof. We show that $|| \lambda^M - \lambda^N ||_\infty = d_{\mathcal{E}}^{\mathcal{L}}(M,N)$.

To see $|| \lambda^M - \lambda^N ||_\infty \leq d_{\mathcal{E}}^{\mathcal{L}}(M,N)$, fix $\mathbf{p}, k$, and let $\lambda^M(\mathbf{p}, k) = \delta_M$ and $\lambda^N(\mathbf{p}, k) = \delta_N$. WLOG, assume $\delta_M \geq \delta_N$. Let $d_{\mathcal{E}}^{\mathcal{L}}(M,N) = \epsilon$. Therefore, by definition of $d_{\mathcal{E}}^{\mathcal{L}}$, we have $rk^M \left(\boxed{\mathbf{p}}_{\delta_M}^2\right) = k$ and $rk^M \left(\boxed{\mathbf{p}}_{\delta_N + \epsilon}^2\right) \leq rk^N \left(\boxed{\mathbf{p}}_{\delta_N}^2\right) = k$. Thus, by the definition of $\mathbb{Z}\mathbb{Z}$-GRIL, we get $\delta_N + \epsilon \geq \delta_M$, i.e., $\delta_M - \delta_N \leq \epsilon = d_{\mathcal{E}}^{\mathcal{L}}$.

To see $|| \lambda^M - \lambda^N ||_\infty \geq d_{\mathcal{E}}^{\mathcal{L}}(M,N)$, fix $\mathbf{p}, k$, and let $| \lambda^M(\mathbf{p}, k) - \lambda^N(\mathbf{p}, k) | = \epsilon$. Let $\boxed{\mathbf{p}}_\delta^2$ be a worm. Let $k = rk^N \left(\boxed{\mathbf{p}}_{\delta + \epsilon}^2\right)$. Then, $\lambda^N(\mathbf{p}, k) \geq \delta + \epsilon$. Thus, $| \lambda^M(\mathbf{p}, k) - \lambda^N(\mathbf{p}, k) | = \epsilon$ and $\lambda^N(\mathbf{p}, k) \geq \delta + \epsilon$ give $\lambda^M(\mathbf{p}, k) \geq \delta$. Therefore, $rk^M \left(\boxed{\mathbf{p}}_\delta^2\right) \geq k = rk^N \left(\boxed{\mathbf{p}}_{\delta + \epsilon}^2\right)$. Similarly, we can show $rk^N \left(\boxed{\mathbf{p}}_\delta^2\right) \geq rk^M \left(\boxed{\mathbf{p}}_{\delta + \epsilon}^2\right)$. Thus, by definition of $d_{\mathcal{E}}^{\mathcal{L}}$, we get that $|| \lambda^M - \lambda^N ||_\infty \geq d_{\mathcal{E}}^{\mathcal{L}}(M,N)$.

## B Experimental Details

Here, we report additional details about our experiments. We begin by including a detailed description of the UEA datasets in Table 8. Further, we have a comparison of treating a multivariate time series as a sequence of point clouds versus treating it as a sequence of graphs as the input to the $\mathbb{Z}\mathbb{Z}$-GRIL framework. We report the results of this experiment in Table 4. We can see that there is no clear winner. On some datasets, $\mathbb{Z}\mathbb{Z}$-GRIL extracts more relevant information from sequences of point clouds while on some datasets, information from sequences of graphs performs better. We have a visualization of $\mathbb{Z}\mathbb{Z}$-GRIL in Figure 7. We can see in the figure that the $\mathbb{Z}\mathbb{Z}$-GRIL topological signature is different for samples of different classes and very similar for samples in the same class.
