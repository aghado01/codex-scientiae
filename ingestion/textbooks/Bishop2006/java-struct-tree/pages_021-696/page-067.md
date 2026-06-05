[Page 67]

Figure 1.28 The regression function y(x), which minimizes the expected squared loss, is given by the mean of the conditional distribution p(t|x).

t

y(x0)

y(x)

p(t|x0)

x0 x

which is the conditional average of t conditioned on x and is known as the regression function. This result is illustrated in Figure 1.28. It can readily be extended to multiple target variables represented by the vector t, in which case the optimal solution

Exercise 1.25 is the conditional average y(x) = Et[t|x].

We can also derive this result in a slightly different way, which will also shed light on the nature of the regression problem. Armed with the knowledge that the optimal solution is the conditional expectation, we can expand the square term as follows

{y(x) − t}2 = {y(x) − E[t|x] + E[t|x] − t}2

= {y(x) − E[t|x]}2 + 2{y(x) − E[t|x]}{E[t|x] − t} + {E[t|x] − t}2

where, to keep the notation uncluttered, we use E[t|x] to denote Et[t|x]. Substituting into the loss function and performing the integral over t, we see that the cross-term vanishes and we obtain an expression for the loss function in the form

E[L] = � {y(x) − E[t|x]}2 p(x)dx + � {E[t|x] − t}2p(x)dx. (1.90)

The function y(x) we seek to determine enters only in the ﬁrst term, which will be minimized when y(x) is equal to E[t|x], in which case this term will vanish. This is simply the result that we derived previously and that shows that the optimal least squares predictor is given by the conditional mean. The second term is the variance of the distribution of t, averaged over x. It represents the intrinsic variability of the target data and can be regarded as noise. Because it is independent of y(x), it represents the irreducible minimum value of the loss function.

As with the classiﬁcation problem, we can either determine the appropriate probabilities and then use these to make optimal decisions, or we can build models that make decisions directly. Indeed, we can identify three distinct approaches to solving regression problems given, in order of decreasing complexity, by:

(a) First solve the inference problem of determining the joint density p(x,t). Then normalize to ﬁnd the conditional density p(t|x), and ﬁnally marginalize to ﬁnd the conditional mean given by (1.89).
