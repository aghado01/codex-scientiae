[Page 8]

## 3. Nonparametric regression on manifolds

Consider the following nonparametric regression problem

$$
y = f ( x ) + \varepsilon , \ x \in \mathbb { M } , \\ \intertext { w h o n $ \mathbb { M } $ i s a $ d $ \dim o n o l $ e $ o m o n o t $ D i m o n o p i n o n m o n o t $ }
$$

where M is a d − dimensional compact Riemannian manifold, f : M → R is the regression function and ε is a normal random variable with mean zero and variance σ 2 > 0. ˜

For a given sample ( y 1 , x 1 ) , . . ., ( y n , x n ), let f be an estimator of f based on the regression model (3.1). We will assess the estimator’s performance by the sup–norm loss:

$$
\| \tilde { f } - f \ \| _ { \infty } = \sup _ { x \in M } | \tilde { f } ( x ) - f ( x ) | .
$$

Furthermore, we will take as the parameter space, Λ( β, L ), the class of H¨older functions

$$
( 3 . 3 ) \ \Lambda ( \beta , L ) & = \{ f \colon \mathbb { M } \to \mathbb { R } \ | \ | f ( x ) - f ( z ) | \leq L \rho ( x , z ) ^ { \beta } , x , z \in \mathbb { M } \} , \\ \intertext { w h o r } \ w h o r \ 0 \ < \beta < 1 \ e n d \ i s \ t h o b \ P i o m n o p n i o n \ m o t i v o n \ \mathbb { M } \ i \ j \ o l ( n \ \Omega ) \ i s
$$

where 0 < β ≤ 1 and ρ is the Riemannian metric on M , i.e., ρ ( x, z ) is the geodesic length (determined by the metric tensor) between x, z ∈ M .

For w ( u ), a continuous non-decreasing function which increases no faster than a power of its argument as u → ∞ with w (0) = 0, we deﬁne the sup-norm minimax risk by

$$
r _ { n } ( w , \beta , L ) = \inf _ { \tilde { f } } \sup _ { f \in \Lambda ( \beta , L ) } \mathbb { E } w ( \psi _ { n } ^ { - 1 } \, \| \, \tilde { f } - f \, \| _ { \infty } ) ,
$$

where the ψ n → 0 is the sup–norm minimax rate, as n → ∞ , and E denotes expectation with respect to (3.1) where ε is normally distributed.

3.1. Asymptotic equidistance on manifolds. Consider a set of points z i ∈ M , i = 1 , · · · , m . We will say that the set of points is asymptotically equidistant if

$$
\inf _ { i \neq j } \rho ( z _ { i } , z _ { j } ) \sim \frac { ( \text {vol} \, \mathbb { M } ) ^ { 1 / d } } { m }
$$

/negationslash

as m → ∞ for all i, j = 1 , . . ., m , where for two real sequences { a m } and { b m } , a m ∼ b m will mean | a m /b m | → 1 as m → ∞ , this implies that

$$
\frac { \max _ { j } \min _ { i \neq j } \rho ( z _ { i } , z _ { j } ) } { \min _ { j } \min _ { i \neq j } \rho ( z _ { i } , z _ { j } ) } \sim 1 \ ,
$$

/negationslash

/negationslash

as m → ∞ . It will be assumed throughout that the manifold admits a collection of asymptotically equidistant points. This is certainly true for the sphere (in any dimension), and will be true for all compact
