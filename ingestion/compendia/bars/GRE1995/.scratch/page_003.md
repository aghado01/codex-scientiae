[Page 3]

## 2. Bayesian Model Choice as Hierarchical Model

Suppose that we have a countable collection of candidate models { Alk, k € % }. Model Ak has a vector 0(k) of unknown parameters; assumed to lie in 9" , where the dimension nk may vary from model to model.  With obvious changes; our methods would apply to an arbitrary collection of parameter subspaces:  We observe data y There is a natural hierarchical structure expressed by modelling the joint distribution of (k, 0(), y) as

$$
p ( k , \theta ^ { ( k ) } , y ) = p ( k ) p ( \theta ^ { ( k ) } | k ) p ( y | k , \theta ^ { ( k ) } ) ,
$$

abbreviate the over 8 = pair

As a concrete example; consider a change-point problem in which there is an unknown number of change-points in a piecewise constant regression function on the interval [0, L]. }, model Mk says that there are exactly k change-points. To parametrise the resulting step function; we need to specify the position of each change-point; and the value of the function on each of the (k + 1) subintervals into which [0,L] is divided. Thus 0() is a vector of length nx = 2k + 1.

Bayesian inference about k and will be based on the joint posterior 0(k)|y), which is the target of the Markov chain Monte Carlo computations described below. It will often be appropriate to factorise this as 0(k) p(k,

$$
p(k, \theta^{(k)}|y) = p(k|y)\,p(\theta^{(k)}|k,y)
$$

and to interpret the two terms separately, thus avoiding any 'model averaging . Inference about the model indicator may sometimes be phrased in terms, not of p(kly) but of the Bayes factor for one model relative to another:

$$
B_{k_0 k_1} = \frac{p(k_0|y)}{p(k_1|y)} \cdot \frac{p(k_1)}{p(k_0)}
$$

which does not depend on the hyperprior p(k) All these quantities are readily estimated from the Markov chain Monte Carlo sample obtained by the methods below; if Bayes factors be specified to implement the computation, but it can be chosen on grounds of convenience. Note that regarding the posterior p(k, 0()|y) as the objective of the computation does not preclude model selection Or prediction ultimately based on a non-coherent principle such as that advocated by Madigan & Raftery (1994); thus the methods of the present paper would be applicable to their analysis. being

Recent work on Markov chain Monte Carlo computation with application to aspects of Bayesian model determination includes Phillips & Smith (1995), based on the jump diffusion samplers of Grenander & Miller (1994), Carlin & Chib (1995) who effectively work with M. Piccioni and G.
