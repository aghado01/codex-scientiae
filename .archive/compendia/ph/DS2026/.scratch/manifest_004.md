# Manifest: Page 004

## REPAIR_MATH
- RAW: ```
\lambda ^ { M } ( p , k ) \coloneqq \sup \left \{ \delta \geq 0 \, \colon r k ^ { M } \left ( \boxed { p } \bmod { ^ { 2 } _ { \delta } } \right ) \geq k \right \} ,
```
  FIX: ```
$$
\lambda ^ { M } ( p , k ) \coloneqq \sup \left \{ \delta \geq 0 \, \colon r k ^ { M } \left ( \boxed { p } \bmod { ^ { 2 } _ { \delta } } \right ) \geq k \right \} ,
$$
```
- RAW: ```
I ^ { \epsilon } \colon = \{ r \in \mathbb { Z } \mathbb { Z } \times \mathbb { Z } \colon \exists \mathfrak { q } \in I \text { such that } | | r - \mathfrak { q } | | _ { \infty } \leq \epsilon \} \, .
```
  FIX: ```
$$
I ^ { \epsilon } \colon = \{ r \in \mathbb { Z } \mathbb { Z } \times \mathbb { Z } \colon \exists \mathfrak { q } \in I \text { such that } | | r - \mathfrak { q } | | _ { \infty } \leq \epsilon \} \, .
$$
```
- RAW: ```
d _ { \mathcal { E } } ^ { \mathcal { L } } ( M , N ) \coloneqq & \inf _ { \epsilon \geq 0 } \{ \forall \mathbf p \bigsqcup _ { \delta } ^ { 2 } \in \mathbf I ( \mathbb { Z } \mathbb { Z } \times \mathbb { Z } ) , \\ & r k ^ { M } \left ( \lfloor \mathbf p \rfloor _ { \delta } ^ { 2 } \right ) \geq r k ^ { N } \left ( \lfloor \mathbf p \rfloor _ { \delta + \epsilon } ^ { 2 } \right ) \text { and } \\ & r k ^ { N } \left ( \lfloor \mathbf p \rfloor _ { \delta } ^ { 2 } \right ) \geq r k ^ { M } \left ( \lfloor \mathbf p \rfloor _ { \delta + \epsilon } ^ { 2 } \right ) \} .
```
  FIX: ```
$$
d _ { \mathcal { E } } ^ { \mathcal { L } } ( M , N ) \coloneqq & \inf _ { \epsilon \geq 0 } \{ \forall \mathbf p \bigsqcup _ { \delta } ^ { 2 } \in \mathbf I ( \mathbb { Z } \mathbb { Z } \times \mathbb { Z } ) , \\ & r k ^ { M } \left ( \lfloor \mathbf p \rfloor _ { \delta } ^ { 2 } \right ) \geq r k ^ { N } \left ( \lfloor \mathbf p \rfloor _ { \delta + \epsilon } ^ { 2 } \right ) \text { and } \\ & r k ^ { N } \left ( \lfloor \mathbf p \rfloor _ { \delta } ^ { 2 } \right ) \geq r k ^ { M } \left ( \lfloor \mathbf p \rfloor _ { \delta + \epsilon } ^ { 2 } \right ) \} .
$$
```
- RAW: ```
| | \lambda ^ { M } - \lambda ^ { N } | | _ { \infty } = d _ { \mathcal { E } } ^ { \mathcal { L } } ( M , N ) \leq d _ { \mathcal { I } } ( M , N ) .
```
  FIX: ```
$$
| | \lambda ^ { M } - \lambda ^ { N } | | _ { \infty } = d _ { \mathcal { E } } ^ { \mathcal { L } } ( M , N ) \leq d _ { \mathcal { I } } ( M , N ) .
$$
```
- RAW: `centered at p with width δ = 1 .`
  FIX: `centered at \( p \) with width \( \delta = 1 \).`
- RAW: `centered at p with width δ = 2 .`
  FIX: `centered at \( p \) with width \( \delta = 2 \).`
- RAW: `Definition 3.4 (Z Z -G RIL ) . Let M be a quasi zigzag persistence module. Then, the ZigZag Generalized Rank Invariant Landscape is a function λ M : ZZ × Z × N → N defined as`
  FIX: `Definition 3.4 (\( \mathbb{ZZ} \)-GRIL). Let \( M \) be a quasi zigzag persistence module. Then, the ZigZag Generalized Rank Invariant Landscape is a function \( \lambda^M \colon \mathbb{ZZ} \times \mathbb{Z} \times \mathbb{N} \to \mathbb{N} \) defined as`
- RAW: `where p ∈ ZZ × Z .`
  FIX: `where \( p \in \mathbb{ZZ} \times \mathbb{Z} \).`
- RAW: `The basic idea of Z Z -G RIL is similar to G RIL .`
  FIX: `The basic idea of \( \mathbb{ZZ} \)-GRIL is similar to GRIL.`
- RAW: `subposet of ZZ × Z and cover it with worms.`
  FIX: `subposet of \( \mathbb{ZZ} \times \mathbb{Z} \) and cover it with worms.`
- RAW: `landscape function (Z Z -G RIL ).`
  FIX: `landscape function (\( \mathbb{ZZ} \)-GRIL).`
- RAW: `# 3.1 Stability of Z Z -G RIL`
  FIX: `# 3.1 Stability of \( \mathbb{ZZ} \)-GRIL`
- RAW: `We prove the stability of Z Z -G RIL by showing`
  FIX: `We prove the stability of \( \mathbb{ZZ} \)-GRIL by showing`
- RAW: `interleaving distance, d I ( M,N ) , (see`
  FIX: `interleaving distance, \( d_{\mathcal{I}}(M, N) \), (see`
- RAW: `zigzag persistence modules M,N can be`
  FIX: `zigzag persistence modules \( M, N \) can be`
- RAW: `For this, we need the notion of ϵ thickening .`
  FIX: `For this, we need the notion of \( \epsilon \)-thickening.`
- RAW: `Let I ( ZZ × Z ) denote the collection of all subposets in ZZ × Z such that their corresponding subposets in Z 2 are intervals. For ϵ ∈ Z + , the ϵ -thickening of I is defined as`
  FIX: `Let \( \mathcal{I}(\mathbb{ZZ} \times \mathbb{Z}) \) denote the collection of all subposets in \( \mathbb{ZZ} \times \mathbb{Z} \) such that their corresponding subposets in \( \mathbb{Z}^2 \) are intervals. For \( \epsilon \in \mathbb{Z}^+ \), the \( \epsilon \)-thickening of \( I \) is defined as`
- RAW: `Definition 3.5. Let L denote the collection of all worms in ZZ × Z . Let M and N be quasi zigzag persistence modules.`
  FIX: `Definition 3.5. Let \( \mathcal{L} \) denote the collection of all worms in \( \mathbb{ZZ} \times \mathbb{Z} \). Let \( M \) and \( N \) be quasi zigzag persistence modules.`
- RAW: `Note that p 2 δ + ϵ contains the ϵ -thickening of p 2 δ .`
  FIX: `Note that \( \lfloor \mathbf{p} \rfloor_{\delta + \epsilon}^2 \) contains the \( \epsilon \)-thickening of \( \lfloor \mathbf{p} \rfloor_\delta^2 \).`
- RAW: `Proposition 3.6. Given two quasi zigzag persistence modules M and N , d L E ( M,N ) ≤ d I ( M,N ) where d I denotes the interleaving distance between M and N .`
  FIX: `Proposition 3.6. Given two quasi zigzag persistence modules \( M \) and \( N \), \( d_{\mathcal{E}}^{\mathcal{L}}(M, N) \leq d_{\mathcal{I}}(M, N) \) where \( d_{\mathcal{I}} \) denotes the interleaving distance between \( M \) and \( N \).`

## REPAIR_PROSE
- RAW: `Theorem 3.7. Let M and N be two quasi zigzag persistence modules. Let λ M and λ N denote the Z Z -G RIL functions of M and N respectively. Then, M N`
  FIX: `Theorem 3.7. Let \( M \) and \( N \) be two quasi zigzag persistence modules. Let \( \lambda^M \) and \( \lambda^N \) denote the \( \mathbb{ZZ} \)-GRIL functions of \( M \) and \( N \) respectively. Then,`
