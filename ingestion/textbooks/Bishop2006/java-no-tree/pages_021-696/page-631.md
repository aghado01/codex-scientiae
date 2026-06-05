[Page 631]

Figure 13.6 Transition diagram showing a model whose latent variables have three possible states corresponding to the three boxes. The black lines denote the elements of the transition matrix Ajk.

A22

A21

A12

- k = 2
- k = 3


k = 1

A32

A23

A11

A31

A13

A33

has K(K−1) independent parameters. We can then write the conditional distribution explicitly in the form

K

p(zn|zn−1,A) =

k=1

###### K

Azn−

1,jznk

jk . (13.7)

j=1

The initial latent node z1 is special in that it does not have a parent node, and so it has a marginal distribution p(z1) represented by a vector of probabilities π with elements πk ≡ p(z1k = 1), so that

K

πz

p(z1|π) =

k (13.8)

1k

k=1

###### where k πk = 1.

The transition matrix is sometimes illustrated diagrammatically by drawing the states as nodes in a state transition diagram as shown in Figure 13.6 for the case of K = 3. Note that this does not represent a probabilistic graphical model, because the nodes are not separate variables but rather states of a single variable, and so we have shown the states as boxes rather than circles.

It is sometimes useful to take a state transition diagram, of the kind shown in Figure 13.6, and unfold it over time. This gives an alternative representation of the

Section 8.4.5 transitions between latent states, known as a lattice or trellis diagram, and which is shown for the case of the hidden Markov model in Figure 13.7.

The speciﬁcation of the probabilistic model is completed by deﬁning the conditional distributions of the observed variables p(xn|zn,φ), where φ is a set of parameters governing the distribution. These are known as emission probabilities, and might for example be given by Gaussians of the form (9.11) if the elements of x are continuous variables, or by conditional probability tables if x is discrete. Because xn is observed, the distribution p(xn|zn,φ) consists, for a given value of φ, of a vector of K numbers corresponding to the K possible states of the binary vector zn.
