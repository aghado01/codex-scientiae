# Manifest: Page 009

## REPAIR_MATH
- RAW: ```
\lambda _ { \mathcal { D } _ { X } } ( x ) = \sum _ { j = 1 } ^ { N } c _ { j } ^ { \mathcal { D } _ { X } } \mathcal { N } ^ { * } ( x ; \mu _ { j } ^ { \mathcal { D } _ { X } } , \sigma _ { j } ^ { \mathcal { D } _ { X } } I ) , \\ \intertext { b e r o f m i ture c o n n t e r s }
```
  FIX: ```
$$
\lambda _ { \mathcal { D } _ { X } } ( x ) = \sum _ { j = 1 } ^ { N } c _ { j } ^ { \mathcal { D } _ { X } } \mathcal { N } ^ { * } ( x ; \mu _ { j } ^ { \mathcal { D } _ { X } } , \sigma _ { j } ^ { \mathcal { D } _ { X } } I ) , \\ \intertext { b e r o f m i ture c o n n t e r s }
$$
```
- RAW: ```
\ell ( y | x ) = \mathcal { N } ^ { * } ( y ; x , \sigma ^ { \mathcal { D } _ { Y } } o \, I ) .
```
  FIX: ```
$$
\ell ( y | x ) = \mathcal { N } ^ { * } ( y ; x , \sigma ^ { \mathcal { D } _ { Y } } o \, I ) .
$$
```
- RAW: ```
\lambda _ { \mathcal { D } _ { Y _ { S } } } ( y ) = \sum _ { k = 1 } ^ { M } c _ { k } ^ { \mathcal { D } _ { Y _ { S } } } \mathcal { N } ^ { * } ( y ; \mu _ { k } ^ { \mathcal { D } _ { Y _ { S } } } , \sigma _ { k } ^ { \mathcal { D } _ { Y _ { S } } } I ) ,
```
  FIX: ```
$$
\lambda _ { \mathcal { D } _ { Y _ { S } } } ( y ) = \sum _ { k = 1 } ^ { M } c _ { k } ^ { \mathcal { D } _ { Y _ { S } } } \mathcal { N } ^ { * } ( y ; \mu _ { k } ^ { \mathcal { D } _ { Y _ { S } } } , \sigma _ { k } ^ { \mathcal { D } _ { Y _ { S } } } I ) ,
$$
```
- RAW: ```
\begin{array} { r l } & { \text {Equation} \, ( 3 ) \, i n \, T h e o r m \, 3 . 1 \, i s \, a \, G a u s i s i n \, m i x t u r e \, o f t h e \, f o r m } \\ & { \quad \lambda _ { D _ { X } | D _ { Y } _ { 1 } , m } ( x ) = ( 1 - \alpha ) \lambda _ { D _ { X } } ( x ) + \frac { \alpha } { m } \sum _ { i = 1 } ^ { m } \sum _ { y \in \mathcal { D } _ { Y } } \sum _ { j = 1 } ^ { N } C _ { j } ^ { y } \mathcal { N } ^ { * } ( x ; \mu _ { j } ^ { y } , \sigma _ { j } ^ { y } I ) , } \\ & { \quad w h e r e \quad C _ { j } ^ { y } = \frac { w _ { j } ^ { y } } { \lambda _ { D _ { Y } _ { s } } ( y ) + \alpha \sum _ { j = 1 } ^ { N } w _ { j } ^ { y } Q _ { j } } ; \, Q _ { j } ^ { y } = \int _ { W } \mathcal { N } ( u ; \mu _ { j } ^ { y } , \sigma _ { j } ^ { y } I ) d u ; } \\ & { \quad w _ { j } ^ { y } = c _ { j } ^ { X } \mathcal { N } ( y ; \mu _ { j } ^ { X } x , ( \sigma _ { j } ^ { Y _ { o } } + \sigma _ { j } ^ { D _ { X } } ) I ) ; } \\ & { \quad a n d \quad \mu _ { j } ^ { X } = \frac { \sigma _ { j } ^ { D _ { X } } y + \sigma ^ { D _ { Y } o } \mu _ { j } ^ { X } } { \sigma _ { j } ^ { D _ { X } } + \sigma ^ { D _ { Y } o } } ; \sigma _ { j } ^ { y } = \frac { \sigma ^ { D _ { Y } o } \, \sigma _ { j } ^ { D _ { X } } } { \sigma _ { j } ^ { D _ { X } } + \sigma ^ { D _ { Y } o } } . } \\ & { \quad T h e \, \pro f o r \, \text {Proposition} \, 3 . 1 \, f o l lows \, from \, w e l l \, k n w n \, r e s l u t s \, a b o u t \, \text {products of Gaussian densities given} } \end{array}
```
  FIX: ```
$$
\begin{array} { r l } & { \text {Equation} \, ( 3 ) \, i n \, T h e o r m \, 3 . 1 \, i s \, a \, G a u s i s i n \, m i x t u r e \, o f t h e \, f o r m } \\ & { \quad \lambda _ { D _ { X } | D _ { Y } _ { 1 } , m } ( x ) = ( 1 - \alpha ) \lambda _ { D _ { X } } ( x ) + \frac { \alpha } { m } \sum _ { i = 1 } ^ { m } \sum _ { y \in \mathcal { D } _ { Y } } \sum _ { j = 1 } ^ { N } C _ { j } ^ { y } \mathcal { N } ^ { * } ( x ; \mu _ { j } ^ { y } , \sigma _ { j } ^ { y } I ) , } \\ & { \quad w h e r e \quad C _ { j } ^ { y } = \frac { w _ { j } ^ { y } } { \lambda _ { D _ { Y } _ { s } } ( y ) + \alpha \sum _ { j = 1 } ^ { N } w _ { j } ^ { y } Q _ { j } } ; \, Q _ { j } ^ { y } = \int _ { W } \mathcal { N } ( u ; \mu _ { j } ^ { y } , \sigma _ { j } ^ { y } I ) d u ; } \\ & { \quad w _ { j } ^ { y } = c _ { j } ^ { X } \mathcal { N } ( y ; \mu _ { j } ^ { X } x , ( \sigma _ { j } ^ { Y _ { o } } + \sigma _ { j } ^ { D _ { X } } ) I ) ; } \\ & { \quad a n d \quad \mu _ { j } ^ { X } = \frac { \sigma _ { j } ^ { D _ { X } } y + \sigma ^ { D _ { Y } o } \mu _ { j } ^ { X } } { \sigma _ { j } ^ { D _ { X } } + \sigma ^ { D _ { Y } o } } ; \sigma _ { j } ^ { y } = \frac { \sigma ^ { D _ { Y } o } \, \sigma _ { j } ^ { D _ { X } } } { \sigma _ { j } ^ { D _ { X } } + \sigma ^ { D _ { Y } o } } . } \\ & { \quad T h e \, \pro f o r \, \text {Proposition} \, 3 . 1 \, f o l lows \, from \, w e l l \, k n w n \, r e s l u t s \, a b o u t \, \text {products of Gaussian densities given} } \end{array}
$$
```

