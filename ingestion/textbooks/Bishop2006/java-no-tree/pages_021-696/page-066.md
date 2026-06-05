[Page 66]

independent, so that

p(xI,xB|Ck) = p(xI|Ck)p(xB|Ck). (1.84) Section 8.2 This is an example of conditional independence property, because the indepen-

dence holds when the distribution is conditioned on the class Ck. The posterior probability, given both the X-ray and blood data, is then given by

p(Ck|xI,xB) ∝ p(xI,xB|Ck)p(Ck) ∝ p(xI|Ck)p(xB|Ck)p(Ck) ∝

p(Ck|xI)p(Ck|xB) p(Ck)

(1.85)

Thus we need the class prior probabilities p(Ck), which we can easily estimate from the fractions of data points in each class, and then we need to normalize the resulting posterior probabilities so they sum to one. The particular condi-

Section 8.2.2 tional independence assumption (1.84) is an example of the naive Bayes model. Note that the joint marginal distribution p(xI,xB) will typically not factorize under this model. We shall see in later chapters how to construct models for combining data that do not require the conditional independence assumption (1.84).

###### 1.5.5 Loss functions for regression

So far, we have discussed decision theory in the context of classiﬁcation problems. We now turn to the case of regression problems, such as the curve ﬁtting

Section 1.1 example discussed earlier. The decision stage consists of choosing a speciﬁc estimate y(x) of the value of t for each input x. Suppose that in doing so, we incur a loss L(t,y(x)). The average, or expected, loss is then given by

###### E[L] = L(t,y(x))p(x,t)dxdt. (1.86)

A common choice of loss function in regression problems is the squared loss given by L(t,y(x)) = {y(x) − t}2. In this case, the expected loss can be written

E[L] = {y(x) − t}2p(x,t)dxdt. (1.87) Our goal is to choose y(x) so as to minimize E[L]. If we assume a completely

- Appendix D ﬂexible function y(x), we can do this formally using the calculus of variations to give


δE[L] δy(x)

= 2 {y(x) − t}p(x,t)dt = 0. (1.88) Solving for y(x), and using the sum and product rules of probability, we obtain

tp(x,t)dt p(x)

= tp(t|x)dt = Et[t|x] (1.89)

y(x) =
