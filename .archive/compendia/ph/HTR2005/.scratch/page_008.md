[Page 8]

$$
L_{k+1, j} := Q^0(y_{0j}|k+1) = \sum_{h=k}^{j-1} Q^0(y_{0h}|k) Q^0(y_{hj}|1) = \sum_{h=k}^{j-1} L_{kh} A^0_{hj}
$$

That is (apart from binomial factors) the evidence of y 0 j with k +1 segments equals the evidence of y 0 h with k segments times the single-segment evidence of y hj , summed over all locations h of boundary k . The recursion starts with L 1 j = A 0 0 j , or more conveniently with L 0 j = δ j 0 . We also need a right recursion for r =0, j = n , p − l =1, m − p = k : n − k n − k

$$
R_{k+1, i} := Q^0(y_{in}|k+1) = \sum_{h=i+1}^{n-k} Q^0(y_{ih}|1) Q^0(y_{hn}|k) = \sum_{h=i+1}^{n-k} A^0_{ih} R_{kh}
$$

The recursion starts with R 1 n = A 0 in , or more conveniently with R 0 i = δ in .

Quantities of interest. Note that

$$
L_{kn} = R_{k0} = Q^0(y|k) = \binom{n-1}{k-1} P(y|k)
$$

are proportional to the data evidence for ﬁxed k . So the data evidence can be computed as

$$
E := P(y) = \sum_{k=1}^n P(y|k) P(k) = \frac{1}{k_{\max}} \sum_{k=1}^{k_{\max}} \frac{L_{kn}}{\binom{n-1}{k-1}}
$$

The posterior of k and its MAP estimate are

$$
C_k := P(k|y) = \frac{P(y|k) P(k)}{P(y)} = \frac{L_{kn}}{\binom{n-1}{k-1} k_{\max} E} \quad \text{and} \quad \hat{k} = \arg\max_{k=1..k_{\max}} C_k \tag{18}
$$

Segment boundaries. We now determine the segment boundaries. Consider recursion (12) for i = l =0, m = k , j = n , but keep t p = h ﬁxed, i.e. do not sum over it. Then (13) and (14) reduce to the l.h.s. and r.h.s. of

$$
\binom{n-1}{k-1} P(y, \mu, t_p | k) = Q(y_{0h}, \mu_{0p} | p) Q(y_{hn}, \mu_{pk} | k-p)
$$

Integration over µ gives

$$
\binom{n-1}{k-1} P(y, t_p | k) = Q^0(y_{0h} | p) Q^0(y_{hn} | k-p)
$$

Hence the posterior probability that boundary p is located at t p = h , given ˆ k , is

$$
B_{ph} := P(t_p = h | y, \hat{k}) = \frac{\binom{n-1}{\hat{k}-1} P(y, t_p | \hat{k})}{\binom{n-1}{\hat{k}-1} P(y | \hat{k})} = \frac{L_{ph} R_{\hat{k}-p, h}}{L_{\hat{k} n}}
$$
