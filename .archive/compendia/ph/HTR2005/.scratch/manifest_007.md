# Manifest: Page 007

## REPAIR_MATH
- RAW: ```
\begin{array} { r l } & { \text {segmentation are independent, i.e.} } \\ & { P ( y _ { i j } , \mu _ { l m } | t _ { l m } , m - l ) \ = \ \prod _ { p = l + 1 } ^ { m } \left [ P ( \mu _ { p } ) \prod _ { t = t _ { p - 1 } + 1 } ^ { t _ { p } } P ( y _ { t } | \mu _ { p } ) \right ] } \\ & { = \ P ( y _ { i h } , \mu _ { l p } | t _ { p } , p - l ) P ( y _ { h j } , \mu _ { p m } | t _ { p m } , m - p ) \ \ ( a n y \ p ) ( 1 1 ) } \\ & { = \ P ( y _ { i h } , \mu _ { l p } | t _ { p } , p - l ) P ( y _ { h j } , \mu _ { p m } | t _ { p m } , m - p ) \ \ ( a n y \ p ) ( 1 1 ) } \end{array}
```
  FIX: ```
$$
\begin{array} { r l } & { \text {segmentation are independent, i.e.} } \\ & { P ( y _ { i j } , \mu _ { l m } | t _ { l m } , m - l ) \ = \ \prod _ { p = l + 1 } ^ { m } \left [ P ( \mu _ { p } ) \prod _ { t = t _ { p - 1 } + 1 } ^ { t _ { p } } P ( y _ { t } | \mu _ { p } ) \right ] } \\ & { = \ P ( y _ { i h } , \mu _ { l p } | t _ { p } , p - l ) P ( y _ { h j } , \mu _ { p m } | t _ { p m } , m - p ) \ \ ( a n y \ p ) ( 1 1 ) } \\ & { = \ P ( y _ { i h } , \mu _ { l p } | t _ { p } , p - l ) P ( y _ { h j } , \mu _ { p m } | t _ { p m } , m - p ) \ \ ( a n y \ p ) ( 1 1 ) } \end{array}
$$
```
- RAW: ```
This is our key recursion. \, \text {Consider now} \\ Q ( y _ { i j } , \mu _ { l m } | m - l ) \, \colon = \, & \, \left ( j _ { m - 1 } ^ { - 1 } P ( y _ { i j } , \mu _ { l m } | t _ { l } , t _ { m } , m - l ) \\ \stackrel { ( a ) } { = } & \, \left ( j _ { m - 1 } ^ { - 1 } \right ) \sum _ { t _ { m } \colon i = t _ { l } < \dots < t _ { m } = j } P ( y _ { i j } , \mu _ { l m } | t _ { l m } , m - l ) P ( t _ { l m } | m - l ) \\ \stackrel { ( b ) } { = } & \sum _ { t _ { m } \colon i = t _ { l } < \dots < t _ { m } = j } P ( y _ { i j } , \mu _ { l m } | t _ { l m } , m - l ) \\ \stackrel { ( c ) } { = } & \sum _ { t _ { p } = i + p - l } ^ { j + p - m } \sum _ { t _ { p } \colon i = t _ { l } < \dots < t _ { p } = h } P ( y _ { i h } , \mu _ { l p } | t _ { l p } , p - l ) \sum _ { t _ { p } \colon h = t _ { p } < \dots < t _ { m } = j } P ( y _ { h j } , \mu _ { p m } | t _ { p m } , m - p ) \\ = \sum _ { h = i + p - l } ^ { j + p - m } Q ( y _ { i h } , \mu _ { l p } | p - l ) Q ( y _ { h j } , \mu _ { p m } | m - p ) \\ ( a ) \, \text {is just an instance of formula} \, P ( A ) = \sum _ { \substack { C , A \\ \ } } P ( A | H _ { i } ) P ( H _ { i } ) \, \text {for a partitioning} \, ( H _ { i } ) \, \text {of} \\ \, \text {the sample space.  In } ( b ) \, \text {we exploited uniformly} \, ( 4 ) \, \text {of} \, P ( t _ { l m } | m - l ) = ( \, ^ { j - 1 } _ { m - l } ) ^ { - 1 } \, \text {and}
```
  FIX: ```
$$
This is our key recursion. \, \text {Consider now} \\ Q ( y _ { i j } , \mu _ { l m } | m - l ) \, \colon = \, & \, \left ( j _ { m - 1 } ^ { - 1 } P ( y _ { i j } , \mu _ { l m } | t _ { l } , t _ { m } , m - l ) \\ \stackrel { ( a ) } { = } & \, \left ( j _ { m - 1 } ^ { - 1 } \right ) \sum _ { t _ { m } \colon i = t _ { l } < \dots < t _ { m } = j } P ( y _ { i j } , \mu _ { l m } | t _ { l m } , m - l ) P ( t _ { l m } | m - l ) \\ \stackrel { ( b ) } { = } & \sum _ { t _ { m } \colon i = t _ { l } < \dots < t _ { m } = j } P ( y _ { i j } , \mu _ { l m } | t _ { l m } , m - l ) \\ \stackrel { ( c ) } { = } & \sum _ { t _ { p } = i + p - l } ^ { j + p - m } \sum _ { t _ { p } \colon i = t _ { l } < \dots < t _ { p } = h } P ( y _ { i h } , \mu _ { l p } | t _ { l p } , p - l ) \sum _ { t _ { p } \colon h = t _ { p } < \dots < t _ { m } = j } P ( y _ { h j } , \mu _ { p m } | t _ { p m } , m - p ) \\ = \sum _ { h = i + p - l } ^ { j + p - m } Q ( y _ { i h } , \mu _ { l p } | p - l ) Q ( y _ { h j } , \mu _ { p m } | m - p ) \\ ( a ) \, \text {is just an instance of formula} \, P ( A ) = \sum _ { \substack { C , A \\ \ } } P ( A | H _ { i } ) P ( H _ { i } ) \, \text {for a partitioning} \, ( H _ { i } ) \, \text {of} \\ \, \text {the sample space.  In } ( b ) \, \text {we exploited uniformly} \, ( 4 ) \, \text {of} \, P ( t _ { l m } | m - l ) = ( \, ^ { j - 1 } _ { m - l } ) ^ { - 1 } \, \text {and}
$$
```
- RAW: ```
L \text { us define more generally } r ^ { \prime \prime } \ \overset { \cdot } { Q } ^ { \text {moments} } \text { of } \mu _ { t } ^ { \prime } . \\ Q _ { t } ^ { r } ( y _ { i j } | m - l ) \ \colon = \ \int Q ( y _ { i j } , \mu _ { l m } | m - l ) \mu _ { t } ^ { r } d \mu _ { l m } \\ = \sum _ { h = i + p - l } ^ { t - 1 } Q ^ { 0 } ( y _ { i h } | p - l ) Q _ { t } ^ { r } ( y _ { h j } | p - l ) + \sum _ { h = t } ^ { j + p - m } Q _ { t } ^ { r } ( y _ { i h } | m - p ) Q ^ { 0 } ( y _ { h j } | m - p ) \\ \text {Depending on whether } h < t \text { or } h \geq t , \text { the } \mu _ { t } ^ { \prime \prime } \text { term combines with the right or left}
```
  FIX: ```
$$
L \text { us define more generally } r ^ { \prime \prime } \ \overset { \cdot } { Q } ^ { \text {moments} } \text { of } \mu _ { t } ^ { \prime } . \\ Q _ { t } ^ { r } ( y _ { i j } | m - l ) \ \colon = \ \int Q ( y _ { i j } , \mu _ { l m } | m - l ) \mu _ { t } ^ { r } d \mu _ { l m } \\ = \sum _ { h = i + p - l } ^ { t - 1 } Q ^ { 0 } ( y _ { i h } | p - l ) Q _ { t } ^ { r } ( y _ { h j } | p - l ) + \sum _ { h = t } ^ { j + p - m } Q _ { t } ^ { r } ( y _ { i h } | m - p ) Q ^ { 0 } ( y _ { h j } | m - p ) \\ \text {Depending on whether } h < t \text { or } h \geq t , \text { the } \mu _ { t } ^ { \prime \prime } \text { term combines with the right or left}
$$
```
- RAW: ```
A _ { i j } ^ { r } \, \colon = \, Q _ { t } ^ { r } ( y _ { i j } | 1 ) \, = \, \int P ( \mu _ { m } ) \prod _ { t = i + 1 } ^ { j } P ( y _ { t } | \mu _ { m } ) \mu _ { m } ^ { r } d \mu _ { m } , \quad ( 0 \leq i < j \leq n ) \quad ( 1 6 ) \\ \\ \text {Note } A ^ { 0 } = P ( y _ { i } | t \, , \quad ) \, \text {is the evidence and } A ^ { r } \, / A ^ { 0 } = F [ u _ { r } ^ { r } \, | u _ { t } \, , \quad ] \, \text {the } r ^ { t h } \, \text {mo} .
```
  FIX: ```
$$
A _ { i j } ^ { r } \, \colon = \, Q _ { t } ^ { r } ( y _ { i j } | 1 ) \, = \, \int P ( \mu _ { m } ) \prod _ { t = i + 1 } ^ { j } P ( y _ { t } | \mu _ { m } ) \mu _ { m } ^ { r } d \mu _ { m } , \quad ( 0 \leq i < j \leq n ) \quad ( 1 6 ) \\ \\ \text {Note } A ^ { 0 } = P ( y _ { i } | t \, , \quad ) \, \text {is the evidence and } A ^ { r } \, / A ^ { 0 } = F [ u _ { r } ^ { r } \, | u _ { t } \, , \quad ] \, \text {the } r ^ { t h } \, \text {mo} .
$$
```

## REPAIR_PROSE
- RAW: ```
[Page 7]

by the model assumptions (1) and (2). The probabilities for a general but ﬁxed segmentation are independent, i.e.
```
  FIX: ```
by the model assumptions (1) and (2). The probabilities for a general but fixed segmentation are independent, i.e.
```
- RAW: ```
( a ) is just an instance of formula P ( A )=   i P ( A | H i ) P ( H i ) for a partitioning ( H i ) of the sample space. In ( b ) we exploited uniformity (4) of P ( t lm | m − l )=( j − i − 1 m − l − 1 ) − 1 and hence its independence from the concrete segmentation t lm . In ( c ) we ﬁx segment boundary t p , sum over the left and right segmentations, and ﬁnally over t p .
```
  FIX: ```
\( (a) \) is just an instance of formula \( P ( A ) = \sum _ { i } P ( A | H _ i ) P ( H _ i ) \) for a partitioning \( ( H _ i ) \) of the sample space. In \( (b) \) we exploited uniformity (4) of \( P ( t _ { l m } | m - l ) = \binom { j - i - 1 } { m - l - 1 } ^ { - 1 } \) and hence its independence from the concrete segmentation \( t _ { l m } \). In \( (c) \) we fix segment boundary \( t _ p \), sum over the left and right segmentations, and finally over \( t _ p \).
```
- RAW: ```
Left and right recursions. If we integrate (12) over µ lm , the integral factorizes and we get a recursion in (a quantity that is proportional to) the evidence of y ij . Let us deﬁne more generally r th “Q-moments” of µ ′ t .
```
  FIX: ```
Left and right recursions. If we integrate (12) over \( \mu _ { l m } \), the integral factorizes and we get a recursion in (a quantity that is proportional to) the evidence of \( y _ { i j } \). Let us define more generally \( r ^ { \text {th} } \) "Q-moments" of \( \mu _ t ^ \prime \).
```
- RAW: ```
Depending on whether h<t or h ≥ t , the µ ′ t r term combines with the right or left Q in recursion (14) to Q r t , while the other Q simply gets integrated to Q 0 t = Q 0 independent t . The recursion terminates with
```
  FIX: ```
Depending on whether \( h < t \) or \( h \geq t \), the \( ( \mu _ t ^ \prime ) ^ r \) term combines with the right or left \( Q \) in recursion (14) to \( Q _ t ^ r \), while the other \( Q \) simply gets integrated to \( Q _ t ^ 0 = Q ^ 0 \) independent of \( t \). The recursion terminates with
```
- RAW: ```
Note A 0 ij = P ( y ij | t m -1 ,m ) is the evidence and A r ij /A 0 ij = E [ µ r m | y ij ,t m -1 ,m ] the r th moment of µ ′ t = µ m in case y ij is modeled by a single segment. It is convenient to formally start the recursion with Q 0 ( y ij | 0)= δ ij = { 1 if i = j 0 else (consistent with the recursion) with interpretation that (only) an empty data set ( i = j ) can have 0 segments. Since p was an arbitrary split number, we can choose it conveniently. We need a left recursion for r =0, i =0, p -l = k , and m -p =1:
```
  FIX: ```
Note \( A _ { i j } ^ 0 = P ( y _ { i j } | t _ { m - 1 , m } ) \) is the evidence and \( A _ { i j } ^ r / A _ { i j } ^ 0 = E [ \mu _ m ^ r | y _ { i j } , t _ { m - 1 , m } ] \) the \( r ^ { \text {th} } \) moment of \( \mu _ t ^ \prime = \mu _ m \) in case \( y _ { i j } \) is modeled by a single segment. It is convenient to formally start the recursion with \( Q ^ 0 ( y _ { i j } | 0 ) = \delta _ { i j } = \begin{cases} 1 & \text{if } i = j \\ 0 & \text{else} \end{cases} \) (consistent with the recursion) with interpretation that (only) an empty data set (\( i = j \)) can have 0 segments. Since \( p \) was an arbitrary split number, we can choose it conveniently. We need a left recursion for \( r = 0 \), \( i = 0 \), \( p - l = k \), and \( m - p = 1 \):
```
