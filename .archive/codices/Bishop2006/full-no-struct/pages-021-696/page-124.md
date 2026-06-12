[Page 124]

![The image is a bar graph with two sets of data represented by two sets of bars. The x-axis is labeled (-5) to 10 and the y-axis is labeled (-5) to 10. The data points are represented by two sets of bars, one for each set of data. The bars are colored blue and red, with the blue bars representing the data points and the red bars representing the values. The data points are as follows: - The blue bar for the first set of data is at -5 and 0.5. - The blue bar for the second set of data is at -5 and 0.5. - The red bar for the first set of data is at -5 and 0.5. - The red bar for the second set of data is at -5 and 0.5. The y-axis is labeled (-5) to 10](../images/imageFile57.png)

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

-5

0

5

10

-5

0

5

10

(a)

(b)

Figure 2.16 Illustration of the robustness of Student’s t-distribution compared to a Gaussian. (a) Histogram distribution of 30 data points drawn from a Gaussian distribution, together with the maximum likelihood ﬁt obtained from a t-distribution (red curve) and a Gaussian (green curve, largely hidden by the red curve). Because the t-distribution contains the Gaussian as a special case it gives almost the same solution as the Gaussian. (b) The same data set but with three additional outlying data points showing how the Gaussian (green curve) is strongly distorted by the outliers, whereas the t-distribution (red curve) is relatively unaffected.

outliers is much less signiﬁcant for the t-distribution than for the Gaussian. Outliers can arise in practical applications either because the process that generates the data corresponds to a distribution having a heavy tail or simply through mislabelled data. Robustness is also an important property for regression problems. Unsurprisingly, the least squares approach to regression does not exhibit robustness, because it corresponds to maximum likelihood under a (conditional) Gaussian distribution. By basing a regression model on a heavy-tailed distribution such as a t-distribution, we obtain a more robust model.

If we go back to (2.158) and substitute the alternative parameters ν = 2 a , λ = a/b , and η = τb/a , we see that the t-distribution can be written in the form

$$
d / b , \, & \text { and } \eta = \neq b / d , \, \text {we see that the } t \text {distribution} \, \text { can be written in the form } \\ & \text {St} ( x | \mu , \lambda , \nu ) = \int _ { 0 } ^ { \infty } \mathcal { N } \left ( x | \mu , ( \eta \lambda ) ^ { - 1 } \right ) \, \text {Gam} ( \eta | \nu / 2 , \nu / 2 ) \, \text {d} \eta . \\ & \text {We can then generalize this to a multivariate Gaussian $\mathcal{N}(x| \mu, \Lambda)$ to obtain the cor-}
$$

We can then generalize this to a multivariate Gaussian N ( x | µ , Λ ) to obtain the corresponding multivariate Student’s t-distribution in the form

$$
\text {Responding variant} \, S t ( \lambda ) & = \int _ { 0 } ^ { \infty } \mathcal { N } ( x | \mu , ( \eta \Lambda ) ^ { - 1 } ) G a ( \eta | \nu / 2 , \nu / 2 ) \, d \eta . \\ \text {Using the same technique as for the univariate case, we can evaluate this integral to}
$$

Using the same technique as for the univariate case, we can evaluate this integral to give
