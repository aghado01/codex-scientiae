[Page 570]

During the evolution of this dynamical system, the value of the Hamiltonian H is constant, as is easily seen by differentiation

�

�

�

dH dτ

dzi dτ

dri dτ

∂H ∂zi

∂H ∂ri

=

+

i

�

� = 0. (11.60)

�

∂H ∂zi

∂H ∂ri −

∂H ∂zi

∂H ∂ri

=

i

A second important property of Hamiltonian dynamical systems, known as Liouville’s Theorem, is that they preserve volume in phase space. In other words, if we consider a region within the space of variables (z,r), then as this region evolves under the equations of Hamiltonian dynamics, its shape may change but its volume will not. This can be seen by noting that the ﬂow ﬁeld (rate of change of location in phase space) is given by

� (11.61) and that the divergence of this ﬁeld vanishes

V = �

dz dτ

dr dτ

,

�

�

�

dzi dτ

dri dτ

∂ ∂zi

∂ ∂ri

div V =

+

i

�−

� = 0. (11.62)

�

∂H ∂ri

∂H ∂zi

∂ ∂zi

∂ ∂ri

=

+

i

Now consider the joint distribution over phase space whose total energy is the Hamiltonian, i.e., the distribution given by

p(z,r) =

1 ZH

exp(−H(z,r)). (11.63)

Using the two results of conservation of volume and conservation of H, it follows that the Hamiltonian dynamics will leave p(z,r) invariant. This can be seen by considering a small region of phase space over which H is approximately constant. If we follow the evolution of the Hamiltonian equations for a ﬁnite time, then the volume of this region will remain unchanged as will the value of H in this region, and hence the probability density, which is a function only of H, will also be unchanged.

Although H is invariant, the values of z and r will vary, and so by integrating the Hamiltonian dynamics over a ﬁnite time duration it becomes possible to make large changes to z in a systematic way that avoids random walk behaviour.

Evolution under the Hamiltonian dynamics will not, however, sample ergodically from p(z,r) because the value of H is constant. In order to arrive at an ergodic sampling scheme, we can introduce additional moves in phase space that change the value of H while also leaving the distribution p(z,r) invariant. The simplest way to achieve this is to replace the value of r with one drawn from its distribution conditioned on z. This can be regarded as a Gibbs sampling step, and hence from
