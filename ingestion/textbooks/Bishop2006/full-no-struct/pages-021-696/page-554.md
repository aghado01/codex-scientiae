[Page 554]

For distributions deﬁned in terms of a graphical model, we can apply the importance sampling technique in various ways. For discrete variables, a simple approach is called uniform sampling . The joint distribution for a directed graph is deﬁned by (11.4). Each sample from the joint distribution is obtained by ﬁrst setting those variables z i that are in the evidence set equal to their observed values. Each of the remaining variables is then sampled independently from a uniform distribution over the space of possible instantiations. To determine the corresponding weight associated with a sample z ( l ) , we note that the sampling distribution q ( z ) is uniform over the possible choices for z , and that p ( z | x ) = p ( z ) , where x denotes the subset of variables that are observed, and the equality follows from the fact that every sample z that is generated is necessarily consistent with the evidence. Thus the weights r l are simply proportional to p ( z ) . Note that the variables can be sampled in any order. This approach can yield poor results if the posterior distribution is far from uniform, as is often the case in practice.

An improvement on this approach is called likelihood weighted sampling (Fung and Chang, 1990; Shachter and Peot, 1990) and is based on ancestral sampling of the variables. For each variable in turn, if that variable is in the evidence set, then it is just set to its instantiated value. If it is not in the evidence set, then it is sampled from the conditional distribution p ( z i | pa i ) in which the conditioning variables are set to their currently sampled values. The weighting associated with the resulting sample z is then given by

$$
r ( z ) = \prod _ { z _ { i } \notin e } \frac { p ( z _ { i } | \text {pa} _ { i } ) } { p ( z _ { i } | \text {pa} _ { i } ) } \prod _ { z _ { i } \in e } \frac { p ( z _ { i } | \text {pa} _ { i } ) } { 1 } = \prod _ { z _ { i } \in e } p ( z _ { i } | \text {pa} _ { i } ) . \\ \intertext { T h i s w a t h e f t h e f t h a n d s u r d u s e a n t i v e s }
$$

This method can be further extended using self-importance sampling (Shachter and Peot, 1990) in which the importance sampling distribution is continually updated to reﬂect the current estimated posterior distribution.

# 11.1.5 Sampling-importance-resampling

The rejection sampling method discussed in Section 11.1.2 depends in part for its success on the determination of a suitable value for the constant k . For many pairs of distributions p ( z ) and q ( z ) , it will be impractical to determine a suitable
