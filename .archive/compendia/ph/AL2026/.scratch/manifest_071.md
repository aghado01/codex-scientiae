# Manifest: Page 071

## REPAIR_MATH
- RAW: ```
\hat { 0 } + 1 \coloneqq 1 , \, n + 1 \coloneqq \hat { 1 } \\ \hat { 0 } + 1 ^ { \prime } \coloneqq 1 ^ { \prime } , \, t ^ { \prime } + 1 ^ { \prime } \coloneqq ( t + 1 ) ^ { \prime } \, ( t ^ { \prime } \in [ m - 1 ] ^ { \prime } ) , \, m ^ { \prime } + 1 ^ { \prime } \coloneqq \hat { 1 } , \\ 1 - 1 \coloneqq \hat { 0 } , \, \hat { 1 } - 1 \coloneqq n , \\ 1 ^ { \prime } - 1 ^ { \prime } \coloneqq \hat { 0 } , \, s ^ { \prime } - 1 ^ { \prime } \coloneqq ( s - 1 ) ^ { \prime } \, ( s ^ { \prime } \in [ 2 ^ { \prime } , m ^ { \prime } ] ) , \, \hat { 1 } - 1 ^ { \prime } \coloneqq m ^ { \prime } ,
```
  FIX: ```
$$
\hat { 0 } + 1 \coloneqq 1 , \, n + 1 \coloneqq \hat { 1 } \\ \hat { 0 } + 1 ^ { \prime } \coloneqq 1 ^ { \prime } , \, t ^ { \prime } + 1 ^ { \prime } \coloneqq ( t + 1 ) ^ { \prime } \, ( t ^ { \prime } \in [ m - 1 ] ^ { \prime } ) , \, m ^ { \prime } + 1 ^ { \prime } \coloneqq \hat { 1 } , \\ 1 - 1 \coloneqq \hat { 0 } , \, \hat { 1 } - 1 \coloneqq n , \\ 1 ^ { \prime } - 1 ^ { \prime } \coloneqq \hat { 0 } , \, s ^ { \prime } - 1 ^ { \prime } \coloneqq ( s - 1 ) ^ { \prime } \, ( s ^ { \prime } \in [ 2 ^ { \prime } , m ^ { \prime } ] ) , \, \hat { 1 } - 1 ^ { \prime } \coloneqq m ^ { \prime } ,
$$
```
- RAW: ```
d _ { M } ( V _ { I } ) = \text {rank} \, M _ { \hat { 1 } , \hat { 0 } }
```
  FIX: ```
$$
d _ { M } ( V _ { I } ) = \text {rank} \, M _ { \hat { 1 } , \hat { 0 } }
$$
```
- RAW: ```
d _ { M } ( V _ { I } ) = \text {rank} \left [ \frac { M _ { t + 1 , s } } { M _ { t , s } \ \ M _ { t , s - 1 } } \right ] - \text {rank} \, M _ { t + 1 , s } - \text {rank} \, M _ { t , s - 1 } .
```
  FIX: ```
$$
d _ { M } ( V _ { I } ) = \text {rank} \left [ \frac { M _ { t + 1 , s } } { M _ { t , s } \ \ M _ { t , s - 1 } } \right ] - \text {rank} \, M _ { t + 1 , s } - \text {rank} \, M _ { t , s - 1 } .
$$
```
- RAW: ```
d _ { M } ( V _ { I } ) = \text {rank} \left [ \frac { M _ { t ^ { \prime } + 1 ^ { \prime } , s ^ { \prime } } } { M _ { t ^ { \prime } , s ^ { \prime } } } \Big | _ { M _ { t ^ { \prime } , s ^ { \prime } - 1 ^ { \prime } } } \right ] - \text {rank} \, M _ { t ^ { \prime } + 1 ^ { \prime } , s ^ { \prime } } - \text {rank} \, M _ { t ^ { \prime } , s ^ { \prime } - 1 ^ { \prime } } .
```
  FIX: ```
$$
d _ { M } ( V _ { I } ) = \text {rank} \left [ \frac { M _ { t ^ { \prime } + 1 ^ { \prime } , s ^ { \prime } } } { M _ { t ^ { \prime } , s ^ { \prime } } } \Big | _ { M _ { t ^ { \prime } , s ^ { \prime } - 1 ^ { \prime } } } \right ] - \text {rank} \, M _ { t ^ { \prime } + 1 ^ { \prime } , s ^ { \prime } } - \text {rank} \, M _ { t ^ { \prime } , s ^ { \prime } - 1 ^ { \prime } } .
$$
```
- RAW: ```
d _ { M } ( V _ { I } ) = \text {rank} \begin{bmatrix} M _ { t + 1 , \hat { 0 } } \\ M _ { t ^ { \prime } + 1 ^ { \prime } , \hat { 0 } } \\ M _ { \max \{ t , t ^ { \prime } \} , \hat { 0 } } \end{bmatrix} - \text {rank} \begin{bmatrix} M _ { t + 1 , \hat { 0 } } \\ M _ { t ^ { \prime } + 1 ^ { \prime } , \hat { 0 } } \\ \end{bmatrix} .
```
  FIX: ```
$$
d _ { M } ( V _ { I } ) = \text {rank} \begin{bmatrix} M _ { t + 1 , \hat { 0 } } \\ M _ { t ^ { \prime } + 1 ^ { \prime } , \hat { 0 } } \\ M _ { \max \{ t , t ^ { \prime } \} , \hat { 0 } } \end{bmatrix} - \text {rank} \begin{bmatrix} M _ { t + 1 , \hat { 0 } } \\ M _ { t ^ { \prime } + 1 ^ { \prime } , \hat { 0 } } \\ \end{bmatrix} .
$$
```



## REPAIR_PROSE
- RAW: ` We write I d to denote the set of all intervals having this type. ˆ ˆ ˆ ˆ`
  FIX: ` We write \( I_d \) to denote the set of all intervals having this type.`
- RAW: ` We write I l to denote the set of all intervals having this type. ˆ ˆ ˆ ˆ`
  FIX: ` We write \( I_l \) to denote the set of all intervals having this type.`
- RAW: ` We write I r to denote the set of all intervals having this type.`
  FIX: ` We write \( I_r \) to denote the set of all intervals having this type.`

## REPAIR_MATH
- RAW: `I : = [ s ′ ,t ′ ] : = { x ′ ∈ B n,m | s ′ ≤ x ′ ≤ t ′ }`
  FIX: `\( I := [ s' , t' ] := \{ x' \in B_{n,m} \mid s' \le x' \le t' \} \)`
- RAW: `s ′ ,t ′ ∈ [ m ] ′`
  FIX: `\( s' , t' \in [m]' \)`
- RAW: `I : = [ 0 ,t ] ∪ [ 0 ,t ′ ]`
  FIX: `\( I := [ \hat{0} , t ] \cup [ \hat{0} , t' ] \)`
- RAW: `t ∈ U \{ 1 }`
  FIX: `\( t \in U \setminus \{ \hat{1} \} \)`
- RAW: `t ′ ∈ D \{ 1 }`
  FIX: `\( t' \in D \setminus \{ \hat{1} \} \)`
- RAW: `I : = [ s, 1] ∪ [ s ′ , 1]`
  FIX: `\( I := [ s, \hat{1} ] \cup [ s' , \hat{1} ] \)`
- RAW: `s ∈ U \ { 0 }`
  FIX: `\( s \in U \setminus \{ \hat{0} \} \)`
- RAW: `s ′ ∈ D \ { 0 }`
  FIX: `\( s' \in D \setminus \{ \hat{0} \} \)`
- RAW: `d M ( V I )`
  FIX: `\( d_M(V_I) \)`
- RAW: `I = B n,m`
  FIX: `\( I = B_{n,m} \)`
- RAW: `V I`
  FIX: `\( V_I \)`
- RAW: `mod k [ P ]`
  FIX: `\( \operatorname{mod} k[P] \)`
- RAW: `sc 1 ( I )`
  FIX: `\( \operatorname{sc}_1(I) \)`
- RAW: `sc( ⇑ I )`
  FIX: `\( \operatorname{sc}(\Uparrow I) \)`
- RAW: `I : = [ s,t ] : = { x ∈ B n,m | s ≤ x ≤ t }`
  FIX: `\( I := [s, t] := \{ x \in B_{n,m} \mid s \le x \le t \} \)`
- RAW: `s,t ∈ [ n ]`
  FIX: `\( s, t \in [n] \)`
- RAW: `sc( I ) = { s }`
  FIX: `\( \operatorname{sc}(I) = \{s\} \)`
- RAW: `sc 1 ( I ) = ∅`
  FIX: `\( \operatorname{sc}_1(I) = \emptyset \)`
- RAW: `sc( ⇑ I ) = { t +1 }`
  FIX: `\( \operatorname{sc}(\Uparrow I) = \{t+1\} \)`
- RAW: `sk( I ) = { t }`
  FIX: `\( \operatorname{sk}(I) = \{t\} \)`
- RAW: `sk 1 ( I ) = ∅`
  FIX: `\( \operatorname{sk}_1(I) = \emptyset \)`
- RAW: `sk( ⇓ I ) = { s − 1 }`
  FIX: `\( \operatorname{sk}(\Downarrow I) = \{s-1\} \)`
- RAW: `I : = [ ˆ 0 ,t ] ∪ [ ˆ 0 ,t ′ ]`
  FIX: `\( I := [\hat{0}, t] \cup [\hat{0}, t'] \)`
- RAW: `t ∈ U \ { ˆ 1 }`
  FIX: `\( t \in U \setminus \{\hat{1}\} \)`
- RAW: `t ′ ∈ D \ { ˆ 1 }`
  FIX: `\( t' \in D \setminus \{\hat{1}\} \)`
- RAW: `t = ˆ 0`
  FIX: `\( t = \hat{0} \)`
- RAW: `t ′ = ˆ 0`
  FIX: `\( t' = \hat{0} \)`
- RAW: `max( I ) = max { t,t ′ }`
  FIX: `\( \max(I) = \max\{t, t'\} \)`
- RAW: `sc( I ) = { ˆ 0 }`
  FIX: `\( \operatorname{sc}(I) = \{\hat{0}\} \)`
- RAW: `sc( ⇑ I ) = { t + 1 ,t ′ + 1 ′ }`
  FIX: `\( \operatorname{sc}(\Uparrow I) = \{t+1, t'+1'\} \)`

