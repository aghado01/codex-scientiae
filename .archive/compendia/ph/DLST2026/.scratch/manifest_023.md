# Manifest: Page 023

## REPAIR_MATH
- RAW: ```
$$
( \mathcal { B } _ { 0 } , \mathcal { V } _ { 0 } ) \supseteq ( \mathcal { B } _ { 1 } , \mathcal { V } _ { 1 } ) \subseteq ( \mathcal { B } _ { 2 } , \mathcal { V } _ { 2 } ) \supseteq ( \mathcal { B } _ { 3 } , \mathcal { V } _ { 3 } ) \supseteq ( \mathcal { B } _ { 4 } , \mathcal { V } _ { 4 } ) .
$$
```
  FIX: ```
\[
( \mathcal { B } _ { 0 } , \mathcal { V } _ { 0 } ) \supseteq ( \mathcal { B } _ { 1 } , \mathcal { V } _ { 1 } ) \subseteq ( \mathcal { B } _ { 2 } , \mathcal { V } _ { 2 } ) \supseteq ( \mathcal { B } _ { 3 } , \mathcal { V } _ { 3 } ) \supseteq ( \mathcal { B } _ { 4 } , \mathcal { V } _ { 4 } ) .
\]
```
- RAW: ```
$$
\overrightarrow { \iota } _ { \lambda } \colon \mathbb { P } _ { \lambda } \ni p \mapsto r \in \mathbb { P } _ { \lambda + 1 }
$$
```
  FIX: ```
\[
\overrightarrow { \iota } _ { \lambda } \colon \mathbb { P } _ { \lambda } \ni p \mapsto r \in \mathbb { P } _ { \lambda + 1 }
\]
```
- RAW: ```
$$
\overleftarrow { \iota } _ { \lambda } \colon \mathbb { P } _ { \lambda + 1 } \ni r \mapsto p \in \mathbb { P } _ { \lambda }
$$
```
  FIX: ```
\[
\overleftarrow { \iota } _ { \lambda } \colon \mathbb { P } _ { \lambda + 1 } \ni r \mapsto p \in \mathbb { P } _ { \lambda }
\]
```

## REPAIR_PROSE
- RAW: ```
Figure 13. From top left to bottom right, multivector fields V 0 , V 1 , V 2 , V 3 , and V 4 on a simplicial complex K . In particular, V 0 ⊒ V 1 ⊑ V 2 ⊒ V 3 ⊒ V 4 .
```
  FIX: ```
Figure 13. From top left to bottom right, multivector fields \( \mathcal{V}_0 \), \( \mathcal{V}_1 \), \( \mathcal{V}_2 \), \( \mathcal{V}_3 \), and \( \mathcal{V}_4 \) on a simplicial complex \( K \). In particular, \( \mathcal{V}_0 \sqsupseteq \mathcal{V}_1 \sqsubseteq \mathcal{V}_2 \sqsupseteq \mathcal{V}_3 \sqsupseteq \mathcal{V}_4 \).
```
- RAW: ```
Whenever we have inscribed block decompositions ( B , V ) ⊑ ( B ′ , V ′ ) with corresponding index sets P and P ′ , we can define the indexing map ι : P → P ′ such that ι ( p ) : = r if B ∋ B p ⊂ B r ∈ B ′ . We leave it as an easy exercise to the reader to verify that ι is an order preserving map between the flow induced partial orders.
```
  FIX: ```
Whenever we have inscribed block decompositions \( (\mathcal{B}, \mathcal{V}) \sqsubseteq (\mathcal{B}', \mathcal{V}') \) with corresponding index sets \( \mathbb{P} \) and \( \mathbb{P}' \), we can define the indexing map \( \iota \colon \mathbb{P} \to \mathbb{P}' \) such that \( \iota(p) := r \) if \( \mathcal{B} \ni B_p \subset B_r \in \mathcal{B}' \). We leave it as an easy exercise to the reader to verify that \( \iota \) is an order preserving map between the flow induced partial orders.
```
- RAW: ```
In the case of zigzag filtration B , we distinguish two types of indexing maps: for B λ ⊑ B λ +1 we have the λ -forward map denoted and defined as:
```
  FIX: ```
In the case of zigzag filtration \( \mathcal{B} \), we distinguish two types of indexing maps: for \( \mathcal{B}_\lambda \sqsubseteq \mathcal{B}_{\lambda+1} \) we have the \( \lambda \)-forward map denoted and defined as:
```
- RAW: ```
such that B λ ∋ B p,λ ⊂ B r,λ +1 ∈ B λ +1 . Analogously, for B λ ⊒ B λ +1 we have the λ -backward map :
```
  FIX: ```
such that \( \mathcal{B}_\lambda \ni B_{p,\lambda} \subset B_{r,\lambda+1} \in \mathcal{B}_{\lambda+1} \). Analogously, for \( \mathcal{B}_\lambda \sqsupseteq \mathcal{B}_{\lambda+1} \) we have the \( \lambda \)-backward map:
```
- RAW: ```
such that B λ +1 ∋ B r,λ +1 ⊂ B p,λ ∈ B λ +1 . Whenever we refer to B we assume that the corresponding indexing sets P λ , and λ -forward/backward maps, −→ ι λ and ←− ι λ , are implied.
```
  FIX: ```
such that \( \mathcal{B}_{\lambda+1} \ni B_{r,\lambda+1} \subset B_{p,\lambda} \in \mathcal{B}_{\lambda+1} \). Whenever we refer to \( \mathcal{B} \) we assume that the corresponding indexing sets \( \mathbb{P}_\lambda \), and \( \lambda \)-forward/backward maps, \( \overrightarrow{\iota}_\lambda \) and \( \overleftarrow{\iota}_\lambda \), are implied.
```
- RAW: ```
Example 5.5. For the zigzag filtration B from Example 5.3 we have four indexing maps: ←− ι 0 , −→ ι 1 , ←− ι 2 , and ←− ι 3 , as shown in Figure 16 . ♢
```
  FIX: ```
Example 5.5. For the zigzag filtration \( \mathcal{B} \) from Example 5.3 we have four indexing maps: \( \overleftarrow{\iota}_0 \), \( \overrightarrow{\iota}_1 \), \( \overleftarrow{\iota}_2 \), and \( \overleftarrow{\iota}_3 \), as shown in Figure 16. \( \diamondsuit \)
```
