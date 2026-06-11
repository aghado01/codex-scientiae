[Page 549]

Figure 11.4

In the rejection sampling method, samples are drawn from a simple distribution q ( z ) and rejected if they fall in the grey area between the unnormalized distribution e p ( z ) and the scaled distribution kq ( z ) . The resulting samples are distributed according to p ( z ) , which is the normalized version of e p ( z ) .

![The image depicts a graph that shows the relationship between two variables, specifically the concentration of a chemical substance and its activity. The graph is a line graph with a horizontal axis labeled kq and a vertical axis labeled k. The x-axis is labeled t, and the y-axis is labeled k. The graph shows a downward trend in the concentration of the chemical substance as the x-axis increases. The line of the graph starts at a point where the concentration of the substance is at its highest point, which is labeled as kq(0) at the point where the concentration is at its highest. The line then decreases in a downward trend, moving from the highest point to the lowest point. The graph also includes a vertical axis labeled t, which represents the time in seconds. The x-axis is labeled t, and the y-axis is labeled kq(z). The graph shows a downward trend in the concentration](../images/imageFile256.png)

kq (

(

z

)

kq (

(

z

)

0

p

˜

(

z

)

u

0

z

z

0

Exercise 11.6

We next introduce a constant k whose value is chosen such that kq ( z ) p ( z ) for all values of z . The function kq ( z ) is called the comparison function and is illustrated for a univariate distribution in Figure 11.4. Each step of the rejection sampler involves generating two random numbers. First, we generate a number z 0 from the distribution q ( z ) . Next, we generate a number u 0 from the uniform distribution over [0 ,kq ( z 0 )] . This pair of random numbers has uniform distribution under the curve of the function kq ( z ) . Finally, if u 0 > p ( z 0 ) then the sample is rejected, otherwise u 0 is retained. Thus the pair is rejected if it lies in the grey shaded region in Figure 11.4. The remaining pairs then have uniform distribution under the curve of p ( z ) , and hence the corresponding z values are distributed according to p ( z ) , as desired. The original values of z are generated from the distribution q ( z ) , and these samples are then accepted with probability p ( z ) /kq ( z ) , and so the probability that a

The original values of z are generated from the distribution q ( z ) , and these samples are then accepted with probability ˜ p ( z ) /kq ( z ) , and so the probability that a sample will be accepted is given by

$$
\text {will be accepted is given by} \\ p ( \text {accept} ) \ = \ \int \{ \widetilde { p } ( z ) / k q ( z ) \} q ( z ) \, d z \\ = \ \frac { 1 } { k } \int \widetilde { p } ( z ) \, d z . \\ \intertext { f r a c t o n $ p $ o n t i n g a t h a r $ d z $ } \text {under the unnormalized distribution } \widetilde { p } ( z ) \, \text { to the area under the curve } k q ( z ) .
$$

Thus the fraction of points that are rejected by this method depends on the ratio of the area under the unnormalized distribution p ( z ) to the area under the curve kq ( z ) . We therefore see that the constant k should be as small as possible subject to the limitation that kq ( z ) must be nowhere less than p ( z ) . As an illustration of the use of rejection sampling, consider the task of sampling

˜ As an illustration of the use of rejection sampling, consider the task of sampling from the gamma distribution

$$
G a ( z | a , b ) = \frac { b ^ { a } z ^ { a - 1 } \exp ( - b z ) } { \Gamma ( a ) } \quad ( 1 1 . 1 5 )
$$

which, for a > 1 , has a bell-shaped form, as shown in Figure 11.5. A suitable proposal distribution is therefore the Cauchy (11.8) because this too is bell-shaped and because we can use the transformation method, discussed earlier, to sample from it. We need to generalize the Cauchy slightly to ensure that it nowhere has a smaller value than the gamma distribution. This can be achieved by transforming a uniform random variable y using z = b tan y + c , which gives random numbers distributed according to.
