[Page 648]

From the product rule, we then have

�n

p(x1,...,xn) =

cm (13.57)

m=1

and so

α(zn) = p(zn|x1,...,xn)p(x1,...,xn) = � n

cm�

�

α�(zn). (13.58)

m=1

We can then turn the recursion equation (13.36) for α into one for α� given by

� zn−1 α�(zn−1)p(zn|zn−1). (13.59)

cnα�(zn) = p(xn|zn)

Note that at each stage of the forward message passing phase, used to evaluate α�(zn), we have to evaluate and store cn, which is easily done because it is the coefﬁcient that normalizes the right-hand side of (13.59) to give α�(zn).

We can similarly deﬁne re-scaled variables β�(zn) using

β(zn) = � N

cm�

�

β�(zn) (13.60)

m=n+1

which will again remain within machine precision because, from (13.35), the quantities β�(zn) are simply the ratio of two conditional probabilities

p(xn+1,...,xN|zn) p(xn+1,...,xN|x1,...,xn)

β�(zn) =

. (13.61)

The recursion result (13.38) for β then gives the following recursion for the re-scaled variables

�

cn+1β�(zn) =

β�(zn+1)p(xn+1|zn+1)p(zn+1|zn). (13.62)

zn+1

In applying this recursion relation, we make use of the scaling factors cn that were previously computed in the α phase.

From (13.57), we see that the likelihood function can be found using

�N

p(X) =

cn. (13.63)

n=1

Similarly, using (13.33) and (13.43), together with (13.63), we see that the required Exercise 13.15 marginals are given by

γ(zn) = α�(zn)β�(zn) (13.64) ξ(zn−1,zn) = cnα�(zn−1)p(xn|zn)p(zn|z−1)β�(zn). (13.65)
