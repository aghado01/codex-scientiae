# Manifest: Page 044

## REPAIR_MATH
- RAW: ```
\int _ { W \cap U } p ^ { \ell } ( x , y ) \, d x \, d y & \geq \sum _ { j = 1 } ^ { N _ { \ell } } \int _ { U _ { j } } \frac { 1 } { 2 \pi N _ { \ell } \sigma ^ { 2 } } e ^ { - \left ( \left ( x - \frac { b _ { j } + d _ { j } } { 2 } \right ) ^ { 2 } + \left ( y - \frac { b _ { j } + d _ { j } } { 2 } \right ) ^ { 2 } \right ) / 2 \sigma ^ { 2 } } \, d x \, d y \\ & = \int _ { B ( ( 0 , 0 ) , \delta ) } \frac { 1 } { 2 \pi } e ^ { - ( x ^ { 2 } + y ^ { 2 } ) / 2 } \, d x \, d y .
```
  FIX: ```
$$
\int _ { W \cap U } p ^ { \ell } ( x , y ) \, d x \, d y & \geq \sum _ { j = 1 } ^ { N _ { \ell } } \int _ { U _ { j } } \frac { 1 } { 2 \pi N _ { \ell } \sigma ^ { 2 } } e ^ { - \left ( \left ( x - \frac { b _ { j } + d _ { j } } { 2 } \right ) ^ { 2 } + \left ( y - \frac { b _ { j } + d _ { j } } { 2 } \right ) ^ { 2 } \right ) / 2 \sigma ^ { 2 } } \, d x \, d y \\ & = \int _ { B ( ( 0 , 0 ) , \delta ) } \frac { 1 } { 2 \pi } e ^ { - ( x ^ { 2 } + y ^ { 2 } ) / 2 } \, d x \, d y .
$$
```
- RAW: ```
\int _ { \mathcal { W } _ { 0 \colon d - 1 } } \max ( d _ { i } - b _ { i } ) \delta Z \leq \int _ { \mathcal { W } _ { 0 \colon d - 1 } } \| Z \| \, f ( Z ) \delta Z
```
  FIX: ```
$$
\int _ { \mathcal { W } _ { 0 \colon d - 1 } } \max ( d _ { i } - b _ { i } ) \delta Z \leq \int _ { \mathcal { W } _ { 0 \colon d - 1 } } \| Z \| \, f ( Z ) \delta Z
$$
```
- RAW: ```
\int _ { \mathcal { W } _ { 0 ; d - 1 } } \| Z \| \, f ( Z ) \delta Z \leq \int _ { K } C _ { 2 } \, \| Z \| \, \delta Z + \sum _ { N = 1 } ^ { M } \int _ { h _ { N } ^ { - 1 } ( h _ { N } ( K ) ^ { c } ) } C _ { 3 } \, \| Z \| ^ { - 2 N - 1 } \, d \xi _ { 1 } \dots d \xi _ { N } .
```
  FIX: ```
$$
\int _ { \mathcal { W } _ { 0 ; d - 1 } } \| Z \| \, f ( Z ) \delta Z \leq \int _ { K } C _ { 2 } \, \| Z \| \, \delta Z + \sum _ { N = 1 } ^ { M } \int _ { h _ { N } ^ { - 1 } ( h _ { N } ( K ) ^ { c } ) } C _ { 3 } \, \| Z \| ^ { - 2 N - 1 } \, d \xi _ { 1 } \dots d \xi _ { N } .
$$
```

