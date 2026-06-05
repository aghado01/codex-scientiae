[Page 724]

###### 704 D. CALCULUS OF VARIATIONS

Figure D.1 A functional derivative can be deﬁned by considering how the value of a functional F[y] changes when the function y(x) is changed to y(x) +  η(x) where η(x) is an arbitrary function of x.

y(x)

y(x) +  η(x)

x

y(x), where η(x) is an arbitrary function of x, as illustrated in Figure D.1. We denote the functional derivative of E[f] with respect to f(x) by δF/δf(x), and deﬁne it by the following relation:

F[y(x) +  η(x)] = F[y(x)] +

δF δy(x)

η(x)dx + O( 2). (D.3)

This can be seen as a natural extension of (D.2) in which F[y] now depends on a continuous set of variables, namely the values of y at all points x. Requiring that the functional be stationary with respect to small variations in the function y(x) gives

δE δy(x)

η(x)dx = 0. (D.4)

Because this must hold for an arbitrary choice of η(x), it follows that the functional derivative must vanish. To see this, imagine choosing a perturbation η(x) that is zero everywhere except in the neighbourhood of a point x, in which case the functional derivative must be zero at x = x. However, because this must be true for every choice of x, the functional derivative must vanish for all values of x.

Consider a functional that is deﬁned by an integral over a function G(y,y ,x) that depends on both y(x) and its derivative y (x) as well as having a direct dependence on x

F[y] = G(y(x),y (x),x) dx (D.5)

where the value of y(x) is assumed to be ﬁxed at the boundary of the region of integration (which might be at inﬁnity). If we now consider variations in the function y(x), we obtain

F[y(x) +  η(x)] = F[y(x)] +

∂G ∂y

η(x) +

∂G ∂y

η (x) dx + O( 2). (D.6)

We now have to cast this in the form (D.3). To do so, we integrate the second term by parts and make use of the fact that η(x) must vanish at the boundary of the integral (because y(x) is ﬁxed at the boundary). This gives

F[y(x) +  η(x)] = F[y(x)] +

d dx

∂G ∂y −

∂G ∂y

η(x)dx + O( 2) (D.7)
