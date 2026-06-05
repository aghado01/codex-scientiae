[Page 573]

ri

ri�

zi

zi�

Figure 11.14 Each step of the leapfrog algorithm (11.64)–(11.66) modiﬁes either a position variable zi or a momentum variable ri. Because the change to one variable is a function only of the other, any region in phase space will be sheared without change of volume.

region R� and integrating backwards in time to end up in region R is given by

1 ZH

1 2

min{1,exp(−H(R�) + H(R))}. (11.69) It is easily seen that the two probabilities (11.68) and (11.69) are equal, and hence Exercise 11.17 detailed balance holds. Note that this proof ignores any overlap between the regions

exp(−H(R�))δV

R and R� but is easily generalized to allow for such overlap.

It is not difﬁcult to construct examples for which the leapfrog algorithm returns to its starting position after a ﬁnite number of iterations. In such cases, the random replacement of the momentum values before each leapfrog integration will not be sufﬁcient to ensure ergodicity because the position variables will never be updated. Such phenomena are easily avoided by choosing the magnitude of the step size at random from some small interval, before each leapfrog integration.

We can gain some insight into the behaviour of the hybrid Monte Carlo algorithm by considering its application to a multivariate Gaussian. For convenience, consider a Gaussian distribution p(z) with independent components, for which the Hamiltonian is given by

1 2 �

1 2 �

1 σi2

zi2 +

H(z,r) =

ri2. (11.70)

i

i

Our conclusions will be equally valid for a Gaussian distribution having correlated components because the hybrid Monte Carlo algorithm exhibits rotational isotropy. During the leapfrog integration, each pair of phase-space variables zi,ri evolves independently. However, the acceptance or rejection of the candidate point is based on the value of H, which depends on the values of all of the variables. Thus, a signiﬁcant integration error in any one of the variables could lead to a high probability of rejection. In order that the discrete leapfrog integration be a reasonably
