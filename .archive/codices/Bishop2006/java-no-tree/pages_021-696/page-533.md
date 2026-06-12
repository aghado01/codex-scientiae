[Page 533]

| |
|---|


| |
|---|


−5 0 5 θ 10 θ

−5 0 5 10

- Figure 10.16 Examples of the approximation of speciﬁc factors for a one-dimensional version of the clutter problem, showing fn(θ) in blue, fen(θ) in red, and q\n(θ) in green. Notice that the current form for q\n(θ) controls the range of θ over which fen(θ) will be a good approximation to fn(θ).


pass through all factors is less than some threshold. Finally, we use (10.208) to evaluate the approximation to the model evidence, given by

N

p(D) (2πvnew)D/2 exp(B/2)

n=1

sn(2πvn)−D/2 (10.223)

where

N

(mnew)Tmnew v −

mTnmn vn

B =

. (10.224)

n=1

Examples factor approximations for the clutter problem with a one-dimensional parameter space θ are shown in Figure 10.16. Note that the factor approximations can have inﬁnite or even negative values for the ‘variance’ parameter vn. This simply corresponds to approximations that curve upwards instead of downwards and are not necessarily problematic provided the overall approximate posterior q(θ) has positive variance. Figure 10.17 compares the performance of EP with variational Bayes (mean ﬁeld theory) and the Laplace approximation on the clutter problem.

###### 10.7.2 Expectation propagation on graphs

So far in our general discussion of EP, we have allowed the factors fi(θ) in the distribution p(θ) to be functions of all of the components of θ, and similarly for the approximating factors f(θ) in the approximating distribution q(θ). We now consider situations in which the factors depend only on subsets of the variables. Such restrictions can be conveniently expressed using the framework of probabilistic graphical models, as discussed in Chapter 8. Here we use a factor graph representation because this encompasses both directed and undirected graphs.
