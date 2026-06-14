# Manifest: Page 014

## REPAIR_PROSE
- RAW: ```
# 4.1 Block extension functor for zigzag modules
```
  FIX: ```
## 4.1 Block extension functor for zigzag modules
```

- RAW: ```
Figure 2: Inclusion of the zigzag poset into op × .
```
  FIX: ```
Figure 2: Inclusion of the zigzag poset into \(\mathbb{Z}^{\mathrm{op}} \times \mathbb{Z}\).
```

- RAW: ```
To define an interleaving distance on extended zigzag modules we extend the approach in [3] and in [18] (version 4 on arXiv). In both approaches, the authors send a zigzag persistence module to a op × -indexed module which allows them to define an interleaving distance for zigzag modules. Here, by op we mean the opposite category. The partial order on op × (or op × , respectively) is given by ( a,b ) ≤ ( c,d ) iff c ≤ a ≤ b ≤ d . This can be motivated by the partial order on intervals, where [ a,b ] ⊂ [ c,d ] iff c ≤ a ≤ b ≤ d . We slightly change and extend this approach to send an extended zigzag module to an op × × -indexed module in order to define the interleaving distance.
```
  FIX: ```
To define an interleaving distance on extended zigzag modules we extend the approach in [3] and in [18] (version 4 on arXiv). In both approaches, the authors send a zigzag persistence module to a \(\mathbb{Z}^{\mathrm{op}} \times \mathbb{Z}\)-indexed module which allows them to define an interleaving distance for zigzag modules. Here, by \(\mathrm{op}\) we mean the opposite category. The partial order on \(\mathbb{Z}^{\mathrm{op}} \times \mathbb{Z}\) (or \(\mathbb{R}^{\mathrm{op}} \times \mathbb{R}\), respectively) is given by \((a,b) \leq (c,d)\) iff \(c \leq a \leq b \leq d\). This can be motivated by the partial order on intervals, where \([a,b] \subset [c,d]\) iff \(c \leq a \leq b \leq d\). We slightly change and extend this approach to send an extended zigzag module to an \(\mathbb{Z}^{\mathrm{op}} \times \mathbb{Z} \times \mathbb{R}\)-indexed module in order to define the interleaving distance.
```

- RAW: ```
At first, we show how to extend a zigzag module to a op × -indexed module. By zigzag module we mean a functor from the poset ZZ to vec . We include ZZ into the poset op × as follows: we map a sink index i to ( i,i ) and a source index j to ( j + 1 ,j − 1) , shown in Figure 2. Note that we required the maps being strictly alternating so that every index is either a sink or a source index. Since this is an order-preserving map the inclusion ι : ZZ   → op × is a functor. To map a zigzag module to a op × indexed module we consider the composition of three functors: first, we define E 1 : vec ZZ → vec op × as the left Kan extension (see Appendix A.2) along the inclusion functor ι . Second, we restrict the module to the set U := { ( i,j ) ∈ op × | i ≤ j } by the restriction functor ( − ) | U : vec op × → vec U . Finally, we define E 2 : vec U → vec op × as the right Kan extension along the canonical inclusion κ : U   → op × . In total, we define the block extension functor
```
  FIX: ```
At first, we show how to extend a zigzag module to a \(\mathbb{Z}^{\mathrm{op}} \times \mathbb{Z}\)-indexed module. By zigzag module we mean a functor from the poset \(\mathbb{ZZ}\) to \(\mathrm{vec}\). We include \(\mathbb{ZZ}\) into the poset \(\mathbb{Z}^{\mathrm{op}} \times \mathbb{Z}\) as follows: we map a sink index \(i\) to \((i,i)\) and a source index \(j\) to \((j+1, j-1)\), shown in Figure 2. Note that we required the maps being strictly alternating so that every index is either a sink or a source index. Since this is an order-preserving map the inclusion \(\iota \colon \mathbb{ZZ} \to \mathbb{Z}^{\mathrm{op}} \times \mathbb{Z}\) is a functor. To map a zigzag module to a \(\mathbb{Z}^{\mathrm{op}} \times \mathbb{Z}\)-indexed module we consider the composition of three functors: first, we define \(E_1 \colon \mathrm{vec}^{\mathbb{ZZ}} \to \mathrm{vec}^{\mathbb{Z}^{\mathrm{op}} \times \mathbb{Z}}\) as the left Kan extension (see Appendix A.2) along the inclusion functor \(\iota\). Second, we restrict the module to the set \(U \colon= \{ (i,j) \in \mathbb{Z}^{\mathrm{op}} \times \mathbb{Z} \mid i \leq j \}\) by the restriction functor \((-) |_U \colon \mathrm{vec}^{\mathbb{Z}^{\mathrm{op}} \times \mathbb{Z}} \to \mathrm{vec}^U\). Finally, we define \(E_2 \colon \mathrm{vec}^U \to \mathrm{vec}^{\mathbb{Z}^{\mathrm{op}} \times \mathbb{Z}}\) as the right Kan extension along the canonical inclusion \(\kappa \colon U \hookrightarrow \mathbb{Z}^{\mathrm{op}} \times \mathbb{Z}\). In total, we define the block extension functor
```

- RAW: ```
It is known that any zigzag module decomposes into a direct sum of interval modules [5]. Following [3], we distinguish four different types of interval modules. Here, we denote by < and ≤ the partial order in 2 .
```
  FIX: ```
It is known that any zigzag module decomposes into a direct sum of interval modules [5]. Following [3], we distinguish four different types of interval modules. Here, we denote by \(<\) and \(\leq\) the partial order in \(\mathbb{Z}^2\).
```

## REPAIR_MATH
- RAW: ```
E \colon = E _ { 2 } \circ ( - ) | _ { U } \circ E _ { 1 } \colon \text {vec} ^ { Z Z } \to \text {vec} ^ { \mathbb { Z } ^ { \circ } } . \\ \intertext { t a n y \ z i g z a g \ m o d u l e \ de c o m p o s e s \ into a \ direct c u s t \ }
```
  FIX: ```
$$
E \colon= E_2 \circ (-) |_U \circ E_1 \colon \mathrm{vec}^{\mathbb{ZZ}} \to \mathrm{vec}^{\mathbb{Z}^{\mathrm{op}} \times \mathbb{Z}}.
$$
```

- RAW: ```
( a , b ) _ { Z Z } & \colon = \{ i \in \mathbb { Z } \, | \, ( a , a ) < \iota ( i ) < ( b , b ) \} \quad \text {for } a < b \in \mathbb { Z } \cup \{ - \infty , \infty \} , \\ [ a , b ) _ { Z Z } & \colon = \{ i \in \mathbb { Z } \, | \, ( a , a ) \leq \iota ( i ) < ( b , b ) \} \quad \text {for } a < b \in \mathbb { Z } \cup \{ \infty \} , \\ ( a , b ) _ { Z Z } & \colon = \{ i \in \mathbb { Z } \, | \, ( a , a ) < \iota ( i ) \leq ( b , b ) \} \quad \text {for } a < b \in \mathbb { Z } \cup \{ - \infty \} , \\ [ a , b ) _ { Z Z } & \colon = \{ i \in \mathbb { Z } \, | \, ( a , a ) \leq \iota ( i ) \leq ( b , b ) \} \quad \text {for } a \leq b \in \mathbb { Z } .
```
  FIX: ```
$$
\begin{aligned}
( a , b ) _ { \mathbb{ZZ} } &\colon= \{ i \in \mathbb { Z } \mid ( a , a ) < \iota ( i ) < ( b , b ) \} \quad \text {for } a < b \in \mathbb { Z } \cup \{ - \infty , \infty \} , \\
[ a , b ) _ { \mathbb{ZZ} } &\colon= \{ i \in \mathbb { Z } \mid ( a , a ) \leq \iota ( i ) < ( b , b ) \} \quad \text {for } a < b \in \mathbb { Z } \cup \{ \infty \} , \\
( a , b ] _ { \mathbb{ZZ} } &\colon= \{ i \in \mathbb { Z } \mid ( a , a ) < \iota ( i ) \leq ( b , b ) \} \quad \text {for } a < b \in \mathbb { Z } \cup \{ - \infty \} , \\
[ a , b ] _ { \mathbb{ZZ} } &\colon= \{ i \in \mathbb { Z } \mid ( a , a ) \leq \iota ( i ) \leq ( b , b ) \} \quad \text {for } a \leq b \in \mathbb { Z } .
\end{aligned}
$$
```
