[Page 690]

- 0

0.5

1

- 1.5


- 0

0.5

1

- 1.5


- 0

- 0.5
- 1


- 1.5


| |
|---|


| |
|---|


| |
|---|


−0.5

−0.5

−0.5

−1

−1

−1

−1.5

−1.5

−1.5

−1 −0.5 0 0.5 1

−1

−0.5 0 0.5 1

−1

−0.5 0 0.5 1

1

- 0.8
- 1


- 0.8
- 1


| | | | | | | | | | | | | | | | | | | | |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|


| | | | | | | | | | | | | | | | | | | | |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|


| | | | | | | | | | | | | | | | | | | | |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|


0.8

0.6

0.6

0.6

- 0.4


0.4

0.4

0.2

0.2

0.2

0

0

0

−1 −0.5 0 0.5 1

−1 −0.5 0 0.5 1

−1 −0.5 0 0.5 1

- Figure 14.8 Example of a synthetic data set, shown by the green points, having one input variable x and one


target variable t, together with a mixture of two linear regression models whose mean functions y(x, wk), where k ∈ {1, 2}, are shown by the blue and red lines. The upper three plots show the initial conﬁguration (left), the result of running 30 iterations of EM (centre), and the result after 50 iterations of EM (right). Here β was initialized to the reciprocal of the true variance of the set of target values. The lower three plots show the corresponding responsibilities plotted as a vertical line for each data point in which the length of the blue segment gives the posterior probability of the blue line for that data point (and similarly for the red segment).

###### 14.5.2 Mixtures of logistic models

Because the logistic regression model deﬁnes a conditional distribution for the target variable, given the input vector, it is straightforward to use it as the component distribution in a mixture model, thereby giving rise to a richer family of conditional distributions compared to a single logistic regression model. This example involves a straightforward combination of ideas encountered in earlier sections of the book and will help consolidate these for the reader.

The conditional distribution of the target variable, for a probabilistic mixture of K logistic regression models, is given by

p(t|φ,θ) =

K

πkykt [1 − yk]1−t (14.45)

k=1

where φ is the feature vector, yk = σ wkTφ is the output of component k, and θ denotes the adjustable parameters namely {πk} and {wk}.

Now suppose we are given a data set {φn,tn}. The corresponding likelihood
