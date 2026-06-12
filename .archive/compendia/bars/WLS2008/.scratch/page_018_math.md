[Page 18]

Generates β from the posterior distribution π ( β | k,ξ, Data ) or from the N     β,   X   WX   − 1   approximation, as follows. One β is generated from the normal approximation. If the β appears to not be an outlier under the posterior distribution, the β variate is accepted and returned. If the β does appear to be an outlier, the routine takes a user-deﬁned number of Metropolis-Hastings steps and returns the last sampled β.The β is identiﬁed as an outlier if its log Metropolis-Hastings acceptance probability is below a user-deﬁned threshhold.

Let π ∗ denote the density for the normal approximation. Note that the Cholesky decomposition of X WX is already available from the last ﬁtting iteration.

$$
\stackrel { \beta, \, the \, M L E \, o f \, \beta.} { \beta }
$$

U, a p × p upper triangular matrix that contains information on the estimated covariance matrix of β .

MHI, the number of Metropolis-Hastings iterations. This is a user-deﬁned parameter.

MHT, the threshhold used to determine whether (a) the initial β variate from the normal approximation should be kept as the resulting variate, or (b) MHI Metropolis-Hastings iterations are used. MHT is compared to the log of the acceptance probability. MHT is a user-deﬁned parameter.

error, a boolean indicator of failure

β, the random variate. Only deﬁned if not error .

β curr ← β

for i ← 0 to MHI − 1

iter ← 0, error ← false, exit ← false

iter ← iter + 1 z ∼ N (0,I ) A ← Solution to U A = z.error ← (unable to solve equation) exit ← (( not error ) or ( iter ≥ 20))
