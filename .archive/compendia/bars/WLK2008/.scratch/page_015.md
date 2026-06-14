[Page 15]

\[
\mu_{D,curr} \leftarrow \exp(X_{D,curr} \beta_{curr})
\]

Form the natural spline grid basis for M curr → X G,curr

\[
\mu_{G,curr} \leftarrow \exp(X_{G,curr} \beta_{curr})
\]

comment: Find mode and the mean function evaluated at the mode. In neuron firing examples, it produces the location of the peak firing rate, and the peak firing rate.

Use μ G, curr to form an interpolating spline.

Locate mode of interpolating spline → ( x mode , μ curr ( x mode ))

Write desired parameters to a file.

Store desired parameters for later use.

comment: update posterior modal values, if appropriate

if (( BIC curr > maxBIC ) or ( i == burnin iterations ))

\[
\max BIC \leftarrow BIC_{curr}
\]

parameter modes ← current parameter values

- Use partial sorting to form confidence intervals of desired stored parameters.
- Calculate means of desired stored parameters.
- return


## 5.3. Function: Fit Poisson regression model

- input:

X , an n × p design matrix

y , a vector of observed counts

μ (0) , a vector of starting values

## • output:

β ̂ , estimated coefficients

U , a p × p upper triangular matrix that contains information on the estimated covariance matrix of β ̂

error , a boolean indicator of fit failure.

- μ ← μ (0)
- j ← 0
- ℓ 0 ← 0
- error ← false
- repeat


\[
\begin{aligned}
j &\leftarrow j + 1 \\
z &\leftarrow \log \mu + (y - \mu) / \mu .
\end{aligned}
\]
