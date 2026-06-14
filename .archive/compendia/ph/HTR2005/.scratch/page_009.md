[Page 9]

So our estimate for segment boundary p is

$$
\hat { t } _ { p } \, \colon = \, \arg \max _ { h } P ( t _ { p } = h | y , \hat { k } ) \, = \, \arg \max _ { h } \{ B _ { p h } \} \, = \, \arg \max _ { h } \{ L _ { p h } R _ { \hat { k } - p , h } \}
$$

Segment levels. Finally we need the segment levels, given the segment number ˆ k and boundaries ˆ t . The r th moment of segment m with boundaries i = ˆ t m − 1 and j = ˆ t m is

$$
j = & l _ { m } \text { is} \\ & \widehat { \mu _ { m } ^ { r } } \, = \, \mathbf E [ \mu _ { m } ^ { r } | y , \hat { t } , \hat { k } ] \, = \, \mathbf E [ \mu _ { m } ^ { r } | y _ { i j } , \hat { t } _ { m - 1 , m } , 1 ] \, = \, \frac { \int P ( y _ { i j } , \mu _ { m } | \hat { t } _ { m - 1 , m } , 1 ) \mu _ { m } ^ { r } d \mu _ { m } } { \int P ( y _ { i j } , \mu _ { m } | \hat { t } _ { m - 1 , m } , 1 ) d \mu _ { m } } \, = \, \frac { A _ { i j } ^ { r } } { A _ { i j } ^ { 0 } } \\ & \text {Note that this expression is independent of other segment boundaries and their} \\ & \quad \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \
$$

Note that this expression is independent of other segment boundaries and their number, as it should.

Regression curve. Recursion (15) allows in principle to compute the regression curve E [ µ ′ t | y ] by deﬁning ( L r =1 t ) kj and ( R r =1 t ) ki analogous to L kj and R ki , but this procedure needs O ( n 3 ) space and O ( k max n 3 ) time, one O ( n ) worse than our target performance. We reduce probabilities of µ ′ t to probabilities of µ m : We exploit the fact that in every segmentation, µ ′ t lies in some segment. Let this (unique) segment be m with (unique) boundaries i = t m − 1 <t ≤ t m = j . Then µ ′ t = µ m . Summing now over all such segments we get

$$
P ( \mu _ { t } ^ { \prime } | y , k ) & = \sum _ { m = 1 } ^ { k } \sum _ { i = 0 } ^ { t - 1 } \sum _ { j = t } ^ { n } P ( \mu _ { m } , t _ { m - 1 } = i , t _ { m } = j | y , k ) \\ \intertext { c . i . } P ( \mu _ { t } ^ { \prime } | y , k ) & = \sum _ { m = 1 } ^ { k } \sum _ { i = 0 } ^ { t - 1 } \sum _ { j = t } ^ { n } P ( \mu _ { m } , t _ { m - 1 } = i , t _ { m } = j | y , k ) \\
$$

By ﬁxing t p in (13) we arrived at (19). Similarly, dividing the data into three parts and ﬁxing t l and t m we can derive

$$
( \begin{matrix} n - 1 \\ k - 1 \end{matrix} ) P ( y , \mu , t _ { l } , t _ { m } | k ) \, = \, Q ( y _ { 0 i } , \mu _ { 0 l } | l ) Q ( y _ { i j } \mu _ { m } | m - l ) Q ( y _ { j n } \mu _ { m k } | k - m )
$$

Setting l = m − 1, integrating over µ 0 l and µ mk , dividing by ( n − 1 k − 1 ) P ( y | k ), and inserting into (23), we get

$$
P ( \mu _ { t } ^ { \prime } | y , k ) \, = \, \frac { 1 } { L _ { k n } } \sum _ { m = 1 } ^ { k } \sum _ { i < t \leq j } L _ { m - 1 , i } Q ( y _ { i j } , \mu _ { m } | 1 ) R _ { k - m , j } \\
$$

The posterior moments of µ ′ t , given ˆ k , can hence be computed by

$$
\widehat { \mu _ { t } ^ { \prime } } \, = \, \sum _ { i < t \leq j } \, F _ { i j } ^ { r } \text { with } \, F _ { i j } ^ { r } \colon = \frac { 1 } { L _ { \hat { k } n } } \sum _ { m = 1 } ^ { \hat { k } } L _ { m - 1 , i } A _ { i j } ^ { r } R _ { \hat { k } - m , j } \, \quad \\ \text {while segment boundaries and values make sense only for fixed k (we chose \hat { k } ), the}
$$

While segment boundaries and values make sense only for ﬁxed k (we chose ˆ k ), the regression curve ˆ µ ′ t could actually be averaged over all k instead of ﬁxing k = ˆ k .
