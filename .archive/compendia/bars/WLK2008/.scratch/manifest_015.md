# Manifest: Page 015

## REPAIR_MATH
- RAW: ```
$$
\mu _ { D , c u r r } \leftarrow \exp ( X _ { D , c u r r } \beta _ { c u r r } )
$$
```
  FIX: ```
\[
\mu_{D,curr} \leftarrow \exp(X_{D,curr} \beta_{curr})
\]
```
- RAW: ```
$$
\mu _ { G , c u r r } \leftarrow \exp ( X _ { G , c u r r } \beta _ { c u r r } )
$$
```
  FIX: ```
\[
\mu_{G,curr} \leftarrow \exp(X_{G,curr} \beta_{curr})
\]
```
- RAW: ```
$$
\max { B I C } \leftarrow { B I C } _ { c u r r }
$$
```
  FIX: ```
\[
\max BIC \leftarrow BIC_{curr}
\]
```
- RAW: ```
$$
j & \leftarrow j + 1 \\ z & \leftarrow \log \mu + ( y - \mu ) / \mu .
$$
```
  FIX: ```
\[
\begin{aligned}
j &\leftarrow j + 1 \\
z &\leftarrow \log \mu + (y - \mu) / \mu .
\end{aligned}
\]
```

## REPAIR_PROSE
- RAW: Form the natural spline grid basis for M curr → X G,curr
  FIX: Form the natural spline grid basis for \(M_{curr} \rightarrow X_{G,curr}\)
- RAW: Use μ G, curr to form an interpolating spline.
  FIX: Use \(\mu_{G,curr}\) to form an interpolating spline.
- RAW: Locate mode of interpolating spline → ( x mode , μ curr ( x mode ))
  FIX: Locate mode of interpolating spline \(\rightarrow (x_{mode}, \mu_{curr}(x_{mode}))\)
- RAW: if (( BIC curr > maxBIC ) or ( i == burnin iterations ))
  FIX: if ((\(BIC_{curr} > \max BIC\)) or (\(i == \text{burnin iterations}\)))
- RAW: parameter modes ← current parameter values
  FIX: \(\text{parameter modes} \leftarrow \text{current parameter values}\)
- RAW: X , an n × p design matrix
  FIX: \(X\), an \(n \times p\) design matrix
- RAW: y , a vector of observed counts
  FIX: \(y\), a vector of observed counts
- RAW: μ (0) , a vector of starting values
  FIX: \(\mu^{(0)}\), a vector of starting values
- RAW: ## • output:
  FIX: - output:
- RAW: β ̂ , estimated coefficients
  FIX: \(\hat{\beta}\), estimated coefficients
- RAW: U , a p × p upper triangular matrix that contains information on the estimated covariance matrix of β ̂
  FIX: \(U\), a \(p \times p\) upper triangular matrix that contains information on the estimated covariance matrix of \(\hat{\beta}\)
- RAW: - μ ← μ (0)
  FIX: - \(\mu \leftarrow \mu^{(0)}\)
- RAW: - j ← 0
  FIX: - \(j \leftarrow 0\)
- RAW: - ℓ 0 ← 0
  FIX: - \(\ell_0 \leftarrow 0\)

## REPLACE_TABLES
