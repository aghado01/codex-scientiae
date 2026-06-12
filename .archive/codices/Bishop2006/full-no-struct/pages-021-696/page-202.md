[Page 202]

Figure 4.1 Illustration of the geometry of a linear discriminant function in two dimensions. The decision surface, shown in red, is perpendicular to w , and its displacement from the origin is controlled by the bias parameter w 0 . Also, the signed orthogonal distance of a general point x from the decision surface is given by y ( x ) / w .

![The image depicts a geometric figure with several lines and points. Here is a detailed description of the image: ### Description: - **Lines and Points**: - There are two lines: - Line A is a straight line with a positive slope. - Line B is a straight line with a negative slope. - There are two points: - Point A is located on line A. - Point B is located on line B. - There are two points: - Point C is located on line A. - Point D is located on line B. - There are two points: - Point E is located on line A. - Point F is located on line B. - There are two points: - Point G is located on line A. - Point H is located on line B. - There are two points: - Point J is located on line A. - Point K is located on line](../images/imageFile91.png)

x

y >

0

2

y

= 0

R

y <

0

1

R

2

x

w

y

(

)

x

‖

‖

w

⊥

x

x

1

-

w

0

‖

‖

w

$$
x = x _ { \perp } + r \frac { w } { \| w \| } . \\ \intertext { f t h i s r o u l t b y r T }
$$

Multiplying both sides of this result by w T and adding w 0 , and making use of y ( x ) = w T x + w 0 and y ( x ⊥ ) = w T x ⊥ + w 0 = 0 , we have

$$
r = \frac { y ( x ) } { \| w \| } .
$$

This result is illustrated in Figure 4.1.

As with the linear regression models in Chapter 3, it is sometimes convenient to use a more compact notation in which we introduce an additional dummy ‘input’ value x 0 = 1 and then deﬁne w = ( w 0 , w ) and x = ( x 0 , x ) so that y ( x ) = w T x . (4.8)

In this case, the decision surfaces are D -dimensional hyperplanes passing through the origin of the D + 1 -dimensional expanded input space.

# 4.1.2 Multiple classes

Now consider the extension of linear discriminants to K > 2 classes. We might be tempted be to build a K -class discriminant by combining a number of two-class discriminant functions. However, this leads to some serious difﬁculties (Duda and Hart, 1973) as we now show.

Consider the use of K − 1 classiﬁers each of which solves a two-class problem of separating points in a particular class C k from points not in that class. This is known as a one-versus-the-rest classiﬁer. The left-hand example in Figure 4.2 shows an
