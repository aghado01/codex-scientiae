[Page 567]

![The image is a graph with two axes labeled as x and y. The x-axis is labeled as z and the y-axis is labeled as u. The graph shows a curve that appears to be a sine wave. The curve starts at the origin and extends upwards and downwards, with a peak at the origin and a trough at the origin. The curve has a smooth, continuous appearance, and it appears to be a sine wave. The graph is drawn with a red line that is labeled as u and a blue line that is labeled as z. The red line is a sine wave, and it starts at the origin and extends upwards and downwards, with a peak at the origin and a trough at the origin. The blue line is a sine wave, and it starts at the origin and extends upwards and downwards, with a peak at the origin and a trough at the origin. The graph is drawn on a white background. There are no other](../images/imageFile266.png)

p

˜

(

z

)

p

˜

(

z

)

z

z

u

u

min

max

z

z

τ

τ

(

)

(

)

z

z

(a)

(b)

Figure 11.13 Illustration of slice sampling. (a) For a given value z ( τ ) , a value of u is chosen uniformly in the region 0 u e p ( z ( τ ) ) , which then deﬁnes a ‘slice’ through the distribution, shown by the solid horizontal lines. (b) Because it is infeasible to sample directly from a slice, a new sample of z is drawn from a region z min z z max , which contains the previous value z ( τ ) .

$$
\widehat { p } ( z , u ) = \begin{cases} 1 / Z _ { p } & \text {if } 0 \leqslant u \leqslant \widetilde { p } ( z ) \\ 0 & \text {otherwise} \end{cases} \\ \int \widetilde { p } ( z ) \, d z . \, The marginal distribution over z \, is \text {given by}
$$

$$
\int \widehat { p } ( z , u ) \, d u & = \int _ { 0 } ^ { \widehat { p } ( z ) } \frac { 1 } { Z _ { p } } \, d u = \frac { \widetilde { p } ( z ) } { Z _ { p } } = p ( z ) \\ \intertext { w e c a n s a m p l e s o r } \text {This can be achieved by alternately sampling z and u.  Given the value of z }
$$

and so we can sample from p ( z ) by sampling from p ( z,u ) and then ignoring the u values. This can be achieved by alternately sampling z and u . Given the value of z we evaluate p ( z ) and then sample u uniformly in the range 0 u p ( z ) , which is straightforward. Then we ﬁx u and sample z uniformly from the ‘slice’ through the distribution deﬁned by { z : p ( z ) > u } . This is illustrated in Figure 11.13(a). In practice, it can be difﬁcult to sample directly from a slice through the distribu-

tion and so instead we deﬁne a sampling scheme that leaves the uniform distribution under p ( z,u ) invariant, which can be achieved by ensuring that detailed balance is satisﬁed. Suppose the current value of z is denoted z ( τ ) and that we have obtained a corresponding sample u . The next value of z is obtained by considering a region z min z z max that contains z ( τ ) . It is in the choice of this region that the adaptation to the characteristic length scales of the distribution takes place. We want the region to encompass as much of the slice as possible so as to allow large moves in z space while having as little as possible of this region lying outside the slice, because this makes the sampling less efﬁcient.

One approach to the choice of region involves starting with a region containing z ( τ ) having some width w and then testing each of the end points to see if they lie within the slice. If either end point does not, then the region is extended in that direction by increments of value w until the end point lies outside the region. A candidate value z is then chosen uniformly from this region, and if it lies within the slice, then it forms z ( τ +1) . If it lies outside the slice, then the region is shrunk such that z forms an end point and such that the region still contains z ( τ ) . Then another
