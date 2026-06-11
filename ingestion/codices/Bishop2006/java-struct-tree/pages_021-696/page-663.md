[Page 663]

µnew0 = E[z1] (13.110) V0new = E[z1zT1 ] − E[z1]E[zT1 ]. (13.111)

Similarly, to optimize A and Γ, we substitute for p(zn|zn−1,A,Γ) in (13.108) using (13.75) giving

N − 1 2

Q(θ,θold) = −

ln|Γ|

�1 2

(zn − Azn−1)TΓ−1(zn − Azn−1)� + const (13.112)

�N

−EZ|θold

n=2

in which the constant comprises terms that are independent of A and Γ. Maximizing Exercise 13.33 with respect to these parameters then gives

�� N

�−1 (13.113)

Anew = � N

�

�

�

�

�

�

znzTn−1

zn−1zTn−1

E

E

n=2

n=2

�N

1 N − 1

�

�

� − AnewE

�

�

Γnew =

znzTn

zn−1zTn

E

n=2

(Anew)T�. (13.114)

�

�

�

�

Anew + AnewE

znzTn−1

zn−1zTn−1

−E

Note that Anew must be evaluated ﬁrst, and the result can then be used to determine Γnew.

Finally, in order to determine the new values of C and Σ, we substitute for p(xn|zn,C,Σ) in (13.108) using (13.76) giving

N 2

Q(θ,θold) = −

ln|Σ|

�1 2

(xn − Czn)TΣ−1(xn − Czn)� + const.

�N

−EZ|θold

n=1

Exercise 13.34 Maximizing with respect to C and Σ then gives

Cnew = � N

�

n=1

�N

1 N

Σnew =

n=1

−xnE

�� N

�−1 (13.115)

�

�

�

�

�

xnE

zTn

znzTn

E

n=1

�

xnxTn − CnewE[zn]xTn

�

�

�

�

�

Cnew + CnewE

zTn

znzTn

Cnew

. (13.116)
