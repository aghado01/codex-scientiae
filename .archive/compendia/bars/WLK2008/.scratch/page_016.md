[Page 16]

$$
W \leftarrow D i a g \left ( \mu \right )
$$

\( H \leftarrow WX \) . comment: Use known diagonal structure of \( W \)

$$
J \leftarrow H ^ { \top } X
$$

\( U \leftarrow \) Upper triangular matrix from the Cholesky decomposition of \( J = U^\top U \) if Cholesky decomposition fails

\( \text{error} \leftarrow \text{true} \)

\( \text{exit} \leftarrow \text{true} \)

else

\( \hat{\beta} \leftarrow \) Solution to \( J\beta = H^\top z \) . comment: Use Cholesky decomposition of \( J \) if unable to solve equation

\( \text{error} \leftarrow \text{true} \)

\( \text{exit} \leftarrow \text{true} \)

else

$$
\eta \leftarrow X \beta
$$

$$
\mu \leftarrow \exp ( \eta )
$$

$$
\ell _ { j } \leftarrow \Sigma _ { i } \left ( y _ { i } \eta _ { i } - \mu _ { i } \right )
$$

$$
e x i t \leftarrow ( ( ( | \ell _ { j } - \ell _ { j - 1 } | < \varepsilon ) \text { and } ( j > 1 ) ) \text { or } ( j > 2 0 ) )
$$

- until ( \( \text{exit} \) )
- return


## 5.4. Function: Generate random coefficient vector

- Generates \( \beta \) posterior distribution \( \pi ( \beta | k , \xi , \text{Data} ) \) or from the \( N ( \hat{\beta} , ( X^\top WX )^{-1} ) \) approximation, as follows. One \( \beta \) is generated from the normal approximation. If \( \beta \) the appears to not be an outlier under the posterior distribution, the \( \beta \) variate is accepted and returned. If the \( \beta \) does appear to be an outlier, the routine takes a user-defined number of Metropolis-Hastings steps and returns the last sampled \( \beta \) . The \( \beta \) is identified as an outlier if its log Metropolis-Hastings acceptance probability is below a userdefined threshhold.
- Let \( \pi^* \) denote the density for the normal approximation. Note that the Cholesky decomposition of \( X^\top WX \) is already available from the last fitting iteration.
- input:


\( \hat{\beta} \) , the MLE of \( \beta \) .

\( U \) , a \( p \times p \) upper triangular matrix that contains information on the estimated covariance matrix of \( \hat{\beta} \) .

\( MHI \) , the number of Metropolis-Hastings iterations. This is a user-defined parameter.

\( MHT \) , the threshhold used to determine whether (a) the initial \( \beta \) variate from the normal approximation should be kept as the resulting variate, or (b) \( MHI \) Metropolis-Hastings iterations are used. \( MHT \) is compared to the log of the acceptance probability. \( MHT \) is a user-defined parameter.

- output:
