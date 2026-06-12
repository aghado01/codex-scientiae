
$$
p ( \xi _ { i } | c ) = \int _ { 0 } ^ { \infty } p ( \xi _ { i } | \rho _ { i } ) p ( \rho _ { i } | c ) d \rho _ { i } .
$$

The joint distribution of the b j ’s is normal with zero mean vector and variance-covariance matrix δ j I K κ (see Equation (3.2)). Using (3.3) we can write ( b | γ ,τ,ξ 1 ) ∼ N ( 0 , ( τξ 1 ) − 1 D − 1 γ ), where D γ =diag( e γ 1 ,...,e γ K κ ) and γ = Z γ b γ where b γ = ( b γ 1 ,...,b γK ι )   and

$$
Z _ { \gamma } = \begin{bmatrix} ( \kappa _ { 1 } - \iota _ { 1 } ) _ { + } ^ { q } & \dots & ( \kappa _ { 1 } - \iota _ { K _ { \iota } } ) _ { + } ^ { q } \\ \vdots & \ddots & \vdots \\ ( \kappa _ { K _ { \kappa } } - \iota _ { 1 } ) _ { + } ^ { q } & \dots & ( \kappa _ { K _ { \kappa } } - \iota _ { K _ { \iota } } ) _ { + } ^ { q } \end{bmatrix} ,
$$

that is, in the design matrix Z γ the knots { κ j } K κ j =1 are treated as covariate values with knots { ι k } K ι k =1 . The parameter vector b γ ∼ N ( 0 ,η − 1 I K ι + q ). Note that η = δξ 2 and δ = τξ 1 , so η = τξ 1 ξ 2 . The prior on b γ can then be written as ( b γ | τ,ξ 1 ,ξ 2 ) ∼ N ( 0 , ( τξ 1 ξ 2 ) − 1 I K ι + q ). This completes the prior specification for the BAPS model. Yue et al. (2012) show that the choice of priors leads to a proper posterior distribution.

# 3.5 Sampling Scheme

In this section, we present the sampling scheme for the BAPS model. Let T = [ X,Z ]. To sample from the posterior

$$
p ( \beta , b , \tau , \xi _ { 1 } , \xi _ { 2 } , \rho _ { 1 } , \rho _ { 2 } , \gamma | y ) & \otimes p ( y | \beta , b , \tau ) p ( \tau ) p ( \beta ) p ( b | \gamma , \tau , \xi _ { 1 } ) p ( \xi _ { 1 } | \rho _ { 1 } ) p ( \xi _ { 2 } | \rho _ { 2 } ) \\ & \times p ( \rho _ { 1 } | c _ { 1 } ) p ( \rho _ { 2 } | c _ { 2 } ) p ( b _ { \gamma } | \tau , \xi _ { 1 } . \xi _ { 2 } ) .
$$

The full conditional posterior distributions for the individual parameters ( β , b ,τ,ξ 1 ,ξ 2 ,ρ 1 ,ρ 2 , γ ) are as follows.

1. The parameter vectors β and b are sampled jointly as θ = ( β , b ) from the multivariate normal distribution, N ( µ θ ,Q θ ), where

$$
\mu _ { \theta } = \tau Q _ { \theta } T ^ { \prime } y ,
$$
