[Page 569]

for each position variable there is a corresponding momentum variable, and the joint space of position and momentum variables is called phase space.

Without loss of generality, we can write the probability distribution p(z) in the form

1 Zp

p(z) =

exp(−E(z)) (11.54)

where E(z) is interpreted as the potential energy of the system when in state z. The system acceleration is the rate of change of momentum and is given by the applied force, which itself is the negative gradient of the potential energy

dri dτ

∂E(z) ∂zi

= −

. (11.55)

It is convenient to reformulate this dynamical system using the Hamiltonian framework. To do this, we ﬁrst deﬁne the kinetic energy by

1 2 �

1 2�r�2 =

K(r) =

ri2. (11.56)

i

The total energy of the system is then the sum of its potential and kinetic energies

H(z,r) = E(z) + K(r) (11.57)

where H is the Hamiltonian function. Using (11.53), (11.55), (11.56), and (11.57), we can now express the dynamics of the system in terms of the Hamiltonian equa-

Exercise 11.15 tions given by

dzi dτ

dri dτ

∂H ∂ri

=

∂H ∂zi

= −

(11.58)

. (11.59)

William Hamilton

![image 115](../../../../../images/imageFile115.png)

1805–1865

William Rowan Hamilton was an Irish mathematician and physicist, and child prodigy, who was appointed Professor of Astronomy at Trinity College, Dublin, in 1827, before he had even graduated. One

of Hamilton’s most important contributions was a new formulation of dynamics, which played a signiﬁcant role in the later development of quantum mechanics.

His other great achievement was the development of quaternions, which generalize the concept of complex numbers by introducing three distinct square roots of minus one, which satisfy i2 = j2 = k2 = ijk = −1. It is said that these equations occurred to him while walking along the Royal Canal in Dublin with his wife, on 16 October 1843, and he promptly carved the equations into the side of Broome bridge. Although there is no longer any evidence of the carving, there is now a stone plaque on the bridge commemorating the discovery and displaying the quaternion equations.
