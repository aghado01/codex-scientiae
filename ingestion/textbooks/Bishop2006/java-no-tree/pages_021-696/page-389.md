[Page 389]

- Figure 8.11 An extension of the model of Figure 8.10 to include Dirichlet priors over the parameters governing the discrete distributions.

x1 x2 xM

µ1 µ2 µM

- Figure 8.12 As in Figure 8.11 but with a single set of parameters µ shared amongst all of the conditional distributions p(xi|xi−1).


µ1 µ

x1 x2 xM

ter µi representing the probability p(xi = 1), giving M parameters in total for the parent nodes. The conditional distribution p(y|x1,...,xM), however, would require 2M parameters representing the probability p(y = 1) for each of the 2M possible settings of the parent variables. Thus in general the number of parameters required to specify this conditional distribution will grow exponentially with M. We can obtain a more parsimonious form for the conditional distribution by using a logistic

Section 2.4 sigmoid function acting on a linear combination of the parent variables, giving

p(y = 1|x1,...,xM) = σ w0 +

M

wixi = σ(wTx) (8.10)

i=1

where σ(a) = (1+exp(−a))−1 is the logistic sigmoid, x = (x0,x1,...,xM)T is an (M + 1)-dimensional vector of parent states augmented with an additional variable

x0 whose value is clamped to 1, and w = (w0,w1,...,wM)T is a vector of M + 1 parameters. This is a more restricted form of conditional distribution than the general case but is now governed by a number of parameters that grows linearly with M. In this sense, it is analogous to the choice of a restrictive form of covariance matrix (for example, a diagonal matrix) in a multivariate Gaussian distribution. The motivation for the logistic sigmoid representation was discussed in Section 4.2.

- Figure 8.13 A graph comprising M parents x1, . . . , xM and a single child y, used to illustrate the idea of parameterized conditional distributions for discrete variables.


x1 xM

y
