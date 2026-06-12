
$$
\ w e i g h t _ { i j } = \beta _ { 0 } + b _ { i } + \beta _ { 1 } w e e k _ { j } + \epsilon _ { i j } ,
$$

where the $b_i \stackrel{iid}{\sim} N(0, \sigma^2_b)$ with variance component $\sigma^2_b > 0$. The $b_i$'s are an example of a random effect that helps explain the randomness of other pig samples and helps account for the correlations of weight measurements within individual pigs.

# 2.3 The Linear Mixed Model

The linear mixed model can be generalized and rewritten in a compact form. This leads to

$$
y = X \beta + Z b + \epsilon .
$$

The expected value and variance-covariance matrix of the random vectors in expression (2.9) are given by

$$
E \begin{bmatrix} b \\ \epsilon \end{bmatrix} = \begin{bmatrix} 0 \\ 0 \end{bmatrix} \quad \text {and} \ \ C o \begin{bmatrix} b \\ \epsilon \end{bmatrix} = \begin{bmatrix} G & 0 \\ 0 & R \end{bmatrix} ,
$$

respectively. In the pig example, $G = \sigma^2_b I_{K_\kappa}$, and $R = \sigma^2_\epsilon I_n$ where $I_{K_\kappa}$ is a $K_\kappa \times K_\kappa$ identity matrix, $I_n$ is an $n \times n$ identity matrix, and $\sigma^2_b$ and $\sigma^2_\epsilon$ are positive constants . Estimation of the fixed and random effects can be done by making the following distributional assumptions (Robinson, 1991), on $(y | b)$ and $b$ ,

$$
( y | b ) \sim N ( X \beta + Z b , R ) , \ \ b \sim N ( 0 , G ) .
$$

The joint density for ( y , b ) is then

$$
p ( y , b ) \ & = \ p ( y | b ) p ( b ) \\ & \quad \propto \ \exp \left \{ - \frac { 1 } { 2 } ( y - T \theta ) ^ { \prime } R ^ { - 1 } ( y - T \theta ) - \frac { 1 } { 2 } b ^ { \prime } G ^ { - 1 } b \right \} .
$$
