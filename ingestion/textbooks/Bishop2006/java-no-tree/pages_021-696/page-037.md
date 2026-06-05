[Page 37]

Suppose instead we are told that a piece of fruit has been selected and it is an orange, and we would like to know which box it came from. This requires that we evaluate the probability distribution over boxes conditioned on the identity of the fruit, whereas the probabilities in (1.16)–(1.19) give the probability distribution over the fruit conditioned on the identity of the box. We can solve the problem of reversing the conditional probability by using Bayes’ theorem to give

p(F = o|B = r)p(B = r) p(F = o)

- 3

- 4 ×


4 10 ×

p(B = r|F = o) =

=

20 9

=

2 3

. (1.23)

From the sum rule, it then follows that p(B = b|F = o) = 1 − 2/3 = 1/3.

We can provide an important interpretation of Bayes’ theorem as follows. If we had been asked which box had been chosen before being told the identity of the selected item of fruit, then the most complete information we have available is provided by the probability p(B). We call this the prior probability because it is the probability available before we observe the identity of the fruit. Once we are told that the fruit is an orange, we can then use Bayes’ theorem to compute the probability p(B|F), which we shall call the posterior probability because it is the probability obtained after we have observed F. Note that in this example, the prior probability of selecting the red box was 4/10, so that we were more likely to select the blue box than the red one. However, once we have observed that the piece of selected fruit is an orange, we ﬁnd that the posterior probability of the red box is now 2/3, so that it is now more likely that the box we selected was in fact the red one. This result accords with our intuition, as the proportion of oranges is much higher in the red box than it is in the blue box, and so the observation that the fruit was an orange provides signiﬁcant evidence favouring the red box. In fact, the evidence is sufﬁciently strong that it outweighs the prior and makes it more likely that the red box was chosen rather than the blue one.

Finally, we note that if the joint distribution of two variables factorizes into the product of the marginals, so that p(X,Y ) = p(X)p(Y ), then X and Y are said to be independent. From the product rule, we see that p(Y |X) = p(Y ), and so the conditional distribution of Y given X is indeed independent of the value of X. For instance, in our boxes of fruit example, if each box contained the same fraction of apples and oranges, then p(F|B) = P(F), so that the probability of selecting, say, an apple is independent of which box is chosen.

###### 1.2.1 Probability densities

As well as considering probabilities deﬁned over discrete sets of events, we also wish to consider probabilities with respect to continuous variables. We shall limit ourselves to a relatively informal discussion. If the probability of a real-valued variable x falling in the interval (x,x + δx) is given by p(x)δx for δx → 0, then p(x) is called the probability density over x. This is illustrated in Figure 1.12. The probability that x will lie in an interval (a,b) is then given by

p(x ∈ (a,b)) =

b

p(x)dx. (1.24)

a
