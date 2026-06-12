[Page 3]

Assume labeled observations { ( x i,y i ) } m i =1 ⊂ [0, 1] d × R are independent and identically distributed, such that for i = 1,...,m, 2

$$
y _ { i } = f ( x _ { i } ) + \epsilon _ { i }, \ \epsilon _ { i } \sim N ( 0, \sigma ^ { 2 } ),
$$

where f : [0, 1] d → R is an unknown function, and σ 2 > 0 is the noise variance.

The article utilizes tensor product splines to model the real multivariate function f.As the name implies, the tensor product spline space is the tensor product of d univariate spline spaces corresponding to each component of x.The univariate spline space in [0, 1] of degree p i and non-decreasing knot sequence { ξ ij } k i +1 j =0 allowing duplicates ( ξ i 0 = 0,ξ i ( k i +1) = 1) consists of the following univariate functions: (1) Be a polynomial of at most degree p i on each interval ( ξ ij,ξ i ( j +1) ) ; (2) Belong to C p i − 1 ([0, 1]) except for the coincident knots, and if ξ i ( j − 1) < ξ ij = ... = ξ i ( j + l ) < ξ i ( j + l +1), the function has continuous derivatives up to the order p i − 1 − l at that point ( l ≤ p i ).Specifically, when l = p i, the spline function may discontinue at the coincident knot.

Remark 1. The usual spline-based methods employ equidistant knots or quantile-based knots, posing the distinct knot assumption implicitly. This results in continuous splines. When the true function exists jumping discontinuity, the distinct knot spline will fail to make an accurate estimation. However, the spline with automatic knot selection can circumvent the problem by optimal placement.

Let p = { p i } d i =1, k = { k i } d i =1, and ξ = { ξ i } d i =1 with ξ i = { ξ ij } k i j =1.Denote the tensor product spline space as S p,k,ξ and the univariate spline space as S p i,k i,ξ i for i = 1,...,d.Then S p,k,ξ = d i =1 S p i,k i,ξ i, where S p i,k i,ξ i is a linear space with the dimension of k i + p i + 1.Let { b ij } k i + p i +1 j =1 be a basis of S p i,k i,ξ i, such as B-splines. Consequently, the dimension of S p,k,ξ is Π d i =1 ( k i + p i + 1), denoted as ν.And b = d i =1 { b ij } k i + p i +1 j =1 is a basis of S p,k,ξ.For simplicity, rewrite b as { b i } ν i =1.Thus, any f ∈ S p,k,ξ can be represented by ν i =1 β i b i.Let β = ( β 1,...,β ν ) ⊤.Define the design matrix Z by Z ij = b j ( x i ) for i = 1,...,m and j = 1,...,ν.Therefore, (1) can be reformulated as

$$
y = Z \beta + \epsilon, \ \epsilon \sim N _ { m } ( 0, \sigma ^ { 2 } I _ { m } ),
$$

where y,ϵ ∈ R m, β ∈ R ν, Z ∈ R m × ν.Notably, (2) is an ordinary linear regression model.

Experiments have demonstrated that changes on p have little impact on the performance; see Perperoglou et al. [2019]. Cubic splines ( p = 3) and linear splines ( p = 1) are the most common alternatives in the research. We will explore the two splines in the simulations. Given the degree, the number and position of knots determine basis functions of the spline space, affecting the non-linearity in the model.

We specify the priors of k,ξ,β,σ in (2) as follows. Firstly, we initialize enormous candidate knots. Owing to the specific structure of tensor product splines, the candidate knots can be chosen in each component separately. Let n i nodes η i ⊂ [0, 1] be the i -th component. Then the overall candidate knots are given by η = d i =1 η i.To simplify the analysis, assume that the knots in η i are distinct. Nevertheless, when n i is sufficiently large and η i is sufficiently dense in [0, 1], we can still find a spline model to reflect jumping discontinuity well. For i = 1,...,d, let M k i be the model space containing all the possible location combinations with k i knots in [0, 1].Then the size of M k i is τ ( M k i ) = n i k i  .Since k i << n i, τ ( M k i ) is increasing as k i increases. Let M k be d i =1 M k i.Then τ ( M k ) = Π d i =1 n i k i  .The priors of k,ξ are specified as

$$
\pi ( k ) \, \infty \, \tau ( \mathcal { M } _ { k } ) ^ { 1 - \gamma }, \, \pi ( \xi | k ) = 1 / \tau ( \mathcal { M } _ { k } ), \ \ 0 \leq \gamma \leq 1 .
$$

Consequently, π ( k,ξ ) ∝ τ ( M k ) − γ.Given k, the prior probabilities of different position combinations are equal. The parameter γ adjusts the growth rate of π ( k ).It is equivalent to imposing a penalty on π ( k ).As γ increases from 0 to 1, the growth rate becomes milder gradually. Particularly, when γ = 0, we have π ( k ) ∝ τ ( M k ) and π ( k,ξ ) ∝ 1, meaning the same prior probability for knots. Sometimes this γ causes that excessive knots are selected.
