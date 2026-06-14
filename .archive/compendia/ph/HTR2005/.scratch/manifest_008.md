# Manifest: Page 008

## REPAIR_MATH
- RAW: ```
L _ { k + 1 , j } \colon = Q ^ { 0 } ( y _ { 0 j } | k + 1 ) \, = \, \sum _ { h = k } ^ { j - 1 } Q ^ { 0 } ( y _ { 0 h } | k ) Q ^ { 0 } ( y _ { h j } | 1 ) \, = \, \sum _ { h = k } ^ { j - 1 } L _ { k h } A _ { h j } ^ { 0 } \\ \text {That is (apart from binomial factors) the evidence of } y _ { 0 j } \text { with } k + 1 \text { segments equals}
```
  FIX: ```
$$
L_{k+1, j} := Q^0(y_{0j}|k+1) = \sum_{h=k}^{j-1} Q^0(y_{0h}|k) Q^0(y_{hj}|1) = \sum_{h=k}^{j-1} L_{kh} A^0_{hj}
$$
```
- RAW: ```
R _ { k + 1 , i } \colon = Q ^ { 0 } ( y _ { i n } | k + 1 ) \, = \, \sum _ { h = i + 1 } ^ { n - k } Q ^ { 0 } ( y _ { i h } | 1 ) Q ^ { 0 } ( y _ { h n } | k ) \, = \, \sum _ { h = i + 1 } ^ { n - k } A _ { i h } ^ { 0 } R _ { k h } \\ \intertext { T h e r c u r s i n t s with $R _ { k } = A ^ { 0 } $ o r m o r e n v i e n t y i t h e w $ R _ { k } = \delta $ }
```
  FIX: ```
$$
R_{k+1, i} := Q^0(y_{in}|k+1) = \sum_{h=i+1}^{n-k} Q^0(y_{ih}|1) Q^0(y_{hn}|k) = \sum_{h=i+1}^{n-k} A^0_{ih} R_{kh}
$$
```
- RAW: ```
L _ { k n } \, = \, R _ { k 0 } \, = \, Q ^ { 0 } ( y | k ) \, = \, ( \, ^ { n - 1 } _ { k - 1 } ) P ( y | k ) \\
```
  FIX: ```
$$
L_{kn} = R_{k0} = Q^0(y|k) = \binom{n-1}{k-1} P(y|k)
$$
```
- RAW: ```
E \, \colon = \, P ( y ) \, = \, \sum _ { k = 1 } ^ { n } P ( y | k ) P ( k ) \, = \, \frac { 1 } { k _ { \max } } \sum _ { k = 1 } ^ { k _ { \max } } \frac { L _ { k n } } { \binom { n - 1 } { k - 1 } } \\ \intertext { e s t a r i o n f k i n d i t s a M A p e s t i m a t e r a n }
```
  FIX: ```
$$
E := P(y) = \sum_{k=1}^n P(y|k) P(k) = \frac{1}{k_{\max}} \sum_{k=1}^{k_{\max}} \frac{L_{kn}}{\binom{n-1}{k-1}}
$$
```
- RAW: ```
C _ { k } \, \colon = \, P ( k | y ) \, = \, \frac { P ( y | k ) P ( k ) } { P ( y ) } \, = \, \frac { L _ { k n } } { ( \binom { n - 1 } { k - 1 } k _ { \max } E } \quad \text {and} \quad \hat { k } = \arg \max _ { k = 1 . . k _ { \max } } C _ { k } \quad ( 1 8 ) }
```
  FIX: ```
$$
C_k := P(k|y) = \frac{P(y|k) P(k)}{P(y)} = \frac{L_{kn}}{\binom{n-1}{k-1} k_{\max} E} \quad \text{and} \quad \hat{k} = \arg\max_{k=1..k_{\max}} C_k \tag{18}
$$
```
- RAW: ```
( \begin{matrix} n ^ { - 1 } _ { k } ) P ( y , \mu , t _ { p } | k ) \, = \, Q ( y _ { 0 h } , \mu _ { 0 p } | p ) Q ( y _ { h n } , \mu _ { p k } | k - p ) \\ \end{matrix} & \\
```
  FIX: ```
$$
\binom{n-1}{k-1} P(y, \mu, t_p | k) = Q(y_{0h}, \mu_{0p} | p) Q(y_{hn}, \mu_{pk} | k-p)
$$
```
- RAW: ```
( \begin{matrix} n - 1 \\ k - 1 \end{matrix} ) P ( y , t _ { p } | k ) \, = \, Q ^ { 0 } ( y _ { 0 h } | p ) Q ^ { 0 } ( y _ { h n } | k - p )
```
  FIX: ```
$$
\binom{n-1}{k-1} P(y, t_p | k) = Q^0(y_{0h} | p) Q^0(y_{hn} | k-p)
$$
```
- RAW: ```
B _ { p h } \, \colon = \, P ( t _ { p } = h | y , \hat { k } ) \, = \, \frac { ( \stackrel { n - 1 } { \hat { k } } _ { - 1 } ) P ( y , t _ { p } | \hat { k } ) } { ( \stackrel { n - 1 } { \hat { k } } _ { - 1 } ) P ( y | \hat { k } ) } \, = \, \frac { L _ { p h } R _ { \hat { k } - p , h } } { L _ { \hat { k } n } }
```
  FIX: ```
$$
B_{ph} := P(t_p = h | y, \hat{k}) = \frac{\binom{n-1}{\hat{k}-1} P(y, t_p | \hat{k})}{\binom{n-1}{\hat{k}-1} P(y | \hat{k})} = \frac{L_{ph} R_{\hat{k}-p, h}}{L_{\hat{k} n}}
$$
```

## REPAIR_PROSE
- RAW: `That is (apart from binomial factors) the evidence of y 0 j with k +1 segments equals the evidence of y 0 h with k segments times the single-segment evidence of y hj , summed over all locations h of boundary k . The recursion starts with L 1 j = A 0 0 j , or more conveniently with L 0 j = δ j 0 . We also need a right recursion for r =0, j = n , p − l =1, m − p = k : n − k n − k`
  FIX: `That is (apart from binomial factors) the evidence of \(y_{0j}\) with \(k+1\) segments equals the evidence of \(y_{0h}\) with \(k\) segments times the single-segment evidence of \(y_{hj}\), summed over all locations \(h\) of boundary \(k\). The recursion starts with \(L_{1j} = A^0_{0j}\), or more conveniently with \(L_{0j} = \delta_{j0}\). We also need a right recursion for \(r=0, j=n, p-l=1, m-p=k\):`
- RAW: `The recursion starts with R 1 n = A 0 in , or more conveniently with R 0 i = δ in .`
  FIX: `The recursion starts with \(R_{1n} = A^0_{in}\), or more conveniently with \(R_{0i} = \delta_{in}\).`
- RAW: `are proportional to the data evidence for ﬁxed k . So the data evidence can be computed as`
  FIX: `are proportional to the data evidence for ﬁxed \(k\). So the data evidence can be computed as`
- RAW: `The posterior of k and its MAP estimate are`
  FIX: `The posterior of \(k\) and its MAP estimate are`
- RAW: `Segment boundaries. We now determine the segment boundaries. Consider recursion (12) for i = l =0, m = k , j = n , but keep t p = h ﬁxed, i.e. do not sum over it. Then (13) and (14) reduce to the l.h.s. and r.h.s. of`
  FIX: `Segment boundaries. We now determine the segment boundaries. Consider recursion (12) for \(i=l=0, m=k, j=n\), but keep \(t_p=h\) ﬁxed, i.e. do not sum over it. Then (13) and (14) reduce to the l.h.s. and r.h.s. of`
- RAW: `Integration over µ gives`
  FIX: `Integration over \(\mu\) gives`
- RAW: `Hence the posterior probability that boundary p is located at t p = h , given ˆ k , is`
  FIX: `Hence the posterior probability that boundary \(p\) is located at \(t_p=h\), given \(\hat{k}\), is`
