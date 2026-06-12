[Page 629]

Figure 13.5 We can represent sequential data using a Markov chain of latent variables, with each observation conditioned on the state of the corresponding latent variable. This important graphical structure forms the foundation both for the hidden Markov model and for linear dynamical systems.

![The image depicts a diagram illustrating a mathematical relationship between two variables, specifically a function and a set of points. The diagram is structured with a circle as the central point, and the points are connected by lines. The diagram is labeled as follows: - **Circle**: A circle is depicted as a red circle with a diameter of 1. - **Points**: There are five points labeled as points 1, 2, 3, 4, and 5. - **Line**: A line connects points 1 and 2. - **Line Segment**: A line segment connects points 1 and 2. - **Line Segment**: A line segment connects points 1 and 2. - **Line Segment**: A line segment connects points 1 and 2. - **Line Segment**: A line segment connects points 1 and 2. - **Line Segment**: A line segment connects points](../images/imageFile305.png)

-

n

n

1

+1

n

1

2

z

z

z

z

z

-

n

n

1

+1

n

1

2

x

x

x

x

x

Each observation is now inﬂuenced by two previous observations. We can similarly consider extensions to an M th order Markov chain in which the conditional distribution for a particular variable depends on the previous M variables. However, we have paid a price for this increased ﬂexibility because the number of parameters in the model is now much larger. Suppose the observations are discrete variables having K states. Then the conditional distribution p ( x n | x n − 1 ) in a ﬁrst-order Markov chain will be speciﬁed by a set of K − 1 parameters for each of the K states of x n − 1 giving a total of K ( K − 1) parameters. Now suppose we extend the model to an M th order Markov chain, so that the joint distribution is built up from conditionals p ( x n | x n − M ,..., x n − 1 ) . If the variables are discrete, and if the conditional distributions are represented by general conditional probability tables, then the number of parameters in such a model will have K M − 1 ( K − 1) parameters. Because this grows exponentially with M , it will often render this approach impractical for larger values of M .

For continuous variables, we can use linear-Gaussian conditional distributions in which each node has a Gaussian distribution whose mean is a linear function of its parents. This is known as an autoregressive or AR model (Box et al. , 1994; Thiesson et al. , 2004). An alternative approach is to use a parametric model for p ( x n | x n − M ,..., x n − 1 ) such as a neural network. This technique is sometimes called a tapped delay line because it corresponds to storing (delaying) the previous M values of the observed variable in order to predict the next value. The number of parameters can then be much smaller than in a completely general model (for example it may grow linearly with M ), although this is achieved at the expense of a restricted family of conditional distributions.

Suppose we wish to build a model for sequences that is not limited by the Markov assumption to any order and yet that can be speciﬁed using a limited number of free parameters. We can achieve this by introducing additional latent variables to permit a rich class of models to be constructed out of simple components, as we did with mixture distributions in Chapter 9 and with continuous latent variable models in Chapter 12. For each observation x n , we introduce a corresponding latent variable z n (which may be of different type or dimensionality to the observed variable). We now assume that it is the latent variables that form a Markov chain, giving rise to the graphical structure known as a state space model , which is shown in Figure 13.5. It satisﬁes the key conditional independence property that z n − 1 and z n +1 are independent given z n , so that z z z

$$
z _ { n + 1 } \perp _ { n - 1 } z _ { n - 1 } \, | \, z _ { n } .
$$
