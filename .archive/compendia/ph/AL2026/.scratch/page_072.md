[Page 72]

Case 2. Suppose t = n and t ′ = m . Then sc( I ) = { ˆ 0 } , sc 1 ( I ) = ∅ , sc( ⇑ I ) = { ˆ 1 } . On the other hand, sk( I ) = { t,t ′ } , sk 1 ( I ) = { ˆ 0 } , sk( ⇓ I ) = ∅ . Then we obtain

$$
d _ { M } ( V _ { I } ) = \text {rank} \begin{bmatrix} M _ { \hat { 1 } , \hat { 0 } } \\ M _ { t , \hat { 0 } } \end{bmatrix} - \text {rank} \, M _ { \hat { 1 } , \hat { 0 } } - \text {rank} \begin{bmatrix} M _ { t , \hat { 0 } } \\ - M _ { t ^ { \prime } , \hat { 0 } } \end{bmatrix} - \text {rank} \begin{bmatrix} M _ { t , \hat { 0 } } \\ - M _ { t ^ { \prime } , \hat { 0 } } \end{bmatrix}
$$

Case 3. Suppose t,t ′ are not in the above two cases. Then sc( I ) = { ˆ 0 } , sc 1 ( I ) = ∅ , sc( ⇑ I ) = { t +1 ,t ′ +1 ′ } . On the other hand, sk( I ) = { t,t ′ } , sk 1 ( I ) = { ˆ 0 } , sk( ⇓ I ) = ∅ . Then we obtain

$$
d _ { M } ( V _ { I } ) = \text {rank} \begin{bmatrix} M _ { t + 1 , \hat { 0 } } \\ M _ { t ^ { \prime } + 1 , \hat { 0 } } \end{bmatrix} - \text {rank} \begin{bmatrix} M _ { t ^ { \prime } + 1 , \hat { 0 } } \\ M _ { t ^ { \prime } + 1 , \hat { 0 } } \end{bmatrix} - \text {rank} \begin{bmatrix} M _ { t + 1 , \hat { 0 } } \\ M _ { t ^ { \prime } + 1 , \hat { 0 } } \end{bmatrix} - \text {rank} \begin{bmatrix} M _ { t , \hat { 0 } } \\ - M _ { t ^ { \prime } , \hat { 0 } } \end{bmatrix} .
$$

Notice that if we let t = n and t ′ = m in ( 6.91 ), then the result coincides with ( 6.90 ). Therefore, we can unify Case 2 and Case 3 and summarize the final result as follows: ˆ ˆ

Case 1*. If t = 0 or t ′ = 0 , then we have

$$
d _ { M } ( V _ { I } ) = \text {rank} \begin{bmatrix} M _ { t + 1 , \hat { 0 } } \\ M _ { t ^ { \prime } + 1 ^ { \prime } , \hat { 0 } } \\ M _ { \max \{ t , t ^ { \prime } \} , \hat { 0 } } \end{bmatrix} - \text {rank} \begin{bmatrix} M _ { t + 1 , \hat { 0 } } \\ M _ { t ^ { \prime } + 1 ^ { \prime } , \hat { 0 } } \end{bmatrix} .
$$

Case 2*. If t ̸ = ˆ 0 and t ′ ̸ = ˆ 0 , then



$$
d _ { M } ( V _ { I } ) = \text {rank} \begin{bmatrix} M _ { t + 1 , \hat { 0 } } \\ M _ { t ^ { \prime } + 1 , \hat { 0 } } \end{bmatrix} - \text {rank} \begin{bmatrix} M _ { t ^ { \prime } + 1 , \hat { 0 } } \\ M _ { t ^ { \prime } + 1 , \hat { 0 } } \end{bmatrix} - \text {rank} \begin{bmatrix} M _ { t + 1 , \hat { 0 } } \\ M _ { t ^ { \prime } + 1 , \hat { 0 } } \end{bmatrix} - \text {rank} \begin{bmatrix} M _ { t , \hat { 0 } } \\ - M _ { t ^ { \prime } , \hat { 0 } } \end{bmatrix} .
$$

(v) Let I : = [ s, ˆ 1] ∪ [ s ′ , ˆ 1] for some s ∈ U \ { ˆ 0 } and s ′ ∈ D \ { ˆ 0 } . This case is just the dual of case (iv) above, and we analogously obtain the following. Case 1 ′ . If s = ˆ 1 or s ′ = ˆ 1 , then we have

$$
d _ { M } ( V _ { I } ) = \text {rank} \left [ M _ { \hat { 1 } , \min \{ s , s ^ { \prime } \} } \, | \, M _ { \hat { 1 } , s - 1 } \ M _ { \hat { 1 } , s ^ { \prime } - 1 ^ { \prime } } \right ] - \text {rank} \left [ M _ { \hat { 1 } , s - 1 } \ M _ { \hat { 1 } , s ^ { \prime } - 1 ^ { \prime } } \right ] .
$$

Case 2 ′ . If s ̸ = ˆ 1 and s ′ ̸ = ˆ 1 , then we have



$$
\begin{aligned}
d _ { M } ( V _ { I } ) & = \text {rank} \left [ \begin{array}{cc|cc} M _ { \hat { 1 } , s } & M _ { \hat { 1 } , s ^ { \prime } } & M _ { \hat { 1 } , s - 1 } & M _ { \hat { 1 } , s ^ { \prime } - 1 ^ { \prime } } \\ M _ { \hat { 1 } , s } & 0 & 0 & 0 \end{array} \right ] - \text {rank} \left [ M _ { \hat { 1 } , s } \ M _ { \hat { 1 } , s ^ { \prime } } \right ] \\ & - \text {rank} \left [ M _ { \hat { 1 } , s - 1 } \ M _ { \hat { 1 } , s ^ { \prime } - 1 ^ { \prime } } \right ] .
\end{aligned}
$$
