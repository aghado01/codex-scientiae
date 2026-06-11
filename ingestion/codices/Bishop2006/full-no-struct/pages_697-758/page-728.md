[Page 728]

Figure E.1

![In this image, we can see a diagram. There are two points named x and y. We can see a line named ( g(x) ) and a point named ( g(x) ).](../images/imageFile352.png)

∇

f

(

)

x

A

x

∇

g

(

)

x

g

(

) = 0

x

then parallel to the constraint surface g ( x ) = 0 , we see that the vector ∇ g is normal to the surface.

Next we seek a point x on the constraint surface such that f ( x ) is maximized. Such a point must have the property that the vector ∇ f ( x ) is also orthogonal to the constraint surface, as illustrated in Figure E.1, because otherwise we could increase the value of f ( x ) by moving a short distance along the constraint surface. Thus ∇ f and ∇ g are parallel (or anti-parallel) vectors, and so there must exist a parameter λ such that

$$
\nabla f + \lambda \nabla g & = 0 \\ \intertext { t a l g r a n g e m u l t i n l i r } \
$$

/negationslash

where λ = 0 is known as a Lagrange multiplier . Note that λ can have either sign. At this point, it is convenient to introduce the Lagrangian function deﬁned by

$$
L ( x , \lambda ) & \equiv f ( x ) + \lambda g ( x ) . \\ \dot { \cdot } & \quad \dot { \cdot } , \quad \dot { \cdot } \cdot _ { x } \dot { \cdot } \cdot _ { y } \dot { \cdot } , \quad \dot { \cdot } \cdot _ { x } \dot { \cdot } \cdot _ { y } \dot { \cdot } , \quad \Sigma _ { x } \dot { \cdot } , \quad \Sigma _ { y } \dot { \cdot } , \quad \Sigma _ { x } \dot { \cdot } , \quad \Sigma _ { y } \dot { \cdot }
$$

The constrained stationarity condition (E.3) is obtained by setting ∇ x L = 0 . Furthermore, the condition ∂L/∂λ = 0 leads to the constraint equation g ( x ) = 0 .

Thus to ﬁnd the maximum of a function f ( x ) subject to the constraint g ( x ) = 0 , we deﬁne the Lagrangian function given by (E.4) and we then ﬁnd the stationary point of L ( x ,λ ) with respect to both x and λ . For a D -dimensional vector x , this gives D +1 equations that determine both the stationary point x and the value of λ . If we are only interested in x , then we can eliminate λ from the stationarity equations without needing to ﬁnd its value (hence the term ‘undetermined multiplier’).

As a simple example, suppose we wish to ﬁnd the stationary point of the function f ( x 1 ,x 2 ) = 1 − x 2 1 − x 2 2 subject to the constraint g ( x 1 ,x 2 ) = x 1 + x 2 − 1 = 0 , as illustrated in Figure E.2. The corresponding Lagrangian function is given by

$$
L ( x , \lambda ) = 1 - x _ { 1 } ^ { 2 } - x _ { 2 } ^ { 2 } + \lambda ( x _ { 1 } + x _ { 2 } - 1 ) . \\ \dot { x } _ { i } . \quad f _ { i } \colon \quad _ { 1 } \colon \quad _ { 2 } \colon \quad _ { 1 } \colon \quad _ { 2 } \colon \quad _ { i } \colon \quad _ { 1 } \colon \quad _ { 2 } \colon \quad _ { i } \colon
$$

The conditions for this Lagrangian to be stationary with respect to x 1 , x 2 , and λ give the following coupled equations:

$$
- 2 x _ { 1 } + \lambda \ & = \ 0 \\ = & 2 x _ { 0 } + \lambda \ & = \ 0
$$

$$
- 2 x _ { 2 } + \lambda \ = \ 0 \\ r _ { 1 } + r _ { 0 } - 1 \ = \ 0
$$

$$
x _ { 1 } + x _ { 2 } - 1 \ = \ 0 .
$$
