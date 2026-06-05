[Page 36]

Figure 1.11 An illustration of a distribution over two variables, $X$, which takes 9 possible values, and $Y$, which takes two possible values. The top left ﬁgure shows a sample of 60 points drawn from a joint probability distribution over these variables. The remaining ﬁgures show histogram estimates of the marginal distributions $p(X)$ and $p(Y)$, as well as the conditional distribution $p(X \mid Y = 1)$ corresponding to the bottom row in the top left ﬁgure.

![image 14](../../../../../images/imageFile14.png)

Again, note that these probabilities are normalized so that

$$
p(F = a \mid B = r) + p(F = o \mid B = r) = 1 \tag{1.20}
$$

and similarly

$$
p(F = a \mid B = b) + p(F = o \mid B = b) = 1. \tag{1.21}
$$

We can now use the sum and product rules of probability to evaluate the overall probability of choosing an apple

$$
p(F = a) = p(F = a \mid B = r)p(B = r) + p(F = a \mid B = b)p(B = b) = \frac{1}{4} \times \frac{4}{10} + \frac{3}{4} \times \frac{6}{10} = \frac{11}{20}. \tag{1.22}
$$

from which it follows, using the sum rule, that $p(F = o) = 1 - 11/20 = 9/20$.
