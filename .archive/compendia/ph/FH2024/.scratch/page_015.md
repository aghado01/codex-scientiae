[Page 15]

![The image consists of a diagram with four different shapes and four different points. The shapes are labeled as follows: 1. **Rectangle**: This shape has four vertices labeled as A, B, C, and D. 2. **Cube**: This shape has four vertices labeled as A, B, C, and D. 3. **Cylinder**: This shape has four vertices labeled as A, B, C, and D. 4. **Cubic Cone**: This shape has four vertices labeled as A, B, C, and D. The points are labeled as follows: - A: 0 - B: 0 - C: 0 - D: 0 The diagram is labeled as follows: - The diagram is a diagram of a geometric figure. - The vertices are labeled as A, B, C, and D. - The line segments are labeled as AB, BC, CD](<FH2024/imageFile2.png>)

Figure 3: Extension of zigzag intervals to block intervals for the four different types ( · , · ) , [ · , · ) , ( · , · ] and [ · , · ] (in that order). Cf. Figure 3 in [3].

By \( \langle a,b \rangle_{ZZ} \) we denote an interval of any of these four types.

In \( \mathrm{vec}^{\mathbb{Z}^{\mathrm{op}} \times \mathbb{Z}} \), we consider a special class of persistence modules that are called block decomposable modules [3]. These are modules that decompose into a direct sum of block intervals, where the blocks are sets of the following forms

\[
\begin{aligned}
( a , b ) _ { B L } & \colon = \{ ( x , y ) \in \mathbb { Z } ^ { \mathrm{op} } \times \mathbb { Z } \mid a < x , y < b \} \quad \text { for } a < b \in \mathbb { Z } \cup \{ - \infty , \infty \} , \\ [ a , b ) _ { B L } & \colon = \{ ( x , y ) \in \mathbb { Z } ^ { \mathrm{op} } \times \mathbb { Z } \mid a \leq y < b \} \quad \text { for } a < b \in \mathbb { Z } \cup \{ \infty \} , \\ ( a , b ] _ { B L } & \colon = \{ ( x , y ) \in \mathbb { Z } ^ { \mathrm{op} } \times \mathbb { Z } \mid a < x \leq b \} \quad \text { for } a < b \in \mathbb { Z } \cup \{ - \infty \} , \\ [ a , b ] _ { B L } & \colon = \{ ( x , y ) \in \mathbb { Z } ^ { \mathrm{op} } \times \mathbb { Z } \mid x \leq b , y \geq a \} \quad \text { for } a \leq b \in \mathbb { Z } \, .
\end{aligned}
\]

Again, by ⟨ a,b ⟩ BL we denote a block of any of the above types.

Remark 4.1 Note that there is a canonical isomorphism between vec op × and vec × induced by the isomorphism ρ : × → op × sending each ( a,b ) to ( − a,b ) . As a result, a op × -indexed persistence module in general does not decompose into a direct sum of interval modules, just like 2 -indexed modules. Hence, block decomposable modules are a proper subset of all op × -indexed modules.

The following lemma motivates why E is called the block extension functor.

Lemma 4.2 The block extension functor E sends zigzag interval modules to block interval modules, i.e. it holds that E ( I ⟨ a,b ⟩ ZZ ) = I ⟨ a,b ⟩ BL .
