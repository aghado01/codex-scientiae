[Page 631]

Figure 13.6 Transition diagram showing a model whose latent variables have three possible states corresponding to the three boxes. The black lines denote the elements of the transition matrix A jk .

![In this image, we can see a diagram. There are two arrows in the image.](../images/imageFile306.png)

A

22

A

21

A

12

k

= 2

A

A

A

k

= 1

32

23

11

k

A = 3

A

31

A

13

A

33

Section 8.4.5

has K ( K − 1) independent parameters. We can then write the conditional distribution explicitly in the form

$$
p ( z _ { n } | z _ { n - 1 , A } ) = \prod _ { k = 1 } ^ { K } \prod _ { j = 1 } ^ { K } A _ { j k } ^ { z _ { n - 1 , j } z _ { n k } } . \\ \intertext { l o t . n o t . n o d . g . i s o m o j i l . p h t t i d e s n o t h e v o r n o r p e d o n d o s e }
$$

The initial latent node z 1 is special in that it does not have a parent node, and so it has a marginal distribution p ( z 1 ) represented by a vector of probabilities π with elements π k ≡ p ( z 1 k = 1) , so that

$$
p ( z _ { 1 } | \pi ) = \prod _ { k = 1 } ^ { K } \pi _ { k } ^ { z _ { 1 k } }
$$

where k π k = 1 . The transition matrix is sometimes illustrated diagrammatically by drawing the states as nodes in a state transition diagram as shown in Figure 13.6 for the case of K = 3 . Note that this does not represent a probabilistic graphical model, because the nodes are not separate variables but rather states of a single variable, and so we have shown the states as boxes rather than circles.

It is sometimes useful to take a state transition diagram, of the kind shown in Figure 13.6, and unfold it over time. This gives an alternative representation of the transitions between latent states, known as a lattice or trellis diagram, and which is shown for the case of the hidden Markov model in Figure 13.7.

The speciﬁcation of the probabilistic model is completed by deﬁning the conditional distributions of the observed variables p ( x n | z n , φ ) , where φ is a set of parameters governing the distribution. These are known as emission probabilities , and might for example be given by Gaussians of the form (9.11) if the elements of x are continuous variables, or by conditional probability tables if x is discrete. Because x n is observed, the distribution p ( x n | z n , φ ) consists, for a given value of φ , of a vector of K numbers corresponding to the K possible states of the binary vector z n .
