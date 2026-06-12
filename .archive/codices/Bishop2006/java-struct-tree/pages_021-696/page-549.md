[Page 549]

Figure 11.4 In the rejection sampling method, samples are drawn from a simple distribution q(z) and rejected if they fall in the grey area between the unnormalized distribution ep(z) and the scaled distribution kq(z). The resulting samples are distributed according to p(z), which is the normalized version of

kq(z0) kq(z)

p˜(z)

u0

ep(z). z0 z

We next introduce a constant k whose value is chosen such that kq(z) � �p(z) for all values of z. The function kq(z) is called the comparison function and is illustrated for a univariate distribution in Figure 11.4. Each step of the rejection sampler involves generating two random numbers. First, we generate a number z0 from the distribution q(z). Next, we generate a number u0 from the uniform distribution over [0,kq(z0)]. This pair of random numbers has uniform distribution under the curve of the function kq(z). Finally, if u0 > �p(z0) then the sample is rejected, otherwise u0 is retained. Thus the pair is rejected if it lies in the grey shaded region in Figure 11.4. The remaining pairs then have uniform distribution under the curve of�p(z),

Exercise 11.6 and hence the corresponding z values are distributed according to p(z), as desired.

The original values of z are generated from the distribution q(z), and these samples are then accepted with probability �p(z)/kq(z), and so the probability that a sample will be accepted is given by

p(accept) = � {�p(z)/kq(z)}q(z)dz

�

1 k

�p(z)dz. (11.14)

=

Thus the fraction of points that are rejected by this method depends on the ratio of the area under the unnormalized distribution �p(z) to the area under the curve kq(z). We therefore see that the constant k should be as small as possible subject to the limitation that kq(z) must be nowhere less than �p(z).

As an illustration of the use of rejection sampling, consider the task of sampling from the gamma distribution

baza−1 exp(−bz) Γ(a)

Gam(z|a,b) =

(11.15)

which, for a > 1, has a bell-shaped form, as shown in Figure 11.5. A suitable proposal distribution is therefore the Cauchy (11.8) because this too is bell-shaped and because we can use the transformation method, discussed earlier, to sample from it. We need to generalize the Cauchy slightly to ensure that it nowhere has a smaller value than the gamma distribution. This can be achieved by transforming a uniform random variable y using z = btany + c, which gives random numbers distributed

Exercise 11.7 according to.
