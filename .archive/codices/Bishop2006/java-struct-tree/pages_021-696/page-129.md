[Page 129]

3000

1

2000

I0(m)

1000

A(m)

0.5

0

0 5 10

m

0

0 5 10

m

Figure 2.20 Plot of the Bessel function I0(m) deﬁned by (2.180), together with the function A(m) deﬁned by (2.186).

Setting the derivative with respect to θ0 equal to zero gives

�N

sin(θn − θ0) = 0. (2.182)

n=1

To solve for θ0, we make use of the trigonometric identity

sin(A − B) = cosB sinA − cosAsinB (2.183) Exercise 2.53 from which we obtain

��

� (2.184)

n sinθn

θ0ML = tan−1

�

n cosθn

which we recognize as the result (2.169) obtained earlier for the mean of the observations viewed in a two-dimensional Cartesian space.

Similarly, maximizing (2.181) with respect to m, and making use of I0�(m) = I1(m) (Abramowitz and Stegun, 1965), we have

�N

1 N

A(m) =

cos(θn − θ0ML) (2.185)

n=1

where we have substituted for the maximum likelihood solution for θ0ML (recalling that we are performing a joint optimization over θ and m), and we have deﬁned

I1(m) I0(m)

A(m) =

. (2.186)

The function A(m) is plotted in Figure 2.20. Making use of the trigonometric identity (2.178), we can write (2.185) in the form

A(mML) = � 1 N

cosθn�cosθ0ML −

� 1 N

sinθn�sinθ0ML. (2.187)

�N

�N

n=1
