[Page 126]

Figure 2.17 Illustration of the representation of values θn of a periodic variable as twodimensional vectors xn living on the unit circle. Also shown is the average x of those vectors.

x2

x3 x4

x¯ r¯

θ¯

x2

x1

x1

instead to give

�N

1 N

x =

xn (2.167)

n=1

and then ﬁnd the corresponding angle θ of this average. Clearly, this deﬁnition will ensure that the location of the mean is independent of the origin of the angular coordinate. Note that x will typically lie inside the unit circle. The Cartesian coordinates of the observations are given by xn = (cosθn,sinθn), and we can write the Cartesian coordinates of the sample mean in the form x = (r cosθ,r sinθ). Substituting into (2.167) and equating the x1 and x2 components then gives

�N

�N

1 N

1 N

r cosθ =

cosθn, r sinθ =

sinθn. (2.168)

n=1

n=1

Taking the ratio, and using the identity tanθ = sinθ/cosθ, we can solve for θ to give

��

�. (2.169)

n sinθn

θ = tan−1

�

n cosθn

Shortly, we shall see how this result arises naturally as the maximum likelihood estimator for an appropriately deﬁned distribution over a periodic variable.

We now consider a periodic generalization of the Gaussian called the von Mises distribution. Here we shall limit our attention to univariate distributions, although periodic distributions can also be found over hyperspheres of arbitrary dimension. For an extensive discussion of periodic distributions, see Mardia and Jupp (2000).

By convention, we will consider distributions p(θ) that have period 2π. Any probability density p(θ) deﬁned over θ must not only be nonnegative and integrate
