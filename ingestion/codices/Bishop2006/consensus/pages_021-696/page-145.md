[Page 145]

Figure 2.26 Illustration of $K$-nearest-neighbour density estimation using the same data set as in Figures 2.25 and 2.24. We see that the parameter $K$ governs the degree of smoothing, so that a small value of $K$ leads to a very noisy density model (top panel), whereas a large value (bottom panel) smoothes out the bimodal nature of the true distribution (shown by the green curve) from which the data set was generated.

![The image is a line graph that shows the relationship between two variables, specifically the concentration of a chemical substance and the temperature. The x-axis represents the temperature in Kelvin, while the y-axis represents the concentration of the chemical substance. The graph is labeled as K and K_s and is labeled as K_s and K_s_s respectively. The graph shows a general trend of increasing temperature as the concentration of the chemical substance increases. The concentration of the chemical substance increases from left to right on the graph. The line of the graph is relatively steep, indicating that the concentration of the chemical substance increases at a constant rate. The graph also shows a peak in the concentration of the chemical substance at the point labeled K_s (which is the highest concentration of the chemical substance). This peak is at a temperature of 5 K, which is the highest temperature in the graph. The graph also shows](../images/imageFile69.png)

density $p(\mathbf{x})$, and we allow the radius of the sphere to grow until it contains precisely $K$ data points. The estimate of the density $p(\mathbf{x})$ is then given by (2.246) with $V$ set to the volume of the resulting sphere. This technique is known as $K$ nearest neighbours and is illustrated in Figure 2.26, for various choices of the parameter $K$, using the same data set as used in Figure 2.24 and Figure 2.25. We see that the value of $K$ now governs the degree of smoothing and that again there is an optimum choice for $K$ that is neither too large nor too small. Note that the model produced by $K$ nearest neighbours is not a true density model because the integral over all space diverges.

We close this chapter by showing how the $K$-nearest-neighbour technique for density estimation can be extended to the problem of classification. To do this, we apply the $K$-nearest-neighbour density estimation technique to each class separately and then make use of Bayes' theorem. Let us suppose that we have a data set comprising $N_k$ points in class $\mathcal{C}_k$ with $N$ points in total, so that $\sum_k N_k = N$. If we wish to classify a new point $\mathbf{x}$, we draw a sphere centred on $\mathbf{x}$ containing precisely $K$ points irrespective of their class. Suppose this sphere has volume $V$ and contains $K_k$ points from class $\mathcal{C}_k$. Then (2.246) provides an estimate of the density associated with each class
$$
p(\mathbf{x}|\mathcal{C}_k) = \frac{K_k}{N_k V}. \tag{2.253}
$$

Similarly, the unconditional density is given by
$$
p(\mathbf{x}) = \frac{K}{N V} \tag{2.254}
$$

while the class priors are given by
$$
p(\mathcal{C}_k) = \frac{N_k}{N}. \tag{2.255}
$$

We can now combine (2.253), (2.254), and (2.255) using Bayes' theorem to obtain the posterior probability of class membership
$$
p(\mathcal{C}_k|\mathbf{x}) = \frac{p(\mathbf{x}|\mathcal{C}_k)p(\mathcal{C}_k)}{p(\mathbf{x})} = \frac{K_k}{K}. \tag{2.256}
$$

If we wish to minimize the probability of misclassification, this is done by assigning the test point $\mathbf{x}$ to the class having the largest posterior probability, corresponding to the largest value of $K_k/K$. Thus to classify a new point, we identify the $K$ nearest points from the training data set and then assign the new point to the class having the largest number of representatives amongst this set. Ties can be broken at random. The particular case of $K = 1$ is called the nearest-neighbour rule, because a test point is simply assigned to the same class as the nearest point from the training set. These concepts are illustrated in Figure 2.27.
