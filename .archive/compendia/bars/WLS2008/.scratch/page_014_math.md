[Page 14]

Declare models M curr, M cand, and M temp .

Set initial knots in M curr.The initial knots may be user deﬁned, equally spaced, or obtained via logspline.

Calculate birth and death probabilities for each possible value of k, using the userdeﬁned prior, as follows:

if ( k > = MAXKNOTS) birth probability = 0 else birth probability = c min(1,π ( k + 1) /π ( k )) if ( k < = 1) death probability = 0 else death probability = c min(1,π ( k − 1) /π ( k ))

probability of knot relocation is 1 − ( birth probability + death probability ).

Deﬁne µ (0), used to start each iterative ﬁtting process.

for i ← 0 to ( n − 1)

$$
\mu _ { i } ^ { ( 0 ) } = \max \left ( 0.1, y _ { i } \right )
$$

Form the natural spline design basis for M curr → X D, curr

Fit the Poisson regression model for M curr.See function description below.

if (ﬁt of M curr failed)
