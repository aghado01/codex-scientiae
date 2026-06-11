[Page 559]

Figure 11.9

A simple illustration using Metropolis algorithm to sample from a Gaussian distribution whose one standard-deviation contour is shown by the ellipse. The proposal distribution is an isotropic Gaussian distribution whose standard deviation is 0.2. Steps that are accepted are shown as green lines, and rejected steps are shown in red. A total of 150 candidate samples are generated, of which 43 are rejected.

![The image is a scatter plot with a white background. The plot is titled Spatial Analysis of the 2016 Presidential Election. The x-axis represents the years, ranging from 2000 to 2016, while the y-axis represents the percentage of votes each candidate received. The scatter plot is visually represented with a grid of points, each point representing a candidate's percentage of votes. Here is a detailed description of the plot: - **X-axis (Years):** The x-axis is labeled Years and ranges from 2000 to 2016. - **Y-axis (Percentage of Votes):** The y-axis is labeled Percentage of Votes and ranges from 0 to 1. **Data Points:** - **Candidate A:** - **Percentage of Votes:** 1.5 - **X-Axis](../images/imageFile261.png)

3

2.5

2

1.5

1

0.5

0

0

0.5

1

1.5

2

2.5

3

walk. Consider a state space z consisting of the integers, with probabilities

$$
p ( z ^ { ( \tau + 1 ) } = z ^ { ( \tau ) } ) \ = \ 0 . 5
$$

$$
p ( z ^ { ( \tau + 1 ) } = z ^ { ( \tau ) } + 1 ) \ = \ 0 . 2 5
$$

$$
p ( z ^ { ( \tau + 1 ) } = z ^ { ( \tau ) } - 1 ) \ = \ 0 . 2 5 \quad & \quad ( 1 1 . 3 6 )
$$

where z ( τ ) denotes the state at step τ . If the initial state is z (1) = 0 , then by symmetry the expected state at time τ will also be zero E [ z ( τ ) ] = 0 , and similarly it is easily seen that E [( z ( τ ) ) 2 ] = τ/ 2 . Thus after τ steps, the random walk has only travelled a distance that on average is proportional to the square root of τ . This square root dependence is typical of random walk behaviour and shows that random walks are very inefﬁcient in exploring the state space. As we shall see, a central goal in designing Markov chain Monte Carlo methods is to avoid random walk behaviour.

# 11.2.1 Markov chains

Before discussing Markov chain Monte Carlo methods in more detail, it is useful to study some general properties of Markov chains in more detail. In particular, we ask under what circumstances will a Markov chain converge to the desired distribution. A ﬁrst-order Markov chain is deﬁned to be a series of random variables z (1) ,..., z ( M ) such that the following conditional independence property holds for m ∈ { 1 ,...,M − 1 }

$$
p ( z ^ { ( m + 1 ) } | z ^ { ( 1 ) } , \dots , z ^ { ( m ) } ) = p ( z ^ { ( m + 1 ) } | z ^ { ( m ) } ) .
$$

This of course can be represented as a directed graph in the form of a chain, an example of which is shown in Figure 8.38. We can then specify the Markov chain by giving the probability distribution for the initial variable p ( z (0) ) together with the
