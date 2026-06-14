# Manifest: Page 016

## REPAIR_MATH
- RAW: ```
W \leftarrow D i a g \left ( \mu \right )
```
  FIX: ```
$$
W \leftarrow D i a g \left ( \mu \right )
$$
```
- RAW: ```
J \leftarrow H ^ { \top } X
```
  FIX: ```
$$
J \leftarrow H ^ { \top } X
$$
```
- RAW: ```
\eta \leftarrow X \beta
```
  FIX: ```
$$
\eta \leftarrow X \beta
$$
```
- RAW: ```
\mu \leftarrow \exp ( \eta )
```
  FIX: ```
$$
\mu \leftarrow \exp ( \eta )
$$
```
- RAW: ```
\ell _ { j } \leftarrow \Sigma _ { i } \left ( y _ { i } \eta _ { i } - \mu _ { i } \right )
```
  FIX: ```
$$
\ell _ { j } \leftarrow \Sigma _ { i } \left ( y _ { i } \eta _ { i } - \mu _ { i } \right )
$$
```
- RAW: ```
e x i t \leftarrow ( ( ( | \ell _ { j } - \ell _ { j - 1 } | < \varepsilon ) \text { and } ( j > 1 ) ) \text { or } ( j > 2 0 ) )
```
  FIX: ```
$$
e x i t \leftarrow ( ( ( | \ell _ { j } - \ell _ { j - 1 } | < \varepsilon ) \text { and } ( j > 1 ) ) \text { or } ( j > 2 0 ) )
$$
```

## REPAIR_PROSE
- RAW: ```
H ← WX . comment: Use known diagonal structure of W
```
  FIX: ```
\( H \leftarrow WX \) . comment: Use known diagonal structure of \( W \)
```
- RAW: ```
U ← Upper triangular matrix from the Cholesky decomposition of J = U ⊺ U if Cholesky decomposition fails

error ← true

exit ← true

else

β ̂ ← Solution to Jβ = H ⊺ z . comment: Use Cholesky decomposition of J if unable to solve equation

error ← true

exit ← true

else
```
  FIX: ```
\( U \leftarrow \) Upper triangular matrix from the Cholesky decomposition of \( J = U^\top U \) if Cholesky decomposition fails

\( \text{error} \leftarrow \text{true} \)

\( \text{exit} \leftarrow \text{true} \)

else

\( \hat{\beta} \leftarrow \) Solution to \( J\beta = H^\top z \) . comment: Use Cholesky decomposition of \( J \) if unable to solve equation

\( \text{error} \leftarrow \text{true} \)

\( \text{exit} \leftarrow \text{true} \)

else
```
- RAW: ```
- until ( exit )
- return
```
  FIX: ```
- until ( \( \text{exit} \) )
- return
```
- RAW: ```
- Generates β posterior distribution π ( β | k , ξ , Data ) or from the N ( β ̂ , ( X ⊺ WX ) -1 ) approximation, as follows. One β is generated from the normal approximation. If β the appears to not be an outlier under the posterior distribution, the β variate is accepted and returned. If the β does appear to be an outlier, the routine takes a user-defined number of Metropolis-Hastings steps and returns the last sampled β . The β is identified as an outlier if its log Metropolis-Hastings acceptance probability is below a userdefined threshhold.
```
  FIX: ```
- Generates \( \beta \) posterior distribution \( \pi ( \beta | k , \xi , \text{Data} ) \) or from the \( N ( \hat{\beta} , ( X^\top WX )^{-1} ) \) approximation, as follows. One \( \beta \) is generated from the normal approximation. If \( \beta \) the appears to not be an outlier under the posterior distribution, the \( \beta \) variate is accepted and returned. If the \( \beta \) does appear to be an outlier, the routine takes a user-defined number of Metropolis-Hastings steps and returns the last sampled \( \beta \) . The \( \beta \) is identified as an outlier if its log Metropolis-Hastings acceptance probability is below a userdefined threshhold.
```
- RAW: ```
- Let π * denote the density for the normal approximation. Note that the Cholesky decomposition of X ⊺ WX is already available from the last fitting iteration.
```
  FIX: ```
- Let \( \pi^* \) denote the density for the normal approximation. Note that the Cholesky decomposition of \( X^\top WX \) is already available from the last fitting iteration.
```
- RAW: ```
β ̂ , the MLE of β .
```
  FIX: ```
\( \hat{\beta} \) , the MLE of \( \beta \) .
```
- RAW: ```
U , a p × p upper triangular matrix that contains information on the estimated covariance matrix of β ̂ .
```
  FIX: ```
\( U \) , a \( p \times p \) upper triangular matrix that contains information on the estimated covariance matrix of \( \hat{\beta} \) .
```
- RAW: ```
MHI , the number of Metropolis-Hastings iterations. This is a user-defined parameter.
```
  FIX: ```
\( MHI \) , the number of Metropolis-Hastings iterations. This is a user-defined parameter.
```
- RAW: ```
MHT , the threshhold used to determine whether (a) the initial β variate from the normal approximation should be kept as the resulting variate, or (b) MHI Metropolis-Hastings iterations are used. MHT is compared to the log of the acceptance probability. MHT is a user-defined parameter.
```
  FIX: ```
\( MHT \) , the threshhold used to determine whether (a) the initial \( \beta \) variate from the normal approximation should be kept as the resulting variate, or (b) \( MHI \) Metropolis-Hastings iterations are used. \( MHT \) is compared to the log of the acceptance probability. \( MHT \) is a user-defined parameter.
```
