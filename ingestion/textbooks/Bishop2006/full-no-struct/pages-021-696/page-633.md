[Page 633]

![The image depicts a scatter plot with two sets of points plotted on it. The x-axis is labeled k and the y-axis is labeled 1. The points are represented by red and blue dots, respectively. The points are connected by a line that appears to be a straight line. The points are scattered around the x-axis, with some points closer to the x-axis and others farther away. The points are scattered in a random pattern, with no clear pattern or pattern in the data. The scatter plot is titled k = 3 and has a legend at the bottom right corner. The legend indicates that the points are located at different points on the x-axis, with the points closer to the x-axis being closer to the x-axis. The legend also includes a scale of range 0 to 0.5, which indicates the range of values for which the points are plotted. The points are scattered in a random pattern](../images/imageFile308.png)

1

1

0.5

0.5

k

= 1

k

= 3

k

= 2

0

0

0

0.5

1

0

0.5

1

Figure 13.8 Illustration of sampling from a hidden Markov model having a 3-state latent variable z and a Gaussian emission model p ( x | z ) where x is 2-dimensional. (a) Contours of constant probability density for the emission distributions corresponding to each of the three states of the latent variable. (b) A sample of 50 points drawn from the hidden Markov model, colour coded according to the component that generated them and with lines connecting the successive observations. Here the transition matrix was ﬁxed so that in any state there is a 5% probability of making a transition to each of the other states, and consequently a 90% probability of remaining in the same state.

Gaussians, we ﬁrst chose one of the components at random with probability given by the mixing coefﬁcients π k and then generate a sample vector x from the corresponding Gaussian component. This process is repeated N times to generate a data set of N independent samples. In the case of the hidden Markov model, this procedure is modiﬁed as follows. We ﬁrst choose the initial latent variable z 1 with probabilities governed by the parameters π k and then sample the corresponding observation x 1 . Now we choose the state of the variable z 2 according to the transition probabilities p ( z 2 | z 1 ) using the already instantiated value of z 1 . Thus suppose that the sample for z 1 corresponds to state j . Then we choose the state k of z 2 with probabilities A jk for k = 1 ,...,K . Once we know z 2 we can draw a sample for x 2 and also sample the next latent variable z 3 and so on. This is an example of ancestral sampling for a directed graphical model. If, for instance, we have a model in which the diagonal transition elements A kk are much larger than the off-diagonal elements, then a typical data sequence will have long runs of points generated from a single component, with infrequent transitions from one component to another. The generation of samples from a hidden Markov model is illustrated in Figure 13.8.

There are many variants of the standard HMM model, obtained for instance by imposing constraints on the form of the transition matrix A (Rabiner, 1989). Here we mention one of particular practical importance called the left-to-right HMM, which is obtained by setting the elements A jk of A to zero if k < j , as illustrated in the
