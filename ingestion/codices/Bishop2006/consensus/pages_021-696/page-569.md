[Page 569]

for each position variable there is a corresponding momentum variable, and the joint space of position and momentum variables is called phase space.

Without loss of generality, we can write the probability distribution $p(\mathbf{z})$ in the form

$$
p(\mathbf{z}) = \frac{1}{Z_p} \exp(-E(\mathbf{z})) \tag{11.54}
$$

where $E(\mathbf{z})$ is interpreted as the potential energy of the system when in state $\mathbf{z}$. The system acceleration is the rate of change of momentum and is given by the applied force, which itself is the negative gradient of the potential energy

$$
\frac{dr_i}{d\tau} = -\frac{\partial E(\mathbf{z})}{\partial z_i}. \tag{11.55}
$$

It is convenient to reformulate this dynamical system using the Hamiltonian framework. To do this, we ﬁrst deﬁne the kinetic energy by

$$
K(\mathbf{r}) = \frac{1}{2}\|\mathbf{r}\|^2 = \frac{1}{2} \sum_i r_i^2. \tag{11.56}
$$

The total energy of the system is then the sum of its potential and kinetic energies

$$
H(\mathbf{z}, \mathbf{r}) = E(\mathbf{z}) + K(\mathbf{r}) \tag{11.57}
$$

where $H$ is the Hamiltonian function. Using (11.53), (11.55), (11.56), and (11.57), we can now express the dynamics of the system in terms of the Hamiltonian equations given by

$$
\frac{dz_i}{d\tau} = \frac{\partial H}{\partial r_i} \tag{11.58}
$$

$$
\frac{dr_i}{d\tau} = -\frac{\partial H}{\partial z_i}. \tag{11.59}
$$

![William Hamilton](../images/imageFile42.png)

**William Hamilton**  
1805–1865  
William Rowan Hamilton was an Irish mathematician and physicist, and child prodigy, who was appointed Professor of Astronomy at Trinity College, Dublin, in 1827, before he had even graduated. One of Hamilton’s most important contributions was a new formulation of dynamics, which played a signiﬁcant role in the later development of quantum mechanics. His other great achievement was the development of quaternions, which generalize the concept of complex numbers by introducing three distinct square roots of minus one, which satisfy $i^2 = j^2 = k^2 = ijk = -1$. It is said that these equations occurred to him while walking along the Royal Canal in Dublin with his wife, on 16 October 1843, and he promptly carved the equations into the side of Broome bridge. Although there is no longer any evidence of the carving, there is now a stone plaque on the bridge commemorating the discovery and displaying the quaternion equations.
