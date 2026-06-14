# Manifest: Page 015

## REPAIR_PROSE
- RAW: ```
By ⟨ a,b ⟩ ZZ we denote an interval of any of these four types. op

In vec × , we consider a special class of persistence modules
```
  FIX: ```
By \( \langle a,b \rangle_{ZZ} \) we denote an interval of any of these four types.

In \( \mathrm{vec}^{\mathbb{Z}^{\mathrm{op}} \times \mathbb{Z}} \), we consider a special class of persistence modules
```
- RAW: `Figure 3: Extension of zigzag intervals to block intervals for the four different types ( · , · ) , [ · , · ) , ( · , · ] and [ · , · ] (in that order). Cf. Figure 3 in [3].`
  FIX: `Figure 3: Extension of zigzag intervals to block intervals for the four different types \( (\cdot, \cdot) \), \( [\cdot, \cdot) \), \( (\cdot, \cdot] \), and \( [\cdot, \cdot] \) (in that order). Cf. Figure 3 in [3].`

## REPAIR_MATH
- RAW: ```
$$
( a , b ) _ { B L } & \colon = \{ ( x , y ) \in \mathbb { Z } ^ { \mathbb { P } } \times \mathbb { Z } \, | a < x , y < b \} \quad \text { for } a < b \in \mathbb { Z } \cup \{ - \infty , \infty \} , \\ [ a , b ) _ { B L } & \colon = \{ ( x , y ) \in \mathbb { Z } ^ { \mathbb { P } } \times \mathbb { Z } \, | a \leq y < b \} \quad \text { for } a < b \in \mathbb { Z } \cup \{ \infty \} , \\ ( a , b ) _ { B L } & \colon = \{ ( x , y ) \in \mathbb { Z } ^ { \mathbb { P } } \times \mathbb { Z } \, | a < x \leq b \} \quad \text { for } a < b \in \mathbb { Z } \cup \{ - \infty \} , \\ [ a , b ) _ { B L } & \colon = \{ ( x , y ) \in \mathbb { Z } ^ { \mathbb { P } } \times \mathbb { Z } \, | x \leq b , y \geq a \} \quad \text { for } a \leq b \in \mathbb { Z } \, .
$$
```
  FIX: ```
\[
\begin{aligned}
( a , b ) _ { B L } & \colon = \{ ( x , y ) \in \mathbb { Z } ^ { \mathrm{op} } \times \mathbb { Z } \mid a < x , y < b \} \quad \text { for } a < b \in \mathbb { Z } \cup \{ - \infty , \infty \} , \\ [ a , b ) _ { B L } & \colon = \{ ( x , y ) \in \mathbb { Z } ^ { \mathrm{op} } \times \mathbb { Z } \mid a \leq y < b \} \quad \text { for } a < b \in \mathbb { Z } \cup \{ \infty \} , \\ ( a , b ] _ { B L } & \colon = \{ ( x , y ) \in \mathbb { Z } ^ { \mathrm{op} } \times \mathbb { Z } \mid a < x \leq b \} \quad \text { for } a < b \in \mathbb { Z } \cup \{ - \infty \} , \\ [ a , b ] _ { B L } & \colon = \{ ( x , y ) \in \mathbb { Z } ^ { \mathrm{op} } \times \mathbb { Z } \mid x \leq b , y \geq a \} \quad \text { for } a \leq b \in \mathbb { Z } \, .
\end{aligned}
\]
```
- RAW: `Again, by ⟨ a,b ⟩ BL we denote a block of any of the above types.`
  FIX: `Again, by \( \langle a,b \rangle_{BL} \) we denote a block of any of the above types.`
- RAW: `Remark 4.1 Note that there is a canonical isomorphism between vec op × and vec × induced by the isomorphism ρ : × → op × sending each ( a,b ) to ( − a,b ) . As a result, a op × -indexed persistence module in general does not decompose into a direct sum of interval modules, just like 2 -indexed modules. Hence, block decomposable modules are a proper subset of all op × -indexed modules.`
  FIX: `Remark 4.1 Note that there is a canonical isomorphism between \( \mathrm{vec}^{\mathbb{Z}^{\mathrm{op}} \times \mathbb{Z}} \) and \( \mathrm{vec}^{\mathbb{Z} \times \mathbb{Z}} \) induced by the isomorphism \( \rho \colon \mathbb{Z} \times \mathbb{Z} \to \mathbb{Z}^{\mathrm{op}} \times \mathbb{Z} \) sending each \( (a,b) \) to \( (-a,b) \). As a result, a \( \mathbb{Z}^{\mathrm{op}} \times \mathbb{Z} \)-indexed persistence module in general does not decompose into a direct sum of interval modules, just like \( \mathbb{Z}^2 \)-indexed modules. Hence, block decomposable modules are a proper subset of all \( \mathbb{Z}^{\mathrm{op}} \times \mathbb{Z} \)-indexed modules.`
- RAW: `The following lemma motivates why E is called the block extension functor.`
  FIX: `The following lemma motivates why \( E \) is called the block extension functor.`
- RAW: `Lemma 4.2 The block extension functor E sends zigzag interval modules to block interval modules, i.e. it holds that E ( I ⟨ a,b ⟩ ZZ ) = I ⟨ a,b ⟩ BL .`
  FIX: `Lemma 4.2 The block extension functor \( E \) sends zigzag interval modules to block interval modules, i.e. it holds that \( E ( I_{\langle a,b \rangle_{ZZ}} ) = I_{\langle a,b \rangle_{BL}} \).`
