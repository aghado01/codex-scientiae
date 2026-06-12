[Page 407]

To do this we again return to the concept of a graphical model as a ﬁlter, corresponding to Figure 8.25. Consider the set of all possible distributions deﬁned over a ﬁxed set of variables corresponding to the nodes of a particular undirected graph. We can deﬁne UI to be the set of such distributions that are consistent with the set of conditional independence statements that can be read from the graph using graph separation. Similarly, we can deﬁne UF to be the set of such distributions that can be expressed as a factorization of the form (8.39) with respect to the maximal cliques of the graph. The Hammersley-Clifford theorem (Clifford, 1990) states that the sets UI and UF are identical. Because we are restricted to potential functions which are strictly positive it is

Because we are restricted to potential functions which are strictly positive it is convenient to express them as exponentials, so that

$$
\psi _ { C } ( { \mathbf x } _ { C } ) = \exp \left \{ - E ( { \mathbf x } _ { C } ) \right \}
$$

where E ( x C ) is called an energy function , and the exponential representation is called the Boltzmann distribution . The joint distribution is deﬁned as the product of potentials, and so the total energy is obtained by adding the energies of each of the maximal cliques.

In contrast to the factors in the joint distribution for a directed graph, the potentials in an undirected graph do not have a speciﬁc probabilistic interpretation. Although this gives greater ﬂexibility in choosing the potential functions, because there is no normalization constraint, it does raise the question of how to motivate a choice of potential function for a particular application. This can be done by viewing the potential function as expressing which conﬁgurations of the local variables are preferred to others. Global conﬁgurations that have a relatively high probability are those that ﬁnd a good balance in satisfying the (possibly conﬂicting) inﬂuences of the clique potentials. We turn now to a speciﬁc example to illustrate the use of undirected graphs.

# 8.3.3 Illustration: Image de-noising

We can illustrate the application of undirected graphs using an example of noise removal from a binary image (Besag, 1974; Geman and Geman, 1984; Besag, 1986). Although a very simple example, this is typical of more sophisticated applications. Let the observed noisy image be described by an array of binary pixel values y i ∈ {− 1 , +1 } , where the index i = 1 ,...,D runs over all pixels. We shall suppose that the image is obtained by taking an unknown noise-free image, described by binary pixel values x i ∈ {− 1 , +1 } and randomly ﬂipping the sign of pixels with some small probability. An example binary image, together with a noise corrupted image obtained by ﬂipping the sign of the pixels with probability 10%, is shown in Figure 8.30. Given the noisy image, our goal is to recover the original noise-free image.

Because the noise level is small, we know that there will be a strong correlation between x i and y i . We also know that neighbouring pixels x i and x j in an image are strongly correlated. This prior knowledge can be captured using the Markov random field model whose undirected graph is shown in Figure 8.31. This graph has two types of cliques, each of which contains two variables. The cliques of the form { x i , y i } have an associated energy function that expresses the correlation between these variables. We choose a very simple energy function for these cliques of the form -ηx i y i where η is a positive constant. This has the desired effect of giving a lower energy (thus encouraging a higher probability) when x i and y i have the same sign and a higher energy when they have the opposite sign.
