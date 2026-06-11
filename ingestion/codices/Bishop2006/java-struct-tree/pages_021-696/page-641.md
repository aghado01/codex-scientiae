[Page 641]

Figure 13.12 Illustration of the forward recursion (13.36) for evaluation of the α variables. In this fragment of the lattice, we see that the quantity α(zn1) is obtained by taking the elements α(zn−1,j) of α(zn−1) at step n−1 and summing them up with weights given by Aj1, corresponding to the values of p(zn|zn−1), and then multiplying by the data contribution p(xn|zn1).

α(zn−1,1)

k = 1

α(zn,1) A11

A21

α(zn−1,2)

k = 2

A31

p(xn|zn,1)

α(zn−1,3)

k = 3

n − 1 n

It is worth taking a moment to study this recursion relation in some detail. Note that there are K terms in the summation, and the right-hand side has to be evaluated for each of the K values of zn so each step of the α recursion has computational cost that scaled like O(K2). The forward recursion equation for α(zn) is illustrated using a lattice diagram in Figure 13.12.

In order to start this recursion, we need an initial condition that is given by

�K

{πkp(x1|φk)}z

α(z1) = p(x1,z1) = p(z1)p(x1|z1) =

(13.37)

1k

k=1

which tells us that α(z1k), for k = 1,...,K, takes the value πkp(x1|φk). Starting at the ﬁrst node of the chain, we can then work along the chain and evaluate α(zn) for every latent node. Because each step of the recursion involves multiplying by a K × K matrix, the overall cost of evaluating these quantities for the whole chain is of O(K2N).

We can similarly ﬁnd a recursion relation for the quantities β(zn) by making use of the conditional independence properties (13.27) and (13.28) giving

β(zn) = p(xn+1,...,xN|zn)

�

=

p(xn+1,...,xN,zn+1|zn)

zn+1

�

p(xn+1,...,xN|zn,zn+1)p(zn+1|zn)

=

zn+1

�

p(xn+1,...,xN|zn+1)p(zn+1|zn)

=

zn+1

�

p(xn+2,...,xN|zn+1)p(xn+1|zn+1)p(zn+1|zn).

=

zn+1
