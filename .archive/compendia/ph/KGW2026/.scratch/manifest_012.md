# Manifest: Page 012

## REPAIR_PROSE
- RAW: `Properties of N -Chain Complexes`
  FIX: `Properties of \( N \)-Chain Complexes`
- RAW: `∂ -invariant`
  FIX: `\( \partial \)-invariant`
- RAW: `2 -path Ω N 2`
  FIX: `2-path \( \Omega_N^2 \)`
- RAW: `digraph G as`
  FIX: `digraph \( G \) as`
- RAW: `- • e i,j,i a double edge in G`
  FIX: `- \( e_{i,j,i} \) a double edge in \( G \)`
- RAW: `- • e i,j,k + e i,k a triangle in G`
  FIX: `- \( e_{i,j,k} + e_{i,k} \) a triangle in \( G \)`
- RAW: `- • e i,j,k + e i,l,k a square in G`
  FIX: `- \( e_{i,j,k} + e_{i,l,k} \) a square in \( G \)`

## REPAIR_MATH
- RAW: ```
$$
F o r \, N = 2 ,
$$
```
  FIX: ```
$$
\text{For } N = 2,
$$
```
- RAW: ```
$$
For N = 2 , \\ Z _ { 1 } ^ { 2 , 1 } ( L _ { 1 } ) = K e r ( B _ { 1 } ( L _ { 1 } ) ) & = \langle e _ { 1 , 4 } + e _ { 4 , 3 } + e _ { 3 , 2 } - e _ { 1 , 2 } \rangle , \quad Z _ { 1 } ^ { 2 , 1 } ( L _ { 2 } ) = K e r ( B _ { 1 } ( L _ { 2 } ) ) = \langle e _ { 1 , 4 } + e _ { 4 , 3 } - e _ { 2 , 3 } - e _ { 1 , 2 } \rangle , \\ Z _ { 1 } ^ { 2 , 1 } ( L _ { 3 } ) = K e r ( B _ { 1 } ( L _ { 3 } ) ) & = \langle e _ { 1 , 4 } - e _ { 3 , 4 } + e _ { 3 , 2 } - e _ { 1 , 2 } \rangle , \\ B _ { 0 } ^ { 2 , 1 } ( L _ { 1 } ) = \langle e _ { 2 - 1 } , e _ { 3 } - e _ { 4 } , e _ { 2 - 3 } \rangle , \quad B _ { 0 } ^ { 2 , 1 } ( L _ { 2 } ) = \langle e _ { 2 - 1 } , e _ { 3 } - e _ { 4 } , e _ { 2 - 3 } \rangle , \\ \text {For } N = 3 , \\ Z _ { 1 , 3 } ^ { 3 , 1 } ( L _ { 1 } ) = K e r ( B _ { 1 } ( L _ { 1 } ) ) & = 0 , \quad Z _ { 1 } ^ { 3 , 1 } ( L _ { 2 } ) = K e r ( B _ { 1 } ( L _ { 2 } ) ) = \langle \xi _ { 1 , 2 } - \xi _ { 1 , 4 } - e _ { 2 , 3 } + e _ { 4 , 3 } \rangle , \\ Z _ { 1 , 3 } ^ { 3 , 1 } ( L _ { 3 } ) = K e r ( B _ { 1 } ( L _ { 3 } ) ) & = \langle e _ { 1 , 2 } - e _ { 1 , 4 } - e _ { 3 , 2 } + e _ { 3 , 4 } \rangle , \\ B _ { 0 } ^ { 3 , 1 } ( L _ { 1 } ) = 0 \quad B _ { 0 } ^ { 3 , 1 } ( L _ { 2 } ) = \langle ( \xi + \xi ^ { 2 } ) ( e _ { 4 } - e _ { 2 } ) , \quad B _ { 0 } ^ { 3 , 1 } ( L _ { 3 } ) = 0 \\ B _ { 0 } ^ { 3 , 2 } ( L _ { 1 } ) = \langle e _ { 4 } + e _ { 1 } , e _ { 3 } + \xi _ { 4 } , e _ { 2 } + \xi _ { 3 } , e _ { 2 } + \xi _ { 1 } \rangle , \quad B _ { 0 } ^ { 3 , 2 } ( L _ { 2 } ) = \langle e _ { 4 } + \xi _ { 3 } , e _ { 2 } + \xi _ { 3 } , e _ { 2 } + \xi _ { 1 } \rangle , \\ B _ { 0 } ^ { 3 , 2 } ( L _ { 3 } ) = \langle e _ { 3 } + e _ { 4 } , e _ { 3 } + \xi _ { 2 } , e _ { 2 } + \xi _ { 1 } \rangle , \quad B _ { 1 , 2 } ^ { 3 , 2 } ( L _ { 2 } ) = \langle \xi _ { 1 , 2 } + \xi _ { 1 , 4 } , e _ { 1 , 2 } + \xi _ { 2 , 3 } , e _ { 2 , 3 } + e _ { 4 , 3 } \rangle . \\ \text {Observe that } B _ { 1 } ^ { 3 , 1 } ( L _ { 1 } ) = 0 \text { for all } i = 1 , 2 , 3 \text { and } B _ { 1 , 2 } ^ { 3 , 2 } ( L _ { i } ) = 0 \text { for } i = 1 , 3 . \\ \text {Table } 3 \colon \text {Comparison of path and Mayer path homologies for } L _ { 1 } , L _ { 2 } , L _ { 3 }
$$
```
  FIX: ```
$$
\begin{aligned}
\text{For } N &= 2, \\
Z_1^{2,1}(L_1) &= \text{Ker}(B_1(L_1)) = \langle e_{1,4} + e_{4,3} + e_{3,2} - e_{1,2} \rangle, \quad Z_1^{2,1}(L_2) = \text{Ker}(B_1(L_2)) = \langle e_{1,4} + e_{4,3} - e_{2,3} - e_{1,2} \rangle, \\
Z_1^{2,1}(L_3) &= \text{Ker}(B_1(L_3)) = \langle e_{1,4} - e_{3,4} + e_{3,2} - e_{1,2} \rangle, \\
B_0^{2,1}(L_1) &= \langle e_{2,1}, e_3 - e_4, e_{2,3} \rangle, \quad B_0^{2,1}(L_2) = \langle e_{2,1}, e_3 - e_4, e_{2,3} \rangle, \\
\text{For } N &= 3, \\
Z_{1,3}^{3,1}(L_1) &= \text{Ker}(B_1(L_1)) = 0, \quad Z_1^{3,1}(L_2) = \text{Ker}(B_1(L_2)) = \langle \xi_{1,2} - \xi_{1,4} - e_{2,3} + e_{4,3} \rangle, \\
Z_{1,3}^{3,1}(L_3) &= \text{Ker}(B_1(L_3)) = \langle e_{1,2} - e_{1,4} - e_{3,2} + e_{3,4} \rangle, \\
B_0^{3,1}(L_1) &= 0, \quad B_0^{3,1}(L_2) = \langle (\xi + \xi^2)(e_4 - e_2) \rangle, \quad B_0^{3,1}(L_3) = 0, \\
B_0^{3,2}(L_1) &= \langle e_4 + e_1, e_3 + \xi_4, e_2 + \xi_3, e_2 + \xi_1 \rangle, \quad B_0^{3,2}(L_2) = \langle e_4 + \xi_3, e_2 + \xi_3, e_2 + \xi_1 \rangle, \\
B_0^{3,2}(L_3) &= \langle e_3 + e_4, e_3 + \xi_2, e_2 + \xi_1 \rangle, \quad B_{1,2}^{3,2}(L_2) = \langle \xi_{1,2} + \xi_{1,4}, e_{1,2} + \xi_{2,3}, e_{2,3} + e_{4,3} \rangle.
\end{aligned}
$$

Observe that \( B_1^{3,1}(L_1) = 0 \) for all \( i = 1, 2, 3 \) and \( B_{1,2}^{3,2}(L_i) = 0 \) for \( i = 1, 3 \).
```
- RAW: ```
$$
=
$$
```
  FIX: ```
```

## REPLACE_TABLES
- USE_ARTIFACT: page_012_tables.md#Table_4
  REPLACE_FROM: `Table 3: Comparison of path and Mayer path homologies for L 1 ,L 2 ,L 3`
  REPLACE_TO: `|L 3|C|C|C 4|C|C 4|C 4|`
