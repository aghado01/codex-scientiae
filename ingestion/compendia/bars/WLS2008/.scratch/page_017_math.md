[Page 17]

X, an n × p design matrix y, a vector of observed counts

µ (0), a vector of starting values

β, estimated coeﬃcients

U, a p × p upper triangular matrix that contains information on the estimated covariance matrix of β .

error, a boolean indicator of ﬁt failure.

µ ← µ (0)

j ← 0

❼ glyph[lscript] 0 ← 0

error ← false

repeat

$$
j & \leftarrow j + 1 \\ z & \leftarrow \log \mu + ( y - \mu ) / \mu.\\ W & \leftarrow D i a g \left ( \mu \right )
$$

H ← WX.comment: Use known diagonal structure of W

$$
J \leftarrow H ^ { \top } X
$$

U ← Upper triangular matrix from the Cholesky decomposition of J = U U if Cholesky decomposition fails

$$
\ e r r o r & \leftarrow \text {true} \\ \ e x i t & \leftarrow \text {true}
$$

else

β ← Solution to Jβ = H z.comment: Use Cholesky decomposition of J if unable to solve equation

true

error


true

exit


else

$$
\eta \leftarrow X \widehat { \beta }
$$

$$
\eta & \leftarrow X \widehat { \beta } \\ \mu & \leftarrow \exp \left ( \eta \right ) \\ \ell _ { j } & \leftarrow \sum _ { i } \left ( y _ { i } \eta _ { i } - \mu _ { i } \right ) \\ e x i t & \leftarrow ( ( | \ell _ { j } - \ell _ { j - 1 } | < \varepsilon ) \text { and } ( j > 1 ) ) \text { or } ( j > 2 0 ) )
$$
