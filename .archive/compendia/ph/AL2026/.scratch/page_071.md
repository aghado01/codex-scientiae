[Page 71]

- (iii) I : = [ s ′ ,t ′ ] : = { x ′ ∈ B n,m | s ′ ≤ x ′ ≤ t ′ } for some s ′ ,t ′ ∈ [ m ] ′ . We write I d to denote the set of all intervals having this type. ˆ ˆ ˆ ˆ
- (iv) I : = [ 0 ,t ] ∪ [ 0 ,t ′ ] for some t ∈ U \{ 1 } and t ′ ∈ D \{ 1 } . We write I l to denote the set of all intervals having this type. ˆ ˆ ˆ ˆ
- (v) I : = [ s, 1] ∪ [ s ′ , 1] for some s ∈ U \ { 0 } and s ′ ∈ D \ { 0 } . We write I r to denote the set of all intervals having this type.


From now on, we provide the formula of d M ( V I ) case by case. Before doing so, we set the following conventions, which are used below:

$$
\hat { 0 } + 1 \coloneqq 1 , \, n + 1 \coloneqq \hat { 1 } \\ \hat { 0 } + 1 ^ { \prime } \coloneqq 1 ^ { \prime } , \, t ^ { \prime } + 1 ^ { \prime } \coloneqq ( t + 1 ) ^ { \prime } \, ( t ^ { \prime } \in [ m - 1 ] ^ { \prime } ) , \, m ^ { \prime } + 1 ^ { \prime } \coloneqq \hat { 1 } , \\ 1 - 1 \coloneqq \hat { 0 } , \, \hat { 1 } - 1 \coloneqq n , \\ 1 ^ { \prime } - 1 ^ { \prime } \coloneqq \hat { 0 } , \, s ^ { \prime } - 1 ^ { \prime } \coloneqq ( s - 1 ) ^ { \prime } \, ( s ^ { \prime } \in [ 2 ^ { \prime } , m ^ { \prime } ] ) , \, \hat { 1 } - 1 ^ { \prime } \coloneqq m ^ { \prime } ,
$$

(i) Let I = B n,m . Since V I is injective in mod k [ P ] , we apply ( 3.23 ) here and obtain

$$
d _ { M } ( V _ { I } ) = \text {rank} \, M _ { \hat { 1 } , \hat { 0 } }
$$

by noticing both sc 1 ( I ) and sc( ⇑ I ) are empty.

- (ii) Let I : = [ s,t ] : = { x ∈ B n,m | s ≤ x ≤ t } for some s,t ∈ [ n ] . Since V I is noninjective in mod k [ P ] , we apply ( 3.37 ) here. In this case, sc( I ) = { s } , sc 1 ( I ) = ∅ , sc( ⇑ I ) = { t +1 } . On the other hand, sk( I ) = { t } , sk 1 ( I ) = ∅ , sk( ⇓ I ) = { s − 1 } . Then we obtain

$$
d _ { M } ( V _ { I } ) = \text {rank} \left [ \frac { M _ { t + 1 , s } } { M _ { t , s } \ \ M _ { t , s - 1 } } \right ] - \text {rank} \, M _ { t + 1 , s } - \text {rank} \, M _ { t , s - 1 } .
$$

- (iii) Let I : = [ s ′ ,t ′ ] : = { x ′ ∈ B n,m | s ′ ≤ x ′ ≤ t ′ } for some s ′ ,t ′ ∈ [ m ] ′ . This case is similar to the above case and thus we obtain

$$
d _ { M } ( V _ { I } ) = \text {rank} \left [ \frac { M _ { t ^ { \prime } + 1 ^ { \prime } , s ^ { \prime } } } { M _ { t ^ { \prime } , s ^ { \prime } } } \Big | _ { M _ { t ^ { \prime } , s ^ { \prime } - 1 ^ { \prime } } } \right ] - \text {rank} \, M _ { t ^ { \prime } + 1 ^ { \prime } , s ^ { \prime } } - \text {rank} \, M _ { t ^ { \prime } , s ^ { \prime } - 1 ^ { \prime } } .
$$

- (iv) Let I : = [ ˆ 0 ,t ] ∪ [ ˆ 0 ,t ′ ] for some t ∈ U \ { ˆ 1 } and t ′ ∈ D \ { ˆ 1 } . Case 1. Suppose t = ˆ 0 or t ′ = ˆ 0 . Then V I is an injective module in mod k [ P ] with max( I ) = max { t,t ′ } . Hence we apply ( 3.23 ) here. In this case, sc( I ) = { ˆ 0 } , sc 1 ( I ) = ∅ , sc( ⇑ I ) = { t + 1 ,t ′ + 1 ′ } . Then we obtain


$$
d _ { M } ( V _ { I } ) = \text {rank} \begin{bmatrix} M _ { t + 1 , \hat { 0 } } \\ M _ { t ^ { \prime } + 1 ^ { \prime } , \hat { 0 } } \\ M _ { \max \{ t , t ^ { \prime } \} , \hat { 0 } } \end{bmatrix} - \text {rank} \begin{bmatrix} M _ { t + 1 , \hat { 0 } } \\ M _ { t ^ { \prime } + 1 ^ { \prime } , \hat { 0 } } \\ \end{bmatrix} .
$$
