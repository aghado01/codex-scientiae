[Page 563]

in some particular order or by choosing the variable to be updated at each step at random from some distribution.

For example, suppose we have a distribution p(z1,z2,z3) over three variables, and at step τ of the algorithm we have selected values z1(τ),z2(τ) and z3(τ). We ﬁrst replace z1(τ) by a new value z1(τ+1) obtained by sampling from the conditional distribution

###### p(z1|z2(τ),z3(τ)). (11.46)

Next we replace z2(τ) by a value z2(τ+1) obtained by sampling from the conditional distribution

- p(z2|z1(τ+1),z3(τ)) (11.47) so that the new value for z1 is used straight away in subsequent sampling steps. Then we update z3 with a sample z3(τ+1) drawn from
- p(z3|z1(τ+1),z2(τ+1)) (11.48) and so on, cycling through the three variables in turn.


Gibbs Sampling

- 1. Initialize {zi : i = 1,...,M}
- 2. For τ = 1,...,T:


- – Sample z1(τ+1) ∼ p(z1|z2(τ),z3(τ),...,zM(τ)).
- – Sample z2(τ+1) ∼ p(z2|z1(τ+1),z3(τ),...,zM(τ)).

.

- – Sample zj(τ+1) ∼ p(zj|z1(τ+1),...,zj(τ−+1)1 ,zj(τ+1) ,...,zM(τ)).

.

- – Sample zM(τ+1) ∼ p(zM|z1(τ+1),z2(τ+1),...,zM(τ+1)−1 ).


###### Josiah Willard Gibbs

![image 114](../../../../../images/imageFile114.png)

States at Yale, a post for which he received no salary because at the time he had no publications. He developed the ﬁeld of vector analysis and made contributions to crystallography and planetary orbits. His most famous work, entitled On the Equilibrium of Heterogeneous Substances, laid the foundations for the science of physical chemistry.

###### 1839–1903

Gibbs spent almost his entire life living in a house built by his father in New Haven, Connecticut. In 1863, Gibbs was granted the ﬁrst PhD in engineering in the United States, and in 1871 he was appointed to

the ﬁrst chair of mathematical physics in the United
