[Page 127]

Figure 2.18 The von Mises distribution can be derived by considering a two-dimensional Gaussian of the form (2.173), whose density contours are shown in blue and conditioning on the unit circle shown in red.

|x2<br><br>|p(x)|
|---|---|
|1|x1<br><br>|


###### r =

to one, but it must also be periodic. Thus p(θ) must satisfy the three conditions

p(θ) 0 (2.170)

2π

p(θ)dθ = 1 (2.171)

0

p(θ + 2π) = p(θ). (2.172) From (2.172), it follows that p(θ + M2π) = p(θ) for any integer M.

We can easily obtain a Gaussian-like distribution that satisﬁes these three properties as follows. Consider a Gaussian distribution over two variables x = (x1,x2) having mean µ = (µ1,µ2) and a covariance matrix Σ = σ2I where I is the 2 × 2 identity matrix, so that

1 2πσ2

(x1 − µ1)2 + (x2 − µ2)2 2σ2

p(x1,x2) =

exp −

. (2.173)

The contours of constant p(x) are circles, as illustrated in Figure 2.18. Now suppose we consider the value of this distribution along a circle of ﬁxed radius. Then by construction this distribution will be periodic, although it will not be normalized. We can determine the form of this distribution by transforming from Cartesian coordinates (x1,x2) to polar coordinates (r,θ) so that

x1 = r cosθ, x2 = r sinθ. (2.174) We also map the mean µ into polar coordinates by writing

###### µ1 = r0 cosθ0, µ2 = r0 sinθ0. (2.175)

Next we substitute these transformations into the two-dimensional Gaussian distribution (2.173), and then condition on the unit circle r = 1, noting that we are interested only in the dependence on θ. Focussing on the exponent in the Gaussian distribution we have

1 2σ2

(r cosθ − r0 cosθ0)2 + (r sinθ − r0 sinθ0)2

−

- 1

- 2σ2


= −

1 + r02 − 2r0 cosθ cosθ0 − 2r0 sinθ sinθ0

r0 σ2

=

cos(θ − θ0) + const (2.176)
