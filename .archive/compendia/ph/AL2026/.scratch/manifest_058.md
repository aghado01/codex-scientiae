# Manifest: Page 058

## REPAIR_MATH
- RAW: ```
P ^ { \prime } ( 2 ^ { \prime } , 4 ^ { \prime } ) ( \alpha ) & = P _ { 2 ^ { \prime } } ^ { \prime } ( \alpha ) \oplus P _ { 4 ^ { \prime } } ^ { \prime } ( \alpha ) \\ & = \left [ \begin{matrix} P _ { 2 ^ { \prime } } ^ { \prime } ( p _ { 2 ^ { \prime } , 1 } ) & P _ { 4 ^ { \prime } , 1 } ^ { \prime } & 0 \\ - P _ { 2 ^ { \prime } } ^ { \prime } ( p _ { 2 ^ { \prime } } , 2 ) & 0 & 0 \\ 0 & 0 & P _ { 4 ^ { \prime } , 3 } ^ { \prime } ( p _ { 4 ^ { \prime } , 3 } ) \end{matrix} \right ] \oplus \left [ \begin{matrix} P _ { 4 ^ { \prime } } ^ { \prime } ( p _ { 2 ^ { \prime } , 1 } ) & P _ { 4 ^ { \prime } , 1 } ^ { \prime } ( p _ { 4 ^ { \prime } , 1 } ) & 0 \\ - P _ { 4 ^ { \prime } } ^ { \prime } ( p _ { 2 ^ { \prime } , 2 } ) & 0 & 0 \\ 0 & 0 & P _ { 4 ^ { \prime } } ^ { \prime } ( p _ { 4 ^ { \prime } , 3 } ) \end{matrix} \right ] \\ & = \left [ \begin{matrix} 1 & 0 & 0 \\ - 1 & 0 & 0 \\ 0 & 0 & 0 \end{matrix} \right ] \oplus \left [ \begin{matrix} 1 & 1 & 0 \\ - 1 & 0 & 0 \\ 0 & 0 & 0 \end{matrix} \right ] .
```
  FIX: ```
$$
P ^ { \prime } ( 2 ^ { \prime } , 4 ^ { \prime } ) ( \alpha ) & = P _ { 2 ^ { \prime } } ^ { \prime } ( \alpha ) \oplus P _ { 4 ^ { \prime } } ^ { \prime } ( \alpha ) \\ & = \left [ \begin{matrix} P _ { 2 ^ { \prime } } ^ { \prime } ( p _ { 2 ^ { \prime } , 1 } ) & P _ { 4 ^ { \prime } , 1 } ^ { \prime } & 0 \\ - P _ { 2 ^ { \prime } } ^ { \prime } ( p _ { 2 ^ { \prime } } , 2 ) & 0 & 0 \\ 0 & 0 & P _ { 4 ^ { \prime } , 3 } ^ { \prime } ( p _ { 4 ^ { \prime } , 3 } ) \end{matrix} \right ] \oplus \left [ \begin{matrix} P _ { 4 ^ { \prime } } ^ { \prime } ( p _ { 2 ^ { \prime } , 1 } ) & P _ { 4 ^ { \prime } , 1 } ^ { \prime } ( p _ { 4 ^ { \prime } , 1 } ) & 0 \\ - P _ { 4 ^ { \prime } } ^ { \prime } ( p _ { 2 ^ { \prime } , 2 } ) & 0 & 0 \\ 0 & 0 & P _ { 4 ^ { \prime } } ^ { \prime } ( p _ { 4 ^ { \prime } , 3 } ) \end{matrix} \right ] \\ & = \left [ \begin{matrix} 1 & 0 & 0 \\ - 1 & 0 & 0 \\ 0 & 0 & 0 \end{matrix} \right ] \oplus \left [ \begin{matrix} 1 & 1 & 0 \\ - 1 & 0 & 0 \\ 0 & 0 & 0 \end{matrix} \right ] .
$$
```
- RAW: ```
P ^ { \prime } ( 2 ^ { \prime } , 4 ^ { \prime } ) ( \alpha ) = \begin{bmatrix} 1 & 0 & 0 \\ - 1 & 0 & 0 \\ 0 & 0 & 0 & 0 & 1 \end{bmatrix} ,
```
  FIX: ```
$$
P ^ { \prime } ( 2 ^ { \prime } , 4 ^ { \prime } ) ( \alpha ) = \begin{bmatrix} 1 & 0 & 0 \\ - 1 & 0 & 0 \\ 0 & 0 & 0 & 0 & 1 \end{bmatrix} ,
$$
```
- RAW: ```
P ^ { \prime } ( 4 , 3 ^ { \prime } ) ( \alpha ) & = P ^ { \prime } _ { 4 } ( \alpha ) \oplus P ^ { \prime } _ { 3 ^ { \prime } } ( \alpha ) \\ & = \left [ - P ^ { \prime } _ { 4 } ( P _ { 2 ^ { \prime } , 1 } ) \ P ^ { \prime } _ { 4 } ( P _ { 4 ^ { \prime } , 1 } ) \right ] _ { 0 } \ \oplus \left [ - P ^ { \prime } _ { 3 ^ { \prime } } ( P _ { 2 ^ { \prime } , 1 } ) \ P ^ { \prime } _ { 3 ^ { \prime } } ( P _ { 4 ^ { \prime } , 1 } ) \right ] _ { 0 } \quad \oplus \left [ - P ^ { \prime } _ { 3 ^ { \prime } } ( P _ { 2 ^ { \prime } , 2 } ) \ \left ( \begin{array} { c c c } P ^ { \prime } _ { 3 ^ { \prime } } ( P _ { 2 ^ { \prime } , 1 } ) & P ^ { \prime } _ { 3 ^ { \prime } } ( P _ { 4 ^ { \prime } , 1 } ) & 0 \\ 0 & 0 & P ^ { \prime } _ { 4 , 3 ^ { \prime } } ( P _ { 3 ^ { \prime } } ) \end{array} \right ] \\ & = \left [ 0 . 0 0 \right ] \oplus \left [ 1 \, 0 0 \right ] . \\ & = \left [ 0 . 0 0 \right ] \ \oplus \left [ - 1 0 0 \right ] .
```
  FIX: ```
$$
P ^ { \prime } ( 4 , 3 ^ { \prime } ) ( \alpha ) & = P ^ { \prime } _ { 4 } ( \alpha ) \oplus P ^ { \prime } _ { 3 ^ { \prime } } ( \alpha ) \\ & = \left [ - P ^ { \prime } _ { 4 } ( P _ { 2 ^ { \prime } , 1 } ) \ P ^ { \prime } _ { 4 } ( P _ { 4 ^ { \prime } , 1 } ) \right ] _ { 0 } \ \oplus \left [ - P ^ { \prime } _ { 3 ^ { \prime } } ( P _ { 2 ^ { \prime } , 1 } ) \ P ^ { \prime } _ { 3 ^ { \prime } } ( P _ { 4 ^ { \prime } , 1 } ) \right ] _ { 0 } \quad \oplus \left [ - P ^ { \prime } _ { 3 ^ { \prime } } ( P _ { 2 ^ { \prime } , 2 } ) \ \left ( \begin{array} { c c c } P ^ { \prime } _ { 3 ^ { \prime } } ( P _ { 2 ^ { \prime } , 1 } ) & P ^ { \prime } _ { 3 ^ { \prime } } ( P _ { 4 ^ { \prime } , 1 } ) & 0 \\ 0 & 0 & P ^ { \prime } _ { 4 , 3 ^ { \prime } } ( P _ { 3 ^ { \prime } } ) \end{array} \right ] \\ & = \left [ 0 . 0 0 \right ] \oplus \left [ 1 \, 0 0 \right ] . \\ & = \left [ 0 . 0 0 \right ] \ \oplus \left [ - 1 0 0 \right ] .
$$
```
- RAW: ```
P ^ { \prime } ( 4 , 3 ^ { \prime } ) ( \alpha ) = \begin{bmatrix} 0 & 0 & 0 & 1 & 0 & 0 \\ 0 & 0 & 0 & - 1 & 0 & 0 \\ 0 & 0 & 0 & 0 & 0 & 0 \end{bmatrix} .
```
  FIX: ```
$$
P ^ { \prime } ( 4 , 3 ^ { \prime } ) ( \alpha ) = \begin{bmatrix} 0 & 0 & 0 & 1 & 0 & 0 \\ 0 & 0 & 0 & - 1 & 0 & 0 \\ 0 & 0 & 0 & 0 & 0 & 0 \end{bmatrix} .
$$
```
- RAW: ```
A \text { direct computation shows that rank } M = 8 \text { and the rank of the remaining big}
```
  FIX: ```
```
- RAW: ```
d _ { M } ( V _ { I } ) = 8 - 7 = 1 .
```
  FIX: ```
$$
d _ { M } ( V _ { I } ) = 8 - 7 = 1 .
$$
```

## REPAIR_PROSE
- RAW: ```
A direct computation shows that rank M = 8 , and the rank of the remaining big matrix is 7. Hence by Theorem 5.7 , we have
```
  FIX: ```
A direct computation shows that \( \operatorname{rank} M = 8 \), and the rank of the remaining big matrix is \( 7 \). Hence by Theorem 5.7, we have
```

