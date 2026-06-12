[Page 7]

condition   are   needed.   As   mentioned   in   Webb   et   al.   ( 2020 ),   Fourier   basis   approximations   suffer   from   a   drawback   known   as   the   Gibbs   phenomenon,   meaning   that   close   to   the   boundary   the   approximation   leads   to   an   oscillatory   overshoot.   Fourier   extensions   circumvent   this   issue   by   approximating   the   function   using   a   Fourier   series   that   is   periodic   on   a   larger   interval.   Theorem   3.2   in   Webb   et   al.   ( 2020 ) provides   uniform convergence   rates   for   the   Fourier   extensions   approximation,   leading   in   ( 10 ) to   a   rate   O ( k − r j + 1 / 2 j ),   which   is   the   approximation   rate   of   Legendre   polynomials.

This   section   aims   to   obtain   results   concerning   the   consistency   and   the   convergence   rates   of   the   estimators   deﬁned   in   Section 2 under   assumptions C1 to C7 below.   As   in   Guo   et   al.   ( 2013 ),   without   loss   of   generality,   we   will   assume   I j = [ 0,   1 ] for   j   = 1,   ...,   p.  In   assumption C1 below   the   function   ρ will   correspond   to   either   ρ 0 or   ρ 1 according   to   the   result   to   be   derived.   From   now   on   C r ( 0,   1 ) will   stand   for   the   space   of   functions   continuously   differentiable   up   to   order   r,       ·   refers   to   the   Euclidean   norm   in   R q and   for   any   continuous   function   v   : R   → R,     v   ∞ = sup t | v ( t ) |.  We   will   denote   as   G the   class   of   functions   G = { g : [ 0,   1 ]   → R such that   1 0 g ( x ) dx   = 0 } and,   for   any   r ≥ 1,   we   deﬁne η r 0, 1 η ( ) <, 0   r and sup | η ( r ) ( z 1 ) − η ( r ) ( z 2 ) | < .

$$
\mathcal { H } _ { r } = \{ \eta \in \mathcal { C } ^ { r } [ 0, 1 ] \, \colon \, \| \eta ^ { ( \ell ) } \| _ { \infty } < \infty, \, 0 \leq \ell \leq r \text { and } \sup _ { z _ { 1 } \neq z _ { 2 } } \frac { | \eta ^ { ( r ) } ( z _ { 1 } ) - \eta ^ { ( r ) } ( z _ { 2 } ) | } { | z _ { 1 } - z _ { 2 } | } < \infty \} \, .
$$

C1 (a) The   function   ρ : R   → [ 0 ;   +∞ ) is   bounded,   continuous,   even,   non–decreasing   in   [ 0,   +∞ ) and   such   that   ρ ( 0 )   = 0.   Furthermore,   lim t →+∞ ρ ( t )    = 0 and   if   0   ≤ u   < v with   ρ ( v )   < sup t ρ ( t ) then   ρ ( u )   < ρ ( v ).  Without   loss   of   generality,   since   ρ is   bounded,   we   assume   that   sup t ρ ( t )   = 1. (b) ρ is   continuously   differentiable   with   bounded   derivative   ψ.  Moreover,   the   function   ζ : R   → R deﬁned   as   ζ( t )   =

(b) ρ is continuously differentiable with bounded derivative ψ.Moreover, the function ζ : R → R defined as ζ( t ) = t ψ( t ), t ∈ R, is bounded.

Remark 3.1. Conditions C1 and C2 are standard conditions for the errors and for the loss function, respectively. The fi rst one is a condition assumed in the context of robustness to ensure Fisher-consistency. In this sense, C6 is also a requirement for Fisher-consistency and it is the conditional counterpart of the usual assumption in linear regression models to guarantee Fisher-consistency. Under the partially linear additive model we are considering, Fisher-consistency will be derived in Lemma A.1 in the Appendix. Note that if, for almost any x 0 ∈ R p, the distribution of Z given X = x 0 has a density, then P ( b t Z = a | X = x 0 ) = 0, for any a ∈ R, b ∈ R q, ( b, a ) /negationslash= 0, implying that C6 and C7 hold. Furthermore, it is worth mentioning that C6 holds whenever P ( b t Z + ∑ p j = 1 g j ( X j ) = a ) = 0 in C7 .

Condition C3 regards the smoothness of the additive nonparametric components and r j corresponds to the smoothness degree of the j -additive true functions η j.The regularity of the additive components stated in C3 is related to the order of the B -splines used to approximate them, meaning that if for instance cubic splines are used, our results will be valid for twice continuously differentiable functions. As mentioned in He et al. (2002), if we think that η j is less smooth, quadratic splines can be considered.

The   condition   about   the   knots   spacing   given   in C4 is   a   standard   one   when   using   B -spline   approximations.

Strong   consistency   of   the   preliminary   scale   estimator   is   required   in C5 to   allow   for   other   choices   of   the   robust   scale   estimators,   besides   the   one   introduced   in   Section 2.2.  Proposition 3.1 below   states   that   the   S -scale   deﬁned   through   ( 5 ) is   indeed   strongly   consistent   as   required   in C5 .

Proposition 3.1 derives   strong   consistency   results   for   the   residual   scale   estimator     σ deﬁned   through   ( 5 ).   To   derive   this   result   we   deﬁne   the   population   counterpart   of     σ.  More   precisely,   given   a   ∈ R,   b   ∈ R q and   g j ∈ G,   1   ≤ j   ≤ p,   S ( a,   b,   g 1,   ...,   g p ) stands   for   the   M -scale   functional   corresponding   to   the   residuals   r ( a,   b,   g 1,   ...,   g p )   = Y − a   − b t Z   −   p j = 1 g j ( X j ),   that   is,   S ( a,   b,   g 1,   ...,   g p ) satisﬁes

$$
\mathbb { E } \rho _ { 0 } \left ( \frac { r ( a, b, g _ { 1 }, \dots, g _ { p } ) } { S ( a, b, g _ { 1 }, \dots, g _ { p } ) } \right ) = b \,.\\ \text {Henceforth} \, \text { the scale estimators are calibrated}
$$

Henceforth,   the   scale   estimators   are   calibrated   so   that
