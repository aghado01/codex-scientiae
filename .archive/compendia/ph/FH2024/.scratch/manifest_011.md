# Manifest: Page 011

## REPLACE_TABLES
<!-- No tables found on this page. -->

## REPAIR_MATH
- RAW: ```
( a , b ) \ll ( a ^ { \prime } , b ^ { \prime } ) \Leftrightarrow b \leq b ^ { \prime } \text { and } \begin{cases} a = a ^ { \prime } - 1 & \text {for } a = 2 z + 1 \text { for some } z \in \mathbb { Z } , \\ a = a ^ { \prime } + 1 & \text {else.} \end{cases}
```
  FIX: ```
\[
( a , b ) \ll ( a ^ { \prime } , b ^ { \prime } ) \Leftrightarrow b \leq b ^ { \prime } \text { and } \begin{cases} a = a ^ { \prime } - 1 & \text {for } a = 2 z + 1 \text { for some } z \in \mathbb { Z } , \\ a = a ^ { \prime } + 1 & \text {else.} \end{cases}
\]
```
- RAW: ```
\lambda _ { k } ( x ) \colon = \sup \{ \varepsilon \geq 0 \colon \, \text {rank} ( M | _ { R _ { x } ^ { \varepsilon } } ) \geq k \} .
```
  FIX: ```
\[
\lambda _ { k } ( x ) \colon = \sup \{ \varepsilon \geq 0 \colon \, \text {rank} ( M | _ { R _ { x } ^ { \varepsilon } } ) \geq k \} .
\]
```

## REPAIR_PROSE
- RAW: `Theorem 2.23 Let I ⊂ P be an interval. Then, rank( M | I ) = rank( M ∂I ) .`
  FIX: `Theorem 2.23 Let \( I \subset P \) be an interval. Then, \( \text{rank}( M |_I ) = \text{rank}( M |_{\partial I} ) \).`

- RAW: `construction of Γ ∂I as the concatenation of Γ min and Γ max .`
  FIX: `construction of \( \Gamma_{\partial I} \) as the concatenation of \( \Gamma_{\min} \) and \( \Gamma_{\max} \).`

- RAW: `Hence, Theorem 2.23 holds for any path Γ that is composed`
  FIX: `Hence, Theorem 2.23 holds for any path \( \Gamma \) that is composed`

- RAW: `which we denote by ( ZZ × , ≪ ) , as follows: ZZ := as a set and`
  FIX: `which we denote by \( (\mathbb{Z} \times \mathbb{R}, \ll) \), as follows: \( \mathbb{Z} \times \mathbb{R} \) as a set and`

- RAW: `We equip the set ZZ × with the maximum metric d m as in 2 , i.e. d m ( x,y ) = max {| x 1 − y 1 | , | x 2 − y 2 |} .`
  FIX: `We equip the set \( \mathbb{Z} \times \mathbb{R} \) with the maximum metric \( d_m \) as in 2 , i.e. \( d_m(x, y) = \max \{ |x_1 - y_1|, |x_2 - y_2| \} \).`

- RAW: `Furthermore, we define regions R ε x in the parameter space around a point x ∈ ZZ × as balls around x with radius ε with respect to the maximum norm, so R ε x = { y ∈ ZZ × : y = x + h with h ∈ ZZ × , d m ( h, 0) ≤ ε } .`
  FIX: `Furthermore, we define regions \( R_x^\varepsilon \) in the parameter space around a point \( x \in \mathbb{Z} \times \mathbb{R} \) as balls around \( x \) with radius \( \varepsilon \) with respect to the maximum norm, so \( R_x^\varepsilon = \{ y \in \mathbb{Z} \times \mathbb{R} : y = x + h \text{ with } h \in \mathbb{Z} \times \mathbb{R}, d_m(h, 0) \leq \varepsilon \} \).`

- RAW: `Definition 3.1 The k -th persistence landscape λ k of a persistence module M : ZZ × → vec considers the maximal radius over which k features persist in every (positive) direction through x in the parameter space`
  FIX: `Definition 3.1 The \( k \)-th persistence landscape \( \lambda_k \) of a persistence module \( M : \mathbb{Z} \times \mathbb{R} \to \mathrm{vec} \) considers the maximal radius over which \( k \) features persist in every (positive) direction through \( x \) in the parameter space`

- RAW: `The persistence landscape λ of M is the map λ : × ZZ × → , ( k,x )  → λ k ( x ) .`
  FIX: `The persistence landscape \( \lambda \) of \( M \) is the map \( \lambda : \mathbb{N} \times \mathbb{Z} \times \mathbb{R} \to \mathbb{R}, (k, x) \mapsto \lambda_k(x) \).`

- RAW: `We want to regard landscapes as functions taking values in , not as in the definition in the extended real numbers . To assure this, in the following we exclude infinite indecomposables in our persistence module M .`
  FIX: `We want to regard landscapes as functions taking values in \( \mathbb{R} \), not as in the definition in the extended real numbers \( \overline{\mathbb{R}} \). To assure this, in the following we exclude infinite indecomposables in our persistence module \( M \).`

- RAW: `Remark 3.2 In this work, we restrict our attention to quadratic regions R ε x .`
  FIX: `Remark 3.2 In this work, we restrict our attention to quadratic regions \( R_x^\varepsilon \).`
