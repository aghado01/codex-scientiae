[Page 4]

For   given   values   a   ∈ R,   b   ∈ R q and   λ ( j ) ∈ R k j,   the   classical   least   squares   estimator   is   obtained   minimizing     n i = 1   Y i − a − b t Z i −   p j = 1   k j s = 1 λ ( j ) s B ( j ) s ( X ij )   2.  However,   the   design   matrix   for   this   problem   is   ill   conditioned,   even   when   p   = 1.   Effectively,   taking   into   account   that     k j s = 1   B ( j ) s ( x )   = 1,   for   all   x   ∈ I j,   we   easily   obtain   that     k j s = 1 B ( j ) s ( x )   = 0.   Thus,   we   may   rewrite   the   approximation   as k j k j − 1

$$
\sum _ { s = 1 } ^ { k _ { j } } \lambda _ { s } ^ { ( j ) } B _ { s } ^ { ( j ) } ( x ) & = \sum _ { s = 1 } ^ { k _ { j } - 1 } \left ( \lambda _ { s } ^ { ( j ) } - \lambda _ { k _ { j } } ^ { ( j ) } \right ) B _ { s } ^ { ( j ) } ( x ) \,.\\ \intertext { s u n t i g h s c r { O } } \text {From now on, we denote } K = \sum _ { s = 1 } ^ { p } \, k _ { s } - n \, p \, t h e f f e t i v e d i t y
$$

= = From   now   on,   we   denote   K =   p j = 1 k j − p the   effective   dimension   of   the   considered   space   used   to   approximate   the   nonparametric   additive   components.   Furthermore,   deﬁne   c ( j ) = ( c ( j ) 1,   ...,   c ( j ) k j − 1 ) t ∈ R k j − 1 with   c ( j ) s = λ ( j ) s − λ ( j ) k j and,   for   1   ≤ i   ≤ n,   the   residuals   as

$$
r _ { i } ( a, b, c ) = r _ { i } ( a, b, c ^ { ( 1 ) }, \dots, c ^ { ( p ) } ) = Y _ { i } - a - b ^ { T } Z _ { i } - \sum _ { j = 1 } ^ { p } \sum _ { s = 1 } ^ { k - j - 1 } c _ { s } ^ { ( j ) } B _ { s } ^ { ( j ) } ( X _ { i j } ) = Y _ { i } - a - b ^ { T } Z _ { i } - c ^ { T } V _ { i }, \\ \\
$$

where   c   = ( c ( 1 ) t,   ...,   c ( p ) t ) t ∈ R K,   V i = ( V ( 1 ) ( X i 1 ) t,   ...,   V ( p ) ( X ip ) t ) t and   V ( j ) ( t )   = ( B ( j ) 1 ( t ),   ...,   B ( j ) k j − 1 ( t )) t,   for   1   ≤ j   ≤ p.  With   this   parametrization   the   design   matrix   is   now   well   conditioned.

In   what   follows   the   loss   functions   ρ 0 and   ρ 1 to   be   considered   below   will   be   bounded   ρ -functions   as   deﬁned   in   Maronna   et   al.   ( 2019 ),   so     ρ 0   ∞ =   ρ 1   ∞ = 1 (see   assumption C1(a) ).   A   widely   used   family   of   bounded   ρ -functions   is   the   Tukey’s   bisquare   function   which   is   of   the   form   ρ t, c ( t )   = ρ t ( t / c ) where   ρ t ( t )   = min   1 − ( 1 − t 2 ) 3, 1  ,   that   is,   ρ t, c ( t )   = min   1 − ( 1 − ( t / c ) 2 ) 3, 1  .  The   tuning   constant   c > 0 balances   the   robustness   and   eﬃciency   properties   of   the   associated   estimators. To   deﬁne   the   robust   estimators,   as   in   linear   regression,   we   ﬁrst   compute   an   S -estimator   using   ρ 0.  This   preliminary

To define the robust estimators, as in linear regression, we fi rst compute an S -estimator using ρ 0. This preliminary estimator will allow to compute the initial scale estimator. For that purpose, let sn ( a, b, c ) be the M -scale estimator of the residuals related to ρ 0, that is, sn ( a, b, c ) is the solution on s of the implicit equation

(

)

n

∑

1

r i

a

b

c

(

,

,

)

=

ρ

b

,

0

-

-

n

q

K

s

=

i

1

where   0   < b   < 1. Therefore,   s n ( a,   b,   c ) satisﬁes

$$
\frac { 1 } { n - q - K } \sum _ { i = 1 } ^ { n } \rho _ { 0 } \left ( \frac { r _ { i } ( a, b, c ) } { s _ { n } ( a, b, c ) } \right ) & = b \,.\\ \intertext { s i n c l l o o l _ { \infty } = 1, the b a k d o w n i t p o f t h e M - s a l e s t e m a t i o r s i n g h.1 - b ).For t h e a r t h a r e o n, b = 1 / 2 i s h o s e n o t b a t i n }
$$

Since     ρ 0   ∞ = 1,   the   breakdown   point   of   the   M -scale   estimator   is   min ( b,   1   − b ).  For   that   reason,   b   = 1 / 2 is   chosen   to   obtain   a   50%   breakdown   point   for   the   scale   estimator.   Furthermore,   to   guarantee   Fisher–consistency,   we   need   that   b   = E ( ρ 0 ( ε )).  As   mentioned   in   Maronna   et   al.   ( 2019 ),   typically   the   function   ρ 0 depends   on   a   tuning   constant   c 0,   that   is,   ρ 0 ( t )   = ρ ( t / c 0 ) with   ρ a   ρ -function   and   c 0 > 0.   In   linear   regression   models,   the   constant   c 0 is   numerically   selected   by   the   user   to   guarantee   Fisher–consistency   at   a   given   distribution   for   a   chosen   breakdown   point.   For   instance,   when   ρ 0 is   the   bisquare   function,   that   is,   when   ρ 0 ( t )   = ρ t ( t / c 0 ),   we   may   choose   the   tuning   constant   c 0 as   c 0 = 1.54764 to   ensure   Fisher–consistency   when   ε ∼ N ( 0,   1 ) and   breakdown   point   b   = 1 / 2.   As   described   in   Maronna   et   al.   ( 2019 ),   we   divide   by   n   − q   − K instead   than   by   n in   ( 4 ) to   reduce   the   effect   of   a   large   dimension   K relative   to   the   sample   size. k 1 j j

The   initial   S -estimators   are   deﬁned   as   the   minimizers   of   s n ( a,   b,   c ),   that   is,     η j, ini ( x )   =   j − s = 1   c ( ) s, ini B ( ) s ( x ) where     c ini = (   c ( 1 ) t ini,   ...,     c ( p ) t ini ) t,     c ( j ) ini = (   c ( j ) 1, ini,   ...,     c ( j ) k j − 1, ini ) t and (   μ ini,   β ini,   c ini ) = argmin a ∈ R, b ∈ R q, c ∈ R K s n ( a, b, c ). The   residual   scale   estimator   equals

=

argmin

sn

a

b

c

)

(

,

,

) .

∈

∈

∈

q

K

R

R

R

a

b

c

,

,

σ = s n (   μ ini,   β ini,   c ini ). (5) As   in   linear   regression,   the   initial   S -estimators   may   be   obtained   combining   subsampling   and   iterative   reweighted   least   squares   as   described   in   Sections   5.7.1   to   5.7.3   of   Maronna   et   al.   ( 2019 ).   To   deﬁne   the   ﬁnal   M -estimator,   consider   a   ρ function   ρ 1 satisfying   ρ 1 ≤ ρ 0 and   sup t ρ 1 ( t )   = sup t ρ 0 ( t ).  For   instance,   when   ρ 0 ( t )   = ρ ( t / c 0 ) and   ρ 1 ( t )   = ρ ( t / c 1 ),   this   last
