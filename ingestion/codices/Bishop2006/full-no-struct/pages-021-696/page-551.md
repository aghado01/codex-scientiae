[Page 551]

Illustrative example of rejection sampling involving sampling from a Gaussian distribution p ( z ) shown by the green curve, by using rejection sampling from a proposal distribution q ( z ) that is also Gaussian and whose scaled version kq ( z ) is shown by the red curve.

![The image is a graph that shows the relationship between two variables, specifically the concentration of a compound and its concentration of a solvent. The graph is titled concentration of compound vs. concentration of solvent and is labeled as p(y) = 0.5 - 0.25x. The graph has two main lines: 1. The first line is a green line that starts at a value of 0.5 and increases to a value of 0.25. This line is labeled as p(y) = 0.5 - 0.25x. 2. The second line is a red line that starts at a value of 0.5 and decreases to a value of 0.25. This line is labeled as p(y) = 0.25 - 0.5x. The x-axis represents the concentration of the compound, while the y-axis](../images/imageFile259.png)

0.5

p

(

z

)

0.25

0

z

-5

0

5

of linear functions, and hence the envelope distribution itself comprises a piecewise exponential distribution of the form

$$
q ( z ) & = k _ { i } \lambda _ { i } \exp \{ - \lambda _ { i } ( z - z _ { i - 1 } ) \} \quad z _ { i - 1 } < z \leqslant z _ { i } . \\ \\ \intertext { q ( z ) = k _ { i } \lambda _ { i } \exp \{ - \lambda _ { i } ( z - z _ { i - 1 } ) \} } z _ { i } & = 1 - z _ { i - 1 } .
$$

Once a sample has been drawn, the usual rejection criterion can be applied. If the sample is accepted, then it will be a draw from the desired distribution. If, however, the sample is rejected, then it is incorporated into the set of grid points, a new tangent line is computed, and the envelope function is thereby reﬁned. As the number of grid points increases, so the envelope function becomes a better approximation of the desired distribution p ( z ) and the probability of rejection decreases.

A variant of the algorithm exists that avoids the evaluation of derivatives (Gilks, 1992). The adaptive rejection sampling framework can also be extended to distributions that are not log concave, simply by following each rejection sampling step with a Metropolis-Hastings step (to be discussed in Section 11.2.2), giving rise to adaptive rejection Metropolis sampling (Gilks et al. , 1995).

Clearly for rejection sampling to be of practical value, we require that the comparison function be close to the required distribution so that the rate of rejection is kept to a minimum. Now let us examine what happens when we try to use rejection sampling in spaces of high dimensionality. Consider, for the sake of illustration, a somewhat artiﬁcial problem in which we wish to sample from a zero-mean multivariate Gaussian distribution with covariance σ 2 p I , where I is the unit matrix, by rejection sampling from a proposal distribution that is itself a zero-mean Gaussian distribution having covariance σ 2 q I . Obviously, we must have σ 2 q σ 2 p in order that there exists a k such that kq ( z ) p ( z ) . In D -dimensions the optimum value of k is given by k = ( σ q /σ p ) D , as illustrated for D = 1 in Figure 11.7. The acceptance rate will be the ratio of volumes under p ( z ) and kq ( z ) , which, because both distributions are normalized, is just 1 /k . Thus the acceptance rate diminishes exponentially with dimensionality. Even if σ q exceeds σ p by just one percent, for D = 1 , 000 the acceptance ratio will be approximately 1 / 20 , 000 . In this illustrative example the comparison function is close to the required distribution. For more practical examples, where the desired distribution may be multimodal and sharply peaked, it will be extremely difﬁcult to ﬁnd a good proposal distribution and comparison function.
