# Manifest: Page 017

## REPAIR_MATH
- RAW: ```
\{ i \in \mathbb { Z } | \iota ( i ) \leq ( a , b ) \in \mathbb { Z } ^ { \text {op} } \times \mathbb { Z } \} = \begin{cases} [ a , b ] & \text {if both a and b are source indices,} \\ [ a , b + 1 ] & \text {if a is a source and b is a sink index,} \\ [ a - 1 , b + 1 ] & \text {if both a and b are sink indices,} \\ [ a - 1 , b ] & \text {if a is a sink and b is a source index.} \end{cases}
```
  FIX: ```
\[
\{ i \in \mathbb { Z } \mid \iota ( i ) \leq ( a , b ) \in \mathbb { Z } ^ { \text {op} } \times \mathbb { Z } \} = \begin{cases} [ a , b ] & \text {if both a and b are source indices,} \\ [ a , b + 1 ] & \text {if a is a source and b is a sink index,} \\ [ a - 1 , b + 1 ] & \text {if both a and b are sink indices,} \\ [ a - 1 , b ] & \text {if a is a sink and b is a source index.} \end{cases}
\]
```
- RAW: ```
E ( M ) ( a , b ) = \varprojlim _ { \longrightarrow } M | _ { \{ i \in \mathbb { Z } \ | \iota ( i ) \leq ( a , b ) \in \mathbb { Z } ^ { \circ p } \times \mathbb { Z } \} } = \varlim _ { \longrightarrow } M | _ { [ a , b ] } .
```
  FIX: ```
\[
E ( M ) ( a , b ) = \varprojlim _ { \longrightarrow } M | _ { \{ i \in \mathbb { Z } \mid \iota ( i ) \leq ( a , b ) \in \mathbb { Z } ^ { \text {op} } \times \mathbb { Z } \} } = \varinjlim _ { \longrightarrow } M | _ { [ a , b ] } .
\]
```
- RAW: ```
E ( M ) ( i , i + 1 ) = \begin{cases} M _ { i } & \text {if $i$ is a sink index,} \\ M _ { i + 1 } & \text {if $i$ is a source index.} \end{cases}
```
  FIX: ```
\[
E ( M ) ( i , i + 1 ) = \begin{cases} M _ { i } & \text {if $i$ is a sink index,} \\ M _ { i + 1 } & \text {if $i$ is a source index.} \end{cases}
\]
```
- RAW: ```
E ( M ) ( a , b ) = \varprojlim _ { \longleftrightarrow } ( E _ { 1 } ( M ) | _ { U } ) | _ { S } ,
```
  FIX: ```
\[
E ( M ) ( a , b ) = \varprojlim _ { \longleftrightarrow } ( E _ { 1 } ( M ) | _ { U } ) | _ { S } ,
\]
```
- RAW: ```
E ( M ) ( a , b ) = \varprojlim _ { \longleftarrow } \left ( E _ { 1 } ( M ) | _ { U } \right ) | _ { S } = \varprojlim _ { \longleftarrow } E _ { 1 } ( M ) | _ { S \cap U _ { L } } .
```
  FIX: ```
\[
E ( M ) ( a , b ) = \varprojlim _ { \longleftarrow } \left ( E _ { 1 } ( M ) | _ { U } \right ) | _ { S } = \varprojlim _ { \longleftarrow } E _ { 1 } ( M ) | _ { S \cap U _ { L } } .
\]
```
- RAW: ```
S \cap U _ { L } = \begin{cases} [ b - 1 , a + 1 ] & \text {if both $a$ and $b$ are source indices,} \\ [ b , a + 1 ] & \text {if a is a source and $b$ is a sink index,} \\ [ b , a ] & \text {if both $a$ and $b$ are sink indices,} \\ [ b - 1 , a ] & \text {if a is a sink and $b$ is a source index.} \end{cases}
```
  FIX: ```
\[
S \cap U _ { L } = \begin{cases} [ b - 1 , a + 1 ] & \text {if both $a$ and $b$ are source indices,} \\ [ b , a + 1 ] & \text {if a is a source and $b$ is a sink index,} \\ [ b , a ] & \text {if both $a$ and $b$ are sink indices,} \\ [ b - 1 , a ] & \text {if a is a sink and $b$ is a source index.} \end{cases}
\]
```
- RAW: ```
E ( M ) ( a , b ) = \lim _ { \longleftrightarrow } M | _ { [ b , a ] } . \quad \Box
```
  FIX: ```
\[
E ( M ) ( a , b ) = \lim _ { \longleftrightarrow } M | _ { [ b , a ] } . \quad \Box
\]
```

## REPAIR_PROSE
- RAW: `By definition of the inclusion ι : ZZ → op × , we have`
  FIX: `By definition of the inclusion \( \iota \colon \mathbb{Z} \to \mathbb{Z}^{\text{op}} \times \mathbb{Z} \), we have`

- RAW: `In each of this four cases [ a,b ] is an upper fence of the respective interval. Using Proposition 2.21 we obtain`
  FIX: `In each of these four cases \( [a,b] \) is an upper fence of the respective interval. Using Proposition 2.21 we obtain`

- RAW: `E ( M )( a,b ) = lim −→ M | { i ∈ | ι ( i ) ≤ ( a,b ) ∈ op × } = lim −→ M | [ a,b ] . It remains to show that E ( M )( a,b ) = lim ←− M | [ b,a ] for a > b . We again use the observation in Proposition 2.21 that limits only depend on lower fences of posets. One lower fence of the poset U is given by the set U L := { ( i,j ) | i ∈ ,j = i or j = i + 1 } . We have that E ( M )( i,i ) = M i and`
  FIX: `It remains to show that \( E(M)(a,b) = \varprojlim_{\longleftarrow} M|_{[b,a]} \) for \( a > b \). We again use the observation in Proposition 2.21 that limits only depend on lower fences of posets. One lower fence of the poset \( U \) is given by the set \( U_L := \{ (i,j) \mid i \in \mathbb{Z}, j = i \text{ or } j = i+1 \} \). We have that \( E(M)(i,i) = M_i \) and`

- RAW: `with S := { ( i,j ) ∈ U | ( i,j ) ≥ ( a,b ) } . Observe that S ∩ U L is a lower fence of S ∩ U and so`
  FIX: `with \( S := \{ (i,j) \in U \mid (i,j) \geq (a,b) \} \). Observe that \( S \cap U_L \) is a lower fence of \( S \cap U \) and so`

- RAW: `In each of these cases the interval [ b,a ] is a lower fence and thus,`
  FIX: `In each of these cases the interval \( [b,a] \) is a lower fence and thus,`

- RAW: ```
We consider an extended zigzag module as a functor M : ZZ × → vec . In the following, by M ( · ,z ) we mean the zigzag module M | { ( x,z ): x ∈ ZZ } and by E ( M )( · , · ,z ) we mean the op × -indexed module E ( M ) | { ( x,y,z ): x ∈ op ,y ∈ } . We define a functor E : vec ZZ × → vec op × × as follows 1. On objects: for an extended zigzag module M vec ZZ × we define E ( M )( , ,z ) :=

∈ · · E (( M )( · ,z )) . The vertical structure maps in M can be seen as morphisms between the zigzag modules M ( · ,z 1 ) and M ( · ,z 2 ) for z 1 ≤ z 2 . Hence, they induce morphisms E ( M )( · , · ,z 1 ) → E ( M )( · , · ,z 2 ) , which themselves become the structure maps of E ( M ) .
```
  FIX: ```
We consider an extended zigzag module as a functor \( M \colon \mathbb{Z} \times \mathbb{R} \to \text{vec} \). In the following, by \( M(\cdot, z) \) we mean the zigzag module \( M|_{\{ (x,z) : x \in \mathbb{Z} \}} \) and by \( E(M)(\cdot, \cdot, z) \) we mean the \( \mathbb{Z}^{\text{op}} \times \mathbb{Z} \)-indexed module \( E(M)|_{\{ (x,y,z) : x \in \mathbb{Z}^{\text{op}}, y \in \mathbb{Z} \}} \). We define a functor \( E \colon \text{vec}^{\mathbb{Z} \times \mathbb{R}} \to \text{vec}^{\mathbb{Z}^{\text{op}} \times \mathbb{Z} \times \mathbb{R}} \) as follows: 1. On objects: for an extended zigzag module \( M \in \text{vec}^{\mathbb{Z} \times \mathbb{R}} \) we define \( E(M)(\cdot, \cdot, z) := E(M(\cdot, z)) \). The vertical structure maps in \( M \) can be seen as morphisms between the zigzag modules \( M(\cdot, z_1) \) and \( M(\cdot, z_2) \) for \( z_1 \leq z_2 \). Hence, they induce morphisms \( E(M)(\cdot, \cdot, z_1) \to E(M)(\cdot, \cdot, z_2) \), which themselves become the structure maps of \( E(M) \).
```
