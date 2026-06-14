# Manifest: Page 069

## REPAIR_MATH
- RAW: ```
g \coloneqq [ g _ { 3 } | g _ { 2 } ] = \begin{bmatrix} 0 & p _ { 1 , 2 } & p _ { 1 , 2 } & 0 \\ p _ { 3 , 2 } & - p _ { 3 , 2 } & 0 & p _ { 3 , 2 } \\ 0 & 0 & - p _ { 4 , 2 } & - p _ { 4 , 2 } \end{bmatrix} .
```
  FIX: ```
$$
g \coloneqq [ g _ { 3 } | g _ { 2 } ] = \begin{bmatrix} 0 & p _ { 1 , 2 } & p _ { 1 , 2 } & 0 \\ p _ { 3 , 2 } & - p _ { 3 , 2 } & 0 & p _ { 3 , 2 } \\ 0 & 0 & - p _ { 4 , 2 } & - p _ { 4 , 2 } \end{bmatrix} .
$$
```
- RAW: ```
\tilde { g } \coloneqq \left [ g _ { 3 } | \tilde { g } _ { 2 } \right ] = \left [ \begin{matrix} 0 & p _ { 1 , 2 } & p _ { 1 , 2 } \\ p _ { 3 , 2 } & - p _ { 3 , 2 } & 0 \\ 0 & 0 & - p _ { 4 , 2 } \end{matrix} \right ] ,
```
  FIX: ```
$$
\tilde { g } \coloneqq \left [ g _ { 3 } | \tilde { g } _ { 2 } \right ] = \left [ \begin{matrix} 0 & p _ { 1 , 2 } & p _ { 1 , 2 } \\ p _ { 3 , 2 } & - p _ { 3 , 2 } & 0 \\ 0 & 0 & - p _ { 4 , 2 } \end{matrix} \right ] ,
$$
```
- RAW: ```
\zeta ( x ) \coloneqq \begin{cases} 2 , & \text {if } x \in \{ 2 , 2 ^ { \prime } , 2 ^ { \prime \prime } \} , \\ x , & \text {if } x \in \{ 1 , 3 , 4 \} . \end{cases}
```
  FIX: ```
$$
\zeta ( x ) \coloneqq \begin{cases} 2 , & \text {if } x \in \{ 2 , 2 ^ { \prime } , 2 ^ { \prime \prime } \} , \\ x , & \text {if } x \in \{ 1 , 3 , 4 \} . \end{cases}
$$
```
- RAW: ```
\mathbb { k } [ \zeta ] \left ( \left [ p _ { 3 , 2 } \right | - p _ { 3 , 2 ^ { \prime } } \right ] \, 0 \, \right ) = \begin{bmatrix} 0 & p _ { 1 , 2 ^ { \prime } } & p _ { 1 , 2 ^ { \prime \prime } } \\ p _ { 3 , 2 } & - p _ { 3 , 2 ^ { \prime } } & 0 \\ 0 & 0 & - p _ { 4 , 2 ^ { \prime \prime } } \end{bmatrix} \right ) = \begin{bmatrix} 0 & p _ { 1 , 2 } & p _ { 1 , 2 } \\ p _ { 3 , 2 } & - p _ { 3 , 2 } & 0 \\ 0 & 0 & - p _ { 4 , 2 } \end{bmatrix}
```
  FIX: ```
$$
\mathbb { k } [ \zeta ] \left ( \left [ p _ { 3 , 2 } \right | - p _ { 3 , 2 ^ { \prime } } \right ] \, 0 \, \right ) = \begin{bmatrix} 0 & p _ { 1 , 2 ^ { \prime } } & p _ { 1 , 2 ^ { \prime \prime } } \\ p _ { 3 , 2 } & - p _ { 3 , 2 ^ { \prime } } & 0 \\ 0 & 0 & - p _ { 4 , 2 ^ { \prime \prime } } \end{bmatrix} \right ) = \begin{bmatrix} 0 & p _ { 1 , 2 } & p _ { 1 , 2 } \\ p _ { 3 , 2 } & - p _ { 3 , 2 } & 0 \\ 0 & 0 & - p _ { 4 , 2 } \end{bmatrix}
$$
```

## REPAIR_PROSE
- RAW: ```
By Theorem 4.7 , there exists a multiplicity matrix g for I of the form
```
  FIX: ```
By Theorem 4.7, there exists a multiplicity matrix \( g \) for \( I \) of the form
```
- RAW: ```
Notice that the last column of g 2 is the linear combination of its first two columns, hence we may take another morphism ˜ g in k [ P ] given by
```
  FIX: ```
Notice that the last column of \( g_2 \) is the linear combination of its first two columns, hence we may take another morphism \( \tilde{g} \) in \( \mathbb{k}[P] \) given by
```
- RAW: ```
such that rank M ( g ) − rank M ( g 2 ) = rank M ( ˜ g ) − rank M ( ˜ g 2 ) . This shows that the new morphism ˜ g is also a multiplicity matrix for I .
```
  FIX: ```
such that \( \operatorname{rank} M(g) - \operatorname{rank} M(g_2) = \operatorname{rank} M(\tilde{g}) - \operatorname{rank} M(\tilde{g}_2) \). This shows that the new morphism \( \tilde{g} \) is also a multiplicity matrix for \( I \).
```
- RAW: ```
![image 18](<AL2026/imageFile18.png>)






=





and define the order-preserving map ζ : Z → P by
```
  FIX: ```
![image 18](<AL2026/imageFile18.png>)

and define the order-preserving map \( \zeta : Z \to P \) by
```
- RAW: ```
Then ζ essentially covers P . Indeed, we have the following equality:
```
  FIX: ```
Then \( \zeta \) essentially covers \( P \). Indeed, we have the following equality:
```
- RAW: ```
Hence by Theorem 4.16 it suffices to compute ¯ d R ( M ) ( R ( V I )) = d R ( M j ) ( V Z ) . Now, because
```
  FIX: ```
Hence by Theorem 4.16 it suffices to compute \( \bar{d}_{R(M)}(R(V_I)) = d_{R(M_j)}(V_Z) \). Now, because
```
- RAW: ```
![image 19](<AL2026/imageFile19.png>)







1 0 0

[

]

[ 1 ,

,


,



(

) =

0 1 1

1 0 0

[ 1 ,

,


,


[ 1 ,

,


,


[

]

0 1 1






















,





]

]

[

]

[

]

[

]

[

= [
















we conclude that d M ( V P ) = 1 .
```
  FIX: ```
![image 19](<AL2026/imageFile19.png>)

we conclude that \( d_M(V_P) = 1 \).
```
- RAW: ```
We highlight that in the example above, finding a new multiplicity matrix ˜ g for I is crucial for finding the zigzag poset Z . Indeed, we first notice that ζ does not cover the original choice of g given in (6.84). Next, it is straightforward to verify from Definition 4.10 that the following order-preserving map ζ ′ : Z ′ → P covers both g and ˜ g :
```
  FIX: ```
We highlight that in the example above, finding a new multiplicity matrix \( \tilde{g} \) for \( I \) is crucial for finding the zigzag poset \( Z \). Indeed, we first notice that \( \zeta \) does not cover the original choice of \( g \) given in (6.84). Next, it is straightforward to verify from Definition 4.10 that the following order-preserving map \( \zeta' : Z' \to P \) covers both \( g \) and \( \tilde{g} \):
```
