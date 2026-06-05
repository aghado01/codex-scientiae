[Page 71]

the number of different ways of allocating the objects to the bins. There are N ways to choose the ﬁrst object, (N − 1) ways to choose the second object, and so on, leading to a total of N! ways to allocate all N objects to the bins, where N! (pronounced ‘factorial N’) denotes the product N ×(N −1)×···×2×1. However, we don’t wish to distinguish between rearrangements of objects within each bin. In the ith bin there are ni! ways of reordering the objects, and so the total number of ways of allocating the N objects to the bins is given by

N!

W =

(1.94)

�

i ni!

which is called the multiplicity. The entropy is then deﬁned as the logarithm of the multiplicity scaled by an appropriate constant

1 N �

1 N

1 N

lnni!. (1.95)

lnW =

lnN! −

H =

i

We now consider the limit N → ∞, in which the fractions ni/N are held ﬁxed, and apply Stirling’s approximation

lnN! � N lnN − N (1.96) which gives

�ni N �ln�ni N � = −�

�

pi lnpi (1.97)

H = − lim

N→∞

i

i

�

i ni = N. Here pi = limN→∞(ni/N) is the probability of an object being assigned to the ith bin. In physics terminology, the speciﬁc arrangements of objects in the bins is called a microstate, and the overall distribution of occupation numbers, expressed through the ratios ni/N, is called a macrostate. The multiplicity W is also known as the weight of the macrostate.

where we have used

We can interpret the bins as the states xi of a discrete random variable X, where p(X = xi) = pi. The entropy of the random variable X is then

H[p] = −�

p(xi)lnp(xi). (1.98)

i

Distributions p(xi) that are sharply peaked around a few values will have a relatively low entropy, whereas those that are spread more evenly across many values will

have higher entropy, as illustrated in Figure 1.30. Because 0 � pi � 1, the entropy is nonnegative, and it will equal its minimum value of 0 when one of the pi = 1 and all other pj=� i = 0. The maximum entropy conﬁguration can be found by

Appendix E maximizing H using a Lagrange multiplier to enforce the normalization constraint

on the probabilities. Thus we maximize

p(xi)lnp(xi) + λ�

p(xi) − 1� (1.99)

�

H =� −�

i

i
