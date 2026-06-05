[Page 82]

- 1.17 ( ) www The gamma function is deﬁned by

Γ(x) ≡

∞

0

ux−1e−u du. (1.141)

Using integration by parts, prove the relation Γ(x + 1) = xΓ(x). Show also that Γ(1) = 1 and hence that Γ(x + 1) = x! when x is an integer.

- 1.18 ( ) www We can use the result (1.126) to derive an expression for the surface

area SD, and the volume VD, of a sphere of unit radius in D dimensions. To do this, consider the following result, which is obtained by transforming from Cartesian to polar coordinates

D

i=1

∞

−∞

e−x

2

i dxi = SD

∞

0

e−r

2

rD−1 dr. (1.142)

Using the deﬁnition (1.141) of the Gamma function, together with (1.126), evaluate both sides of this equation, and hence show that

SD =

2πD/2 Γ(D/2)

. (1.143)

Next, by integrating with respect to radius from 0 to 1, show that the volume of the unit sphere in D dimensions is given by

VD =

SD D

. (1.144)

Finally, use the results Γ(1) = 1 and Γ(3/2) = √π/2 to show that (1.143) and (1.144) reduce to the usual expressions for D = 2 and D = 3.

- 1.19 ( ) Consider a sphere of radius a in D-dimensions together with the concentric hypercube of side 2a, so that the sphere touches the hypercube at the centres of each of its sides. By using the results of Exercise 1.18, show that the ratio of the volume of the sphere to the volume of the cube is given by


volume of sphere volume of cube

=

πD/2 D2D−1Γ(D/2)

. (1.145)

Now make use of Stirling’s formula in the form

###### Γ(x + 1) (2π)1/2e−xxx+1/2 (1.146)

which is valid for x 1, to show that, as D → ∞, the ratio (1.145) goes to zero. Show also that the ratio of the distance from the centre of the hypercube to one of the corners, divided by the perpendicular distance to one of the sides, is √

D, which therefore goes to ∞ as D → ∞. From these results we see that, in a space of high dimensionality, most of the volume of a cube is concentrated in the large number of corners, which themselves become very long ‘spikes’!
