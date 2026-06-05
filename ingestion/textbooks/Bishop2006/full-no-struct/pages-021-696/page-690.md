[Page 690]

![The image is a bar graph that shows the percentage of people who have been diagnosed with a particular disease over a period of time. The x-axis represents the years, while the y-axis shows the percentage of people who have been diagnosed with the disease. The bars are colored green, blue, red, and black, and they are arranged in a horizontal line. Here is a breakdown of the data: 1. **Green Bar**: - The green bar represents the percentage of people who have been diagnosed with the disease. - The percentage is 0.6. 2. **Blue Bar**: - The blue bar represents the percentage of people who have been diagnosed with the disease. - The percentage is 0.4. 3. **Red Bar**: - The red bar represents the percentage of people who have been diagnosed with the disease. - The percentage is 0.2. 4. **Black Bar**: - The black](../images/imageFile332.png)

1.5

1.5

1.5

1

1

1

0.5

0.5

0.5

0

0

0

−0.5

−0.5

−0.5

−1

−1

−1

−1.5

−1.5

−1.5

−1

−0.5

0

0.5

1

−1

−0.5

0

0.5

1

−1

−0.5

0

0.5

1

1

1

1

0.8

0.8

0.8

0.6

0.6

0.6

0.4

0.4

0.4

0.2

0.2

0.2

0

0

0

−1

−0.5

0

0.5

1

−1

−0.5

0

0.5

1

−1

−0.5

0

0.5

1

Figure 14.8 Example of a synthetic data set, shown by the green points, having one input variable x and one target variable t , together with a mixture of two linear regression models whose mean functions y ( x, w k ) , where k ∈ { 1 , 2 } , are shown by the blue and red lines. The upper three plots show the initial conﬁguration (left), the result of running 30 iterations of EM (centre), and the result after 50 iterations of EM (right). Here β was initialized to the reciprocal of the true variance of the set of target values. The lower three plots show the corresponding responsibilities plotted as a vertical line for each data point in which the length of the blue segment gives the posterior probability of the blue line for that data point (and similarly for the red segment).

# 14.5.2 Mixtures of logistic models

Because the logistic regression model deﬁnes a conditional distribution for the target variable, given the input vector, it is straightforward to use it as the component distribution in a mixture model, thereby giving rise to a richer family of conditional distributions compared to a single logistic regression model. This example involves a straightforward combination of ideas encountered in earlier sections of the book and will help consolidate these for the reader.

The conditional distribution of the target variable, for a probabilistic mixture of K logistic regression models, is given by

$$
p ( t | \phi , \theta ) = \sum _ { k = 1 } ^ { K } \pi _ { k } y _ { k } ^ { t } \left [ 1 - y _ { k } \right ] ^ { 1 - t } & & ( 1 4 . 4 5 ) \\
$$

where φ is the feature vector, y k = σ w T k φ is the output of component k , and θ denotes the adjustable parameters namely { π k } and { w k } . Now suppose we are given a data set { φ n ,t n } . The corresponding likelihood

Now suppose we are given a data set { φ n , t n } . The corresponding likelihood
