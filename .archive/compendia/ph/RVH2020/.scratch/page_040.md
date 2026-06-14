[Page 40]

A classical consequence of the monotonicity of $\gamma$ is that it implies that $\mathcal{G}(\gamma)$ has a maximal and a minimal element. This substantially simplifies the characterization of uniqueness. The following standard result (see, for example, [5, section 4.3.3]) makes this idea precise. In the sequel, we define the maximal and minimal configurations $+ , - \in \{-1, 1\}^{\mathbb{Z}^d}$ as $+_v = 1$ and $-_v = -1$ for all $v \in \mathbb{Z}^d$; moreover, a function $f : \{-1, 1\}^{\mathbb{Z}^d} \to \mathbb{R}$ is said to be local if it depends only on a finite number of coordinates.

Lemma 5.15. Suppose that $\gamma$ is monotone. There exist laws $P_+, P_-$ in $\mathcal{G}(\gamma)$ such that

$$
( \gamma _ { V } f ) ( - ) \uparrow \mathbf E _ { - } [ f ( X ) ] \ \ a n d \ \ ( \gamma _ { V } f ) ( + ) \downarrow \mathbf E _ { + } [ f ( X ) ] \ \ a s \ \ V \uparrow \mathbb { Z } ^ { d }
$$

for every local increasing function $f$. Moreover,

$$
E _ { - } [ f ( X ) ] \leq E [ f ( X ) ] \leq E _ { + } [ f ( X ) ]
$$

for every $P$ in $\mathcal{G}(\gamma)$ and local increasing function $f$. In particular, $|\mathcal{G}(\gamma)| = 1$ iff $P_+ = P_-$.

Proof. Let $f$ be a bounded increasing function and let $W \subset V \Subset \mathbb{Z}^d$. As $\gamma_W f$ is increasing and $\gamma_V = \gamma_V \gamma_W$, we readily obtain $\gamma_W f(-) \leq \gamma_V f \leq \gamma_W f(+)$. Thus the net $(\gamma_V f(-))_{V \Subset \mathbb{Z}^d}$ is increasing and the net $(\gamma_V f(+))_{V \Subset \mathbb{Z}^d}$ is decreasing.

Now note that $\{-1, 1\}^{\mathbb{Z}^d}$ is compact and metrizable (for the product topology). Thus $(\gamma_V(-, \cdot))_{V \Subset \mathbb{Z}^d}$ and $(\gamma_V(+, \cdot))_{V \Subset \mathbb{Z}^d}$ are precompact for the weak convergence topology. In particular, we can choose a cofinal increasing sequence $V_n \Subset \mathbb{Z}^d$ such that $\gamma_{V_n}(-, \cdot) \to P_-$ and $\gamma_{V_n}(+, \cdot) \to P_+$ weakly for some probability measures $P_-$ and $P_+$, respectively. By the above monotonicity, it follows readily that

$$
\lim _ { V \subset \mathbb { C } ^ { Z ^ { d } } } ( \gamma _ { V } f ) ( - ) = E _ { - } [ f ( X ) ] \ \text { and } \ \lim _ { V \subset \mathbb { C } ^ { Z ^ { d } } } ( \gamma _ { V } f ) ( + ) = E _ { + } [ f ( X ) ]
$$

for every local increasing function $f$. Moreover, for any measure $P$ in $\mathcal{G}(\gamma)$, we have

$$
E _ { - } [ f ( X ) ] = \lim _ { V \subset \mathbb { Z } ^ { d } } ( \gamma _ { V } f ) ( - ) \leq \lim _ { V \subset \mathbb { Z } ^ { d } } E [ ( \gamma _ { V } f ) ( X ) ] = E [ f ( X ) ]
$$

for every local increasing function $f$, and similarly for the upper bound.

We now argue that $P_-$ and $P_+$ are in fact in $\mathcal{G}(\gamma)$. To this end, fix any $W \Subset \mathbb{Z}^d$. As $W \subset V_n$ for all $n$ sufficiently large (as $\{V_n\}$ is cofinal), and as $\gamma_W f$ is local if $f$ is local (by the Markov property of the random field), we can write

$$
\mathbf E _ { - } [ g ( X _ { W ^ { c } } ) \left ( \gamma _ { W } f ) ( X ) ] = \lim _ { n \to \infty } ( \gamma _ { V _ { n } } \gamma _ { W } f g ) ( - ) = \lim _ { n \to \infty } ( \gamma _ { V _ { n } } f g ) ( - ) = \mathbf E _ { - } [ g ( X _ { W ^ { c } } ) \, f ( X ) ]
$$

for all local functions $f, g$. Thus $\mathbf{E}_-[f(X) \mid X_{W^c}] = (\gamma_W f)(X)$ for all $W \Subset \mathbb{Z}^d$, which implies that $P_-$ is in $\mathcal{G}(\gamma)$. The conclusion for $P_+$ follows identically.

Finally, we argue that $|\mathcal{G}(\gamma)| = 1$ iff $P_+ = P_-$. If $P_+ \neq P_-$, then evidently $|\mathcal{G}(\gamma)| \geq 2$. On the other hand, if $P_+ = P_-$, then the expectation of every local increasing function must coincide for all $\gamma$-specified random fields. But then all $\gamma$-specified random fields coincide, as the local increasing functions are measure-determining (the moment generating function $E[e^{\lambda_1 X_{v_1} + \dots + \lambda_m X_{v_m}}]$ determines uniquely the joint law of $X_{v_1}, \dots, X_{v_m}$, and $f(x_{v_1}, \dots, x_{v_m}) = e^{\lambda_1 x_{v_1} + \dots + \lambda_m x_{v_m}}$ is local and increasing for every $\lambda_1, \dots, \lambda_m \geq 0$).



We call $P_+$ and $P_-$ the maximal and minimal elements of $\mathcal{G}(\gamma)$. Now recall that if $\gamma$ is monotone, then so is $\gamma^y$. Thus $\mathcal{G}(\gamma^y)$ also has a maximal and a minimal element. The key step in the proof of Theorem 5.12 is the following observation due to Föllmer [19].
