# Manifest: Page 018

## REPLACE_TABLES
*(No tables to replace on this page)*

## REPAIR_MATH
- RAW: ```
E ( M ( \cdot , z _ { 1 } ) ) & \longrightarrow E ( M ( \cdot , z _ { 2 } ) ) \\ \downarrow & \left \lfloor E ( f _ { z _ { 1 } } ) \right \rfloor \underset { \downarrow } { \left \lfloor } E ( f _ { z _ { 2 } } ) \\ E ( N ( \cdot , z _ { 1 } ) ) & \longrightarrow E ( N ( \cdot , z _ { 2 } ) ) ,
```
  FIX: ```
$$
\begin{array}{ccc}
E(M(\cdot, z_1)) & \longrightarrow & E(M(\cdot, z_2)) \\
\downarrow {\scriptstyle E(f_{z_1})} & & \downarrow {\scriptstyle E(f_{z_2})} \\
E(N(\cdot, z_1)) & \longrightarrow & E(N(\cdot, z_2))
\end{array}
$$
```
- RAW: ```
\tilde { l } ( i , z ) = \begin{cases} ( i , i , z ) & \text {if $i$ is a sink index,} \\ ( i + 1 , i - 1 , z ) & \text {if $i$ is a source index.} \end{cases}
```
  FIX: ```
$$
\tilde{\ell}(i, z) = \begin{cases} 
(i, i, z) & \text{if } i \text{ is a sink index,} \\ 
(i + 1, i - 1, z) & \text{if } i \text{ is a source index.} 
\end{cases}
$$
```
- RAW: ```
\tilde { U } \coloneqq \{ ( x , y , z ) \in \mathbb { Z } ^ { o p } \times \mathbb { Z } \times \mathbb { Z } \, | x \leq y \} ,
```
  FIX: ```
$$
\tilde{U} \coloneqq \{ (x, y, z) \in \mathbb{Z}^{op} \times \mathbb{Z} \times \mathbb{Z} \mid x \leq y \} ,
$$
```
- RAW: ```
\mathcal { E } \coloneqq & \text {Ran} _ { \tilde { \kappa } } \circ ( - ) | _ { \tilde { U } } \circ \text {Lan} _ { \tilde { \ell } } \colon \text {vec} ^ { Z \times \mathbb { Z } } \to \text {vec} ^ { \mathbb { Z } ^ { \circ } \times \mathbb { Z } } . \\ \text {hat} \, \mathcal { E } ( M ) ( \cdot , \cdot , z ) = & \ E ( M ( \cdot , z ) ) \text {  if  is  again  sufficient  to  recall  the  considera}
```
  FIX: ```
$$
\mathcal{E} \coloneqq \text{Ran}_{\tilde{\kappa}} \circ (-)|_{\tilde{U}} \circ \text{Lan}_{\tilde{\ell}} \colon \text{vec}^{\mathbb{Z} \times \mathbb{Z}} \to \text{vec}^{\mathbb{Z}^{op} \times \mathbb{Z} \times \mathbb{Z}}.
$$
```
- RAW: ```
\mathcal { E } ( M ) ( x , y , z ) \colon = \begin{cases} \lim _ { \overleftarrow { \L } } M ( \cdot , z ) | _ { [ x , y ] } & \text {for } x \leq y , \\ \underset { \overleftarrow { \L } } { \varinjlim } M ( \cdot , z ) | _ { [ y , x ] } & \text {for } x > y . \end{cases}
```
  FIX: ```
$$
\mathcal{E}(M)(x, y, z) \coloneqq \begin{cases} 
\varprojlim M(\cdot, z)|_{[x, y]} & \text{for } x \leq y, \\ 
\varinjlim M(\cdot, z)|_{[y, x]} & \text{for } x > y. 
\end{cases}
$$
```

## REPAIR_PROSE
- RAW: `f : M → N`
  FIX: `\( f \colon M \to N \)`
- RAW: `z ∈ we`
  FIX: `\( z \in \mathbb{Z} \) we`
- RAW: `f z : M ( · ,z ) → N ( · ,z )`
  FIX: `\( f_z \colon M(\cdot, z) \to N(\cdot, z) \)`
- RAW: `E ( f z ) : E ( M ( · ,z )) → E ( N ( · ,z ))`
  FIX: `\( E(f_z) \colon E(M(\cdot, z)) \to E(N(\cdot, z)) \)`
- RAW: `for each z .`
  FIX: `for each \( z \).`
- RAW: `for all z 1 ≤ z 2`
  FIX: `for all \( z_1 \leq z_2 \)`
- RAW: `functor E in analogy to the block extension functor E .`
  FIX: `functor \( \mathcal{E} \) in analogy to the block extension functor \( E \).`
- RAW: `inclusion ˜ ι : ZZ × → op × × defined as`
  FIX: `inclusion \( \tilde{\ell} \colon \mathbb{Z} \times \mathbb{Z} \to \mathbb{Z}^{op} \times \mathbb{Z} \times \mathbb{Z} \) defined as`
- RAW: `that i is a source index in ZZ`
  FIX: `that \( i \) is a source index in \( \mathbb{Z} \)`
- RAW: `that i is a sink index in ZZ`
  FIX: `that \( i \) is a sink index in \( \mathbb{Z} \)`
- RAW: `inclusion ˜ κ : ˜ U → op × × .`
  FIX: `inclusion \( \tilde{\kappa} \colon \tilde{U} \to \mathbb{Z}^{op} \times \mathbb{Z} \times \mathbb{Z} \).`
- RAW: `Then, E can be defined`
  FIX: `Then, \( \mathcal{E} \) can be defined`
- RAW: `To see that E ( M )( · , · ,z ) = E ( M ( · ,z )) it`
  FIX: `To see that \( \mathcal{E}(M)(\cdot, \cdot, z) = E(M(\cdot, z)) \) it`
- RAW: `The functor E is fully faithful, i.e.`
  FIX: `The functor \( \mathcal{E} \) is fully faithful, i.e.`
- RAW: `from M to N is`
  FIX: `from \( M \) to \( N \) is`
- RAW: `from E ( M ) to E ( N ) for all`
  FIX: `from \( \mathcal{E}(M) \) to \( \mathcal{E}(N) \) for all`
- RAW: `extended zigzag modules M and N .`
  FIX: `extended zigzag modules \( M \) and \( N \).`
- RAW: `( − ) | ˜ U ◦ Lan ˜ ι is fully faithful`
  FIX: `\( (-)|_{\tilde{U}} \circ \text{Lan}_{\tilde{\ell}} \) is fully faithful`
- RAW: `Ran ˜ κ is fully faithful.`
  FIX: `\( \text{Ran}_{\tilde{\kappa}} \) is fully faithful.`
- RAW: `restriction functor ( − ) | ˜ U (see`
  FIX: `restriction functor \( (-)|_{\tilde{U}} \) (see`
- RAW: `( − ) | ˜ U ◦ Ran ˜ κ ( M ) ∼ = M for any`
  FIX: `\( (-)|_{\tilde{U}} \circ \text{Ran}_{\tilde{\kappa}}(M) \cong M \) for any`
- RAW: `extended zigzag module M .`
  FIX: `extended zigzag module \( M \).`
- RAW: `In total, E is fully faithful`
  FIX: `In total, \( \mathcal{E} \) is fully faithful`
