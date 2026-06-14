# Manifest: Page 035

## REPAIR_PROSE
- RAW: `Proof. Assume the contrary that −→ ι ( p ′ ) = q ′ ̸ = q . Since −→ ι is an order preserving map, p < p ′ < p ′′ implies q < q ′ < q , which is a contradiction. □`
  FIX: `Proof. Assume the contrary that \( \overrightarrow{\iota}(p') = q' \neq q \). Since \( \overrightarrow{\iota} \) is an order preserving map, \( p < p' < p'' \) implies \( q < q' < q \), which is a contradiction. \(\square\)`

- RAW: `Proposition 5.23. For any linear extension of P 1 there exists a filtration consistent linear order on P 0 .`
  FIX: `Proposition 5.23. For any linear extension of \( P_1 \) there exists a filtration consistent linear order on \( P_0 \).`

- RAW: `Proof. Define a linear order on P 0 starting from the lowest element as follows: In increasing order, for each q ∈ P 1 , consider the set −→ ι − 1 ( q ). If it is nonempty, fix any linear order on that set consistent with the partial order on P 0 and append it to the growing sequence. If it is empty, skip it.`
  FIX: `Proof. Define a linear order on \( P_0 \) starting from the lowest element as follows: In increasing order, for each \( q \in P_1 \), consider the set \( \overrightarrow{\iota}^{-1}(q) \). If it is nonempty, fix any linear order on that set consistent with the partial order on \( P_0 \) and append it to the growing sequence. If it is empty, skip it.`

- RAW: `The obtained order on P 0 clearly is a linear extension. By construction, p < p ′ implies −→ ι ( p ) ≤ −→ ι ( p ′ ). □`
  FIX: `The obtained order on \( P_0 \) clearly is a linear extension. By construction, \( p < p' \) implies \( \overrightarrow{\iota}(p) \leq \overrightarrow{\iota}(p') \). \(\square\)`

- RAW: `Assume that P 0 = [1 ,m ] Z reflecting a linear order consistent with the filtration. For a p ∈ P 0 denote q p : = −→ ι ( p ). Then we define the sequence of closed sets:`
  FIX: `Assume that \( P_0 = [1, m]_{\mathbb{Z}} \) reflecting a linear order consistent with the filtration. For a \( p \in P_0 \) denote \( q_p := \overrightarrow{\iota}(p) \). Then we define the sequence of closed sets:`

- RAW: `where N 0 : = ∅ . This gives us a nested sequence of topological spaces. The two cases in formula ( 5.4 ) distinguish whether B p is the maximal element in the linear order among the sets merging into B q p , 1 . If B 0 and B 1 are block partitions, then the sequence becomes a filtration of X consistent with the chosen linear order on P 0 .`
  FIX: `where \( N_0 := \emptyset \). This gives us a nested sequence of topological spaces. The two cases in formula (5.4) distinguish whether \( B_p \) is the maximal element in the linear order among the sets merging into \( B_{q_p, 1} \). If \( B_0 \) and \( B_1 \) are block partitions, then the sequence becomes a filtration of \( X \) consistent with the chosen linear order on \( P_0 \).`

- RAW: `Proposition 5.24. If B 0 and B 1 are block partitions then N p = k ≤ p B k, 0 .`
  FIX: `Proposition 5.24. If \( B_0 \) and \( B_1 \) are block partitions then \( N_p = \bigcup_{k \leq p} B_{k,0} \).`

- RAW: `The next two propositions guarantee that the sets defined in formula ( 5.4 ) directly lead to index pairs that can be used to construct the transition diagram.`
  FIX: `The next two propositions guarantee that the sets defined in formula (5.4) directly lead to index pairs that can be used to construct the transition diagram.`

- RAW: `Proposition 5.25. ( N p ,N p − 1 ) is an index pair for M p, 0 : = Inv V 0 B p, 0 .`
  FIX: `Proposition 5.25. \( (N_p, N_{p-1}) \) is an index pair for \( M_{p,0} := \operatorname{Inv}_{V_0} B_{p,0} \).`

- RAW: `Proposition 5.26. Consider a filtration ( B 0 , V 0 ) ⊑ ( B 1 , V 1 ). Let q ∈ P 1 , Q : = −→ ι − 1 ( q ), and p : = max Q . Denote M Q , 0 : = Inv V 0 B q, 1 and M q, 1 : = Inv V 1 B q, 1 . If Q ̸ = ∅ , then, ( P,E ) : = ( N p ,N p −| Q | ) is a common index pair for M Q , 0 in V 0 and for M q, 1 in V 1 .`
  FIX: `Proposition 5.26. Consider a filtration \( (B_0, V_0) \sqsubseteq (B_1, V_1) \). Let \( q \in P_1 \), \( Q := \overrightarrow{\iota}^{-1}(q) \), and \( p := \max Q \). Denote \( M_{Q,0} := \operatorname{Inv}_{V_0} B_{q,1} \) and \( M_{q,1} := \operatorname{Inv}_{V_1} B_{q,1} \). If \( Q \neq \emptyset \), then, \( (P, E) := (N_p, N_{p-|Q|}) \) is a common index pair for \( M_{Q,0} \) in \( V_0 \) and for \( M_{q,1} \) in \( V_1 \).`

- RAW: `Example 5.27. We apply Proposition 5.24 to construct index pairs for the transition diagram described in Examples 5.15 and 5.19 . According to the procedure, we need to choose consistent linear orders for every pair of consecutive block decompositions first. For the step B 0 ⊑ B 1 the only possibility is • < ▼ for P 0 and ◦ < ⋆ < ▼ for P 1 . For the step B 1 ⊒ B 2 we also have no choice but ◦ < ▼ < ⋆ for P 1 and ◦ < ⋆ for P 2 . Note that we have to choose different linear orders for P 1 at each step in to ensure consistency with the filtration. For the remaining steps we use a proper ordering which is already depicted in Figures 17 and 19 .`
  FIX: `Example 5.27. We apply Proposition 5.24 to construct index pairs for the transition diagram described in Examples 5.15 and 5.19. According to the procedure, we need to choose consistent linear orders for every pair of consecutive block decompositions first. For the step \( B_0 \sqsubseteq B_1 \) the only possibility is \( \bullet < \blacktriangledown \) for \( P_0 \) and \( \circ < \star < \blacktriangledown \) for \( P_1 \). For the step \( B_1 \sqsupseteq B_2 \) we also have no choice but \( \circ < \blacktriangledown < \star \) for \( P_1 \) and \( \circ < \star \) for \( P_2 \). Note that we have to choose different linear orders for \( P_1 \) at each step in to ensure consistency with the filtration. For the remaining steps we use a proper ordering which is already depicted in Figures 17 and 19.`

## REPAIR_MATH
- RAW: ```
N _ { p } \coloneqq \begin{cases} N _ { p - 1 } \cup \text {pf} _ { \nu _ { 0 } } ( B _ { p , 0 } , X ) ; & \text { if } p \neq \max \overrightarrow { \iota } ^ { - 1 } ( q _ { p } ) , \\ N _ { p - 1 } \cup \text {pf} _ { \nu _ { 1 } } ( B _ { q _ { p } , 1 } , X ) ; & \text { if } p = \max \overrightarrow { \iota } ^ { - 1 } ( q _ { p } ) , \end{cases}
```
  FIX: ```
$$
N _ { p } \coloneqq \begin{cases} N _ { p - 1 } \cup \text {pf} _ { \nu _ { 0 } } ( B _ { p , 0 } , X ) ; & \text { if } p \neq \max \overrightarrow { \iota } ^ { - 1 } ( q _ { p } ) , \\ N _ { p - 1 } \cup \text {pf} _ { \nu _ { 1 } } ( B _ { q _ { p } , 1 } , X ) ; & \text { if } p = \max \overrightarrow { \iota } ^ { - 1 } ( q _ { p } ) , \end{cases}
$$
```

