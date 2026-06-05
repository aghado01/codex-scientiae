[Page 473]

Figure 9.14 The EM algorithm involves alternately computing a lower bound on the log likelihood for the current parameter values and then maximizing this bound to obtain the new parameter values. See the text for a full discussion.

the text for a full discussion.

![The image is a graph that shows the relationship between three variables: gold, lp(X), and the number of people. The x-axis represents the number of people, while the y-axis represents the gold price. The graph is labeled as gold (q.o.) and has a legend at the bottom right corner that indicates the values of gold, lp(X), and the number of people. The graph shows the following data points: 1. Gold (q.o.): The x-axis is labeled as q.o. 2. lp(X) (q.p.): The y-axis is labeled as X 3. The graph shows a general trend of increasing values of gold and lp(X) as the number of people increases. The graph also includes a legend at the bottom right corner that indicates the values of gold, lp(X), and the number of people.](../images/imageFile229.png)

|

ln p

p

(

θ

)

X

L

(

q,θ )

)

new

θ

old

θ

Exercise 9.25

complete data) log likelihood function whose value we wish to maximize. We start with some initial parameter value θ old , and in the ﬁrst E step we evaluate the posterior distribution over latent variables, which gives rise to a lower bound L ( θ , θ (old) ) whose value equals the log likelihood at θ (old) , as shown by the blue curve. Note that the bound makes a tangential contact with the log likelihood at θ (old) , so that both curves have the same gradient. This bound is a convex function having a unique maximum (for mixture components from the exponential family). In the M step, the bound is maximized giving the value θ (new) , which gives a larger value of log likelihood than θ (old) . The subsequent E step then constructs a bound that is tangential at θ (new) as shown by the green curve.

For the particular case of an independent, identically distributed data set, X will comprise N data points { x n } while Z will comprise N corresponding latent variables { z n } , where n = 1 ,...,N . From the independence assumption, we have p ( X , Z ) = n p ( x n , z n ) and, by marginalizing over the { z n } we have p ( X ) = n p ( x n ) . Using the sum and product rules, we see that the posterior probability that is evaluated in the E step takes the form

$$
p ( Z | X , \theta ) = \frac { p ( X , Z | \theta ) } { \sum _ { z } p ( X , Z | \theta ) } = \frac { \prod _ { n = 1 } ^ { N } p ( x _ { n } , z _ { n } | \theta ) } { \sum _ { z } \prod _ { n = 1 } ^ { N } p ( x _ { n } , z _ { n } | \theta ) } = \prod _ { n = 1 } ^ { N } p ( z _ { n } | x _ { n } , \theta ) \pmod { ( 9 . 7 5 ) } \\ \intertext { a n d s o the posterior distribution also factorizes with respect to n . \ \In the case of }
$$

and so the posterior distribution also factorizes with respect to n . In the case of the Gaussian mixture model this simply says that the responsibility that each of the mixture components takes for a particular data point x n depends only on the value of x n and on the parameters θ of the mixture components, not on the values of the other data points.
