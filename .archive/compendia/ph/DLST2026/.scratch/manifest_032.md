# Manifest: Page 032

## REPAIR_MATH
- RAW: ```
\mathfrak { B } _ { 0 , 1 } \coloneqq ( \mathcal { B } _ { 0 } , \mathcal { V } _ { 0 } ) = ( \mathcal { B } _ { 0 ^ { \prime } } , \mathcal { V } _ { 0 } ) \sqsubseteq ( \mathcal { B } _ { 0 ^ { \prime \prime } } , \mathcal { V } _ { 0 } ) \sqsubseteq \dots \sqsubseteq ( \mathcal { B } _ { 0 ^ { ( n ) } } , \mathcal { V } _ { 0 } ) = ( \mathcal { B } _ { 1 } , \mathcal { V } _ { 1 } ) .
```
  FIX: ```
$$
\mathfrak { B } _ { 0 , 1 } \coloneqq ( \mathcal { B } _ { 0 } , \mathcal { V } _ { 0 } ) = ( \mathcal { B } _ { 0 ^ { \prime } } , \mathcal { V } _ { 0 } ) \sqsubseteq ( \mathcal { B } _ { 0 ^ { \prime \prime } } , \mathcal { V } _ { 0 } ) \sqsubseteq \dots \sqsubseteq ( \mathcal { B } _ { 0 ^ { ( n ) } } , \mathcal { V } _ { 0 } ) = ( \mathcal { B } _ { 1 } , \mathcal { V } _ { 1 } ) .
$$
```
- RAW: ```
\mathfrak { B } _ { 0 , 1 } \mathfrak { B } _ { 1 , 2 } \dots \mathfrak { B } _ { T - 1 , T } ,
```
  FIX: ```
$$
\mathfrak { B } _ { 0 , 1 } \mathfrak { B } _ { 1 , 2 } \dots \mathfrak { B } _ { T - 1 , T } ,
$$
```
- RAW: ```
( \mathcal { B } _ { \lambda } , \mathcal { V } _ { \lambda } ) \supseteq ( \mathcal { B } _ { \lambda + 1 ^ { ( n ) } } , \mathcal { V } _ { \lambda + 1 } ) \supseteq \dots \equiv ( \mathcal { B } _ { \lambda + 1 ^ { \prime \prime } } , \mathcal { V } _ { \lambda + 1 } ) \supseteq ( \mathcal { B } _ { \lambda + 1 ^ { \prime } } , \mathcal { V } _ { \lambda + 1 } ) = ( \mathcal { B } _ { \lambda + 1 } , \mathcal { V } _ { \lambda + 1 } ) .
```
  FIX: ```
$$
( \mathcal { B } _ { \lambda } , \mathcal { V } _ { \lambda } ) \supseteq ( \mathcal { B } _ { \lambda + 1 ^ { ( n ) } } , \mathcal { V } _ { \lambda + 1 } ) \supseteq \dots \equiv ( \mathcal { B } _ { \lambda + 1 ^ { \prime \prime } } , \mathcal { V } _ { \lambda + 1 } ) \supseteq ( \mathcal { B } _ { \lambda + 1 ^ { \prime } } , \mathcal { V } _ { \lambda + 1 } ) = ( \mathcal { B } _ { \lambda + 1 } , \mathcal { V } _ { \lambda + 1 } ) .
$$
```
- RAW: ```
5.3. Transition diagram for a non-basic zigzag filtration. Our strategy for the general, non-basic zigzag filtration B is to reduce it to the basic case and to apply the procedure from the previous section.
```
  FIX: ```
5.3. Transition diagram for a non-basic zigzag filtration. Our strategy for the general, non-basic zigzag filtration \( \mathfrak{B} \) is to reduce it to the basic case and to apply the procedure from the previous section.
```
- RAW: ```
Definition 5.17 (AR-cascade) . Consider two block decompositions such that ( B 0 , V 0 ) ⊑ ( B 1 , V 1 ). An AR-cascade from B 0 to B 1 is a basic filtration of block decompositions
```
  FIX: ```
Definition 5.17 (AR-cascade). Consider two block decompositions such that \( ( \mathcal{B}_0, \mathcal{V}_0 ) \sqsubseteq ( \mathcal{B}_1, \mathcal{V}_1 ) \). An AR-cascade from \( \mathcal{B}_0 \) to \( \mathcal{B}_1 \) is a basic filtration of block decompositions
```
- RAW: ```
In other words, whenever we observe a refinement of B q, 1 into more than two blocks in B 0 , we decompose the split into a sequence of attractor-repeller decompositions leading to a basic filtration. As it follows from the proposition below, it is always possible to merge two elements into a coarser isolating block. An iterative application of the result leads to an AR-cascade.
```
  FIX: ```
In other words, whenever we observe a refinement of \( \mathcal{B}_{q,1} \) into more than two blocks in \( \mathcal{B}_0 \), we decompose the split into a sequence of attractor-repeller decompositions leading to a basic filtration. As it follows from the proposition below, it is always possible to merge two elements into a coarser isolating block. An iterative application of the result leads to an AR-cascade.
```
- RAW: ```
Proposition 5.18. Let ( B 0 , V 0 ) ⊑ ( B 1 , V 1 ), q ∈ P 1 and Q : = −→ ι − 1 ( q ). Then, Q is convex in P 0 . Assume that | Q | ≥ 2 and { p,p ′ } is a convex subset of Q . Then, B 0 ′ : = B 0 \ { B p, 0 ,B p ′ , 0 } ∪ { C V 0 ( { B p, 0 ,B p ′ , 0 } ,X ) } is again a block decomposition. Moreover, ( B 0 , V 0 ) ⊑ ( B 0 ′ , V 0 ) ⊑ ( B 1 , V 1 ).
```
  FIX: ```
Proposition 5.18. Let \( ( \mathcal{B}_0, \mathcal{V}_0 ) \sqsubseteq ( \mathcal{B}_1, \mathcal{V}_1 ) \), \( q \in P_1 \) and \( Q \coloneqq \vec{\iota}^{-1}(q) \). Then, \( Q \) is convex in \( P_0 \). Assume that \( |Q| \ge 2 \) and \( \{ p,p' \} \) is a convex subset of \( Q \). Then, \( \mathcal{B}_0' \coloneqq \mathcal{B}_0 \setminus \{ B_{p,0}, B_{p',0} \} \cup \{ C_{\mathcal{V}_0}( \{ B_{p,0}, B_{p',0} \}, X ) \} \) is again a block decomposition. Moreover, \( ( \mathcal{B}_0, \mathcal{V}_0 ) \sqsubseteq ( \mathcal{B}_0', \mathcal{V}_0 ) \sqsubseteq ( \mathcal{B}_1, \mathcal{V}_1 ) \).
```
- RAW: ```
Consider an arbitrary zigzag filtration B = { ( B λ , V λ ) } λ ∈ Λ , where Λ = [0 ,T ] Z . A simplified zigzag filtration for B is a basic zigzag filtration:
```
  FIX: ```
Consider an arbitrary zigzag filtration \( \mathfrak{B} = \{ (\mathcal{B}_\lambda, \mathcal{V}_\lambda) \}_{\lambda \in \Lambda} \), where \( \Lambda = [0, T]_{\mathbb{Z}} \). A simplified zigzag filtration for \( \mathfrak{B} \) is a basic zigzag filtration:
```
- RAW: ```
- in the ( B λ , V λ ) ⊑ ( B λ +1 , V λ +1 ) case: ( B λ , V λ ) = ( B λ ′ , V λ ) ⊑ ( B λ ′′ , V λ ) ⊑ ... ⊑ ( B λ ( n ) , V λ ) ⊑ ( B λ +1 , V λ +1 ) .
```
  FIX: ```
- in the \( ( \mathcal{B}_\lambda, \mathcal{V}_\lambda ) \sqsubseteq ( \mathcal{B}_{\lambda+1}, \mathcal{V}_{\lambda+1} ) \) case: \( ( \mathcal{B}_\lambda, \mathcal{V}_\lambda ) = ( \mathcal{B}_{\lambda'}, \mathcal{V}_\lambda ) \sqsubseteq ( \mathcal{B}_{\lambda''}, \mathcal{V}_\lambda ) \sqsubseteq \dots \sqsubseteq ( \mathcal{B}_{\lambda^{(n)}}, \mathcal{V}_\lambda ) \sqsubseteq ( \mathcal{B}_{\lambda+1}, \mathcal{V}_{\lambda+1} ) \).
```
- RAW: ```
- in the ( B λ , V λ ) ⊒ ( B λ +1 , V λ +1 ) case:
```
  FIX: ```
- in the \( ( \mathcal{B}_\lambda, \mathcal{V}_\lambda ) \sqsupseteq ( \mathcal{B}_{\lambda+1}, \mathcal{V}_{\lambda+1} ) \) case:
```
- RAW: ```
Example 5.19. Consider B 3 ⊒ B 4 step of the zigzag filtration in Example 5.3 , where the isolating block B ◦ , 3 ∈ B 3 splits into { B □ , 4 ,B γ, 4 ,B β, 4 ,B α, 4 ,B • 4 } ⊂ B 4 . By Proposition 5.18 we can turn B 3 ⊒ B 4 into an AR-cascade ( B 3 , V 3 ) ⊒ ( B 4 ′′ , V 4 ) ⊒ ( B 4 ′ , V 4 ) ⊒ ( B 4 , V 4 ). One possibility is presented in Figure 18 . Block decomposition B 4 ′ is obtained by merging B □ , 4 and B γ, 4 into B □ , 4 ′ , and by merging B • , 4 and B α, 4 into B • , 4 ′ . The block decomposition B 4 ′′ is obtained by merging B • , 4 ′ and B β, 4 ′ from B 4 ′ into B • , 4 ′′ .
```
  FIX: ```
Example 5.19. Consider \( \mathcal{B}_3 \sqsupseteq \mathcal{B}_4 \) step of the zigzag filtration in Example 5.3, where the isolating block \( B_{\circ, 3} \in \mathcal{B}_3 \) splits into \( \{ B_{\square, 4}, B_{\gamma, 4}, B_{\beta, 4}, B_{\alpha, 4}, B_{\bullet, 4} \} \subset \mathcal{B}_4 \). By Proposition 5.18 we can turn \( \mathcal{B}_3 \sqsupseteq \mathcal{B}_4 \) into an AR-cascade \( ( \mathcal{B}_3, \mathcal{V}_3 ) \sqsupseteq ( \mathcal{B}_4'', \mathcal{V}_4 ) \sqsupseteq ( \mathcal{B}_4', \mathcal{V}_4 ) \sqsupseteq ( \mathcal{B}_4, \mathcal{V}_4 ) \). One possibility is presented in Figure 18. Block decomposition \( \mathcal{B}_4' \) is obtained by merging \( B_{\square, 4} \) and \( B_{\gamma, 4} \) into \( B_{\square, 4}' \), and by merging \( B_{\bullet, 4} \) and \( B_{\alpha, 4} \) into \( B_{\bullet, 4}' \). The block decomposition \( \mathcal{B}_4'' \) is obtained by merging \( B_{\bullet, 4}' \) and \( B_{\beta, 4}' \) from \( \mathcal{B}_4' \) into \( B_{\bullet, 4}'' \).
```
- RAW: ```
With the simplified zigzag filtration for B we can finish the transition diagram we started to construct in Example 5.15 . It is shown in Figure 19 . ♢
```
  FIX: ```
With the simplified zigzag filtration for \( \mathfrak{B} \) we can finish the transition diagram we started to construct in Example 5.15. It is shown in Figure 19. \( \Diamond \)
```
- RAW: ```
Remark 5.20 . One should view the above expansion of zigzag filtration analogously to the approach in standard persistence. In practice, for a filtration of complexes K 0 ⊂ K 1 ⊂ ... ⊂ K n we expand the sequence implicitly so that in each step a single cell is added. The chosen order determines the basis and may change the pairing of cells in the algorithm. It does not affect the final persistence
```
  FIX: ```
Remark 5.20. One should view the above expansion of zigzag filtration analogously to the approach in standard persistence. In practice, for a filtration of complexes \( K_0 \subset K_1 \subset \dots \subset K_n \) we expand the sequence implicitly so that in each step a single cell is added. The chosen order determines the basis and may change the pairing of cells in the algorithm. It does not affect the final persistence
```
