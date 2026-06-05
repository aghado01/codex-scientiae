[Page 127]

The von Mises distribution can be derived by considering a two-dimensional Gaussian of the form (2.173), whose density contours are shown in blue and conditioning on the unit circle shown in red.

![image 59](../images/imageFile59.png)

x

2

p

(

)

x

x

1

r

= 1

to one, but it must also be periodic. Thus p ( θ ) must satisfy the three conditions

$$
p ( \theta ) \ \geq \ 0
$$

$$
p ( \theta ) & \ \Rightarrow \ 0 \\ \int _ { 0 } ^ { 2 \pi } p ( \theta ) \, d \theta \ = \ 1 \\ p ( \theta + 2 \pi ) & \ = \ p ( \theta ) .
$$

$$
p ( \theta + 2 \pi ) \ = \ p ( \theta ) .
$$

From (2.172), it follows that p ( θ + M 2 π ) = p ( θ ) for any integer M .

We can easily obtain a Gaussian-like distribution that satisﬁes these three properties as follows. Consider a Gaussian distribution over two variables x = ( x 1 ,x 2 ) having mean µ = ( µ 1 ,µ 2 ) and a covariance matrix Σ = σ 2 I where I is the 2 × 2 identity matrix, so that

$$
\text {identity matrix} , \, & \text {so that} \\ & p ( x _ { 1 } , x _ { 2 } ) = \frac { 1 } { 2 \pi \sigma ^ { 2 } } \exp \left \{ - \frac { ( x _ { 1 } - \mu _ { 1 } ) ^ { 2 } + ( x _ { 2 } - \mu _ { 2 } ) ^ { 2 } } { 2 \sigma ^ { 2 } } \right \} . \\ \intertext { The contours of constant p ( x ) are circles, as i l l u n t r a d e in Figure 2 , 1 8, N o w sup o n s e }
$$

The contours of constant p ( x ) are circles, as illustrated in Figure 2.18. Now suppose we consider the value of this distribution along a circle of ﬁxed radius. Then by construction this distribution will be periodic, although it will not be normalized. We can determine the form of this distribution by transforming from Cartesian coordinates ( x 1 ,x 2 ) to polar coordinates ( r,θ ) so that

$$
x _ { 1 } = r \cos \theta , \quad x _ { 2 } = r \sin \theta .
$$

We also map the mean µ into polar coordinates by writing

$$
\mu _ { 1 } = r _ { 0 } \cos \theta _ { 0 } , \quad \mu _ { 2 } = r _ { 0 } \sin \theta _ { 0 } .
$$

Next we substitute these transformations into the two-dimensional Gaussian distribution (2.173), and then condition on the unit circle r = 1 , noting that we are interested only in the dependence on θ . Focussing on the exponent in the Gaussian distribution we have

$$
\text {we have} & & - \frac { 1 } { 2 \sigma ^ { 2 } } \left \{ ( r \cos \theta - r _ { 0 } \cos \theta _ { 0 } ) ^ { 2 } + ( r \sin \theta - r _ { 0 } \sin \theta _ { 0 } ) ^ { 2 } \right \} \\ & = & - \frac { 1 } { 2 \sigma ^ { 2 } } \left \{ 1 + r _ { 0 } ^ { 2 } - 2 r _ { 0 } \cos \theta \cos \theta _ { 0 } - 2 r _ { 0 } \sin \theta \sin \theta _ { 0 } \right \} \\ & = & \frac { r _ { 0 } } { \sigma ^ { 2 } } \cos ( \theta - \theta _ { 0 } ) + \text {const}
$$
