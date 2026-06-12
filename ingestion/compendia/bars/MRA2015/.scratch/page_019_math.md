[Page 19]

$$
\ w e i g h t _ { i j } = \beta _ { 0 } + b _ { i } + \beta _ { 1 } w e e k _ { j } + \epsilon _ { i j },
$$

where the b i iid ∼ N (0,σ 2 b ) with variance component σ 2 b > 0. The b i ’s are an example of a random eﬀect that helps explain the randomness of other pig samples and helps account for the correlations of weight measurements within individual pigs.

The linear mixed model can be generalized and rewritten in a compact form. This leads to

$$
y = X \beta + Z b + \epsilon .
$$

The expected value and variance-covariance matrix of the random vectors in expression (2.9) are given by

$$
E \begin{bmatrix} b \\ \epsilon \end{bmatrix} = \begin{bmatrix} 0 \\ 0 \end{bmatrix} \quad \text {and} \ \ C o \begin{bmatrix} b \\ \epsilon \end{bmatrix} = \begin{bmatrix} G & 0 \\ 0 & R \end{bmatrix},
$$

respectively. In the pig example, G = σ 2 b I K κ, and R = σ 2   I n where I K κ is a K κ × K κ identity matrix, I n is a n × n identity matrix, and σ 2 b and σ 2   are positive constants.Estimation of the ﬁxed and random eﬀects can be done by making the following distributional assumptions (Robinson, 1991), on ( y | b ) and b,

$$
( y | b ) \sim N ( X \beta + Z b, R ), \ \ b \sim N ( 0, G ) .
$$

The joint density for ( y, b ) is then

$$
p ( y, b ) \ & = \ p ( y | b ) p ( b ) \\ & \quad \infty \ \exp \left \{ - \frac { 1 } { 2 } ( y - T \theta ) ^ { \prime } R ^ { - 1 } ( y - T \theta ) - \frac { 1 } { 2 } b ^ { \prime } G ^ { - 1 } b \right \} .
$$
