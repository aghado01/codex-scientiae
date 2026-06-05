[Page 561]

for some set of mixing coefﬁcients α1,...,αK satisfying αk 0 and k αk = 1. Alternatively, the base transitions may be combined through successive application,

so that

T(z ,z) =

B1(z ,z1)...BK−1(zK−2,zK−1)BK(zK−1,z). (11.43)

...

z1

zn−1

If a distribution is invariant with respect to each of the base transitions, then obviously it will also be invariant with respect to either of the T(z ,z) given by (11.42) or (11.43). For the case of the mixture (11.42), if each of the base transitions satisﬁes detailed balance, then the mixture transition T will also satisfy detailed balance. This does not hold for the transition probability constructed using (11.43), although by symmetrizing the order of application of the base transitions, in the form B1,B2,...,BK,BK,...,B2,B1, detailed balance can be restored. A common example of the use of composite transition probabilities is where each base transition changes only a subset of the variables.

###### 11.2.2 The Metropolis-Hastings algorithm

Earlier we introduced the basic Metropolis algorithm, without actually demonstrating that it samples from the required distribution. Before giving a proof, we ﬁrst discuss a generalization, known as the Metropolis-Hastings algorithm (Hastings, 1970), to the case where the proposal distribution is no longer a symmetric function of its arguments. In particular at step τ of the algorithm, in which the current state is z(τ), we draw a sample z from the distribution qk(z|z(τ)) and then accept it with probability Ak(z ,zτ) where

p(z )qk(z(τ)|z ) p(z(τ))qk(z |z(τ))

Ak(z ,z(τ)) = min 1,

. (11.44)

Here k labels the members of the set of possible transitions being considered. Again, the evaluation of the acceptance criterion does not require knowledge of the normalizing constant Zp in the probability distribution p(z) = p(z)/Zp. For a symmetric proposal distribution the Metropolis-Hastings criterion (11.44) reduces to the standard Metropolis criterion given by (11.33).

We can show that p(z) is an invariant distribution of the Markov chain deﬁned by the Metropolis-Hastings algorithm by showing that detailed balance, deﬁned by (11.40), is satisﬁed. Using (11.44) we have

p(z)qk(z|z )Ak(z ,z) = min(p(z)qk(z|z ),p(z )qk(z |z)) = min(p(z )qk(z |z),p(z)qk(z|z ))

= p(z )qk(z |z)Ak(z,z ) (11.45) as required.

The speciﬁc choice of proposal distribution can have a marked effect on the performance of the algorithm. For continuous state spaces, a common choice is a Gaussian centred on the current state, leading to an important trade-off in determining the variance parameter of this distribution. If the variance is small, then the
