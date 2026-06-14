# Manifest: Page 044

## REPAIR_MATH
- RAW: ```
H _ { d } ( N _ { 2 } , N _ { 1 } ) \, & \longleftrightarrow \, \frac { j _ { * } ^ { d } } { i _ { * } ^ { d } } \, \underset { \longleftrightarrow } { H } _ { d } ( N _ { 2 } , N _ { 0 } ) \\ k _ { * } ^ { d } = 0 \, & \longleftrightarrow \, \\ H _ { d } ( N _ { 1 } , N _ { 0 } )
```
  FIX: ```
$$
H _ { d } ( N _ { 2 } , N _ { 1 } ) \, & \longleftrightarrow \, \frac { j _ { * } ^ { d } } { i _ { * } ^ { d } } \, \underset { \longleftrightarrow } { H } _ { d } ( N _ { 2 } , N _ { 0 } ) \\ k _ { * } ^ { d } = 0 \, & \longleftrightarrow \, \\ H _ { d } ( N _ { 1 } , N _ { 0 } )
$$
```

- RAW: ```
Theorem 7.8. Let M be a Conley-Morse persistence module for the zigzag filtration of block decompositions B : = { ( B λ , V λ ) } λ ∈ Λ , where Λ = [0 ,T ] Z , and let S be the corresponding multiset of strings. Then,
```
  FIX: ```
Theorem 7.8. Let $M$ be a Conley-Morse persistence module for the zigzag filtration of block decompositions $B := \{ ( B_\lambda , V_\lambda ) \}_{\lambda \in \Lambda}$, where $\Lambda = [0, T] \cap \mathbb{Z}$, and let $S$ be the corresponding multiset of strings. Then,
```

- RAW: ```
( a ) A string (interval) u ∈ S cannot pass through the same time step λ ∈ Λ twice, that is, it is spanned along the horizontal filtration.
```
  FIX: ```
( a ) A string (interval) $u \in S$ cannot pass through the same time step $\lambda \in \Lambda$ twice, that is, it is spanned along the horizontal filtration.
```

- RAW: ```
- If B λ ⊑ B λ +1 (coarsening) then every string u ∈ S that is present at λ + 1 is also present in λ , i.e., no bar is born through a coarsening.
```
  FIX: ```
- • If $B_\lambda \sqsubseteq B_{\lambda + 1}$ (coarsening) then every string $u \in S$ that is present at $\lambda + 1$ is also present in $\lambda$, i.e., no bar is born through a coarsening.
```

- RAW: ```
- If B λ ⊑ B λ +1 (coarsening) then there is an even number of strings with the right endpoint at λ + 1, i.e., always an even number of bars dies through a coarsening. Moreover, each such string can be paired with another string of codimension 1.
```
  FIX: ```
- • If $B_\lambda \sqsubseteq B_{\lambda + 1}$ (coarsening) then there is an even number of strings with the right endpoint at $\lambda + 1$, i.e., always an even number of bars dies through a coarsening. Moreover, each such string can be paired with another string of codimension $1$.
```

- RAW: ```
- If B λ ⊒ B λ +1 (refinement), then there is an even number of strings with the left endpoint in column λ , i.e., always an even number of bars is born because of a refinement. Moreover, each such string can be paired with a string of codimension 1.
```
  FIX: ```
- • If $B_\lambda \sqsupseteq B_{\lambda + 1}$ (refinement), then there is an even number of strings with the left endpoint in column $\lambda$, i.e., always an even number of bars is born because of a refinement. Moreover, each such string can be paired with a string of codimension $1$.
```

- RAW: ```
We proceed now to prove ( c ) . Note that after applying the homology functor H d to TD , the only linear functions that are not isomorphisms are the ones corresponding to the AR-splits, the remaining ones come from the connecting sequences, which are isomorphisms by Theorem 4.22 . Note that, in practice, by following the procedure for constructing the transition diagram in Section 5 the situation where a node participates in two AR-splits (like in Figure 21 ) does not happen, instead we get two AR-splits connected by an isomorphism (like in Figure 23 ). For simplicity, our proof adopts the second case though it can be adjusted to the first, more general case.
```
  FIX: ```
We proceed now to prove ( c ) . Note that after applying the homology functor $H_d$ to $TD$, the only linear functions that are not isomorphisms are the ones corresponding to the AR-splits, the remaining ones come from the connecting sequences, which are isomorphisms by Theorem 4.22 . Note that, in practice, by following the procedure for constructing the transition diagram in Section 5 the situation where a node participates in two AR-splits (like in Figure 21 ) does not happen, instead we get two AR-splits connected by an isomorphism (like in Figure 23 ). For simplicity, our proof adopts the second case though it can be adjusted to the first, more general case.
```

- RAW: ```
Therefore we can focus on the AR-split to prove the result. We prove the case B λ ⊑ B λ +1 as the other is analogous. In this case, the AR-split diagram has the following structure:
```
  FIX: ```
Therefore we can focus on the AR-split to prove the result. We prove the case $B_\lambda \sqsubseteq B_{\lambda + 1}$ as the other is analogous. In this case, the AR-split diagram has the following structure:
```

## REPAIR_PROSE
- RAW: ```
- If B λ ⊒ B λ +1 (refinement) then every string u ∈ S that is present at λ is also present in λ + 1, i.e., no bar dies because of a refinement. ( c ) There are two symmetric cases:
```
  FIX: ```
- • If $B_\lambda \sqsupseteq B_{\lambda + 1}$ (refinement) then every string $u \in S$ that is present at $\lambda$ is also present in $\lambda + 1$, i.e., no bar dies because of a refinement.

( c ) There are two symmetric cases:
```
