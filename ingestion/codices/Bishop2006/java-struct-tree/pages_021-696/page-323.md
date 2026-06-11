[Page 323]

Figure 6.3 Illustration of the Nadaraya-Watson kernel regression model using isotropic Gaussian kernels, for the sinusoidal data set. The original sine function is shown by the green curve, the data points are shown in blue, and each is the centre of an isotropic Gaussian kernel. The resulting regression function, given by the conditional mean, is shown by the red line, along with the twostandard-deviation region for the conditional distribution p(t|x) shown by the red shading. The blue ellipse around each data point shows one standard deviation contour for the corresponding kernel. These appear noncircular due to the different scales on the horizontal and vertical axes.

1.5

1

0.5

0

−0.5

−1

−1.5

0 0.2 0.4 0.6 0.8 1

In fact, this model deﬁnes not only a conditional expectation but also a full conditional distribution given by

�

f(x − xn,t − tn)

p(t,x) � p(t,x)dt

n

=

p(t|x) =

(6.48)

� f(x − xm,t − tm)dt

�

m

from which other expectations can be evaluated.

As an illustration we consider the case of a single input variable x in which f(x,t) is given by a zero-mean isotropic Gaussian over the variable z = (x,t) with variance σ2. The corresponding conditional distribution (6.48) is given by a Gaus-

Exercise 6.18 sian mixture, and is shown, together with the conditional mean, for the sinusoidal

synthetic data set in Figure 6.3.

An obvious extension of this model is to allow for more ﬂexible forms of Gaussian components, for instance having different variance parameters for the input and target variables. More generally, we could model the joint distribution p(t,x) using a Gaussian mixture model, trained using techniques discussed in Chapter 9 (Ghahramani and Jordan, 1994), and then ﬁnd the corresponding conditional distribution p(t|x). In this latter case we no longer have a representation in terms of kernel functions evaluated at the training set data points. However, the number of components in the mixture model can be smaller than the number of training set points, resulting in a model that is faster to evaluate for test data points. We have thereby accepted an increased computational cost during the training phase in order to have a model that is faster at making predictions.

6.4. Gaussian Processes

In Section 6.1, we introduced kernels by applying the concept of duality to a nonprobabilistic model for regression. Here we extend the role of kernels to probabilis-
