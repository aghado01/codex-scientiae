[Page 145]

# Figure 2.26

Illustration of K -nearest-neighbour density estimation using the same data set as in Figures 2.25 and 2.24. We see that the parameter K governs the degree of smoothing, so that a small value of K leads to a very noisy density model (top panel), whereas a large value (bottom panel) smoothes out the bimodal nature of the true distribution (shown by the green curve) from which the data set was generated.

![The image is a line graph that shows the relationship between two variables, specifically the concentration of a chemical substance and the temperature. The x-axis represents the temperature in Kelvin, while the y-axis represents the concentration of the chemical substance. The graph is labeled as K and K_s and is labeled as K_s and K_s_s respectively. The graph shows a general trend of increasing temperature as the concentration of the chemical substance increases. The concentration of the chemical substance increases from left to right on the graph. The line of the graph is relatively steep, indicating that the concentration of the chemical substance increases at a constant rate. The graph also shows a peak in the concentration of the chemical substance at the point labeled K_s (which is the highest concentration of the chemical substance). This peak is at a temperature of 5 K, which is the highest temperature in the graph. The graph also shows](../images/imageFile69.png)

5

K

= 1

0

0

0.5

1

5

K

= 5

0

0

0.5

1

5

K

= 30

0

0

0.5

1

Exercise 2.61

density p ( x ) , and we allow the radius of the sphere to grow until it contains precisely K data points. The estimate of the density p ( x ) is then given by (2.246) with V set to the volume of the resulting sphere. This technique is known as K nearest neighbours and is illustrated in Figure 2.26, for various choices of the parameter K , using the same data set as used in Figure 2.24 and Figure 2.25. We see that the value of K now governs the degree of smoothing and that again there is an optimum choice for K that is neither too large nor too small. Note that the model produced by K nearest neighbours is not a true density model because the integral over all space diverges.

We close this chapter by showing how the K -nearest-neighbour technique for density estimation can be extended to the problem of classiﬁcation. To do this, we apply the K -nearest-neighbour density estimation technique to each class separately and then make use of Bayes’ theorem. Let us suppose that we have a data set comprising N k points in class C k with N points in total, so that k N k = N . If we wish to classify a new point x , we draw a sphere centred on x containing precisely K points irrespective of their class. Suppose this sphere has volume V and contains K k points from class C k . Then (2.246) provides an estimate of the density associated with each class K

$$
p ( x | \mathcal { C } _ { k } ) & = \frac { K _ { k } } { N _ { k } V } . & ( 2 . 2 5 3 ) \\
$$

Similarly, the unconditional density is given by

$$
p ( \mathbf x ) = \frac { K } { N V }
$$

while the class priors are given by If we wish to minimize the probability of misclassification, this is done by assigning the test point x to the class having the largest posterior probability, corresponding to the largest value of K k /K . Thus to classify a new point, we identify the K nearest points from the training data set and then assign the new point to the class having the largest number of representatives amongst this set. Ties can be broken at random. The particular case of K = 1 is called the nearest-neighbour rule, because a test point is simply assigned to the same class as the nearest point from the training set. These concepts are illustrated in Figure 2.27.

$$
p ( \mathcal { C } _ { k } ) = \frac { N _ { k } } { N } .
$$

We can now combine (2.253), (2.254), and (2.255) using Bayes’ theorem to obtain the posterior probability of class membership

$$
p ( \mathcal { C } _ { k } | \mathbf x ) = \frac { p ( \mathbf x | \mathcal { C } _ { k } ) p ( \mathcal { C } _ { k } ) } { p ( \mathbf x ) } = \frac { K _ { k } } { K } .
$$
