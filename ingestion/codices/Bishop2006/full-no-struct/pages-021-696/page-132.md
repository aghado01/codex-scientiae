[Page 132]

1

(a)

0.5

0

0.5

1

(b)

0.2

0.3

0.5

0

![In this image we can see a paper with some text and a picture of a paper.](../images/imageFile14.png)

(c)

0

0.5

1

0

0.5

1

Figure 2.23 Illustration of a mixture of 3 Gaussians in a two-dimensional space. (a) Contours of constant density for each of the mixture components, in which the 3 components are denoted red, blue and green, and the values of the mixing coefﬁcients are shown below each component. (b) Contours of the marginal probability density p ( x ) of the mixture distribution. (c) A surface plot of the distribution p ( x ) .

We therefore see that the mixing coefﬁcients satisfy the requirements to be probabilities.

From the sum and product rules, the marginal density is given by

$$
p ( x ) = \sum _ { k = 1 } ^ { K } p ( k ) p ( x | k ) & & ( 2 . 1 9 1 ) \\ \intertext { t o ( 2 . 1 8 8 ) in which we can view } \tau _ { 0 } ( x ) = \intertext { t o ( 2 . 1 8 8 ) in which we can view } \tau _ { 0 } ( x ) = \tau _ { 0 } ( k ) \, \tau _ { 0 } ( x ) \tau _ { 0 } ( k ) & & ( 2 . 1 9 1 )
$$

which is equivalent to (2.188) in which we can view π k = p ( k ) as the prior probability of picking the k th component, and the density N ( x | µ k , Σ k ) = p ( x | k ) as the probability of x conditioned on k . As we shall see in later chapters, an important role is played by the posterior probabilities p ( k | x ) , which are also known as responsibilities . From Bayes’ theorem these are given by

$$
\colon & \text {From Bayes Theoremse are given by} \\ & \quad \gamma _ { k } ( x ) \ \equiv \ p ( k | x ) \\ & \quad = \ \frac { p ( k ) p ( x | k ) } { \sum _ { l } p ( l ) p ( x | l ) } \\ & \quad = \ \frac { \pi _ { k } \mathcal { N } ( x | \mu _ { k } , \Sigma _ { k } ) } { \sum _ { l } \pi _ { l } \mathcal { N } ( x | \mu _ { l } , \Sigma _ { l } ) } . \\ \intertext { s s t h e p r o b a b i l i s t i c h e r p r e t a t i o n } & \emph { r e s } & \frac { \pi _ { k } \mathcal { N } ( x | \mu _ { k } , \Sigma _ { k } ) } { \sum _ { l } \pi _ { l } \mathcal { N } ( x | \mu _ { l } , \Sigma _ { l } ) } . \\ & \emph { r e s } & \intertext { s t h e p r o b a b i l i s t i c h e r p r e t a t i o n } & \emph { r e s } & \intertext { s t h e p r o b a b i l i s t i c h e r p r e t a t i o n } & \emph { r e s } & \intertext { s t h e p r o b a b i l i s t i c h e r p r e t a t i o n } & \emph { r e s } & \intertext { s t h e p r o b a b i l i s t i c h e r p r e t a t i o n } & \emph { r e s } & \intertext { s t h e p r o b a b i l i s t i c h e r p r e t a t i o n } & \emph { r e s } & \intertext { s t h e p r o b a b i l i s t i c h e r p r e t a t i o n } & \emph { r e s } & \intertext { s t h e p r o b a b i l i s t i c h e r p r e t a t i o n } & \emph { r e s } & \intertext { s t h e p r o b a b i l i s t i c h e r p r e t a t i o n } & \emph { r e s } & \intertext { s t h e p r o b a b i l i s t i c h e r p r e t a t i o n } & \emph { r e s } & \intertext { s t h e p r o b a b i l i s t i c h e r p r e t a t i o n } & \emph { r e s } & \intertext { s t h e p r o b a b i l i s t i c h e r p r e t a t i o n } & \emph { r e s } & \intertext { s t h e p r o b a b i l i s t i c h e r p r e t a t i o n } & \emph { r e s } & \intertext { s t h e p r o b a b i l i s t i c h e r p r e t a t i o n } & \emph { r e s } & \intertext { s t h e p r o b a b i l i s t i c h e r p r e t a t i o n } & \emph { r e s } & \intertext { s t h e p r o b a b i l i s t i c h e r p r e t a t i o n } & \emph { r e s } & \intertext { s t h e p r o b a b i l i s t i c h e r p r e t a t i o n } & \emph { r e s } & \intertext { s t h e p r o b a b i l i s t i c h e r p r e t a t i o n } & \emph { r e s } & \intertext { s t h e p r o b a b i l i s t i c h e r p r e t a t i o n } & \emph { r e s } & \intertext { s t h e p r o b a b i l i s t i c h e r p r e t a t i o n } & \emph { r e s } & \intertext { s t h e p r o b a b i l i s t i c h e r p r e t a t i o n } & \emph { r e s } & \intertext { s t h e p r o b a b i l i s t i c h e r p r e t a t i o n } & \emph { r e s } & \intertext { s t h e p r o b a b i l i s t i c h e r p r e t a t i o n } & \emph { r e s } & \intertext { s t h e p r o b a b i l i s t i c h e r p r e t a t i o n } & \emph { r e s } & \intertext { s t h e p r o b a b i l i s t i c h e r p r e t a t i o n } & \emph { r e s } & \intertext { s t h e p r o b a b i l i s t i c h e r p r e t a t i o n } & \emph { r e s } & \intertext { s t h e p r o b a b i l i s t i c h e r p r e t a t i o n } & \emph { r e s } & \intertext { s t h e p r o b a b i l i s t i c h e r p r e t a t i o n } & \emph { r e s } & \intertext { s t h e p r o b a b i l i s t i c h e r p r e t a t i o n } & \emph { r e s } & \intertext { s t h e p r o b a b i l i s t i c h e r p r e t a t i o n } & \emph { r e s } & \intertext { s t h e p r o b a b i l i s t i c h e r p r e t a t i o n } & \emph { r e s } & \intertext { s t h e p r o b a b i l i s t i c h e r p r e t a t i o n } & \emph { r e s } & \intertext { s t h e p r o b a b i l i s t i c h e r p r e t a t i o n } & \emph { r e s } & \intertext { s t h e p r o b a b i l i s t i c h e r p r e t a t i o n } & \emph { r e s } & \intertext { s t h e p r o b a b i l i s t i c h e r p r e t a t i o n } & \emph { r e s } & \intertext { s t h e p r o b a b i l i s t i c h e r p r e t a t i o n } & \emph { r e s } & \intertext { s t h e p r o b a b i l i s t i c h e r p r e t a t i o n } & \emph { r e s } & \intertext { s t h e p r o b a b i l i s t i c h e r p r e t a t i o n } & \emph { r e s } & \intertext { s t h e p r o b a b i l i s t i c h e r p r e t a t i o n } & \emph { r e s } & \intertext { s t h e p r o b a b i l i s t i c h e r p r e t a t i o n } & \emph { r e s } & \intertext { s t h e p r o b a b i l i s t i c h e r p r e t a t i o n } & \emph
$$

We shall discuss the probabilistic interpretation of the mixture distribution in greater detail in Chapter 9.

The form of the Gaussian mixture distribution is governed by the parameters π , µ and Σ , where we have used the notation π ≡ { π 1 ,...,π K } , µ ≡ { µ 1 ,..., µ K } and Σ ≡ { Σ 1 ,... Σ K } . One way to set the values of these parameters is to use maximum likelihood. From (2.188) the log of the likelihood function is given by

$$
\text {maximum likelihood} \cdot \text {from} \left ( 2 . 1 8 \right ) \text { the log of the likelihood function is given by} \\ \ln p ( X | \pi , \mu , \Sigma ) = \sum _ { n = 1 } ^ { N } \ln \left \{ \sum _ { k = 1 } ^ { K } \pi _ { k } \mathcal { N } ( x _ { n } | \mu _ { k } , \Sigma _ { k } ) \right \} \\
$$
