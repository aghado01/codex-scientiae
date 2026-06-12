[Page 5]

condition   is   satisﬁed   if   c 1 > c 0.  We   evaluate   now   an   M -estimator   with   the   preliminary   scale   estimator     σ deﬁned   in   ( 5 ) and   the   loss   function   ρ 1,   that   is, n r i ( a, b, c )

$$
t \text { loss function } \rho _ { 1 }, \text { that is,} \\ & ( \widehat { \mu }, \widehat { \beta }, \widehat { \mathfrak c } ) = \underset { \mathfrak a r { E }, \mathfrak R } { \argmin } \sum _ { \mathfrak a r { R } ^ { k }, \mathfrak c } \rho _ { 1 } \left ( \frac { r _ { i } ( \mathfrak a }, \mathfrak b, \mathfrak c } { \widehat { \sigma } } \right ).\\ & \text {For } 1 \leq j \leq p, \, \text { the robust estimator of the additive function } \eta \text { is then given by} \\ & \quad \text {k} \text {j} - 1
$$

$$
& = \mathcal { J } = I + I ^ { 2 } \\ & \quad \widehat { \eta } _ { j } ( x ) = \sum _ { s = 1 } ^ { k - 1 } \widehat { c } _ { s } ^ { ( j ) } B _ { s } ^ { ( j ) } ( x ) \,, \\ \intertext { where } & \widehat { c } \in ( \mathfrak { C } ^ { ( 1 ) \Upsilon }, \dots, \widehat { c } ^ { ( \mathfrak { P } ) \Upsilon } ) \text { and } \widehat { c } ^ { ( j ) }, \dots, \widehat { c } _ { k - j - 1 } ^ { ( j ) } \text { .} \text { Finally, the estimator of the multivariate regression function is }
$$

where     c = (   c ( 1 ) t,   ...,     c ( p ) t ) t and     c ( j ) = (   c ( j ) 1,   ...,     c ( j ) k j − 1 ) t.  Finally,   the   estimator   of   the   multivariate   regression   function   is   deﬁned   as     m ( z,   x )   =   μ +   β t z   +   p j = 1   η j ( x j ),   for   any   z   ∈ R q and   x   = ( x 1,   ...,   x p ) t.Summarizing,   our   estimators   may   be   implemented   as   follows Step 1 For   j   1,   ...,   p

Step 1 For j = 1,..., p

˜ (c) Define the centered basis B ( j ) s ( x ) = B ( j ) s ( x ) -I j B ( j ) s ( x ) dx, s = 1,..., k j .

˜ ∫ ˜ (d) Keep only the fi rst k j -1 elements of the basis, that is, { B ( j ) s ( x ) : 1 ≤ s ≤ k j -1 }, and define V ( j ) ( t ) = ( B ( j ) 1 ( t ),..., B ( j ) k j -1 ( t )) t .

Step 2 (a) Let   V i = ( V ( 1

Step 3 Choose a bounded ρ -function ρ 0.

(a) Compute the M -scale of the residuals r i ( a, b, c ), 1 ≤ i ≤ n, related to ρ 0, as defined in (4) and denote it sn ( a, b, c ) .

(b) Minimize the scale sn ( a, b, c ), to obtain the scale estimator ̂ σ as its minimum value. Step 4 Choose ρ 1 such that ρ 1 ≤ ρ 0 and sup t ρ 1 ( t ) = sup t ρ 0 ( t ).Using ρ 1, compute an M -estimator ( ̂ µ, ̂ β, ̂ c ) with preliminary scale estimator ̂ σ, as defined in (6). The estimators of the additive components are then obtained using the coefficients c through (7).

̂ With respect to the numerical implementation of our proposal, once the centered B -spline { B ( j ) s ( x ) } k j -1 s = 1 are obtained in Step 1, for j = 1,..., p and the pseudo-covariates V i are computed as described in Step 2, the estimators in Step 4 may be easily obtained using the function lmrob of the library robustbase in R which returns the estimated coefficients ̂ µ, ̂ β and c as well as the scale estimator σ from Step 3 .

̂ ̂ As mentioned above, once the centered B -spline bases are constructed, our proposal is obtained using MM -regression estimators. For that reason, if the basis dimensions, k j, 1 ≤ j ≤ p, are known and fi xed, our proposal leads to estimators of β resistant to high-leverage outliers and with high breakdown point, see Yohai (1987) and Maronna et al. (2019). However, in practice, the number of elements of the basis k j is chosen from the data, for instance, using a robust BIC criterion as the one described in Section 2.3. The breakdown point of the proposed B -spline MM -estimator when the dimension is data-driven is beyond the scope of the paper and this interesting topic may be object of future work.

To   implement   the   proposed   B -spline   MM -estimators,   the   selection   of   the   knot   sequence   to   be   used   when   estimating   the   j -th   additive   component   is   an   important   topic.   Clearly,   knot   selection   is   more   relevant   when   estimating   η j than   for   the   estimators   of   β.  As   mentioned   by   Stone   ( 1985 ),   the   number   of   knots   is   more   crucial   than   their   location   and   for   that   reason   we   discuss   below   an   approach   to   select   the   number   of   interior   knots   N n, j or,   equivalently,   the   basis   dimension   k j,   using   a   robust   BIC   criterion.   Regarding   the   knots   location,   equally   spaced   knots   or   quantile   knots   are   two   possible   choices.   Uniform   knots   are   usually   used   when   the   function   η j does   not   exhibit   dramatic   changes   in   its   derivatives.   In   contrast,   non–uniform   knots   are   desirable   when   the   function   has   very   different   local   behaviors in   different   regions.   A   commonly   used   approach   in   this   last   situation   is   to   consider   quantile   knots,   that   is,   the   quantiles   of   the   observed   explanatory   variables   X ij,   1   ≤ i   ≤ n,   with   uniform   percentile   ranks.

The   number   of   elements   of   the   basis   k j which   approximates   each   additive   function   may   be   determined   by   a   model   selection   criterion.   However,   it   is   well   known   that,   to   ensure   robustness   properties   of   the   ﬁnal   estimator,   a   robust   criterion   is   needed.   As   in   He   et   al.   ( 2002 ),   a   robust   BIC criterion   may   be   deﬁned   as   follows

$$
i \text { needed. As in He et al. ( 2002), a robust BIC criterion may be defined as follows} \\ R B I C ( k ) = & \log \left ( \widehat { \sigma } ^ { 2 } \sum _ { i = 1 } ^ { n } \rho _ { 1 } \left ( \frac { r _ { i } } { \widetilde { \sigma } } \right ) \right ) + \frac { \log ( n ) } { 2 n } \sum _ { j = 1 } ^ { p } k _ { j }, \\ & 5
$$
