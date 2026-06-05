[Page 567]

###### 11.4. Slice Sampling 547

p˜(z)

u

z(τ) z

(a)

p˜(z)

zmin u zmax

z(τ) z

###### (b)

- Figure 11.13 Illustration of slice sampling. (a) For a given value z(τ), a value of u is chosen uniformly in the region 0 u ep(z(τ)), which then deﬁnes a ‘slice’ through the distribution, shown by the solid horizontal lines. (b) Because it is infeasible to sample directly from a slice, a new sample of z is drawn from a region zmin z zmax, which contains the previous value z(τ).


given by

p(z,u) =

1/Zp if 0 u p(z) 0 otherwise

where Zp = p(z)dz. The marginal distribution over z is given by

(11.51)

p(z,u)du =

ep(z)

1 Zp

du =

0

p(z) Zp

= p(z) (11.52)

and so we can sample from p(z) by sampling from p(z,u) and then ignoring the u values. This can be achieved by alternately sampling z and u. Given the value of z we evaluate p(z) and then sample u uniformly in the range 0 u p(z), which is straightforward. Then we ﬁx u and sample z uniformly from the ‘slice’ through the distribution deﬁned by {z : p(z) > u}. This is illustrated in Figure 11.13(a).

In practice, it can be difﬁcult to sample directly from a slice through the distribution and so instead we deﬁne a sampling scheme that leaves the uniform distribution under p(z,u) invariant, which can be achieved by ensuring that detailed balance is satisﬁed. Suppose the current value of z is denoted z(τ) and that we have obtained a corresponding sample u. The next value of z is obtained by considering a region zmin z zmax that contains z(τ). It is in the choice of this region that the adaptation to the characteristic length scales of the distribution takes place. We want the region to encompass as much of the slice as possible so as to allow large moves in z space while having as little as possible of this region lying outside the slice, because this makes the sampling less efﬁcient.

One approach to the choice of region involves starting with a region containing z(τ) having some width w and then testing each of the end points to see if they lie within the slice. If either end point does not, then the region is extended in that direction by increments of value w until the end point lies outside the region. A candidate value z is then chosen uniformly from this region, and if it lies within the slice, then it forms z(τ+1). If it lies outside the slice, then the region is shrunk such that z forms an end point and such that the region still contains z(τ). Then another
