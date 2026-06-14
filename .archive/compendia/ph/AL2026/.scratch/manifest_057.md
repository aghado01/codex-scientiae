# Manifest: Page 057

## REPAIR_MATH
- RAW: ```
M \coloneqq \left [ \frac { P ^ { \prime } ( g _ { 1 } ) ( x ) } { P ^ { \prime } ( g _ { 3 } ) ( x ) } | P ^ { \prime } ( s c _ { 1 } ( I ) \oplus s c ( \uparrow I ) ) ( \alpha ) } \, \frac { 0 } { 0 } \Big | _ { P ^ { \prime } ( s k ( I ) ) ( \alpha ) } \right ] ,
```
  FIX: ```
$$
M \coloneqq \left [ \frac { P ^ { \prime } ( g _ { 1 } ) ( x ) } { P ^ { \prime } ( g _ { 3 } ) ( x ) } | P ^ { \prime } ( s c _ { 1 } ( I ) \oplus s c ( \uparrow I ) ) ( \alpha ) } \, \frac { 0 } { 0 } \Big | _ { P ^ { \prime } ( s k ( I ) ) ( \alpha ) } \right ] ,
$$
```
- RAW: ```
\left [ \frac { P ^ { \prime } ( g _ { 1 } ) ( 1 ^ { \prime } , 2 , 3 ^ { \prime } ) } { P ^ { \prime } ( g _ { 3 } ) ( 1 ^ { \prime } , 2 , 3 ^ { \prime } ) } \Big | _ { P ^ { \prime } ( g _ { 2 } ) ( 1 ^ { \prime } , 2 , 3 ^ { \prime } ) } \Big | _ { 0 } P ^ { \prime } ( 2 ^ { \prime } , 4 ^ { \prime } ) ( \alpha ) \Big | _ { 0 } \, \frac { 0 } { P ^ { \prime } ( 4 , 3 ^ { \prime } ) ( \alpha ) } \right ] .
```
  FIX: ```
$$
\left [ \frac { P ^ { \prime } ( g _ { 1 } ) ( 1 ^ { \prime } , 2 , 3 ^ { \prime } ) } { P ^ { \prime } ( g _ { 3 } ) ( 1 ^ { \prime } , 2 , 3 ^ { \prime } ) } \Big | _ { P ^ { \prime } ( g _ { 2 } ) ( 1 ^ { \prime } , 2 , 3 ^ { \prime } ) } \Big | _ { 0 } P ^ { \prime } ( 2 ^ { \prime } , 4 ^ { \prime } ) ( \alpha ) \Big | _ { 0 } \, \frac { 0 } { P ^ { \prime } ( 4 , 3 ^ { \prime } ) ( \alpha ) } \right ] .
$$
```
- RAW: ```
P ^ { \prime } ( g _ { 1 } ) ( 1 ^ { \prime } ) = \left [ \begin{smallmatrix} P ^ { \prime } _ { 2 ^ { \prime } , 2 } ( 1 ^ { \prime } ) - P ^ { \prime } _ { 2 ^ { \prime } , 1 ^ { \prime } } ( 1 ^ { \prime } ) \\ P ^ { \prime } _ { 4 ^ { \prime } , 2 } ( 1 ^ { \prime } ) & 0 \end{smallmatrix} \right ] \colon P ^ { \prime } _ { 2 } ( 1 ^ { \prime } ) \oplus P ^ { \prime } _ { 1 ^ { \prime } } ( 1 ^ { \prime } ) \to P ^ { \prime } _ { 2 ^ { \prime } } ( 1 ^ { \prime } ) \oplus P ^ { \prime } _ { 4 ^ { \prime } } ( 1 ^ { \prime } ) ,
```
  FIX: ```
$$
P ^ { \prime } ( g _ { 1 } ) ( 1 ^ { \prime } ) = \left [ \begin{smallmatrix} P ^ { \prime } _ { 2 ^ { \prime } , 2 } ( 1 ^ { \prime } ) - P ^ { \prime } _ { 2 ^ { \prime } , 1 ^ { \prime } } ( 1 ^ { \prime } ) \\ P ^ { \prime } _ { 4 ^ { \prime } , 2 } ( 1 ^ { \prime } ) & 0 \end{smallmatrix} \right ] \colon P ^ { \prime } _ { 2 } ( 1 ^ { \prime } ) \oplus P ^ { \prime } _ { 1 ^ { \prime } } ( 1 ^ { \prime } ) \to P ^ { \prime } _ { 2 ^ { \prime } } ( 1 ^ { \prime } ) \oplus P ^ { \prime } _ { 4 ^ { \prime } } ( 1 ^ { \prime } ) ,
$$
```
- RAW: ```
\mathbf k [ P ] ( 1 ^ { \prime } , 2 ) \oplus \mathbf k [ P ] ( 1 ^ { \prime } , 1 ^ { \prime } ) \ \xrightarrow { P ^ { \prime } ( g _ { 1 } ) ( 1 ^ { \prime } ) } \mathbf k [ P ] ( 1 ^ { \prime } , 2 ^ { \prime } ) \oplus \mathbf k [ P ] ( 1 ^ { \prime } , 4 ^ { \prime } ) \\ \left \| \begin{array} { c c } 0 & 0 \\ 0 \oplus \mathbf k p _ { 1 ^ { \prime } , 1 ^ { \prime } } & \xrightarrow { 0 - \lambda _ { p _ { 2 ^ { \prime } , 1 ^ { \prime } } } } \mathbf k p _ { 2 ^ { \prime } , 1 ^ { \prime } } \oplus \mathbf k p _ { 1 ^ { \prime } , 4 ^ { \prime } } \\ \downarrow \varepsilon & \downarrow \varepsilon \\ 0 \oplus \mathbf k \xrightarrow { [ 0 - 1 ] } \mathbf k \oplus \mathbf k
```
  FIX: ```
$$
\mathbf k [ P ] ( 1 ^ { \prime } , 2 ) \oplus \mathbf k [ P ] ( 1 ^ { \prime } , 1 ^ { \prime } ) \ \xrightarrow { P ^ { \prime } ( g _ { 1 } ) ( 1 ^ { \prime } ) } \mathbf k [ P ] ( 1 ^ { \prime } , 2 ^ { \prime } ) \oplus \mathbf k [ P ] ( 1 ^ { \prime } , 4 ^ { \prime } ) \\ \left \| \begin{array} { c c } 0 & 0 \\ 0 \oplus \mathbf k p _ { 1 ^ { \prime } , 1 ^ { \prime } } & \xrightarrow { 0 - \lambda _ { p _ { 2 ^ { \prime } , 1 ^ { \prime } } } } \mathbf k p _ { 2 ^ { \prime } , 1 ^ { \prime } } \oplus \mathbf k p _ { 1 ^ { \prime } , 4 ^ { \prime } } \\ \downarrow \varepsilon & \downarrow \varepsilon \\ 0 \oplus \mathbf k \xrightarrow { [ 0 - 1 ] } \mathbf k \oplus \mathbf k
$$
```
- RAW: ```
P ^ { \prime } ( g _ { 1 } ) ( x ) = \left [ \begin{smallmatrix} 0 & - 1 \\ 0 & 0 \end{smallmatrix} \right ] \oplus \left [ \begin{smallmatrix} 1 & 0 \\ 1 & 0 \end{smallmatrix} \right ] \oplus \left [ \begin{smallmatrix} 0 & 0 \\ 0 & 0 \end{smallmatrix} \right ] .
```
  FIX: ```
$$
P ^ { \prime } ( g _ { 1 } ) ( x ) = \left [ \begin{smallmatrix} 0 & - 1 \\ 0 & 0 \end{smallmatrix} \right ] \oplus \left [ \begin{smallmatrix} 1 & 0 \\ 1 & 0 \end{smallmatrix} \right ] \oplus \left [ \begin{smallmatrix} 0 & 0 \\ 0 & 0 \end{smallmatrix} \right ] .
$$
```
- RAW: ```
P ^ { \prime } ( g _ { 2 } ) ( x ) & = [ \begin{smallmatrix} 0 & 0 \\ 0 & 0 \end{smallmatrix} ] \oplus \left [ \begin{smallmatrix} 0 & 1 \\ 0 & - 1 \end{smallmatrix} \right ] \oplus [ \begin{smallmatrix} 0 & 0 \\ 0 & 0 \end{smallmatrix} ] , \\ P ^ { \prime } ( g _ { 3 } ) ( x ) & = [ \begin{smallmatrix} 0 & 0 \\ 0 & 0 \end{smallmatrix} ] \oplus [ \begin{smallmatrix} 1 & 0 \\ 0 & 0 \end{smallmatrix} ] \oplus [ \begin{smallmatrix} 0 & 0 \\ 0 & 0 \end{smallmatrix} ] \cdot
```
  FIX: ```
$$
P ^ { \prime } ( g _ { 2 } ) ( x ) & = [ \begin{smallmatrix} 0 & 0 \\ 0 & 0 \end{smallmatrix} ] \oplus \left [ \begin{smallmatrix} 0 & 1 \\ 0 & - 1 \end{smallmatrix} \right ] \oplus [ \begin{smallmatrix} 0 & 0 \\ 0 & 0 \end{smallmatrix} ] , \\ P ^ { \prime } ( g _ { 3 } ) ( x ) & = [ \begin{smallmatrix} 0 & 0 \\ 0 & 0 \end{smallmatrix} ] \oplus [ \begin{smallmatrix} 1 & 0 \\ 0 & 0 \end{smallmatrix} ] \oplus [ \begin{smallmatrix} 0 & 0 \\ 0 & 0 \end{smallmatrix} ] \cdot
$$
```
- RAW: ```
P ^ { \prime } ( 2 ^ { \prime } , 4 ^ { \prime } ) ( y ) & & P ^ { \prime } ( 2 ^ { \prime } , 4 ^ { \prime } ) ( x ) \\ = & P ^ { \prime } _ { 2 ^ { \prime } } ( y ) \oplus P ^ { \prime } _ { 4 ^ { \prime } } ( y ) & = & P ^ { \prime } _ { 2 ^ { \prime } } ( x ) \oplus P ^ { \prime } _ { 4 ^ { \prime } } ( x ) \\ = & P ^ { \prime } _ { 2 ^ { \prime } } ( 2 ^ { \prime } ) \oplus P ^ { \prime } _ { 2 ^ { \prime } } ( 4 ^ { \prime } ) \oplus P ^ { \prime } _ { 2 ^ { \prime } } ( 4 ^ { \prime } ) & = & P ^ { \prime } _ { 2 ^ { \prime } } ( 1 ^ { \prime } ) \oplus P ^ { \prime } _ { 2 ^ { \prime } } ( 2 ) \oplus P ^ { \prime } _ { 2 ^ { \prime } } ( 3 ^ { \prime } ) \\ & \oplus P ^ { \prime } _ { 4 ^ { \prime } } ( 2 ^ { \prime } ) \oplus P ^ { \prime } _ { 4 ^ { \prime } } ( 4 ^ { \prime } ) \oplus P ^ { \prime } _ { 4 ^ { \prime } } ( 4 ^ { \prime } ) & \oplus P ^ { \prime } _ { 4 ^ { \prime } } ( 1 ^ { \prime } ) \oplus P ^ { \prime } _ { 4 ^ { \prime } } ( 2 ) \oplus P ^ { \prime } _ { 4 ^ { \prime } } ( 3 ^ { \prime } ) \\ \cong & \mathbb { k } \oplus 0 \oplus 0 \oplus \mathbb { k } \oplus \mathbb { k } \oplus \mathbb { k } , & \cong & \mathbb { k } \oplus \mathbb { k } \oplus 0 \oplus \mathbb { k } \oplus \mathbb { k } \oplus \mathbb { k } .
```
  FIX: ```
$$
P ^ { \prime } ( 2 ^ { \prime } , 4 ^ { \prime } ) ( y ) & & P ^ { \prime } ( 2 ^ { \prime } , 4 ^ { \prime } ) ( x ) \\ = & P ^ { \prime } _ { 2 ^ { \prime } } ( y ) \oplus P ^ { \prime } _ { 4 ^ { \prime } } ( y ) & = & P ^ { \prime } _ { 2 ^ { \prime } } ( x ) \oplus P ^ { \prime } _ { 4 ^ { \prime } } ( x ) \\ = & P ^ { \prime } _ { 2 ^ { \prime } } ( 2 ^ { \prime } ) \oplus P ^ { \prime } _ { 2 ^ { \prime } } ( 4 ^ { \prime } ) \oplus P ^ { \prime } _ { 2 ^ { \prime } } ( 4 ^ { \prime } ) & = & P ^ { \prime } _ { 2 ^ { \prime } } ( 1 ^ { \prime } ) \oplus P ^ { \prime } _ { 2 ^ { \prime } } ( 2 ) \oplus P ^ { \prime } _ { 2 ^ { \prime } } ( 3 ^ { \prime } ) \\ & \oplus P ^ { \prime } _ { 4 ^ { \prime } } ( 2 ^ { \prime } ) \oplus P ^ { \prime } _ { 4 ^ { \prime } } ( 4 ^ { \prime } ) \oplus P ^ { \prime } _ { 4 ^ { \prime } } ( 4 ^ { \prime } ) & \oplus P ^ { \prime } _ { 4 ^ { \prime } } ( 1 ^ { \prime } ) \oplus P ^ { \prime } _ { 4 ^ { \prime } } ( 2 ) \oplus P ^ { \prime } _ { 4 ^ { \prime } } ( 3 ^ { \prime } ) \\ \cong & \mathbb { k } \oplus 0 \oplus 0 \oplus \mathbb { k } \oplus \mathbb { k } \oplus \mathbb { k } , & \cong & \mathbb { k } \oplus \mathbb { k } \oplus 0 \oplus \mathbb { k } \oplus \mathbb { k } \oplus \mathbb { k } .
$$
```
- RAW: ```
)
```
  FIX: ```
$$
)
$$
```
- RAW: ```
Here, P ′ ( g 1 )(1 ′ , 2 , 3 ′ ) = P ′ ( g 1 )(1 ′ ) ⊕ P ′ ( g 1 )(2) ⊕ P ′ ( g 1 )(3 ′ ) and
```
  FIX: ```
Here, \( P^{\prime}(g_{1})(1^{\prime}, 2, 3^{\prime}) = P^{\prime}(g_{1})(1^{\prime}) \oplus P^{\prime}(g_{1})(2) \oplus P^{\prime}(g_{1})(3^{\prime}) \) and
```
- RAW: ```
Therefore, we may have an identification P ′ ( g 1 )(1 ′ ) = 0 − 1 0 0 . Similarly, we have identifications P ′ ( g 1 )(2) = [ 1 0 1 0 ] and P ′ ( g 1 )(3 ′ ) = [ 0 0 0 0 ] , and hence we have
```
  FIX: ```
Therefore, we may have an identification \( P^{\prime}(g_{1})(1^{\prime}) = \left[ \begin{smallmatrix} 0 & -1 \\ 0 & 0 \end{smallmatrix} \right] \). Similarly, we have identifications \( P^{\prime}(g_{1})(2) = \left[ \begin{smallmatrix} 1 & 0 \\ 1 & 0 \end{smallmatrix} \right] \) and \( P^{\prime}(g_{1})(3^{\prime}) = \left[ \begin{smallmatrix} 0 & 0 \\ 0 & 0 \end{smallmatrix} \right] \), and hence we have
```

## REPAIR_PROSE
- RAW: ```
0 0 ⊕ 0 0 ⊕ 0 0 Moreover, P ′ (2 ′ , 4 ′ )( α ): P ′ (2 ′ , 4 ′ )( y ) → P ′ (2 ′ , 4 ′ )( x ) is computed as follows.
```
  FIX: ```
Moreover, \( P^{\prime}(2^{\prime}, 4^{\prime})(\alpha) \colon P^{\prime}(2^{\prime}, 4^{\prime})(y) \to P^{\prime}(2^{\prime}, 4^{\prime})(x) \) is computed as follows.
```
