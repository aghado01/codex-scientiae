[Page 104]

Figure 2.8 Contours of constant probability density for a Gaussian distribution in two dimensions in which the covariance matrix is (a) of general form, (b) diagonal, in which the elliptical contours are aligned with the coordinate axes, and (c) proportional to the identity matrix, in which the contours are concentric circles.

![The image depicts a geometric figure with a central circle and several smaller circles. The central circle is a semicircle, and the smaller circles are all radii of the semicircle. The semicircle is divided into two equal halves, and each half is divided into two equal halves. The smaller circles are all radii of the semicircle, and they are all located at the same distance from the center of the semicircle. Here is a detailed description of the image: 1. **Central Circle**: - The central circle is a semicircle. - The semicircle is divided into two equal halves, and each half is divided into two equal halves. 2. **Smaller Circles**: - There are three smaller circles. - The first smaller circle is located at the top left of the semicircle. - The second smaller circle is located at the top right of the semicircle. - The third smaller circle is](../images/imageFile49.png)

x

x

x

2

2

2

x

x

x

1

1

1

(a)

(b)

(c)

Section 8.3

Section 13.3

A further limitation of the Gaussian distribution is that it is intrinsically unimodal (i.e., has a single maximum) and so is unable to provide a good approximation to multimodal distributions. Thus the Gaussian distribution can be both too ﬂexible, in the sense of having too many parameters, while also being too limited in the range of distributions that it can adequately represent. We will see later that the introduction of latent variables, also called hidden variables or unobserved variables, allows both of these problems to be addressed. In particular, a rich family of multimodal distributions is obtained by introducing discrete latent variables leading to mixtures of Gaussians, as discussed in Section 2.3.9. Similarly, the introduction of continuous latent variables, as described in Chapter 12, leads to models in which the number of free parameters can be controlled independently of the dimensionality D of the data space while still allowing the model to capture the dominant correlations in the data set. Indeed, these two approaches can be combined and further extended to derive a very rich set of hierarchical models that can be adapted to a broad range of practical applications. For instance, the Gaussian version of the Markov random ﬁeld , which is widely used as a probabilistic model of images, is a Gaussian distribution over the joint space of pixel intensities but rendered tractable through the imposition of considerable structure reﬂecting the spatial organization of the pixels. Similarly, the linear dynamical system , used to model time series data for applications such as tracking, is also a joint Gaussian distribution over a potentially large number of observed and latent variables and again is tractable due to the structure imposed on the distribution. A powerful framework for expressing the form and properties of
