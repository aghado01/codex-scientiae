[Page 98]

78 2. PROBABILITY DISTRIBUTIONS

![image 22](../../../../../images/imageFile22.png)

![image 23](../../../../../images/imageFile23.png)

![image 24](../../../../../images/imageFile24.png)

![image 25](../../../../../images/imageFile25.png)

![image 26](../../../../../images/imageFile26.png)

![image 27](../../../../../images/imageFile27.png)

![image 28](../../../../../images/imageFile28.png)

![image 29](../../../../../images/imageFile29.png)

![image 30](../../../../../images/imageFile30.png)

![image 31](../../../../../images/imageFile31.png)

![image 32](../../../../../images/imageFile32.png)

![image 33](../../../../../images/imageFile33.png)

![image 34](../../../../../images/imageFile34.png)

![image 35](../../../../../images/imageFile35.png)

![image 36](../../../../../images/imageFile36.png)

![image 37](../../../../../images/imageFile37.png)

![image 38](../../../../../images/imageFile38.png)

![image 39](../../../../../images/imageFile39.png)

![image 40](../../../../../images/imageFile40.png)

![image 41](../../../../../images/imageFile41.png)

![image 42](../../../../../images/imageFile42.png)

Figure 2.5 Plots of the Dirichlet distribution over three variables, where the two horizontal axes are coordinates in the plane of the simplex and the vertical axis corresponds to the value of the density. Here {αk} = 0.1 on the left plot, {αk} = 1 in the centre plot, and {αk} = 10 in the right plot.

modelled using the binomial distribution (2.9) or as 1-of-2 variables and modelled using the multinomial distribution (2.34) with K = 2.

2.3. The Gaussian Distribution

![image 43](../../../../../images/imageFile43.png)

![image 44](../../../../../images/imageFile44.png)

The Gaussian, also known as the normal distribution, is a widely used model for the distribution of continuous variables. In the case of a single variable x, the Gaussian distribution can be written in the form

exp�−

(x − µ)2� (2.42)

1 2σ2

1 (2πσ2)1/2

N(x|µ,σ2) =

![image 45](../../../../../images/imageFile45.png)

![image 46](../../../../../images/imageFile46.png)

where µ is the mean and σ2 is the variance. For a D-dimensional vector x, the multivariate Gaussian distribution takes the form

exp�−

(x − µ)TΣ−1(x − µ)� (2.43)

1 2

1 (2π)D/2

1 |Σ|1/2

N(x|µ,Σ) =

![image 47](../../../../../images/imageFile47.png)

![image 48](../../../../../images/imageFile48.png)

![image 49](../../../../../images/imageFile49.png)

where µ is a D-dimensional mean vector, Σ is a D × D covariance matrix, and |Σ| denotes the determinant of Σ.

The Gaussian distribution arises in many different contexts and can be motivated Section 1.6 from a variety of different perspectives. For example, we have already seen that for

a single real variable, the distribution that maximizes the entropy is the Gaussian. Exercise 2.14 This property applies also to the multivariate Gaussian.

Another situation in which the Gaussian distribution arises is when we consider the sum of multiple random variables. The central limit theorem (due to Laplace) tells us that, subject to certain mild conditions, the sum of a set of random variables, which is of course itself a random variable, has a distribution that becomes increasingly Gaussian as the number of terms in the sum increases (Walker, 1969). We can
