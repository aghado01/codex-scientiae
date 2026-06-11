[Page 8]

(b) Example 2

(c) Example 3

(a) Example 1

6

2

4

10

1

2

f

(

x

)

f

(

x

)

f

(

x

)

0

0

5

–2

–1

–4

0

0·0

0·2

0·4

0·6

0·8

1·0

0·0

0·2

0·4

0·6

0·8

1·0

0·0

0·2

0·4

0·6

0·8

1·0

x

x

x

Fig. 1. The three true functions used in the simulation study together with one sample.

Example 1. The true function is a spline with three internal knots at (0·2, 0·6, 0·7) T and coe ﬃ cients b = (20, 4, 6, 11, 6) T.The function is evaluated on a regular grid of 101 points, and a zero-mean Normal noise is added to the true function with s = 0·9, so that the signal-to-noise ratio,  ( f )/ s, is 3.

Example 2. The true function is

$$
f ( x ) = \sin ( x ) + 2 \, \exp ( - 3 0 x ^ { 2 } ), \ \ x \in [ - 2, 2 ],
$$

evaluated at 101 regularly spaced points, and the standard deviation of the noise is chosen to be s = 0·3, so that again the signal-to-noise ratio is 3.

Example 3. The true function is a spline with ﬁve knots located at (0·4, 0·4, 0·4, 0·4, 0·7) and coe ﬃ cients (2, − 5, 5, 2, − 3, − 1, 2). The function is evaluated on a regular grid of 201 points in [0, 1], and zero-mean Normal noise is added to the true function with s = 0·55.

We compare our Bayesian adaptive regression splines estimates with spatially adaptive regression splines, Denison et al. (1998), and our modiﬁed Denison et al. estimates using mean squared error

$$
M S E = \frac { 1 } { n } \sum _ { i = 1 } ^ { n } \left \{ \hat { f } ( t _ { i } ) - f ( t _ { i } ) \right \} ^ { 2 }.\\
$$

The average mean squared error, together with standard errors, based on 10 samples of data is reported in Table 1. The Bayesian estimates in Table 1 are all based on a Poisson prior with mean 5 for the number of knots, k. However, when we used a Uniform prior on 1,..., 20 or a Poisson with mean ranging in value between 1 and 20, the mean squared error never changed by more than 25% across these examples, and these changes do not alter the basic ordering found.

We see from Table 1 that Bayesian adaptive regression splines produces values of mean squared error that are smaller than those from Denison et al. (1998) and spatially adaptive regression splines across all three test functions. The modiﬁed Denison et al. method works well for Example 2 and always improves on the original Denison et al. (1998).
