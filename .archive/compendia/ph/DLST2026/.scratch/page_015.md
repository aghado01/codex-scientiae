[Page 15]





![The image consists of a geometric figure, which appears to be a parallelogram. The figure is composed of two parallel sides and two congruent angles. The sides of the parallelogram are colored blue and green, respectively. The angles are colored in blue and green. The figure is divided into two parts, each containing a parallelogram with two sides and two angles.](<DLST2026/imageFile8.png>)






Figure 10. Examples of isolating blocks (brown sets) and isolated invariant sets (green sets) for a multivector field \( V \) from Figure 9. Four isolating blocks on the left panel form a block decomposition \( B \) of \( V \). The green sets on the right panel indicate the invariant parts of the isolating blocks in \( B \) forming a Morse decomposition. The graph on the middle panel represents the flow induced partial order for \( B \).

Note, that in the theory of continuous flows, an isolating block \( B \) is defined as a compact set with the closed exit set and no internal tangencies. In the combinatorial setting the only way to escape an isolating block is through its mouth, which by Proposition 4.3 has to be closed as well. Moreover, no path starting in an isolating block \( B \) can go to \( \text{mo } B \) and directly return to \( B \). This can be viewed as a counterpart of the “no internal tangencies” condition. The closedness of the isolating block, however, must be abandoned due to sparsity inherent in finite topological spaces.

4.2. Morse and block decomposition. Let \( \varphi \) be a full solution in \( V \). We define the ultimate backward and forward images of \( \varphi \):

$$
\begin{aligned}
\text{uim}^- \varphi &\coloneqq \bigcap_{t \le 0} \varphi((-\infty, t]) \\
&= \bigcap_{t < 0} \varphi((-\infty, t]) \\
&= \bigcap_{t < 0} \varphi([t, +\infty]), \\
\text{uim}^+ \varphi &\coloneqq \bigcap_{t > 0} \varphi([t, +\infty)).
\end{aligned}
$$

Clearly, since the space \( X \) is finite, the ultimate images are always non-empty.

Definition 4.7. (Morse decomposition) [33, Definition 7.1] A collection \( ( M , P ) \coloneqq \{ M_p \mid p \in P \} \) of mutually disjoint, non-empty isolated invariant sets is called a Morse decomposition of \( S \subset X \) in \( V \) if there exists a partial order \( ( P , \leq ) \) such that

- (M1) for every \( \varphi \in \text{eSol}_V ( S ) \) there exist \( p, q \in P \) such that \( \text{uim}^- \varphi \subset M_p \) and \( \text{uim}^+ \varphi \subset M_q \),
- (M2) if there exists \( \rho \in \text{Paths}_V ( S ) \) with \( \rho \in M_p \) and \( \rho \in M_q \) for some \( p, q \in P \) then either


- (a) \( p > q \), or
- (b) \( p = q \) and \( \text{im } \rho \subset M_p \).


The primary goal of this work is to study the evolution of a Morse decomposition. However, in order to study continuation it is preferable to shift our attention from isolated invariant sets to isolating blocks. Therefore, we introduce the concept of a block decomposition, which we obtain by replacing isolated invariant sets with isolating blocks in Definition 4.7.
