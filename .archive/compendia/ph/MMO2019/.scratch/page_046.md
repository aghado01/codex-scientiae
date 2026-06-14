[Page 46]

1.0

0.5

0.0

0.5

=1.0

1.0

0.0

(a)

0.5

1.0

![The image is a scatter plot with a linear scale on the x-axis and a linear scale on the y-axis. The plot consists of four data points, each represented by a circle. The data points are scattered around the x-axis, with the x-axis ranging from 0 to 1.0. The data points are labeled as follows: - x: 0.8 - y: 0.5 - x: 0.6 - y: 0.4 The data points are scattered around the x-axis, with the x-axis ranging from 0.0 to 1.0. The data points are labeled as follows: - x: 0.8 - y: 0.5 - x: 0.6 - y: 0.4 The data points are scattered around the y-axis, with the y-axis ranging from 0.](<MMO2019/imageFile13.png>)

1.0

0.8

0.6

0.4

0.2


0.2

0.4

0.6

0.8

1.0

Birth

(b)

Figure 12: (a) An example of the underlying datasets generated for Ex. 5. Each dataset consists of 25 points sampled uniformly on the unit circle which are then perturbed by i.i.d. Gaussian noise with variance (1 / 6) 2 I 2 . (b) The persistence diagram associated to the ˇ Cech ﬁltration of the dataset

While the underlying dataspace is the unit circle in both Ex. 3 and Ex. 5, the precise presentation of the underlying data eﬀects the pdf of the associated random persistence diagram. Precisely, two primary parameters for the underlying dataset are involved: (i) the scale of Gaussian noise and (ii) the sample size of the underlying dataset. The persistence diagram (for degree of homology k = 1) associated with the ‘’true’ unit circle is not random and has a single feature at ( b,d ) = (0 , 1). The random, discrete nature of these examples creates persistence diagrams which deviate from this ‘truth.’

As described for Ex. 3, with very little noise all the sample points lie close to the unit circle, and so the ˇ Cech complex becomes contractible at a radius r ≈ 1. Consequently, the death value of the main topological feature is near the ‘true’ value (e.g., the mode in Fig. 9 is d = 0 . 98 ≈ 1). However, since we are working with discrete points, this feature does not appear immediately: the gaps in the circle need to be ﬁlled in (this is even true without noise). In Ex. 3, the sample size is only 10, so the birth value is typically much larger than the ‘true’ value (e.g., the mode in Fig. 9 is b = 0 . 77 >> 0).

In comparison to Ex. 3, Ex. 5 has relatively more noise; this results in a random persistence diagram with smaller death values for the main feature (e.g., the mode in Fig. 13 is d = 0 . 8 < 0 . 98). It is evident from Fig. 13 that while the noise is additive on the underlying data, its precise eﬀect on the random persistence diagram is nonlinear. Moreover, Ex. 5 has a larger sample size (25 as opposed to 10), resulting in more consistent and smaller birth times for the main feature (e.g., the mode in Fig. 13 is b = 0 . 4 < 0 . 77). In addition, larger noise and sample size both result in more features near the diagonal in Ex. 5 as compared to Ex. 3.

Example 6 While Ex. 5 demonstrates the eﬀect of noise on a persistence diagram pdf, this example will look into the eﬀect of geometry. Consider random underlying datasets each consisting
