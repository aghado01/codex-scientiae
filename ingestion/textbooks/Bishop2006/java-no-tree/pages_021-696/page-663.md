[Page 663]

###### µnew0 = E[z1] (13.110) V0new = E[z1zT1 ] − E[z1]E[zT1 ]. (13.111)

Similarly, to optimize A and Γ, we substitute for p(zn|zn−1,A,Γ) in (13.108) using (13.75) giving

N − 1 2

Q(θ,θold) = −

ln|Γ|

N

1 2

(zn − Azn−1)TΓ−1(zn − Azn−1) + const (13.112)

−EZ|θold

n=2

in which the constant comprises terms that are independent of A and Γ. Maximizing

- Exercise 13.33 with respect to these parameters then gives

Anew =

N

n=2

E znzTn−1

N

n=2

E zn−1zTn−1

−1

(13.113)

Γnew =

1 N − 1

N

n=2

E znzTn − AnewE zn−1zTn

−E znzTn−1 Anew + AnewE zn−1zTn−1 (Anew)T . (13.114)

Note that Anew must be evaluated ﬁrst, and the result can then be used to determine Γnew.

Finally, in order to determine the new values of C and Σ, we substitute for p(xn|zn,C,Σ) in (13.108) using (13.76) giving

Q(θ,θold) = −

N 2

ln|Σ|

−EZ|θold

1 2

N

n=1

(xn − Czn)TΣ−1(xn − Czn) + const.

- Exercise 13.34 Maximizing with respect to C and Σ then gives


Cnew =

Σnew =

−1

N

N

xnE zTn

E znzTn

(13.115)

n=1

n=1

N

1 N

xnxTn − CnewE[zn]xTn

n=1

−xnE zTn Cnew + CnewE znzTn Cnew . (13.116)
