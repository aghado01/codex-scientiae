[Page 323]

Figure 6.3 Illustration of the Nadaraya-Watson kernel regression model using isotropic Gaussian kernels, for the sinusoidal data set. The original sine function is shown by the green curve, the data points are shown in blue, and each is the centre of an isotropic Gaussian kernel. The resulting regression function, given by the conditional mean, is shown by the red line, along with the two-standard-deviation region for the conditional distribution $p(t|\mathbf{x})$ shown by the red shading. The blue ellipse around each data point shows one standard deviation contour for the corresponding kernel. These appear noncircular due to the different scales on the horizontal and vertical axes.

![The image is a scatter plot with a white background. The plot is titled Spatial Analysis of the 2016 Presidential Election. The x-axis is labeled Year, and the y-axis is labeled Sales. The plot is divided into four quadrants, each representing a different year. The quadrants are labeled from top to bottom as follows: 1. **1996** 2. **1998** 3. **1999** 4. **2000** Each quadrant has a different number of sales, with the highest number of sales in the 1996 and 1998 quadrants. The lowest number of sales in the 2000 quadrant is represented by a blue dot. The scatter plot is visually represented by a series of blue and green dots. The blue dots are scattered across the x-axis, while the green dots are](../images/imageFile133.png)

In fact, this model deﬁnes not only a conditional expectation but also a full conditional distribution given by

$$
p(t|\mathbf{x}) = \frac{p(t,\mathbf{x})}{\int p(t,\mathbf{x}) dt} = \frac{\sum_n f(\mathbf{x} - \mathbf{x}_n, t - t_n)}{\sum_m \int f(\mathbf{x} - \mathbf{x}_m, t - t_m) dt} \tag{6.48}
$$

from which other expectations can be evaluated.

As an illustration we consider the case of a single input variable $x$ in which $f(x,t)$ is given by a zero-mean isotropic Gaussian over the variable $\mathbf{z} = (x,t)$ with variance $\sigma^2$. The corresponding conditional distribution (6.48) is given by a Gaussian mixture, and is shown, together with the conditional mean, for the sinusoidal synthetic data set in Figure 6.3.

An obvious extension of this model is to allow for more ﬂexible forms of Gaussian components, for instance having different variance parameters for the input and target variables. More generally, we could model the joint distribution $p(t,\mathbf{x})$ using a Gaussian mixture model, trained using techniques discussed in Chapter 9 (Ghahramani and Jordan, 1994), and then ﬁnd the corresponding conditional distribution $p(t|\mathbf{x})$. In this latter case we no longer have a representation in terms of kernel functions evaluated at the training set data points. However, the number of components in the mixture model can be smaller than the number of training set points, resulting in a model that is faster to evaluate for test data points. We have thereby accepted an increased computational cost during the training phase in order to have a model that is faster at making predictions.

###### 6.4. Gaussian Processes

In Section 6.1, we introduced kernels by applying the concept of duality to a nonprobabilistic model for regression. Here we extend the role of kernels to probabilis-
