# Manifest: Page 015

## REPAIR_MATH
- RAW: ```
& \text {EstGeneral} ( y , n , \alpha , \beta ) \\ & \quad \lceil \nu = [ y ] _ { n / 2 } ; \\ & \quad \rho = ( [ y ] _ { 3 n / 4 } - [ y ] _ { n / 4 } ) / 2 \alpha ; \\ & \quad \text {for} ( t = 1 \dots n - 1 ) \ \Delta _ { t } = y _ { t + 1 } - y _ { t } ; \\ & \quad \sigma = ( [ \Delta ] _ { 3 n / 4 } - [ \Delta ] _ { n / 4 } ) / 2 \beta ; \\ & \quad \text {Grid} = ( \frac { \sigma } { 1 0 } \mathbb { Z } ) \cap [ \nu - 2 5 \rho , \nu + 2 5 \rho ] ; \\ & \quad \text {for} ( i = 0 \dots n ) \\ & \quad \lceil \ f o r ( \mu \in \text {Grid} ) \ R _ { \mu } = P ( \mu | \nu , \rho ) ; \\ & \quad \text {for} ( j = i + 1 \dots n ) \\ & \quad \lceil \ f o r ( \mu \in \text {Grid} ) \ R _ { \mu } * = P ( y _ { j } | \mu , \sigma ) ; \\ & \quad \lceil \ A _ { i j } ^ { r } = \frac { \sigma } { 1 0 } \sum _ { \mu \in \text {Grid} } R _ { \mu } \, \mu ^ { r } ; \, ( r = 0 , 1 , 2 ) \\ & \quad \lceil \ r e t u r n \ ( A _ { \mathbb { I } } ^ { \mathbb { I } } , \nu , \rho , \sigma ) ; \\ \\ \text {Regression} ( A _ { \mathbb { I } } ^ { \mathbb { I } } , n , k _ { \max } )
```
  FIX: ```
$$
& \text {EstGeneral} ( y , n , \alpha , \beta ) \\ & \quad \lceil \nu = [ y ] _ { n / 2 } ; \\ & \quad \rho = ( [ y ] _ { 3 n / 4 } - [ y ] _ { n / 4 } ) / 2 \alpha ; \\ & \quad \text {for} ( t = 1 \dots n - 1 ) \ \Delta _ { t } = y _ { t + 1 } - y _ { t } ; \\ & \quad \sigma = ( [ \Delta ] _ { 3 n / 4 } - [ \Delta ] _ { n / 4 } ) / 2 \beta ; \\ & \quad \text {Grid} = ( \frac { \sigma } { 1 0 } \mathbb { Z } ) \cap [ \nu - 2 5 \rho , \nu + 2 5 \rho ] ; \\ & \quad \text {for} ( i = 0 \dots n ) \\ & \quad \lceil \ f o r ( \mu \in \text {Grid} ) \ R _ { \mu } = P ( \mu | \nu , \rho ) ; \\ & \quad \text {for} ( j = i + 1 \dots n ) \\ & \quad \lceil \ f o r ( \mu \in \text {Grid} ) \ R _ { \mu } * = P ( y _ { j } | \mu , \sigma ) ; \\ & \quad \lceil \ A _ { i j } ^ { r } = \frac { \sigma } { 1 0 } \sum _ { \mu \in \text {Grid} } R _ { \mu } \, \mu ^ { r } ; \, ( r = 0 , 1 , 2 ) \\ & \quad \lceil \ r e t u r n \ ( A _ { \mathbb { I } } ^ { \mathbb { I } } , \nu , \rho , \sigma ) ; \\ \\ \text {Regression} ( A _ { \mathbb { I } } ^ { \mathbb { I } } , n , k _ { \max } )
$$
```
- RAW: ```
\begin{array} { r l } { 1 / 2 } & { \quad \lfloor \, \lfloor A _ { i j } ^ { r } = \frac { \sigma } { 1 0 } \sum _ { \mu \in \text {Grid} } R _ { \mu } \, \mu ^ { r } ; \, ( r = 0 , 1 , 2 ) } \\ & { \quad \lfloor \, \text {return } ( A _ { \mathbb { I } } ^ { \mathbb { I } } , \nu , \rho , \sigma ) ; } \\ { \quad } \\ { R e g r i s e n ( A _ { \mathbb { I } } ^ { \mathbb { I } } , n , k _ { \max } ) } \\ & { \quad \lceil \, \text {for} ( i = 0 . . n ) \, \{ \, L _ { 0 i } = \delta _ { i 0 } ; \, R _ { 0 i } = \delta _ { i n } ; \, \} } \\ & { \quad \text {for} ( k = 0 . . n - 1 ) } \\ A , n , \quad \lceil \, \text {for} ( i = 0 . . n ) \, \ L _ { k + 1 , i } = \sum _ { h = 1 } ^ { i - 1 } L _ { k h } A _ { h i } ^ { 0 } ; } \\ { \quad } & { \quad \lceil \, \text {for} ( i = 0 . . n ) \, R _ { k + 1 , i } = \sum _ { h = i + 1 } ^ { n - k } A _ { i h } ^ { 0 } R _ { k h } ; } \\ { \quad } & { \quad E = k _ { \max } ^ { - 1 } \sum _ { k = 1 } ^ { k _ { \max } } L _ { k n } / ( \begin{matrix} n - 1 \\ k - 1 \end{matrix} ) } \\ { \quad } & { \quad \text {for} ( k = 0 . . k _ { \max } ) \, C _ { k } = L _ { k n } / [ ( \begin{matrix} n - 1 \\ k - 1 \end{matrix} ) k _ { \max } E ] ; } \\ { \quad } & { \quad } & { \hat { k } = \arg \max _ { k = 1 . . k _ { \max } } \{ C _ { k } \} ; } \\ { \quad } & { \quad } & { \text {for} ( i = 0 . . n ) \, B _ { i } = \sum _ { p = 0 } ^ { i } L _ { p i } R _ { \hat { k } - p , i } / L _ { \hat { k } n } ; } \\ { \quad } & { \quad } & { \text {for} ( p = 0 . . k ) \, t _ { p } = \arg \max _ { h } \{ L _ { p h } R _ { \hat { k } - p , h } \} ; } \\ { \quad } & { \quad } & { \text {for} ( p = 1 . . \hat { k } ) \, \widehat { \mu } ^ { r } = A _ { i } ^ { r } \widehat { \mu } _ { i } ^ { \, / } A _ { \hat { k } - i \hat { p } } ^ { 0 } ; \, ( r = 1 , 2 ) } \\ { \quad } & { \quad } & { \text {for} ( i = 0 . . n ) \, \text { for} ( j = i + 1 . . n ) } \\ { \quad } & { \quad } & { \text {for} } \\ { \quad } & { \quad } & { \left [ \, F _ { i j } ^ { r } = \sum _ { n = 1 , i } ^ { k } L _ { m - 1 , i } A _ { i j } ^ { r } R _ { \hat { k } - m , j } / L _ { \hat { k } n } ; } \\ { \quad } & { \quad } & { \mu _ { 0 } ^ { r } = 0 ; \, ( r = 1 , 2 ) } \\ { \quad } & { \quad } & { \text {for} ( t = 0 . . n - 1 ) } \\ { \quad } & { \quad } & { \widehat { \mu } _ { i } ^ { \, / } \widehat { t } _ { i } ^ { r } - \sum _ { i = 0 } ^ { t - 1 } F _ { i j } ^ { r } + \sum _ { i = t + 1 } ^ { n } F _ { t i } ^ { r } } \\ { \quad } & { \quad } & { \text {return } ( E , C _ { \hat { k } } , \hat { k } , B _ { \hat { l } } , \hat { t } _ { \hat { l } } , \widehat { \mu } _ { i } ^ { \, / } \widehat { u } ^ { r } ) ; } \\ & { \quad } & { 1 5 } \end{array}
$$
```
- RAW: ```
⌈ ν = 1 n n t =1 y t ; ρ 2 = 1 n − 1 n t =1 ( y t − ν ) 2 ; σ 2 = 1 2( n − 1) n − 1 t =1 ( y t +1 − y t ) 2 ; for( i =0 ..n ) ⌈ m =0; s =0; for( j = i +1 ..n ) ⌈ d = j − i ; m += y j − ν ; s +=( y j − ν ) 2 ; A 0 ij = exp { 1 2 σ 2 [ m 2 d + σ 2 /ρ 2 − s ] } (2 πσ 2 ) d/ 2 (1+ dρ 2 /σ 2 ) 1 / 2 ; A 1 ij = A 0 ij ( ν + m/d ); ⌊ ⌊ A 2 ij = A 0 ij (( A 1 ij /A 0 ij ) 2 + σ 2 /d ); ⌊ return ( A [] [][] ,ν,ρ,σ );
```
  FIX: ```
FILL_ME_IN
```

## REPAIR_PROSE
- RAW: ```
EstGauss( y,n ) and EstGeneral( y,n,α,β ) compute from data ( y 1 ,...,y n ), estimates for ν , ρ , σ (hat ‘ˆ’ omitted), and from that the evidence A 0 ij of a single segment ranging from i +1 to j , and corresponding ﬁrst and second moments A 1 ij and A 2 ij . The expressions (28), (29), (25), (26), (27) are used in EstGauss() for Gaussian noise and prior, and (32), (33), (34) and numerical integration on a uniform Grid in EstGeneral() for arbitrary noise and prior P , e.g. Cauchy. [ y ] denotes the sorted y array, Grid is the uniform integration grid, += and ∗ = are additive/multiplicative updates, and [] denotes arrays.
```
  FIX: ```
FILL_ME_IN
```
- RAW: ```
## EstGauss( y,n )
```
  FIX: ```
FILL_ME_IN
```
- RAW: ```
## EstGeneral( y,n,α,β )
```
  FIX: ```
FILL_ME_IN
```
- RAW: ```
Regression( A,n,k max ) takes A , n , and an upper bound on the number of segments k max , and computes the evidence E = P ( y ) (17), the probability C k = P ( k | y ) of k segments and its MAP estimate ˆ k (18), the probability B i = P ( ∃ p : t p = i | y , ˆ k ) that a boundary is at i (20) and the MAP location ˆ t p of the p th boundary (21), the ﬁrst and second segment level moments µ p and µ 2 p of all segments p (22), and the Bayesian regression curve µ ′ t and its second moment µ ′ t 2 (24).
```
  FIX: ```
FILL_ME_IN
```

