[Page 36]

p(X,Y )

Y = 2

Y = 1

X

p(X)

p(Y )

p(X|Y = 1)

X X

Figure 1.11 An illustration of a distribution over two variables, X, which takes 9 possible values, and Y , which takes two possible values. The top left ﬁgure shows a sample of 60 points drawn from a joint probability distribution over these variables. The remaining ﬁgures show histogram estimates of the marginal distributions p(X) and p(Y ), as well as the conditional distribution p(X|Y = 1) corresponding to the bottom row in the top left ﬁgure.

Again, note that these probabilities are normalized so that

p(F = a|B = r) + p(F = o|B = r) = 1 (1.20) and similarly

p(F = a|B = b) + p(F = o|B = b) = 1. (1.21)

We can now use the sum and product rules of probability to evaluate the overall probability of choosing an apple

p(F = a) = p(F = a|B = r)p(B = r) + p(F = a|B = b)p(B = b)

4 10

3 4 ×

6 10

11 20

1 4 ×

+

=

=

(1.22)

from which it follows, using the sum rule, that p(F = o) = 1 − 11/20 = 9/20.
