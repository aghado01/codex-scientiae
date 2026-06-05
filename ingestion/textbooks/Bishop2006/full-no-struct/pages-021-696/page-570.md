[Page 570]

During the evolution of this dynamical system, the value of the Hamiltonian H is constant, as is easily seen by differentiation

$$
& \text {as is easily seen by differentiation} \\ & \quad \frac { d H } { d \tau } \ = \ \sum _ { i } \left \{ \frac { \partial H } { \partial z _ { i } } \frac { d z _ { i } } { d \tau } + \frac { \partial H } { \partial r _ { i } } \frac { d r _ { i } } { d \tau } \right \} \\ & \quad = \ \sum _ { i } \left \{ \frac { \partial H } { \partial z _ { i } } \frac { \partial H } { \partial r _ { i } } - \frac { \partial H } { \partial r _ { i } } \frac { \partial H } { \partial z _ { i } } \right \} = 0 . \\ & \text {second important property of Hamiltonian dynamical systems, known as Li-}
$$

A second important property of Hamiltonian dynamical systems, known as Liouville’s Theorem , is that they preserve volume in phase space. In other words, if we consider a region within the space of variables ( z , r ) , then as this region evolves under the equations of Hamiltonian dynamics, its shape may change but its volume will not. This can be seen by noting that the ﬂow ﬁeld (rate of change of location in phase space) is given by

$$
V = \left ( \frac { d z } { d \tau } , \frac { d r } { d \tau } \right ) \\ \text {of this field vanishes}
$$

and that the divergence of this ﬁeld vanishes

$$
\text {at the divergence of this field vanishes} \\ \text {div } V \ = \ \sum _ { i } \left \{ \frac { \partial } { \partial z _ { i } } \frac { d z _ { i } } { d \tau } + \frac { \partial } { \partial r _ { i } } \frac { d r _ { i } } { d \tau } \right \} \\ = \sum _ { i } \left \{ - \frac { \partial } { \partial z _ { i } } \frac { \partial H } { \partial r _ { i } } + \frac { \partial } { \partial r _ { i } } \frac { \partial H } { \partial z _ { i } } \right \} = 0 . \\ \text {row consider the joint distribution over phase space whose total energy is the}
$$

Now consider the joint distribution over phase space whose total energy is the Hamiltonian, i.e., the distribution given by

$$
p ( z , r ) = \frac { 1 } { Z _ { H } } \exp ( - H ( z , r ) ) .
$$

Using the two results of conservation of volume and conservation of H , it follows that the Hamiltonian dynamics will leave p ( z , r ) invariant. This can be seen by considering a small region of phase space over which H is approximately constant. If we follow the evolution of the Hamiltonian equations for a ﬁnite time, then the volume of this region will remain unchanged as will the value of H in this region, and hence the probability density, which is a function only of H , will also be unchanged.

Although H is invariant, the values of z and r will vary, and so by integrating the Hamiltonian dynamics over a ﬁnite time duration it becomes possible to make large changes to z in a systematic way that avoids random walk behaviour.

Evolution under the Hamiltonian dynamics will not, however, sample ergodically from p ( z , r ) because the value of H is constant. In order to arrive at an ergodic sampling scheme, we can introduce additional moves in phase space that change the value of H while also leaving the distribution p ( z , r ) invariant. The simplest way to achieve this is to replace the value of r with one drawn from its distribution conditioned on z . This can be regarded as a Gibbs sampling step, and hence from
