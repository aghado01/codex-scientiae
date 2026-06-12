[Page 124]

0.5

0.5

0.4

0.4

0.3

0.3

0.2

0.2

0.1

0.1

0

0

−5 0 5 10

−5 0 5 10

(a)

(b)

Figure 2.16 Illustration of the robustness of Student’s t-distribution compared to a Gaussian. (a) Histogram distribution of 30 data points drawn from a Gaussian distribution, together with the maximum likelihood ﬁt obtained from a t-distribution (red curve) and a Gaussian (green curve, largely hidden by the red curve). Because the t-distribution contains the Gaussian as a special case it gives almost the same solution as the Gaussian. (b) The same data set but with three additional outlying data points showing how the Gaussian (green curve) is strongly distorted by the outliers, whereas the t-distribution (red curve) is relatively unaffected.

outliers is much less signiﬁcant for the t-distribution than for the Gaussian. Outliers can arise in practical applications either because the process that generates the data corresponds to a distribution having a heavy tail or simply through mislabelled data. Robustness is also an important property for regression problems. Unsurprisingly, the least squares approach to regression does not exhibit robustness, because it corresponds to maximum likelihood under a (conditional) Gaussian distribution. By basing a regression model on a heavy-tailed distribution such as a t-distribution, we obtain a more robust model.

If we go back to (2.158) and substitute the alternative parameters ν = 2a, λ = a/b, and η = τb/a, we see that the t-distribution can be written in the form

St(x|µ,λ,ν) =

∞

N x|µ,(ηλ)−1 Gam(η|ν/2,ν/2)dη. (2.160)

0

We can then generalize this to a multivariate Gaussian N(x|µ,Λ) to obtain the corresponding multivariate Student’s t-distribution in the form

St(x|µ,Λ,ν) =

∞

N(x|µ,(ηΛ)−1)Gam(η|ν/2,ν/2)dη. (2.161)

0

Using the same technique as for the univariate case, we can evaluate this integral to

###### Exercise 2.48 give
