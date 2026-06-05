[Page 234]

Chapter 11

over the parameter vector w since the posterior distribution is no longer Gaussian. It is therefore necessary to introduce some form of approximation. Later in the book we shall consider a range of techniques based on analytical approximations and numerical sampling.

Here we introduce a simple, but widely used, framework called the Laplace approximation, that aims to ﬁnd a Gaussian approximation to a probability density deﬁned over a set of continuous variables. Consider ﬁrst the case of a single continuous variable z , and suppose the distribution p ( z ) is deﬁned by

$$
p ( z ) = \frac { 1 } { Z } f ( z )
$$

where Z = f ( z )d z is the normalization coefﬁcient. We shall suppose that the value of Z is unknown. In the Laplace method the goal is to ﬁnd a Gaussian approximation q ( z ) which is centred on a mode of the distribution p ( z ) . The ﬁrst step is to ﬁnd a mode of p ( z ) , in other words a point z 0 such that p ( z 0 ) = 0 , or equivalently

$$
\text {other words a point } z _ { 0 } \text { such that } p ^ { \prime } ( z _ { 0 } ) = 0 , \text { or equivalently } \\ \frac { d f ( z ) } { d z } \Big | _ { z = z _ { 0 } } = 0 . \\ \text {on} \, \text {has the property that its logarithm is a quadratic function} \\ \text {before consider a Taylor expansion of } \ln f ( z ) \text { centered on the }
$$

A Gaussian distribution has the property that its logarithm is a quadratic function of the variables. We therefore consider a Taylor expansion of ln f ( z ) centred on the mode z 0 so that 1

$$
\ln f ( z ) \simeq \ln f ( z _ { 0 } ) - \frac { 1 } { 2 } A ( z - z _ { 0 } ) ^ { 2 }
$$

$$
A = - \, \frac { d ^ { 2 } } { d z ^ { 2 } } \ln f ( z ) \Big | _ { z = z _ { 0 } } . \\ \intertext { order term in the Taylor expansion does not appear since z _ { 0 } is a } \, the distribution . \, T a k i n g t h e x p e n t i o n w e o b t a n
$$

where

A = − dz 2 ln f ( z ) z = z 0 . (4.128) Note that the ﬁrst-order term in the Taylor expansion does not appear since z 0 is a local maximum of the distribution. Taking the exponential we obtain

$$
\dim \text { of the disambiguation. } \text { making the exchange of commah and
} \\ f ( z ) \simeq f ( z _ { 0 } ) \exp \left \{ - \frac { A } { 2 } ( z - z _ { 0 } ) ^ { 2 } \right \} . \\
$$

We can then obtain a normalized distribution q ( z ) by making use of the standard result for the normalization of a Gaussian, so that

$$
q ( z ) = \left ( \frac { A } { 2 \pi } \right ) ^ { 1 / 2 } \exp \left \{ - \frac { A } { 2 } ( z - z _ { 0 } ) ^ { 2 } \right \} .
$$

The Laplace approximation is illustrated in Figure 4.14. Note that the Gaussian approximation will only be well deﬁned if its precision A > 0 , in other words the stationary point z 0 must be a local maximum, so that the second derivative of f ( z ) at the point z 0 is negative.
