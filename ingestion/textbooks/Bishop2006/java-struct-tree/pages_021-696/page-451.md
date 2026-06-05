[Page 451]

Figure 9.4 Graphical representation of a mixture model, in which the joint distribution is expressed in the form p(x, z) = p(z)p(x|z).

z

x

where the parameters {πk} must satisfy

0 � πk � 1 (9.8) together with

�K

πk = 1 (9.9)

k=1

in order to be valid probabilities. Because z uses a 1-of-K representation, we can also write this distribution in the form

�K

πz

p(z) =

k . (9.10)

k

k=1

Similarly, the conditional distribution of x given a particular value for z is a Gaussian p(x|zk = 1) = N(x|µk,Σk) which can also be written in the form

�K

N(x|µk,Σk)zk

p(x|z) =

. (9.11)

k=1

The joint distribution is given by p(z)p(x|z), and the marginal distribution of x is Exercise 9.3 then obtained by summing the joint distribution over all possible states of z to give

�K

�

p(x) =

p(z)p(x|z) =

πkN(x|µk,Σk) (9.12)

z

k=1

where we have made use of (9.10) and (9.11). Thus the marginal distribution of x is a Gaussian mixture of the form (9.7). If we have several observations x1,...,xN, then, because we have represented the marginal distribution in the form� p(x) =

z p(x,z), it follows that for every observed data point xn there is a corresponding latent variable zn.

We have therefore found an equivalent formulation of the Gaussian mixture involving an explicit latent variable. It might seem that we have not gained much by doing so. However, we are now able to work with the joint distribution p(x,z)
