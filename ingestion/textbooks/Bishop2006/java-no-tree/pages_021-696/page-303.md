[Page 303]

Figure 5.22 Illustration of the evidence framework applied to a synthetic two-class data set. The green curve shows the optimal decision boundary, the black curve shows the result of ﬁtting a two-layer network with 8 hidden units by maximum likelihood, and the red curve shows the result of including a regularizer in which α is optimized using the evidence procedure, starting from the initial value α = 0. Note that the evidence procedure greatly reduces the over-ﬁtting of the network.

- 0
- 1
- 2
- 3


| |
|---|


−1

−2

−2 −1 0 1 2

simplest approximation is to assume that the posterior distribution is very narrow and hence make the approximation

###### p(t|x,D) p(t|x,wMAP). (5.185)

We can improve on this, however, by taking account of the variance of the posterior distribution. In this case, a linear approximation for the network outputs, as was used in the case of regression, would be inappropriate due to the logistic sigmoid outputunit activation function that constrains the output to lie in the range (0,1). Instead, we make a linear approximation for the output unit activation in the form

###### a(x,w) aMAP(x) + bT(w − wMAP) (5.186)

where aMAP(x) = a(x,wMAP), and the vector b ≡ ∇a(x,wMAP) can be found by backpropagation.

Because we now have a Gaussian approximation for the posterior distribution over w, and a model for a that is a linear function of w, we can now appeal to the results of Section 4.5.2. The distribution of output unit activation values, induced by the distribution over network weights, is given by

###### p(a|x,D) = δ a − aMAP(x) − bT(x)(w − wMAP) q(w|D)dw (5.187)

where q(w|D) is the Gaussian approximation to the posterior distribution given by (5.167). From Section 4.5.2, we see that this distribution is Gaussian with mean aMAP ≡ a(x,wMAP), and variance

σa2(x) = bT(x)A−1b(x). (5.188) Finally, to obtain the predictive distribution, we must marginalize over a using

###### p(t = 1|x,D) = σ(a)p(a|x,D)da. (5.189)
