[Page 645]

Figure 13.14 A fragment of the factor graph representation for the hidden Markov model.

z

z

z

![The image depicts a diagram with four interconnected circles, each representing a different variable or parameter. The circles are connected by lines, forming a circular network. The diagram is labeled with the following labels: - **X**: This is the variable represented by a red square. - **Y**: This is the variable represented by a blue circle. - **Z**: This is the variable represented by a red square. - **A**: This is the variable represented by a red square. - **B**: This is the variable represented by a red square. - **C**: This is the variable represented by a red square. - **D**: This is the variable represented by a red square. The diagram is labeled with the following labels: - **X**: This is labeled as x in the diagram. - **Y**: This is labeled as y in the diagram. - **Z**: This is labeled as z](../images/imageFile314.png)

-

n

1

n

1

χ

ψ

n

g

g

g

-

n

n

1

1

x

x

x

-

n

n

1

1

Section 10.1

Section 8.4.4

Note that in (13.44), the inﬂuence of all data from x 1 to x N is summarized in the K values of α ( z N ) . Thus the predictive distribution can be carried forward indeﬁnitely using a ﬁxed amount of storage, as may be required for real-time applications.

Here we have discussed the estimation of the parameters of an HMM using maximum likelihood. This framework is easily extended to regularized maximum likelihood by introducing priors over the model parameters π , A and φ whose values are then estimated by maximizing their posterior probability. This can again be done using the EM algorithm in which the E step is the same as discussed above, and the M step involves adding the log of the prior distribution p ( θ ) to the function Q ( θ , θ old ) before maximization and represents a straightforward application of the techniques developed at various points in this book. Furthermore, we can use variational methods to give a fully Bayesian treatment of the HMM in which we marginalize over the parameter distributions (MacKay, 1997). As with maximum likelihood, this leads to a two-pass forward-backward recursion to compute posterior probabilities.

# 13.2.3 The sum-product algorithm for the HMM

The directed graph that represents the hidden Markov model, shown in Figure 13.5, is a tree and so we can solve the problem of ﬁnding local marginals for the hidden variables using the sum-product algorithm. Not surprisingly, this turns out to be equivalent to the forward-backward algorithm considered in the previous section, and so the sum-product algorithm therefore provides us with a simple way to derive the alpha-beta recursion formulae.

We begin by transforming the directed graph of Figure 13.5 into a factor graph, of which a representative fragment is shown in Figure 13.14. This form of the factor graph shows all variables, both latent and observed, explicitly. However, for the purpose of solving the inference problem, we shall always be conditioning on the variables x 1 ,..., x N , and so we can simplify the factor graph by absorbing the emission probabilities into the transition probability factors. This leads to the simpliﬁed factor graph representation in Figure 13.15, in which the factors are given by

$$
h ( z _ { 1 } ) \ = \ p ( z _ { 1 } ) p ( x _ { 1 } | z _ { 1 } ) & & ( 1 3 . 4 5 ) \\ f \left ( z _ { 1 } \right ) z _ { 1 } \right ) \ = \ p ( z _ { 1 } \ | z _ { 1 } ) n ( x _ { 1 } \ | z _ { 1 } ) & & ( 1 3 . 4 6 )
$$

$$
f _ { n } ( z _ { n - 1 } , z _ { n } ) \ = \ p ( z _ { n } | z _ { n - 1 } ) p ( x _ { n } | z _ { n } ) .
$$
