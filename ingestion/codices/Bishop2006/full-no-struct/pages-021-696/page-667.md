[Page 667]

![The image depicts a series of interconnected nodes, each connected to the others. These nodes are labeled with letters and numbers, and they are arranged in a linear fashion. The nodes are connected by lines, which are used to represent the relationships between the nodes. Here is a detailed description of the image: ### Description of the Image: 1. **Nodes and Connections**: - There are multiple nodes. - Each node has a label and a number. - The labels and numbers are connected to each other. 2. **Relationships and Connections**: - The nodes are connected by lines. - The lines are used to represent the relationships between the nodes. 3. **Labels and Numbers**: - The labels and numbers are used to identify the nodes. - The labels are in a different color, which helps in distinguishing between different nodes. 4. **Relationships and Connections**: - The nodes are connected by lines. - The](../images/imageFile323.png)

|

p

(

z

)

n

n

X

|

p

(

z

)

n

n

+1 |

X

|

p

(

z

)

n

n

+1 |

+1 )

x

|

p

(

z

)

n

n

+1 |

+1 )

z

X

Figure 13.23 Schematic illustration of the operation of the particle ﬁlter for a one-dimensional latent space. At time step n , the posterior p ( z n | x n ) is represented as a mixture distribution, shown schematically as circles whose sizes are proportional to the weights w ( l ) n . A set of L samples is then drawn from this distribution and the new weights w ( l ) n +1 evaluated using p ( x n +1 | z ( l ) n +1 ) .

$$
\text {for } n = 3 , \dots , N .
$$

$$
p ( x _ { n } | x _ { 1 } , \dots , x _ { n - 1 } ) = p ( x _ { n } | x _ { n - 1 } , x _ { n - 2 } )
$$

13.2 ( ) Consider the joint probability distribution (13.2) corresponding to the directed graph of Figure 13.3. Using the sum and product rules of probability, verify that this joint distribution satisﬁes the conditional independence property (13.3) for n = 2 ,...,N . Similarly, show that the second-order Markov model described by the joint distribution (13.4) satisﬁes the conditional independence property

$$
\text {for } n = 3 , \dots , N .
$$

$$
p ( x _ { n } | x _ { 1 } , \dots , x _ { n - 1 } ) = p ( x _ { n } | x _ { n - 1 } , x _ { n - 2 } )
$$

13.3 ( ) By using d-separation, show that the distribution p ( x 1 ,..., x N ) of the observed data for the state space model represented by the directed graph in Figure 13.5 does not satisfy any conditional independence properties and hence does not exhibit the Markov property at any ﬁnite order.

13.4 ( ) www Consider a hidden Markov model in which the emission densities are represented by a parametric model p ( x | z , w ) , such as a linear regression model or a neural network, in which w is a vector of adaptive parameters. Describe how the parameters w can be learned from data using maximum likelihood.
